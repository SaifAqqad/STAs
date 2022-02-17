package edu.asu.stas.data.models;

import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import java.util.Collection;
import java.util.List;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class User implements UserDetails {
    @Id
    @GeneratedValue
    private Long id;

    @Column(nullable = false)
    @NonNull
    @NotNull
    private String firstName;

    @Column(nullable = false)
    @NonNull
    @NotNull
    private String lastName;

    @Column(nullable = false, unique = true)
    @NonNull
    @NotNull
    @Email
    private String email;

    @Column(nullable = false)
    @NonNull
    @NotNull
    private String password;

    @Column(nullable = false)
    @NonNull
    @NotNull
    private String role;

    private String mfaToken;

    private boolean isUsingMfa;

    private boolean isEnabled;

    @OneToMany(mappedBy = "user")
    private List<UserConnection> connections;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role));
    }

    @Override
    public String getUsername() {
        return getEmail();
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

}
