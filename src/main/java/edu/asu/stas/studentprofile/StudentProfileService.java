package edu.asu.stas.studentprofile;

import edu.asu.stas.content.ContentService;
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

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.Comparator;
import java.util.Map;
import java.util.Objects;

@Service
public class StudentProfileService {

    private final StudentProfileRepository studentProfileRepository;
    private final ActivityRepository activityRepository;
    private final CourseRepository courseRepository;
    private final ExperienceRepository experienceRepository;
    private final ProjectRepository projectRepository;
    private final TokenGenerator tokenGenerator;
    private final ContentService contentService;

    @Autowired
    public StudentProfileService(
        StudentProfileRepository studentProfileRepository,
        ActivityRepository activityRepository,
        CourseRepository courseRepository,
        ExperienceRepository experienceRepository,
        ProjectRepository projectRepository,
        TokenGenerator tokenGenerator,
        ContentService contentService
    ) {
        this.studentProfileRepository = studentProfileRepository;
        this.activityRepository = activityRepository;
        this.courseRepository = courseRepository;
        this.experienceRepository = experienceRepository;
        this.projectRepository = projectRepository;
        this.tokenGenerator = tokenGenerator;
        this.contentService = contentService;
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

    public void deleteProfile(@NonNull StudentProfile studentProfile) {
        studentProfileRepository.delete(studentProfile);
    }

    @Transactional
    public StudentProfile createProfile(StudentProfile profile) {
        StudentProfile initialProfile = new StudentProfile();
        initialProfile.setUser(UserService.getAuthenticatedUser());
        initialProfile.setName(profile.getName());
        initialProfile.setAbout(profile.getAbout());
        initialProfile.setMajor(profile.getMajor());
        initialProfile.setLocation(profile.getLocation());
        initialProfile.setUniversity(profile.getUniversity());
        initialProfile.setContactEmail(profile.getContactEmail());
        initialProfile.setContactPhone(profile.getContactPhone());
        StudentProfile savedProfile = studentProfileRepository.save(initialProfile);
        savedProfile.getCourses().addAll(profile.getCourses());
        savedProfile.getCourses().forEach(course -> this.processCourse(course, savedProfile));
        savedProfile.getActivities().addAll(profile.getActivities());
        savedProfile.getActivities().forEach(activity -> this.processActivity(activity, savedProfile));
        savedProfile.getProjects().addAll(profile.getProjects());
        savedProfile.getProjects().forEach(project -> this.processProject(project, savedProfile));
        savedProfile.getExperiences().addAll(profile.getExperiences());
        initialProfile = studentProfileRepository.save(savedProfile);
        return initialProfile;
    }

    private void processCourse(Course course, StudentProfile profile) {
        course.setProfile(profile);
        if (course.getImageUri() != null) {
            var courseImage = course.getImageUri();
            course.setImageUri(null);
            course = courseRepository.save(course);
            try {
                course.setImageUri(contentService.storeResource(
                    courseImage,
                    "course",
                    course.getId().toString()
                ));
            } catch (IOException e) {
                course.setImageUri(null);
            }
        }
        courseRepository.save(course);
    }

    private void processActivity(Activity activity, StudentProfile profile) {
        activity.setProfile(profile);
        if (activity.getImageUri() != null) {
            var activityImage = activity.getImageUri();
            activity.setImageUri(null);
            activity = activityRepository.save(activity);
            try {
                activity.setImageUri(contentService.storeResource(
                    activityImage,
                    "activity",
                    activity.getId().toString()
                ));
            } catch (IOException e) {
                activity.setImageUri(null);
            }
        }
        activityRepository.save(activity);
    }

    private void processProject(Project project, StudentProfile profile) {
        project.setProfile(profile);
        if (project.getImageUri() != null) {
            var projectImage = project.getImageUri();
            project.setImageUri(null);
            project = projectRepository.save(project);
            try {
                project.setImageUri(contentService.storeResource(
                    projectImage,
                    "project",
                    project.getId().toString()
                ));
            } catch (IOException e) {
                project.setImageUri(null);
            }
        }
        projectRepository.save(project);
    }
}
