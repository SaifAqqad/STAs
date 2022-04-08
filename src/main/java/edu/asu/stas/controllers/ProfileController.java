package edu.asu.stas.controllers;

import edu.asu.stas.data.models.StudentProfile;
import edu.asu.stas.data.models.User;
import edu.asu.stas.service.StudentProfileService;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Objects;

@Controller
public class ProfileController {

    private final StudentProfileService studentProfileService;

    @Autowired
    public ProfileController(StudentProfileService studentProfileService) {
        this.studentProfileService = studentProfileService;
    }

    public StudentProfile getStudentProfile(){
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return studentProfileService.getProfileByUser(user);
    }

    @GetMapping("/profile")
    public String getProfile(Model model){
        StudentProfile profile = getStudentProfile();
        if(Objects.nonNull(profile)){
            model.addAttribute("profile", profile);
            return "profile/index";
        }else{
            return "profile/create";
        }
    }
}
