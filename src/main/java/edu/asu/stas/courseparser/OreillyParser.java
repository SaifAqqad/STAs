package edu.asu.stas.courseparser;

import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.TextNode;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.stream.Collectors;

public class OreillyParser implements CourseParser {
    private static final String VALID_URL_PATTERN = "^(?:https?\\://)?(?:www\\.)?oreilly\\.com/(?:videos|library/view)/(?<courseName>[a-zA-Z0-9\\-]+)/(?<courseISBN>[0-9\\-]+)/?.*$";
    private static final String COURSE_TITLE_SELECTOR = ".metadata .t-title";
    private static final String COURSE_DESC_SELECTOR = ".t-description .content span";
    private static final String COURSE_PUBDATE_SELECTOR = "ul.detail-product-information li span.name:contains(Release date) + span.value";
    private static final String COURSE_AUTHOR_SELECTOR = ".metadata .t-authors .author-name";
    private static final String COURSE_PUBLISHER_SELECTOR = "ul.detail-product-information li span.name:contains(Publisher) + span.value.t-publishers";
    private static final String COURSE_IMAGE_SELECTOR = ".content .t-cover-img";

    @Override
    public Course getCourse(String courseUrl) {
        courseUrl = nonNullOrFail(validateURL(courseUrl, VALID_URL_PATTERN), "Invalid URL");
        Document doc = nonNullOrFail(this.getDocument(courseUrl), "Jsoup failed to download the document");
        String name = nonNullOrFail(getName(doc), "Failed to parse course name");
        String description = getDescription(doc);
        String author = nonNullOrFail(getAuthor(doc), "Failed to parse author name");
        String publisher = nonNullOrFail(getPublisher(doc), "Failed to parse publisher name");
        String imageUrl = getImageUrl(doc);
        LocalDate publicationDate = getPublicationDate(doc);
        return new Course(
            name,
            description,
            author,
            publicationDate,
            publisher,
            imageUrl,
            courseUrl
        );
    }

    private LocalDate getPublicationDate(Document doc) {
        var element = doc.selectFirst(COURSE_PUBDATE_SELECTOR);
        if (element == null) {
            return null;
        }
        return YearMonth.parse(element.ownText(), DateTimeFormatter.ofPattern("MMMM yyyy")).atDay(1);
    }

    private String getImageUrl(Document doc) {
        var element = doc.selectFirst(COURSE_IMAGE_SELECTOR);
        return Objects.isNull(element) ? null : element.attr("src");
    }

    private String getPublisher(Document doc) {
        var element = doc.selectFirst(COURSE_PUBLISHER_SELECTOR);
        return Objects.isNull(element) ? null : element.ownText();
    }

    private String getAuthor(Document doc) {
        return doc.select(COURSE_AUTHOR_SELECTOR).stream()
                  .filter(Element::hasText)
                  .map(Element::text)
                  .collect(Collectors.joining(", "));
    }


    private String getDescription(Document doc) {
        var element = doc.selectFirst(COURSE_DESC_SELECTOR);
        if (element == null) {
            return null;
        }
        element.select("br").forEach(e -> e.replaceWith(new TextNode("\n")));
        element.select("p").forEach(e -> e.appendText("\n"));
        return element.wholeText().strip();
    }

    private String getName(Document doc) {
        var element = doc.selectFirst(COURSE_TITLE_SELECTOR);
        return Objects.isNull(element) ? null : element.text();
    }
}
