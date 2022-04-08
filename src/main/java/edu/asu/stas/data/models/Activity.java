package edu.asu.stas.data.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
public class Activity {
    @NonNull
    private String name;

    private String description;

    private LocalDate date;

    private String imageUri;

    @JsonIgnore
    public String getFormattedDate(){
        return date.format(DateTimeFormatter.ofPattern("dd MMMM, yyyy"));
    }

}
