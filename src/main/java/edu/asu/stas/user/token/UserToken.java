package edu.asu.stas.user.token;

import edu.asu.stas.user.User;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@RequiredArgsConstructor
public class UserToken {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NonNull
    @Column(length = 64, unique = true)
    private String token;

    @NonNull
    private LocalDateTime expiryDate;

    @NonNull
    private UserToken.Type type;

    @ManyToOne(optional = false)
    @JoinColumn(nullable = false, name = "user_id")
    @NonNull
    private User user;

    public enum Type {
        VERIFICATION,
        RESET_PASSWORD
    }
}
