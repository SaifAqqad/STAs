package edu.asu.stas.studentprofile;

import edu.asu.stas.studentprofile.activity.Activity;
import edu.asu.stas.studentprofile.activity.ActivityRepository;
import edu.asu.stas.studentprofile.course.Course;
import edu.asu.stas.studentprofile.course.CourseRepository;
import edu.asu.stas.studentprofile.experience.Experience;
import edu.asu.stas.studentprofile.experience.ExperienceRepository;
import edu.asu.stas.studentprofile.project.Project;
import edu.asu.stas.studentprofile.project.ProjectRepository;
import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Objects;

@Controller
public class StudentProfileController {

    private final StudentProfileService studentProfileService;
    private final ExperienceRepository experienceRepository;
    private final ActivityRepository activityRepository;
    private final ProjectRepository projectRepository;
    private final CourseRepository courseRepository;

    @Autowired
    public StudentProfileController(StudentProfileService studentProfileService, ExperienceRepository experienceRepository, ActivityRepository activityRepository, ProjectRepository projectRepository, CourseRepository courseRepository) {
        this.studentProfileService = studentProfileService;
        this.experienceRepository = experienceRepository;
        this.activityRepository = activityRepository;
        this.projectRepository = projectRepository;
        this.courseRepository = courseRepository;
    }

    public StudentProfile getStudentProfile() {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return studentProfileService.getProfileByUser(user);
    }

    @GetMapping("/profile")
    public String getProfilePage(Model model) {
        StudentProfile profile = getStudentProfile();
        if (Objects.isNull(profile)) return "redirect:/profile/create";
        model.addAttribute("profile", profile);
        return "profile/index";
    }

    @GetMapping("/profile/create")
    public String getCreatePage() {
        return "profile/create";
    }

    @GetMapping("profile/experiences/{id}")
    @ResponseBody
    public Experience getExperienceById(@PathVariable Long id) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        return experienceRepository.getByProfileAndId(profile, id);
    }

    @GetMapping("profile/activities/{id}")
    @ResponseBody
    public Activity getActivityById(@PathVariable Long id) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        return activityRepository.getByProfileAndId(profile, id);
    }

    @GetMapping("profile/projects/{id}")
    @ResponseBody
    public Project getProjectById(@PathVariable Long id) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        return projectRepository.getByProfileAndId(profile, id);
    }

    @GetMapping("profile/courses/{id}")
    @ResponseBody
    public Course getCourseById(@PathVariable Long id) {
        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
        return courseRepository.getByProfileAndId(profile, id);
    }

//    @DeleteMapping("profile/experiences/{id}")
//    public ResponseEntity<Long> deleteExperience(@PathVariable Long id) {
//        StudentProfile profile = Objects.requireNonNull(getStudentProfile());
//        if(experienceRepository.deleteByProfileAndId(profile, id))
//            return ResponseEntity.ok()
//        return (ResponseEntity<Long>) ResponseEntity.notFound();
//    }
}
