package edu.asu.stas.studentprofile.endorsement;

import edu.asu.stas.studentprofile.skill.Skill;
import edu.asu.stas.user.User;
import org.springframework.data.repository.CrudRepository;


public interface EndorsementRepository extends CrudRepository<Endorsement, Long> {
    boolean existsByUserAndSkill(User user, Skill skill);
}
