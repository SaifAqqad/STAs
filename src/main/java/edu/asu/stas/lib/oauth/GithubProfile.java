package edu.asu.stas.lib.oauth;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
public class GithubProfile implements OAuthProfile {
    @NonNull
    private String uniqueId;

    @NonNull
    private String firstName;

    @NonNull
    private String lastName;

    @NonNull
    private String email;

    @NonNull
    private Map<String, Object> attributes;

}
