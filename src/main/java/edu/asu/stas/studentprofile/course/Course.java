package edu.asu.stas.studentprofile.course;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.asu.stas.studentprofile.StudentProfile;
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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(length = 5000)
    private String description;

    @Column(length = 5000)
    private String studentComment;

    private String publisher;

    private String url;

    private String imageUri;

    @ManyToOne(optional = false, targetEntity = StudentProfile.class)
    @JsonIgnore
    private StudentProfile profile;

}
