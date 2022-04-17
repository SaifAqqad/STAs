package edu.asu.stas.studentprofile.activity;

import edu.asu.stas.studentprofile.StudentProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.util.Objects;

@RestController
@RequestMapping("/profile/activities")
public class ActivityController {
    private final StudentProfileService studentProfileService;
    private final ActivityRepository activityRepository;

    public ActivityController(StudentProfileService studentProfileService, ActivityRepository activityRepository) {
        this.studentProfileService = studentProfileService;
        this.activityRepository = activityRepository;
    }

    // GET /profile/activities/{id}
    @GetMapping("{id}")
    public ResponseEntity<Activity> getById(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var activity = activityRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(activity))
            return ResponseEntity.notFound().build();
        return ResponseEntity.ok(activity);
    }

    // POST /profile/activities/delete
    @PostMapping("delete")
    @Transactional
    public RedirectView deleteById(Activity activity, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (activityRepository.existsByProfileAndId(profile, activity.getId())) {
            activityRepository.deleteByProfileAndId(profile, activity.getId());
            redirectAttributes.addFlashAttribute("toast", "Activity deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/activities/{id}
    @PostMapping("{id}")
    public RedirectView updateById(
            @PathVariable Long id,
            Activity activity,
            @RequestParam MultipartFile imageUriData,
            RedirectAttributes redirectAttributes
    ) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (id.equals(activity.getId()) && activityRepository.existsByProfileAndId(profile, activity.getId())) {
            activity.setProfile(profile);
            activityRepository.save(activity);
            redirectAttributes.addFlashAttribute("toast", "Activity updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/activities
    @PostMapping
    public RedirectView addNew(
            Activity activity,
            @RequestParam MultipartFile imageUriData,
            RedirectAttributes redirectAttributes
    ) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        activity.setProfile(profile);
        activityRepository.save(activity);
        redirectAttributes.addFlashAttribute("toast", "Activity added successfully");
        return new RedirectView("/profile");
    }

}
