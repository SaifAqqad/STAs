package edu.asu.stas.studentprofile.project;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import edu.asu.stas.studentprofile.StudentProfile;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

import static edu.asu.stas.lib.DateUtils.getYearMonthPeriod;

@Entity
@NoArgsConstructor
@Getter
@Setter
public class Project {
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("MMM yyyy");

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NonNull
    private String name;

    @Column(length = 5000)
    private String description;

    private String url;

    private String imageUri;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate startDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate endDate;

    @ManyToOne(optional = false, targetEntity = StudentProfile.class)
    @JsonIgnore
    private StudentProfile profile;

    @Transient
    @JsonProperty("formattedStartDate")
    public String getFormattedStartDate() {
        return Objects.nonNull(startDate) ? startDate.format(DATE_TIME_FORMATTER) : null;
    }

    @Transient
    @JsonProperty("formattedEndDate")
    public String getFormattedEndDate() {
        return Objects.nonNull(endDate) ? endDate.format(DATE_TIME_FORMATTER) : null;
    }

    @Transient
    @JsonProperty("duration")
    public String getDuration() {
        return getYearMonthPeriod(startDate, endDate);
    }

}
