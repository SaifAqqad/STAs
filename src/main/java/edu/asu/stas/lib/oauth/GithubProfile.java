package edu.asu.stas.lib.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import edu.asu.stas.lib.HttpClientHelper;
import edu.asu.stas.lib.JsonHelper;
import lombok.*;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.springframework.http.HttpHeaders.AUTHORIZATION;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GithubProfile implements OAuthProfile {
    private static final String API_BASE_URL = "https://api.github.com";
    private static final HttpClientHelper http = new HttpClientHelper();

    private String uniqueId;

    private String firstName;

    private String lastName;

    private String email;

    @Setter(value = AccessLevel.NONE)
    private final List<Repository> repositories = new ArrayList<>();

    public static List<Repository> fetchUserRepositories(OAuth2AccessToken accessToken) {
        String response = http.get(
                API_BASE_URL + "/user/repos?per_page=100",
                Map.of(
                        AUTHORIZATION, "bearer " + accessToken.getTokenValue()
                )
        );
        try {
            return objectMapper().readValue(response, new TypeReference<>() {
            });
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    private static ObjectMapper objectMapper() {
        ObjectMapper mapper = JsonHelper.objectMapper();
        mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
        return mapper;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Repository {
        private String name;
        private String description;
        private String language;
        private Long stargazersCount;
        private String htmlUrl;
    }
}
