package edu.asu.stas.data.models;

import lombok.*;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
public class Experience {

    private String companyName;

    private String jobTitle;

    private LocalDate startDate;

    private LocalDate endDate;

}