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
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.Objects;

@SuppressWarnings("ClassCanBeRecord")
@Service
public class StudentProfileService {

    private final StudentProfileRepository studentProfileRepository;
    private final ActivityRepository activityRepository;
    private final CourseRepository courseRepository;
    private final ExperienceRepository experienceRepository;
    private final ProjectRepository projectRepository;

    @Autowired
    public StudentProfileService(
            StudentProfileRepository studentProfileRepository,
            ActivityRepository activityRepository,
            CourseRepository courseRepository,
            ExperienceRepository experienceRepository,
            ProjectRepository projectRepository
    ) {
        this.studentProfileRepository = studentProfileRepository;
        this.activityRepository = activityRepository;
        this.courseRepository = courseRepository;
        this.experienceRepository = experienceRepository;
        this.projectRepository = projectRepository;
    }

    public StudentProfile getProfileByUser(@NonNull User user) {
        StudentProfile profile = studentProfileRepository.getByUser(user);
        if (Objects.isNull(profile)) return null;
        profile.getExperiences().sort(Comparator.comparing(Experience::getStartDate).reversed());
        return profile;
    }

    public StudentProfile getProfileById(Long id) {
        return studentProfileRepository.findById(id).orElse(null);
    }

    public StudentProfile getAuthenticatedUserProfile() {
        User user = UserService.getAuthenticatedUser();
        if (Objects.isNull(user))
            return null;
        return getProfileByUser(user);
    }

    public Activity getActivityById(Long id) {
        return activityRepository.findById(id).orElse(null);
    }

    public Course getCourseById(Long id) {
        return courseRepository.findById(id).orElse(null);
    }

    public Experience getExperienceById(Long id) {
        return experienceRepository.findById(id).orElse(null);
    }

    public Project getProjectById(Long id) {
        return projectRepository.findById(id).orElse(null);
    }

}
