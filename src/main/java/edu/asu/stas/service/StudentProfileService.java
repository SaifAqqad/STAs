package edu.asu.stas.service;

import edu.asu.stas.data.dao.StudentProfileRepository;
import edu.asu.stas.data.models.StudentProfile;
import edu.asu.stas.data.models.User;
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StudentProfileService {

    private final StudentProfileRepository studentProfileRepository;

    @Autowired
    public StudentProfileService(StudentProfileRepository studentProfileRepository) {
        this.studentProfileRepository = studentProfileRepository;
    }

    public StudentProfile getProfileByUser(@NonNull User user) {
        return studentProfileRepository.getByUser(user).orElse(null);
    }
}
