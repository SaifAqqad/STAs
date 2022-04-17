package edu.asu.stas.studentprofile.experience;

import edu.asu.stas.studentprofile.StudentProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.util.Objects;

@RestController
@RequestMapping("/profile/experiences")
public class ExperienceController {
    private final StudentProfileService studentProfileService;
    private final ExperienceRepository experienceRepository;

    public ExperienceController(StudentProfileService studentProfileService, ExperienceRepository experienceRepository) {
        this.studentProfileService = studentProfileService;
        this.experienceRepository = experienceRepository;
    }

    // GET /profile/experiences/{id}
    @GetMapping("{id}")
    public ResponseEntity<Experience> getById(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var experience = experienceRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(experience))
            return ResponseEntity.notFound().build();
        return ResponseEntity.ok(experience);
    }

    // POST /profile/experiences/delete
    @PostMapping("delete")
    @Transactional
    public RedirectView deleteById(Experience experience, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (experienceRepository.existsByProfileAndId(profile, experience.getId())) {
            experienceRepository.deleteByProfileAndId(profile, experience.getId());
            redirectAttributes.addFlashAttribute("toast", "Experience deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/experiences/{id}
    @PostMapping("{id}")
    public RedirectView updateById(@PathVariable Long id, Experience experience, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (id.equals(experience.getId()) && experienceRepository.existsByProfileAndId(profile, experience.getId())) {
            experience.setProfile(profile);
            experienceRepository.save(experience);
            redirectAttributes.addFlashAttribute("toast", "Experience updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/experiences
    @PostMapping
    public RedirectView addNew(Experience experience, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        experience.setProfile(profile);
        experienceRepository.save(experience);
        redirectAttributes.addFlashAttribute("toast", "Experience added successfully");
        return new RedirectView("/profile");
    }

}
