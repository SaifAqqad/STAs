package edu.asu.stas.studentprofile;

import com.fasterxml.jackson.annotation.JsonProperty;
import edu.asu.stas.studentprofile.activity.Activity;
import edu.asu.stas.studentprofile.course.Course;
import edu.asu.stas.studentprofile.experience.Experience;
import edu.asu.stas.studentprofile.project.Project;
import edu.asu.stas.user.User;
import lombok.*;
import org.hibernate.Hibernate;
import org.hibernate.annotations.Type;
import org.springframework.util.LinkedCaseInsensitiveMap;

import javax.persistence.*;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Entity
@NoArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
public class StudentProfile implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private static final String PUBLIC_BASE_URI = "/profile/";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NonNull
    private String name;

    @NonNull
    private String contactEmail;

    private String location;

    @Column(length = 5000)
    private String about;

    private String contactPhone;

    private String university;

    private String major;

    private String imageUri;

    private String uuid;

    private boolean isPublic = false;

    private boolean includeInSearch = false;

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
    private final LinkedCaseInsensitiveMap<String> links = new LinkedCaseInsensitiveMap<>();

    @OneToOne(targetEntity = User.class, fetch = FetchType.LAZY, optional = false)
    private User user;

    @JsonProperty("publicUri")
    public String getPublicUri() {
        if (Objects.isNull(uuid)) {
            return null;
        }
        return PUBLIC_BASE_URI + uuid;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        StudentProfile profile = (StudentProfile) o;
        return id != null && Objects.equals(id, profile.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
