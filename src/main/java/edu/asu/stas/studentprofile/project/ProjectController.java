package edu.asu.stas.studentprofile.project;

import edu.asu.stas.studentprofile.StudentProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.util.Objects;

@RestController
@RequestMapping("/profile/projects")
public class ProjectController {
    private final StudentProfileService studentProfileService;
    private final ProjectRepository projectRepository;

    public ProjectController(StudentProfileService studentProfileService, ProjectRepository projectRepository) {
        this.studentProfileService = studentProfileService;
        this.projectRepository = projectRepository;
    }

    // GET /profile/projects/{id}
    @GetMapping("{id}")
    public ResponseEntity<Project> getById(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var project = projectRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(project))
            return ResponseEntity.notFound().build();
        return ResponseEntity.ok(project);
    }

    // POST /profile/projects/delete
    @PostMapping("delete")
    @Transactional
    public RedirectView deleteById(Project project, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (projectRepository.existsByProfileAndId(profile, project.getId())) {
            projectRepository.deleteByProfileAndId(profile, project.getId());
            redirectAttributes.addFlashAttribute("toast", "Project deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/projects/{id}
    @PostMapping("{id}")
    public RedirectView updateById(@PathVariable Long id, Project project, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (id.equals(project.getId()) && projectRepository.existsByProfileAndId(profile, project.getId())) {
            project.setProfile(profile);
            projectRepository.save(project);
            redirectAttributes.addFlashAttribute("toast", "Project updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/projects
    @PostMapping
    public RedirectView addNew(Project project, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        project.setProfile(profile);
        projectRepository.save(project);
        redirectAttributes.addFlashAttribute("toast", "Project added successfully");
        return new RedirectView("/profile");
    }

}
