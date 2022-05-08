package edu.asu.stas.studentprofile.project;

import edu.asu.stas.content.ContentService;
import edu.asu.stas.studentprofile.StudentProfileService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.Objects;

@RestController
@RequestMapping("/profile/projects")
public class ProjectController {
    private final StudentProfileService studentProfileService;
    private final ProjectRepository projectRepository;
    private final ContentService contentService;

    public ProjectController(
            StudentProfileService studentProfileService,
            ProjectRepository projectRepository,
            ContentService contentService
    ) {
        this.studentProfileService = studentProfileService;
        this.projectRepository = projectRepository;
        this.contentService = contentService;
    }

    // GET /profile/projects/{id}
    @GetMapping("{id}")
    public ResponseEntity<Project> getById(@PathVariable Long id) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        var project = projectRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(project)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(project);
    }

    @GetMapping("profile/{uuid}/projects/{id}")
    public ResponseEntity<Project> getByProfileUuidAndId(@PathVariable String uuid, @PathVariable Long id) {
        var profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            var project = projectRepository.getByProfileAndId(profile, id);
            if (Objects.nonNull(project)) {
                return ResponseEntity.ok(project);
            }
        }
        return ResponseEntity.notFound().build();
    }

    // POST /profile/projects/delete
    @PostMapping("delete")
    @Transactional
    public RedirectView deleteById(Project project, RedirectAttributes redirectAttributes) {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (projectRepository.existsByProfileAndId(profile, project.getId())) {
            projectRepository.deleteByProfileAndId(profile, project.getId());
            String imageName = project.getImageUri().substring(project.getImageUri().lastIndexOf('/') + 1);
            contentService.removeResource("course", project.getId().toString() + "_" + imageName);
            redirectAttributes.addFlashAttribute("toast", "Project deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/activities/{id}
    @PostMapping("{id}")
    @Transactional
    public RedirectView updateById(
            @PathVariable Long id,
            Project project,
            @RequestParam MultipartFile imageUriData,
            RedirectAttributes redirectAttributes
    ) throws IOException {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        if (id.equals(project.getId()) && projectRepository.existsByProfileAndId(profile, project.getId())) {
            project.setProfile(profile);
            if (!imageUriData.isEmpty()) {
                project.setImageUri(contentService.storeResource(
                        imageUriData.getResource(),
                        "project",
                        project.getId().toString()
                ));
            }
            projectRepository.save(project);
            redirectAttributes.addFlashAttribute("toast", "Project updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/activities
    @PostMapping
    @Transactional
    public RedirectView addNew(
            Project project,
            @RequestParam MultipartFile imageUriData,
            RedirectAttributes redirectAttributes
    ) throws IOException {
        var profile = studentProfileService.getAuthenticatedUserProfile();
        project.setProfile(profile);
        project = projectRepository.save(project);
        if (!imageUriData.isEmpty()) {
            project.setImageUri(contentService.storeResource(
                    imageUriData.getResource(),
                    "project",
                    project.getId().toString()
            ));
            projectRepository.save(project);
        }
        redirectAttributes.addFlashAttribute("toast", "Project added successfully");
        return new RedirectView("/profile");
    }

}
