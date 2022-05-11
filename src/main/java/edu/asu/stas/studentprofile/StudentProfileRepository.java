package edu.asu.stas.studentprofile;

import edu.asu.stas.studentprofile.profilesearch.ProfileInfo;
import edu.asu.stas.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;


public interface StudentProfileRepository extends CrudRepository<StudentProfile, Long> {
    boolean existsByUser(User user);

    StudentProfile getByUser(User user);

    StudentProfile getByUuid(String uuid);

    @Query(value = """
            select p from StudentProfile p
            where p.includeInSearch=true
            and p.name like %:name%
            """)
    Page<ProfileInfo> searchForProfile(String name, Pageable pageable);
}
