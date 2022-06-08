package edu.asu.stas.studentprofile.skill;

import edu.asu.stas.studentprofile.StudentProfile;
import org.springframework.data.repository.CrudRepository;

public interface SkillRepository extends CrudRepository<Skill, Long> {
    Skill getAllByProfile(StudentProfile profile);

    boolean existsByProfileAndId(StudentProfile profile, Long id);

    Skill getByProfileAndId(StudentProfile profile, Long id);

    void deleteByProfileAndId(StudentProfile profile, Long id);

}
