package edu.asu.stas.studentprofile.activity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.asu.stas.studentprofile.StudentProfile;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


@Entity
@NoArgsConstructor
@Getter
@Setter
public class Activity {
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd MMMM, yyyy");

    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String name;

    @Column(length = 5000)
    private String description;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    private String imageUri;

    @ManyToOne(optional = false, targetEntity = StudentProfile.class)
    @JsonIgnore
    private StudentProfile profile;

    @Transient
    public String getFormattedDate() {
        return date.format(DATE_TIME_FORMATTER);
    }

}
