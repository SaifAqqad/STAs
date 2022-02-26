package edu.asu.stas.lib;

import lombok.NoArgsConstructor;
import org.springframework.stereotype.Component;

import java.security.SecureRandom;

@NoArgsConstructor
@Component
public class TokenGenerator {
    private static final int LEFT_LIMIT = 48; // numeral '0'
    private static final int RIGHT_LIMIT = 122; // letter 'z'
    private final SecureRandom random = new SecureRandom();

    public String generateToken(int length) {
        return random.ints(LEFT_LIMIT, RIGHT_LIMIT + 1)
                .filter(i -> (i <= 57 || i >= 65) && (i <= 90 || i >= 97))
                .limit(length)
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }
}
