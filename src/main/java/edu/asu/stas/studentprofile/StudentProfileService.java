package edu.asu.stas.studentprofile;

import edu.asu.stas.lib.TokenGenerator;
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
import java.util.Map;
import java.util.Objects;

@SuppressWarnings("ClassCanBeRecord")
@Service
public class StudentProfileService {

    private final StudentProfileRepository studentProfileRepository;
    private final ActivityRepository activityRepository;
    private final CourseRepository courseRepository;
    private final ExperienceRepository experienceRepository;
    private final ProjectRepository projectRepository;
    private final TokenGenerator tokenGenerator;

    @Autowired
    public StudentProfileService(
            StudentProfileRepository studentProfileRepository,
            ActivityRepository activityRepository,
            CourseRepository courseRepository,
            ExperienceRepository experienceRepository,
            ProjectRepository projectRepository,
            TokenGenerator tokenGenerator
    ) {
        this.studentProfileRepository = studentProfileRepository;
        this.activityRepository = activityRepository;
        this.courseRepository = courseRepository;
        this.experienceRepository = experienceRepository;
        this.projectRepository = projectRepository;
        this.tokenGenerator = tokenGenerator;
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

    public StudentProfile getProfileByUuid(String uuid) {
        return studentProfileRepository.getByUuid(uuid);
    }

    public StudentProfile getAuthenticatedUserProfile() {
        User user = UserService.getAuthenticatedUser();
        if (Objects.isNull(user)) {
            return null;
        }
        return getProfileByUser(user);
    }

    public void saveProfile(StudentProfile profile) {
        studentProfileRepository.save(profile);
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

    public void updateProfileInfo(StudentProfile profile, ProfileInfo profileInfo, Map<String, String> links) {
        profile.setName(profileInfo.getName());
        profile.setMajor(profileInfo.getMajor());
        profile.setLocation(profileInfo.getLocation());
        profile.setUniversity(profileInfo.getUniversity());
        profile.setContactEmail(profileInfo.getContactEmail());
        profile.setContactPhone(profileInfo.getContactPhone());
        profile.getLinks().clear();
        profile.getLinks().putAll(links);
        studentProfileRepository.save(profile);
    }

    public ProfilePrivacy updateProfilePrivacy(StudentProfile profile, ProfilePrivacy profilePrivacy) {
        if (profilePrivacy.isPublic()) { // if profile privacy is set to public
            profile.setPublic(true);
            if (profilePrivacy.getUuid().isBlank()) { // if there isn't an existing uuid
                profile.setUuid(tokenGenerator.generateToken(32));
            }
        } else {
            profile.setPublic(false);
            profile.setUuid(null);
        }
        profile.setIncludeInSearch(profilePrivacy.isIncludeInSearch());
        profile = studentProfileRepository.save(profile);
        return new ProfilePrivacy(profile.isPublic(), profile.getUuid(), profile.isIncludeInSearch());
    }
}
