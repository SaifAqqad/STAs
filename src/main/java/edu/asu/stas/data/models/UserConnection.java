package edu.asu.stas.data.models;

import lombok.*;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class UserConnection {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private Service service;
 
    @NonNull
    private String token;

    @ManyToOne(optional = false)
    private User user;

    public enum Service {
        GITHUB,
        GOOGLE,
        FACEBOOK,
        LINKEDIN,
    }

}
