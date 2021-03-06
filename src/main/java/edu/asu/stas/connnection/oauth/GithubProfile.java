package edu.asu.stas.connnection.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import edu.asu.stas.lib.HttpClientHelper;
import edu.asu.stas.lib.JsonHelper;
import lombok.*;
import org.springframework.security.oauth2.core.OAuth2AccessToken;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import static org.springframework.http.HttpHeaders.AUTHORIZATION;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GithubProfile implements OAuthProfile {
    private static final String API_BASE_URL = "https://api.github.com";
    private static final HttpClientHelper http = new HttpClientHelper();

    private String uniqueId;

    private String userName;

    private String firstName;

    private String lastName;

    private String email;

    @Setter(value = AccessLevel.NONE)
    private final List<Repository> repositories = new ArrayList<>();

    public static List<Repository> fetchUserRepositories(OAuth2AccessToken accessToken) {
        String response = http.get(
            API_BASE_URL + "/user/repos?per_page=100",
            Map.of(AUTHORIZATION, "bearer " + accessToken.getTokenValue())
        );
        try {
            return objectMapper().readValue(response, new TypeReference<>() {
            });
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static Map<String, Long> fetchLanguages(Repository repository, OAuth2AccessToken accessToken) {
        String response = http.get(
            repository.getLanguagesUrl(),
            Map.of(AUTHORIZATION, "bearer " + accessToken.getTokenValue())
        );
        try {
            return objectMapper().readValue(response, new TypeReference<>() {
            });
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }

    private static ObjectMapper objectMapper() {
        final DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        final ObjectMapper mapper = JsonHelper.objectMapper();
        mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
        mapper.setDateFormat(df);
        return mapper;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Repository {
        private String name;
        private String description;
        private String languagesUrl;
        private Long stargazersCount;
        private String htmlUrl;
        private Date createdAt;
        private Date updatedAt;
        private Map<String, Long> languages;
    }
}