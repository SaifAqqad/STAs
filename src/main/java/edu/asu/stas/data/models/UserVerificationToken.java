package edu.asu.stas.data.models;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@NoArgsConstructor
@RequiredArgsConstructor
public class UserVerificationToken {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    @Column(length = 64)
    private String token;

    @NonNull
    private LocalDate expiryDate;

    @OneToOne(optional = false)
    @JoinColumn(nullable = false, name = "user_id")
    @NonNull
    private User user;
}
