package edu.asu.stas.studentprofile.profilesearch;

import edu.asu.stas.studentprofile.StudentProfile;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ProfileInfo {
    private Long id;
    private String name;
    private String location;
    private String university;
    private String major;
    private String imageUri;
    private String publicUri;

    public ProfileInfo(StudentProfile profile){
        this.id = profile.getId();
        this.name = profile.getName();
        this.location = profile.getLocation();
        this.university = profile.getUniversity();
        this.major = profile.getMajor();
        this.imageUri = profile.getImageUri();
        this.publicUri = profile.getPublicUri();
    }
}
