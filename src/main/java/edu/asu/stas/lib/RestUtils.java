package edu.asu.stas.lib;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Objects;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class RestUtils {

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
