package edu.asu.stas.courseparser;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public interface CourseParser {

    record Course(
        String name,
        String description,
        String author,
        LocalDate publicationDate,
        String publisher,
        String imageUrl,
        String url
    ) {
    }

    class CourseParserException extends RuntimeException {
        public CourseParserException(String message) {
            super(message);
        }
    }

    Pattern urlPattern = Pattern.compile("^(?<protocol>https?://)?(?:www\\.)?(?<host>[A-Za-z\\-]+)\\..{2,}/?");

    Course getCourse(String courseUrl);

    default String validateURL(String urlString, String pattern) {
        if (!urlString.matches(pattern)) {
            return null;
        }
        return urlString;
    }

    default Document getDocument(String url) {
        try {
            return Jsoup.connect(url).get();
        } catch (IOException e) {
            return null;
        }
    }

    default Map<String, String> getStyles(Element element) {
        Map<String, String> styles = new HashMap<>();
        if (element == null || !element.hasAttr("style")) {
            return null;
        }
        String[] styleAttrs = element.attr("style").split(";");
        for (String styleAttr : styleAttrs) {
            String[] style = styleAttr.split(":", 2);
            styles.put(style[0], style[1]);
        }
        return styles;
    }

    default <T> T nonNullOrFail(T obj, String msg) {
        if (Objects.isNull(obj)) {
            throw new CourseParserException(msg);
        }
        return obj;
    }

    static Course getByURL(String courseUrl) throws CourseParserException {
        Matcher matcher = urlPattern.matcher(courseUrl);
        if(!matcher.find())
            throw new CourseParserException("Invalid URL");
        if (Objects.isNull(matcher.group("protocol"))) {
            courseUrl = "https://" + courseUrl;
        }
        String host = matcher.group("host");
        CourseParser parser = switch (host) {
            case "packtpub" -> new PacktpubParser();
            case "udemy" -> new UdemyParser();
            case "pluralsight" -> new PluralsightParser();
            case "oreilly" -> new OreillyParser();
            default -> throw new CourseParserException(host + " is not supported");
        };
        return parser.getCourse(courseUrl);
    }

}
