package edu.asu.stas.courseparser;

import edu.asu.stas.lib.JsonHelper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

import static edu.asu.stas.courseparser.CourseParser.Course;
import static edu.asu.stas.courseparser.CourseParser.CourseParserException;

@RestController
public class CourseParserController {

    @GetMapping("/courses")
    public Map<String, Object> getCourse(@RequestParam(required = false, defaultValue = "") String url) {
        try {
            Course course = CourseParser.getByURL(url);
            return JsonHelper.objectMapper().convertValue(course, JsonHelper.MAP_STRING_TYPE_REFERENCE);
        } catch (CourseParserException e) {
            return Map.of("error", e.getMessage());
        }
    }

}
