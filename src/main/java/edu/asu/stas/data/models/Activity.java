package edu.asu.stas.data.models;

import lombok.*;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
public class Activity {
    @NonNull
    private String name;

    private String description;

}
