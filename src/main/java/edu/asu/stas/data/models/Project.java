package edu.asu.stas.data.models;

import edu.asu.stas.lib.oauth.GithubProfile.Repository;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.Setter;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@NoArgsConstructor
@Getter
@Setter
public class Project {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String name;

    private String category;

    @Column(length = 5000)
    private String description;

    private String url;

    private String imageUri;

    private LocalDate startDate;

    private LocalDate endDate;

    @ManyToOne(optional = false, targetEntity = StudentProfile.class)
    private StudentProfile profile;

    @Type(type = "json")
    @Column(columnDefinition = "json")
    private Repository repository;
}
