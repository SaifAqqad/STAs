package edu.asu.stas.studentprofile;

import edu.asu.stas.studentprofile.experience.Experience;
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

    @Autowired
    public StudentProfileService(StudentProfileRepository studentProfileRepository) {
        this.studentProfileRepository = studentProfileRepository;
    }

    public StudentProfile getProfileByUser(@NonNull User user) {
        StudentProfile profile = studentProfileRepository.getByUser(user);
        if (Objects.isNull(profile))
            return null;
        profile.getExperiences().sort(Comparator.comparing(Experience::getStartDate).reversed());
        return profile;
    }

    public StudentProfile getAuthenticatedUserProfile() {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        return getProfileByUser(user);
    }

}
