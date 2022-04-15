package edu.asu.stas.studentprofile;

import edu.asu.stas.user.User;
import org.springframework.data.repository.CrudRepository;


public interface StudentProfileRepository extends CrudRepository<StudentProfile, Long> {
    boolean existsByUser(User user);
    StudentProfile getByUser(User user);
}
