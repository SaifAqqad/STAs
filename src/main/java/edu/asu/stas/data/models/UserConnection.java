package edu.asu.stas.data.models;

import lombok.*;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.validation.constraints.NotNull;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class UserConnection{
    @Id
    @GeneratedValue
    private Long id;

    @NotNull
    @NonNull
    private String name;

    @NotNull
    @NonNull
    private String token;

    @ManyToOne(optional = false)
    private User user;

}
