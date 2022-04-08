package edu.asu.stas.data.models;

import edu.asu.stas.lib.oauth.GithubProfile;
import lombok.*;

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

    private GithubProfile.Repository repository;
}
