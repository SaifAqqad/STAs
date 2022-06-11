package edu.asu.stas.studentprofile;

import edu.asu.stas.content.ContentService;
import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
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

    @GetMapping("/profile")
    public String getProfilePage(
        @RequestParam(required = false) Boolean edit,
        Model model,
        SessionStatus sessionStatus,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
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
            User authedUser = (User) model.getAttribute("authenticatedUser");
            if (Objects.nonNull(authedUser) && profile.equals(studentProfileService.getProfileByUser(authedUser))) {
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
        return "profile/create/index";
    }

    @PostMapping("/profile/create")
    @ResponseBody
    public ResponseEntity<StudentProfile> createProfile(
        @Validated @RequestBody StudentProfile profile,
        BindingResult bindingResult,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        if (bindingResult.hasErrors()) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        profile = studentProfileService.createProfile(profile, authedUser);
        return ResponseEntity.ok(profile);
    }

    @PostMapping("/profile/about")
    public String updateProfileAbout(
        String about, RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
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
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
        studentProfileService.updateProfileInfo(
            profile,
            profileInfo,
            links.entrySet()
                 .stream()
                 .filter(entry -> entry.getKey().startsWith("link_") &&
                     !entry.getValue().isBlank())
                 .collect(Collectors.toMap(
                     entry -> entry.getKey()
                                   .replaceFirst("link_", ""),
                     Map.Entry::getValue
                 ))
        );
        redirectAttributes.addFlashAttribute("toast", "Profile updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/info/links")
    public String addNewLink(
        @RequestParam String linkName,
        @RequestParam String linkUrl,
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
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
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User authedUser
    ) throws IOException {
        deleteProfilePicture(redirectAttributes, authedUser);
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
        if (!imageUriData.isEmpty()) {
            profile.setImageUri(contentService.storeResource(
                imageUriData.getResource(),
                "profile",
                profile.getId().toString()
            ));
            studentProfileService.saveProfile(profile);
        }
        redirectAttributes.addFlashAttribute("toast", "Profile picture updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/picture/delete")
    public String deleteProfilePicture(
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
        if (Objects.nonNull(profile.getImageUri())) {
            String imageName = profile.getImageUri().substring(profile.getImageUri().lastIndexOf('/') + 1);
            contentService.removeResource("profile", profile.getId().toString() + "_" + imageName);
            profile.setImageUri(null);
            studentProfileService.saveProfile(profile);
        }
        redirectAttributes.addFlashAttribute("toast", "Profile picture removed successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/privacy")
    @ResponseBody
    public ResponseEntity<ProfilePrivacy> updateProfilePrivacy(
        ProfilePrivacy profilePrivacy,
        @ModelAttribute("authenticatedUser") User authedUser
    ) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
        profilePrivacy = studentProfileService.updateProfilePrivacy(profile, profilePrivacy);
        return ResponseEntity.ok(profilePrivacy);
    }

    @GetMapping("/profile/privacy")
    @ResponseBody
    public ResponseEntity<ProfilePrivacy> getProfilePrivacy(@ModelAttribute("authenticatedUser") User authedUser) {
        StudentProfile profile = studentProfileService.getProfileByUser(authedUser);
        return ResponseEntity.ok(new ProfilePrivacy(
            profile.isPublic(),
            profile.getUuid(),
            profile.isIncludeInSearch()
        ));
    }
}
