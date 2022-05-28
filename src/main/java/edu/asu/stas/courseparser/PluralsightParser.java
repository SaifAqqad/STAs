package edu.asu.stas.courseparser;

import org.jsoup.nodes.Document;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

public class PluralsightParser implements CourseParser {
    private static final String VALID_URL_PATTERN =
        "^(?:https?\\://)?(?:www\\.)?pluralsight\\.com/courses/(?<courseName>[a-zA-Z0-9\\-]+)/?.*$";
    private static final String COURSE_TITLE_SELECTOR = "#course-page-hero h1";
    private static final String COURSE_DESC_SELECTOR = ".course-content-about > p";
    private static final String COURSE_INFO_SELECTOR = "#course-description-tile-info div.course-info__row";
    private static final String COURSE_IMAGE_SELECTOR = "#course-page-hero";
    private static final String COURSE_AUTHOR_SELECTOR = ".course-authors a";

    @Override
    public Course getCourse(String courseUrl) {
        courseUrl = nonNullOrFail(validateURL(courseUrl, VALID_URL_PATTERN), "Invalid URL");
        Document doc = nonNullOrFail(this.getDocument(courseUrl), "Jsoup failed to download the document");
        String name = nonNullOrFail(getName(doc), "Failed to parse course name");
        String publisher = "Pluralsight";
        String description = getDescription(doc);
        String imageUrl = getImageUrl(doc);
        String author = nonNullOrFail(getAuthor(doc), "Failed to parse author name");
        LocalDate pubDate = getPublicationDate(doc);
        return new Course(
            name,
            description,
            author,
            pubDate,
            publisher,
            imageUrl,
            courseUrl
        );
    }

    private LocalDate getPublicationDate(Document doc) {
        String dateString = doc.select(COURSE_INFO_SELECTOR)
                               .stream()
                               .filter(element -> element.child(0).text().contains("Updated"))
                               .map(element -> element.child(1).text())
                               .limit(1)
                               .collect(Collectors.joining(""));
        if (dateString.length() > 0) {
            try {
                return LocalDate.parse(dateString, DateTimeFormatter.ofPattern("MMM d, yyyy"));
            } catch (DateTimeParseException ignored) {
                return null;
            }
        }
        return null;
    }

    private String getAuthor(Document doc) {
        var element = doc.selectFirst(COURSE_AUTHOR_SELECTOR);
        return Objects.isNull(element) ? null : element.text();
    }

    private String getImageUrl(Document doc) {
        Map<String, String> styles = getStyles(doc.selectFirst(COURSE_IMAGE_SELECTOR));
        if (styles != null) {
            return styles.get("background-image")
                         .replace("url('", "")
                         .replace("')", "");
        }
        return null;
    }

    private String getDescription(Document doc) {
        var element = doc.selectFirst(COURSE_DESC_SELECTOR);
        return Objects.isNull(element) ? "" : element.text();
    }

    private String getName(Document doc) {
        var element = doc.selectFirst(COURSE_TITLE_SELECTOR);
        return Objects.isNull(element) ? null : element.text();
    }
}
