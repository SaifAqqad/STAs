package edu.asu.stas.studentprofile;

import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Controller
public class StudentProfileController {

    private final StudentProfileService studentProfileService;

    @Autowired
    public StudentProfileController(StudentProfileService studentProfileService) {
        this.studentProfileService = studentProfileService;
    }

    public StudentProfile getStudentProfile() {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return studentProfileService.getProfileByUser(user);
    }

    @GetMapping("/profile")
    public String getProfilePage(Model model) {
        StudentProfile profile = getStudentProfile();
        if (Objects.isNull(profile)) return "redirect:/profile/create";
        model.addAttribute("profile", profile);
        return "profile/index";
    }

    @GetMapping("/profile/create")
    public String getCreatePage() {
        return "profile/create";
    }

    @PostMapping("/profile/about")
    public String updateProfileAbout(String about, RedirectAttributes redirectAttributes) {
        StudentProfile profile = getStudentProfile();
        if (Objects.nonNull(profile)) {
            profile.setAbout(about.trim());
            studentProfileService.saveProfile(profile);
            redirectAttributes.addFlashAttribute("toast", "Profile updated successfully");
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/info")
    public String updateProfileInfo(ProfileInfo profileInfo, @RequestParam Map<String, String> links, RedirectAttributes redirectAttributes) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        studentProfileService.updateProfileInfo(
                profile,
                profileInfo,
                links.entrySet().stream()
                        .filter(entry -> entry.getKey().startsWith("link_") && !entry.getValue().isBlank())
                        .collect(Collectors.toMap(
                                entry -> entry.getKey().replaceFirst("link_", ""),
                                Map.Entry::getValue))
        );
        redirectAttributes.addFlashAttribute("toast", "Profile updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/info/links")
    public String addNewLink(@RequestParam String linkName, @RequestParam String linkUrl, RedirectAttributes redirectAttributes) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        var links = profile.getLinks();
        if (links.containsKey(linkName)) {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "Link already exists");
        } else {
            links.put(linkName, linkUrl);
            studentProfileService.saveProfile(profile);
            redirectAttributes.addFlashAttribute("toast", "Profile updated successfully");
        }
        return "redirect:/profile";
    }

}
