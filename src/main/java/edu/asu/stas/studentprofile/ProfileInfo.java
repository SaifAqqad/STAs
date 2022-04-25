package edu.asu.stas.studentprofile;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ProfileInfo {
    private String name;
    private String major;
    private String location;
    private String university;
    private String contactEmail;
    private String contactPhone;
}
