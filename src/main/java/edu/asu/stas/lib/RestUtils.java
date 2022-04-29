package edu.asu.stas.lib;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Objects;

public class RestUtils {
    private RestUtils() {
    }

    public static <T> T requireNonNull(T o) {
        if (Objects.isNull(o)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        return o;
    }

    public static <T> T requireNonNull(T o, HttpStatus status) {
        if (Objects.isNull(o)) {
            throw new ResponseStatusException(status);
        }
        return o;
    }
}
