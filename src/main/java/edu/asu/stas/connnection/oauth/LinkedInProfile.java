package edu.asu.stas.connnection.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import edu.asu.stas.lib.HttpClientHelper;
import edu.asu.stas.lib.JsonHelper;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

import java.util.Map;

import static org.springframework.http.HttpHeaders.AUTHORIZATION;

@Data
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class LinkedInProfile implements OAuthProfile {
    private static final String API_BASE_URL = "https://api.linkedin.com/v2";
    private static final HttpClientHelper http = new HttpClientHelper();

    private String uniqueId;

    private String firstName;

    private String lastName;

    private String email;

    public static String fetchEmail(OAuth2AccessToken accessToken) {
        String response = http.get(
                API_BASE_URL + "/emailAddress?q=members&projection=(elements*(handle~))",
                Map.of(
                        AUTHORIZATION, "Bearer " + accessToken.getTokenValue()
                )
        );
        try {
            JsonNode object = JsonHelper.objectMapper().readTree(response);
            return object.get("elements").get(0).get("handle~").get("emailAddress").asText();
        } catch (JsonProcessingException | NullPointerException ignored) {
            return null;
        }
    }
}
