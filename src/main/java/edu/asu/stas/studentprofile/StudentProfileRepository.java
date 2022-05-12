package edu.asu.stas.studentprofile;

import edu.asu.stas.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;


public interface StudentProfileRepository extends CrudRepository<StudentProfile, Long> {
    boolean existsByUser(User user);

    StudentProfile getByUser(User user);

    StudentProfile getByUuid(String uuid);

    @Query(value = """
            SELECT * FROM student_profile
            WHERE is_public = true
            AND include_in_search = true
            AND MATCH(name, location, university)
            AGAINST (CONCAT(:query, '*') IN BOOLEAN MODE)
            """, nativeQuery = true)
    Page<StudentProfile> searchForProfile(@Param("query") String query, Pageable pageable);
}
