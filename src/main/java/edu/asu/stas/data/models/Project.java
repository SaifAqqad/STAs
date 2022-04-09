package edu.asu.stas.data.models;

import edu.asu.stas.lib.oauth.GithubProfile;
import lombok.*;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
public class Project {
    @NonNull
    private String name;

    private String category;

    private String description;

    private String url;

    private String imageUri;

    private LocalDate startDate;

    private LocalDate endDate;

    private GithubProfile.Repository repository;
}
