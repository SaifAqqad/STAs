package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.StudentProfile;
import edu.asu.stas.data.models.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface StudentProfileRepository extends CrudRepository<StudentProfile, Long> {
    boolean existsByUser(User user);
    Optional<StudentProfile> getByUser(User user);
}
