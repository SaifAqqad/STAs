package edu.asu.stas.studentprofile.course;

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
public class CourseController {
    private final StudentProfileService studentProfileService;
    private final CourseRepository courseRepository;
    private final ContentService contentService;


    public CourseController(
        StudentProfileService studentProfileService,
        CourseRepository courseRepository,
        ContentService contentService
    ) {
        this.studentProfileService = studentProfileService;
        this.courseRepository = courseRepository;
        this.contentService = contentService;
    }

    // GET /profile/courses/{id}
    @GetMapping("/profile/courses/{id}")
    public ResponseEntity<Course> getById(
        @PathVariable Long id,
        @ModelAttribute("authenticatedUser") User user
    ) {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        var course = courseRepository.getByProfileAndId(profile, id);
        if (Objects.isNull(course)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(course);
    }

    @GetMapping("profile/{uuid}/courses/{id}")
    public ResponseEntity<Course> getByProfileUuidAndId(@PathVariable String uuid, @PathVariable Long id) {
        var profile = studentProfileService.getProfileByUuid(uuid);
        if (Objects.nonNull(profile) && profile.isPublic()) {
            var course = courseRepository.getByProfileAndId(profile, id);
            if (Objects.nonNull(course)) {
                return ResponseEntity.ok(course);
            }
        }
        return ResponseEntity.notFound().build();
    }

    // POST /profile/courses/delete
    @PostMapping("/profile/courses/delete")
    @Transactional
    public RedirectView deleteById(
        Course course, RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User user
    ) {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        if (courseRepository.existsByProfileAndId(profile, course.getId())) {
            courseRepository.deleteByProfileAndId(profile, course.getId());
            String imageName = course.getImageUri().substring(course.getImageUri().lastIndexOf('/') + 1);
            contentService.removeResource("course", course.getId().toString() + "_" + imageName);
            redirectAttributes.addFlashAttribute("toast", "Course deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/courses/{id}
    @PostMapping("/profile/courses/{id}")
    @Transactional
    public RedirectView updateById(
        @PathVariable Long id,
        Course course,
        @RequestParam MultipartFile imageUriData,
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User user
    ) throws IOException {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        if (id.equals(course.getId()) && courseRepository.existsByProfileAndId(profile, course.getId())) {
            course.setProfile(profile);
            if (!imageUriData.isEmpty()) {
                course.setImageUri(contentService.storeResource(
                    imageUriData.getResource(),
                    "course",
                    course.getId().toString()
                ));
            } else if (course.getImageUri() != null) {
                course.setImageUri(contentService.storeResource(
                    course.getImageUri(),
                    "course",
                    course.getId().toString()
                ));
            }
            courseRepository.save(course);
            redirectAttributes.addFlashAttribute("toast", "Course updated successfully");
        } else {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
        }
        return new RedirectView("/profile");
    }

    // POST /profile/courses
    @PostMapping("/profile/courses")
    @Transactional
    public RedirectView addNew(
        Course course,
        @RequestParam MultipartFile imageUriData,
        RedirectAttributes redirectAttributes,
        @ModelAttribute("authenticatedUser") User user
    ) throws IOException {
        var profile = Objects.isNull(user) ? null : studentProfileService.getProfileByUser(user);
        course.setProfile(profile);
        course = courseRepository.save(course);
        if (!imageUriData.isEmpty()) {
            course.setImageUri(contentService.storeResource(
                imageUriData.getResource(),
                "course",
                course.getId().toString()
            ));
            courseRepository.save(course);
        } else if (course.getImageUri() != null) {
            course.setImageUri(contentService.storeResource(
                course.getImageUri(),
                "course",
                course.getId().toString()
            ));
        }
        redirectAttributes.addFlashAttribute("toast", "Course added successfully");
        return new RedirectView("/profile");
    }

}
