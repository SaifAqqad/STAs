package edu.asu.stas.connnection.oauth;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class GoogleProfile implements OAuthProfile {
    private String uniqueId;

    private String firstName;

    private String lastName;

    private String email;
}
