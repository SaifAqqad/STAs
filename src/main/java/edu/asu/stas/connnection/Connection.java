package edu.asu.stas.connnection;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.asu.stas.connnection.oauth.OAuthProfile;
import edu.asu.stas.user.User;
import lombok.*;
import org.hibernate.annotations.Type;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class Connection implements OAuth2User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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

    @Type(type = "json")
    @Column(columnDefinition = "json")
    private OAuthProfile serviceUserProfile;

    @ManyToOne(optional = false, fetch = FetchType.EAGER)
    @JsonIgnore
    private User user;

    @Override
    public Map<String, Object> getAttributes() {
        return Collections.emptyMap();
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
    public static final class SupportedTypes {
        public static final String GITHUB = "github";
        public static final String LINKEDIN = "linkedin";
        public static final String GOOGLE = "google";
    }

}
