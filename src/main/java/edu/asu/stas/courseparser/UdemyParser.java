package edu.asu.stas.courseparser;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Objects;
import java.util.stream.Collectors;

public class UdemyParser implements CourseParser {
    protected static final String VALID_URL_PATTERN =
        "^(?:https?\\://)?(?:www\\.)?udemy\\.com/course/(?<courseName>[a-zA-Z0-9\\-]+)/?.*$";
    private static final String COURSE_TITLE_SELECTOR = "[data-purpose='lead-title']";
    private static final String COURSE_DESC_SELECTOR = "[data-purpose='lead-headline']";
    private static final String COURSE_PUBDATE_SELECTOR = "[data-purpose='last-update-date']";
    private static final String COURSE_IMAGE_SELECTOR = "[data-purpose='introduction-asset'] img";
    private static final String COURSE_AUTHOR_SELECTOR = ".instructor-links--names--7UPZj > a > span";


    @Override
    public Course getCourse(String courseUrl) {
        courseUrl = nonNullOrFail(validateURL(courseUrl, VALID_URL_PATTERN), "Invalid URL");
        Document doc = nonNullOrFail(this.getDocument(courseUrl), "Failed to download the document");
        String name = nonNullOrFail(getName(doc), "Failed to parse course name");
        String description = getDescription(doc);
        LocalDate pubDate = getPublicationDate(doc);
        String publisher = "Udemy";
        String author = getAuthor(doc);
        String imageUrl = getImageUrl(doc);
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

    private String getImageUrl(Document doc) {
        var element = doc.selectFirst(COURSE_IMAGE_SELECTOR);
        return Objects.isNull(element) ? null : element.attr("src");
    }

    private String getAuthor(Document doc) {
        return doc.select(COURSE_AUTHOR_SELECTOR)
                  .stream()
                  .map(Element::text)
                  .collect(Collectors.joining(", "));
    }

    private LocalDate getPublicationDate(Document doc) {
        LocalDate publicationDate = null;
        try {
            String dateStr = Objects.requireNonNull(doc.selectFirst(COURSE_PUBDATE_SELECTOR))
                                    .child(1)
                                    .text()
                                    .replaceAll("[A-Za-z\\s]", "");
            publicationDate = YearMonth.parse(dateStr, DateTimeFormatter.ofPattern("M/yyyy")).atDay(1);
        } catch (NullPointerException | DateTimeParseException ignored) {
            // ignored
        }
        return publicationDate;
    }

    private String getDescription(Document doc) {
        var element = doc.selectFirst(COURSE_DESC_SELECTOR);
        return Objects.isNull(element) ? "" : element.text();
    }

    private String getName(Document doc) {
        var element = doc.selectFirst(COURSE_TITLE_SELECTOR);
        return Objects.isNull(element) ? null : element.text();
    }

    @Override
    public Document getDocument(String url) {
        try {
            HttpClient client = HttpClient.newBuilder().followRedirects(HttpClient.Redirect.ALWAYS).build();
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            return Jsoup.parse(response.body());
        } catch (IOException e) {
            return null;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return null;
        }
    }
}
