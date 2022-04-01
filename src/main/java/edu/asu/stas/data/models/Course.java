package edu.asu.stas.data.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Course {

    private String name;

    private String description;

    private String studentComment;

    private String url;

    private String imageUri;

}
