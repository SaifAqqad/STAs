package edu.asu.stas.content;

import edu.asu.stas.studentprofile.StudentProfile;
import edu.asu.stas.studentprofile.StudentProfileService;
import edu.asu.stas.user.User;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Objects;

import static edu.asu.stas.lib.RestUtils.requireNonNull;

@RestController
@RequestMapping("/content")
public class ContentController {
    private final ContentService contentService;
    private final StudentProfileService profileService;

    @Autowired
    public ContentController(ContentService contentService, StudentProfileService profileService) {
        this.contentService = contentService;
        this.profileService = profileService;
    }

    @GetMapping("{objectType}/{objectId}/{fileName}")
    public ResponseEntity<Resource> getProfileContent(
        @PathVariable String objectType,
        @PathVariable Long objectId,
        @PathVariable String fileName,
        @ModelAttribute("authenticatedUser") User user
    ) {
        StudentProfile objectProfile = switch (objectType) {
            case "profile" -> requireNonNull(profileService.getProfileById(objectId));
            case "activity" -> requireNonNull(profileService.getActivityById(objectId)).getProfile();
            case "course" -> requireNonNull(profileService.getCourseById(objectId)).getProfile();
            case "experience" -> requireNonNull(profileService.getExperienceById(objectId)).getProfile();
            case "project" -> requireNonNull(profileService.getProjectById(objectId)).getProfile();
            default -> throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        };
        StudentProfile authedProfile = Objects.isNull(user) ? null : profileService.getProfileByUser(user);
        if (objectProfile.isPublic() || objectProfile.equals(authedProfile)) {
            Resource file = requireNonNull(contentService.loadResource(objectType, objectId + "_" + fileName));
            MediaType fileType = MediaType.parseMediaType(new Tika().detect(file.getFilename()));
            return ResponseEntity.ok().contentType(fileType).body(file);
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND);
    }


}
