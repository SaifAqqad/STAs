package edu.asu.stas.data.models;

import lombok.*;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
public class Course {

    private String name;

    private String description;

    private String studentComment;

    private String url;

    private String imageUri;

}
