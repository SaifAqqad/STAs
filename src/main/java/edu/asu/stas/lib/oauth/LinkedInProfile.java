package edu.asu.stas.lib.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.asu.stas.lib.HttpClientHelper;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
public class LinkedInProfile implements OAuthProfile {
    private static final String EMAIL_ENDPOINT = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))";

    private static HttpClientHelper http = new HttpClientHelper();

    @NonNull
    private String uniqueId;

    @NonNull
    private String firstName;

    @NonNull
    private String lastName;

    @NonNull
    private String email;

    @NonNull
    private Map<String, Object> attributes;

    public static String fetchEmail(OAuth2AccessToken accessToken) {
        String response = http.get(EMAIL_ENDPOINT, Map.of("Authorization", "Bearer " + accessToken.getTokenValue()));
        try {
            JsonNode object = new ObjectMapper().readTree(response);
            return object.get("elements").get(0).get("handle~").get("emailAddress").asText();
        } catch (JsonProcessingException | NullPointerException ignored) {
            return null;
        }
    }
}
