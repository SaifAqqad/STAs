package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.StudentProfile;
import edu.asu.stas.data.models.User;
import org.springframework.data.repository.CrudRepository;


public interface StudentProfileRepository extends CrudRepository<StudentProfile, Long> {
    boolean existsByUser(User user);
    StudentProfile getByUser(User user);
}
