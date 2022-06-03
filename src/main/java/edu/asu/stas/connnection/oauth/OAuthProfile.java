package edu.asu.stas.connnection.oauth;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import edu.asu.stas.connnection.Connection;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.io.Serializable;

import static com.fasterxml.jackson.annotation.JsonSubTypes.Type;
import static java.util.Objects.requireNonNull;
import static java.util.Objects.requireNonNullElse;

@JsonTypeInfo(
    use = JsonTypeInfo.Id.NAME,
    property = "profileType"
)
@JsonSubTypes({
    @Type(value = GithubProfile.class, name = "github"),
    @Type(value = GoogleProfile.class, name = "google"),
    @Type(value = LinkedInProfile.class, name = "linkedin")
})
public interface OAuthProfile extends Serializable {
    static OAuthProfile getOAuthProfile(OAuth2UserRequest request, OAuth2User user) {
        String serviceName = request.getClientRegistration().getRegistrationId();
        return switch (serviceName) {
            // Map Google users
            case Connection.SupportedTypes.GOOGLE -> {
                String[] fullName = requireNonNull((String) user.getAttribute("name")).split("\\s", 2);
                String firstName = fullName[0];
                String lastName = fullName.length > 1 ? fullName[1] : "";
                String email = requireNonNull(user.getAttribute("email"));
                yield new GoogleProfile(user.getName(), firstName, lastName, email);
            }
            // Map GitHub users
            case Connection.SupportedTypes.GITHUB -> {
                GithubProfile profile = new GithubProfile();
                String[] fullName = requireNonNull((String) user.getAttribute("name")).split("\\s", 2);
                var repos = GithubProfile.fetchUserRepositories(request.getAccessToken());
                // fetch languages for each repo
                repos.forEach(repo -> repo.setLanguages(GithubProfile.fetchLanguages(repo, request.getAccessToken())));
                profile.setUniqueId(user.getName());
                profile.setFirstName(fullName[0]);
                profile.setLastName(fullName.length > 1 ? fullName[1] : "");
                profile.setUserName(requireNonNull(user.getAttribute("login")));
                profile.setEmail(requireNonNull(user.getAttribute("email")));
                profile.getRepositories().addAll(repos);
                yield profile;
            }
            // Map LinkedIn users
            case Connection.SupportedTypes.LINKEDIN -> {
                String firstName = requireNonNull(user.getAttribute("localizedFirstName"));
                String lastName = requireNonNullElse(user.getAttribute("localizedLastName"), "");
                String email = requireNonNull(LinkedInProfile.fetchEmail(request.getAccessToken()));
                yield new LinkedInProfile(user.getName(), firstName, lastName, email);
            }
            default -> null;
        };
    }

    String getUniqueId();

    String getEmail();

    String getFirstName();

    String getLastName();
}
