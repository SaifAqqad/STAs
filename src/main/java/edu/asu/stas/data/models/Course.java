package edu.asu.stas.data.models;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;


@Entity
@NoArgsConstructor
@Getter
@Setter
public class Course {
    @Id
    @GeneratedValue
    private Long id;

    private String name;

    @Column(length = 5000)
    private String description;

    private String studentComment;

    private String url;

    private String imageUri;

    @ManyToOne(optional = false, targetEntity = StudentProfile.class)
    private StudentProfile profile;

}
