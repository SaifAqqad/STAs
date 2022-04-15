package edu.asu.stas.studentprofile.experience;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.asu.stas.studentprofile.StudentProfile;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@NoArgsConstructor
@Getter
@Setter
public class Experience {
    @Id
    @GeneratedValue
    private Long id;

    private String companyName;

    private String jobTitle;

    @Column(length = 5000)
    private String description;

    private LocalDate startDate;

    private LocalDate endDate;

    @ManyToOne(optional = false, targetEntity = StudentProfile.class)
    @JsonIgnore
    private StudentProfile profile;

}