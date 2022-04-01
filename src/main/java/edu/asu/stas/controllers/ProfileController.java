package edu.asu.stas.controllers;

import edu.asu.stas.data.models.StudentProfile;
import edu.asu.stas.data.models.User;
import edu.asu.stas.service.StudentProfileService;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.Objects;

@Controller
public class ProfileController {

    private final StudentProfileService studentProfileService;

    @Autowired
    public ProfileController(StudentProfileService studentProfileService) {
        this.studentProfileService = studentProfileService;
    }

    @ModelAttribute("studentProfile")
    public StudentProfile getStudentProfile(){
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return studentProfileService.getProfileByUser(user);
    }

    @GetMapping("/profile")
    public String getProfile(){
        return "profile/index";
    }
}
