package edu.asu.stas.studentprofile.skill;

import edu.asu.stas.studentprofile.StudentProfileService;
import edu.asu.stas.studentprofile.endorsement.Endorsement;
import edu.asu.stas.studentprofile.endorsement.EndorsementRepository;
import edu.asu.stas.user.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Objects;

@RestController
public class SkillController {

    record SkillInfo(Long id, String name, int level) {
        public static SkillInfo of(Skill skill) {
            return new SkillInfo(skill.getId(), skill.getName(), skill.getLevel());
        }
    }

    record EndorsementInfo(Long endorsementId, long skillId, String endorserName, String endorserEmail) {
        public static EndorsementInfo of(Endorsement endorsement) {
            return new EndorsementInfo(
                endorsement.getId(),
                endorsement.getSkill().getId(),
                endorsement.getUser().getFirstName() + " " + endorsement.getUser().getLastName(),
                endorsement.getUser().getEmail()
            );
        }
    }

    record SkillEndorsements(Long id, List<EndorsementInfo> endorsements) {
        public static SkillEndorsements of(Skill skill) {
            return new SkillEndorsements(
                skill.getId(),
                skill.getEndorsements().stream().map(EndorsementInfo::of).toList()
            );
        }
    }

    private final StudentProfileService studentProfileService;
    private final SkillRepository skillRepository;
    private final EndorsementRepository endorsementRepository;


    public SkillController(
        StudentProfileService studentProfileService,
        SkillRepository skillRepository,
        EndorsementRepository endorsementRepository
    ) {
        this.studentProfileService = studentProfileService;
        this.skillRepository = skillRepository;
        this.endorsementRepository = endorsementRepository;
    }

    // GET /profile/skills/{id}
    @GetMapping("/profile/skills/{id}")
    public ResponseEntity<SkillInfo> getById(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var skill = skillRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(skill)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(SkillInfo.of(skill));
    }

    @GetMapping("profile/{uuid}/skills/{id}")
    public ResponseEntity<SkillInfo> getByProfileUuidAndId(@PathVariable String uuid, @PathVariable Long id) {
        var profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            var skill = skillRepository.getByProfileAndId(profile, id);
            if (Objects.nonNull(skill)) {
                return ResponseEntity.ok(SkillInfo.of(skill));
            }
        }
        return ResponseEntity.notFound().build();
    }

    // GET /profile/skills/{id}/endorsements
    @GetMapping("/profile/skills/{id}/endorsements")
    public ResponseEntity<SkillEndorsements> getSkillEndorsements(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var skill = skillRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(skill)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(SkillEndorsements.of(skill));
    }

    @GetMapping("/profile/{uuid}/skills/{id}/endorsements")
    public ResponseEntity<SkillEndorsements> getSkillEndorsementsByProfileUuid(
        @PathVariable String uuid,
        @PathVariable Long id
    ) {
        var profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            var skill = skillRepository.getByProfileAndId(profile, id);
            if (Objects.nonNull(skill)) {
                return ResponseEntity.ok(SkillEndorsements.of(skill));
            }
        }
        return ResponseEntity.notFound().build();
    }

    @PreAuthorize("isAuthenticated()")
    @PostMapping("/profile/{uuid}/skills/{id}/endorsements")
    public RedirectView addNewEndorsement(
        @PathVariable String uuid,
        @PathVariable Long id,
        RedirectAttributes redirectAttributes
    ) {
        var profile = Objects.requireNonNull(studentProfileService.getProfileByUuid(uuid));
        var skill = Objects.requireNonNull(skillRepository.getByProfileAndId(profile, id));
        var user = UserService.getAuthenticatedUser();
        if (profile.isPublic()) {
            if (endorsementRepository.existsByUserAndSkill(user, skill)) {
                redirectAttributes.addFlashAttribute("toastColor", "danger");
                redirectAttributes.addFlashAttribute("toast", "You have already endorsed this skill");
                return new RedirectView("/profile/" + uuid);
            }
            var endorsement = new Endorsement();
            endorsement.setSkill(skill);
            endorsement.setUser(user);
            endorsementRepository.save(endorsement);
            return new RedirectView("/profile/" + uuid);
        }
        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You cannot endorse a private profile");
    }


    // POST /profile/skills/delete
    @PostMapping("/profile/skills/delete")
    @Transactional
    public RedirectView deleteById(SkillInfo skill, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (skillRepository.existsByProfileAndId(profile, skill.id)) {
            skillRepository.deleteByProfileAndId(profile, skill.id);
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
        SkillInfo skillInfo,
        RedirectAttributes redirectAttributes
    ) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var skill = skillRepository.getByProfileAndId(profile, id);
        if (Objects.nonNull(skill)) {
            skill.setName(skillInfo.name);
            skill.setLevel(skillInfo.level);
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
        SkillInfo skillInfo,
        RedirectAttributes redirectAttributes
    ) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        Skill skill = new Skill();
        skill.setName(skillInfo.name);
        skill.setLevel(skillInfo.level);
        skill.setProfile(profile);
        skillRepository.save(skill);
        redirectAttributes.addFlashAttribute("toast", "Skill added successfully");
        return new RedirectView("/profile");
    }

}
