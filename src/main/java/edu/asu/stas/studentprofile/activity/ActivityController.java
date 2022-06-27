package edu.asu.stas.studentprofile.activity;

import edu.asu.stas.content.ContentService;
import edu.asu.stas.studentprofile.StudentProfileService;
import edu.asu.stas.user.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.Objects;

@RestController
public class ActivityController {
    private final StudentProfileService studentProfileService;
    private final ActivityRepository activityRepository;
    private final ContentService contentService;

    public ActivityController(
        StudentProfileService studentProfileService,
        ActivityRepository activityRepository,
        ContentService contentService
    ) {
        this.studentProfileService = studentProfileService;
        this.activityRepository = activityRepository;
        this.contentService = contentService;
    }

    // GET /profile/activities/{id}
    @GetMapping("/profile/activities/{id}")
    public ResponseEntity<Activity> getById(
        @PathVariable Long id,
        @ModelAttribute("authenticatedUser") User user
    ) {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        var activity = activityRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(activity)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(activity);
    }

    @GetMapping("profile/{uuid}/activities/{id}")
    public ResponseEntity<Activity> getByProfileUuidAndId(@PathVariable String uuid, @PathVariable Long id) {
        var profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            var activity = activityRepository.getByProfileAndId(profile, id);
            if (Objects.nonNull(activity)) {
                return ResponseEntity.ok(activity);
            }
        }
        return ResponseEntity.notFound().build();
    }

    // POST /profile/activities/delete
    @PostMapping("/profile/activities/delete")
    @Transactional
    public RedirectView deleteById(
        Activity activity, RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User user
    ) {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        var activityObj = activityRepository.getByProfileAndId(profile, activity.getId());
        if (Objects.nonNull(activityObj)) {
            profile.getActivities().remove(activityObj);
            String imageName = activity.getImageUri().substring(activity.getImageUri().lastIndexOf('/') + 1);
            contentService.removeResource("activity", activity.getId().toString() + "_" + imageName);
            redirectAttributes.addFlashAttribute("toast", "Activity deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/activities/{id}
    @PostMapping("/profile/activities/{id}")
    @Transactional
    public RedirectView updateById(
        @PathVariable Long id,
        Activity activity,
        @RequestParam MultipartFile imageUriData,
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User user
    ) throws IOException {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        if (id.equals(activity.getId()) && activityRepository.existsByProfileAndId(profile, activity.getId())) {
            activity.setProfile(profile);
            if (!imageUriData.isEmpty()) {
                activity.setImageUri(contentService.storeResource(
                    imageUriData.getResource(),
                    "activity",
                    activity.getId().toString()
                ));
            } else if (activity.getImageUri() != null) {
                activity.setImageUri(contentService.storeResource(
                    activity.getImageUri(),
                    "activity",
                    activity.getId().toString()
                ));
            }
            activityRepository.save(activity);
            redirectAttributes.addFlashAttribute("toast", "Activity updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/activities
    @PostMapping("/profile/activities")
    @Transactional
    public RedirectView addNew(
        Activity activity,
        @RequestParam MultipartFile imageUriData,
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User user
    ) throws IOException {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        activity.setProfile(profile);
        activity = activityRepository.save(activity);
        if (!imageUriData.isEmpty()) {
            activity.setImageUri(contentService.storeResource(
                imageUriData.getResource(),
                "activity",
                activity.getId().toString()
            ));
            activityRepository.save(activity);
        } else if (activity.getImageUri() != null) {
            activity.setImageUri(contentService.storeResource(
                activity.getImageUri(),
                "activity",
                activity.getId().toString()
            ));
        }
        redirectAttributes.addFlashAttribute("toast", "Activity added successfully");
        return new RedirectView("/profile");
    }

}
