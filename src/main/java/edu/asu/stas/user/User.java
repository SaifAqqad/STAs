package edu.asu.stas.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.asu.stas.connnection.Connection;
import edu.asu.stas.studentprofile.endorsement.Endorsement;
import edu.asu.stas.user.token.UserToken;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class User implements UserDetails {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    private String firstName;

    private String lastName;

    @Column(nullable = false, unique = true)
    @NonNull
    private String email;

    private String password;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateOfBirth;

    @Column(nullable = false)
    @NonNull
    private String role;

    private String token2FA;

    private boolean isUsing2FA;

    private boolean isEnabled;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private final List<UserToken> tokens = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private final List<Connection> connections = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private final List<Endorsement> endorsements = new ArrayList<>();

    @Override
    @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        var authorities = new ArrayList<GrantedAuthority>();
        authorities.add(new SimpleGrantedAuthority(role));
        if (role.equals(Roles.ADMIN)) {
            authorities.add(new SimpleGrantedAuthority(Roles.STUDENT));
        }
        return authorities;
    }

    @Override
    public String getUsername() {
        return email;
    }

    public String getEmail() {
        return email.contains("stas.oauth") ? "" : email;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    @JsonIgnore
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    @JsonIgnore
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @NoArgsConstructor(access = AccessLevel.PRIVATE)
    public static final class Roles {
        public static final String STUDENT = "ROLE_STUDENT";
        public static final String ADMIN = "ROLE_ADMIN";
    }

}
