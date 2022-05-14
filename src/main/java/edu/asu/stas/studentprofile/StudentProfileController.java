package edu.asu.stas.studentprofile;

import edu.asu.stas.content.ContentService;
import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Controller
@SessionAttributes("isEditing")
public class StudentProfileController {

    private final StudentProfileService studentProfileService;
    private final ContentService contentService;


    @Autowired
    public StudentProfileController(StudentProfileService studentProfileService, ContentService contentService) {
        this.studentProfileService = studentProfileService;
        this.contentService = contentService;
    }

    public StudentProfile getStudentProfile() {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return studentProfileService.getProfileByUser(user);
    }

    @GetMapping("/profile")
    public String getProfilePage(
            @RequestParam(required = false) Boolean edit,
            Model model,
            SessionStatus sessionStatus
    ) {
        StudentProfile profile = getStudentProfile();
        if (Objects.isNull(profile)) return "redirect:/profile/create";
        model.addAttribute("profile", profile);
        if (Objects.nonNull(edit)) {
            model.addAttribute("isEditing", edit);
        }
        if (!model.containsAttribute("isEditing")) {
            sessionStatus.setComplete();
            model.addAttribute("isEditing", false);
        }
        return "profile/index";
    }

    @GetMapping("/profile/{uuid}")
    public String getProfileByUuid(@PathVariable String uuid, Model model) {
        StudentProfile profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            User authedUser = UserService.getAuthenticatedUser();
            if(Objects.nonNull(authedUser) && studentProfileService.getProfileByUser(authedUser).equals(profile)) {
                return "redirect:/profile";
            }
            model.addAttribute("profile", profile);
            model.addAttribute("isEditing", false);
            model.addAttribute("isPublicView", true);
            return "profile/index";
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND);
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
    public String updateProfileInfo(
            ProfileInfo profileInfo,
            @RequestParam Map<String, String> links,
            RedirectAttributes redirectAttributes
    ) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        studentProfileService.updateProfileInfo(profile,
                                                profileInfo,
                                                links.entrySet()
                                                        .stream()
                                                        .filter(entry -> entry.getKey().startsWith("link_") &&
                                                                !entry.getValue().isBlank())
                                                        .collect(Collectors.toMap(entry -> entry.getKey()
                                                                .replaceFirst("link_", ""), Map.Entry::getValue)));
        redirectAttributes.addFlashAttribute("toast", "Profile updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/info/links")
    public String addNewLink(
            @RequestParam String linkName,
            @RequestParam String linkUrl,
            RedirectAttributes redirectAttributes
    ) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        var links = profile.getLinks();
        if (links.containsKey(linkName)) {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "Link already exists");
        } else {
            links.put(linkName, linkUrl);
            studentProfileService.saveProfile(profile);
            redirectAttributes.addFlashAttribute("toast", "Link added successfully");
        }
        return "redirect:/profile";
    }

    @PostMapping("/profile/picture")
    public String updateProfilePicture(
            @RequestParam MultipartFile imageUriData,
            RedirectAttributes redirectAttributes
    ) throws IOException {
        deleteProfilePicture(redirectAttributes);
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        if (!imageUriData.isEmpty()) {
            profile.setImageUri(contentService.storeResource(imageUriData.getResource(),
                                                             "profile",
                                                             profile.getId().toString()));
            studentProfileService.saveProfile(profile);
        }
        redirectAttributes.addFlashAttribute("toast", "Profile picture updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/picture/delete")
    public String deleteProfilePicture(RedirectAttributes redirectAttributes) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        String imageName = profile.getImageUri().substring(profile.getImageUri().lastIndexOf('/') + 1);
        contentService.removeResource("profile", profile.getId().toString() + "_" + imageName);
        profile.setImageUri(StudentProfile.DEFAULT_IMAGE_URI);
        studentProfileService.saveProfile(profile);
        redirectAttributes.addFlashAttribute("toast", "Profile picture removed successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/privacy")
    @ResponseBody
    public ResponseEntity<ProfilePrivacy> updateProfilePrivacy(ProfilePrivacy profilePrivacy) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        profilePrivacy = studentProfileService.updateProfilePrivacy(profile, profilePrivacy);
        return ResponseEntity.ok(profilePrivacy);
    }

    @GetMapping("/profile/privacy")
    @ResponseBody
    public ResponseEntity<ProfilePrivacy> getProfilePrivacy() {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        return ResponseEntity.ok(new ProfilePrivacy(profile.isPublic(),
                                                    profile.getUuid(),
                                                    profile.isIncludeInSearch()));
    }
}
