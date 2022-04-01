package edu.asu.stas.data.models;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Project {
    @NonNull
    private String name;

    private String description;

    private String url;
}
