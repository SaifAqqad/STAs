package edu.asu.stas.data.models;

import lombok.*;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class StudentProfile implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String name;

    @NonNull
    private String contactEmail;

    private String about;

    private String contactPhone;

    private String university;

    private String major;

    @Type(type = "json")
    @Column(columnDefinition = "json")
    private final List<Course> courses = new ArrayList<>();

    @Type(type = "json")
    @Column(columnDefinition = "json")
    private final List<Activity> activities = new ArrayList<>();

    @Type(type = "json")
    @Column(columnDefinition = "json")
    private final List<Project> projects = new ArrayList<>();

    @OneToOne(targetEntity = User.class, fetch = FetchType.LAZY, optional = false)
    private User user;
}
