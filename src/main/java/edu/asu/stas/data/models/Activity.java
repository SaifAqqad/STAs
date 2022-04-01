package edu.asu.stas.data.models;

import lombok.*;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Activity {
    @NonNull
    private String name;

    private String description;

}
