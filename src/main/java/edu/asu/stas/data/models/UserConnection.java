package edu.asu.stas.data.models;

import edu.asu.stas.lib.oauth.OAuthProfile;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Map;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class UserConnection implements OAuth2User {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String serviceName;

    @NonNull
    private String serviceUserId;

    @NonNull
    @Column(length = 1000)
    private String serviceToken;

    private String serviceRefreshToken;

    private LocalDateTime serviceTokenExpiry;

    @Transient
    private OAuthProfile serviceUserProfile;

    @ManyToOne(optional = false, fetch = FetchType.EAGER)
    private User user;

    @Override
    public Map<String, Object> getAttributes() {
        return serviceUserProfile.getAttributes();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return user.getAuthorities();
    }

    @Override
    public String getName() {
        return this.getServiceUserId();
    }

    @NoArgsConstructor(access = AccessLevel.PRIVATE)
    public static final class Type {
        public static final String GITHUB = "github";
        public static final String LINKEDIN = "linkedin";
        public static final String GOOGLE = "google";
    }

}
