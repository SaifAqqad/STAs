package edu.asu.stas.data.models;

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
    private StudentProfile profile;

}