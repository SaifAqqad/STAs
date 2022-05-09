package edu.asu.stas.studentprofile;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ProfilePrivacy {
    private boolean isPublic;
    private String uuid;
    private boolean includeInSearch;
}
