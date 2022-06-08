package edu.asu.stas.studentprofile.skill;

import edu.asu.stas.studentprofile.StudentProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.util.Objects;

public class SkillController {

    private final StudentProfileService studentProfileService;
    private final SkillRepository skillRepository;


    public SkillController(
        StudentProfileService studentProfileService,
        SkillRepository skillRepository
    ) {
        this.studentProfileService = studentProfileService;
        this.skillRepository = skillRepository;
    }

    // GET /profile/skills/{id}
    @GetMapping("/profile/skills/{id}")
    public ResponseEntity<Skill> getById(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var skill = skillRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(skill)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(skill);
    }

    @GetMapping("profile/{uuid}/skills/{id}")
    public ResponseEntity<Skill> getByProfileUuidAndId(@PathVariable String uuid, @PathVariable Long id) {
        var profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            var skill = skillRepository.getByProfileAndId(profile, id);
            if (Objects.nonNull(skill)) {
                return ResponseEntity.ok(skill);
            }
        }
        return ResponseEntity.notFound().build();
    }

    // POST /profile/skills/delete
    @PostMapping("/profile/skills/delete")
    @Transactional
    public RedirectView deleteById(Skill skill, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (skillRepository.existsByProfileAndId(profile, skill.getId())) {
            skillRepository.deleteByProfileAndId(profile, skill.getId());
            redirectAttributes.addFlashAttribute("toast", "Skill deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/skills/{id}
    @PostMapping("/profile/skills/{id}")
    @Transactional
    public RedirectView updateById(
        @PathVariable Long id,
        Skill skill,
        RedirectAttributes redirectAttributes
    ) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (id.equals(skill.getId()) && skillRepository.existsByProfileAndId(profile, skill.getId())) {
            skill.setProfile(profile);
            skillRepository.save(skill);
            redirectAttributes.addFlashAttribute("toast", "Skill updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/skills
    @PostMapping("/profile/skills")
    @Transactional
    public RedirectView addNew(
        Skill skill,
        RedirectAttributes redirectAttributes
    ) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        skill.setProfile(profile);
        skillRepository.save(skill);
        redirectAttributes.addFlashAttribute("toast", "Skill added successfully");
        return new RedirectView("/profile");
    }

}
