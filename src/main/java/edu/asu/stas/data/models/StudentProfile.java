package edu.asu.stas.data.models;

import lombok.*;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    private String location;

    private String about;

    private String contactPhone;

    private String university;

    private String major;

    private String imagerUri = "/images/generic_profile.png";

    @OneToMany(mappedBy = "profile", orphanRemoval = true)
    private final List<Course> courses = new ArrayList<>();

    @OneToMany(mappedBy = "profile", orphanRemoval = true)
    private final List<Activity> activities = new ArrayList<>();

    @OneToMany(mappedBy = "profile", orphanRemoval = true)
    private final List<Project> projects = new ArrayList<>();

    @OneToMany(mappedBy = "profile", orphanRemoval = true)
    private final List<Experience> experiences = new ArrayList<>();

    @Type(type = "json")
    @Column(columnDefinition = "json")
    private final Map<String, String> links = new HashMap<>();

    @OneToOne(targetEntity = User.class, fetch = FetchType.LAZY, optional = false)
    private User user;
}
