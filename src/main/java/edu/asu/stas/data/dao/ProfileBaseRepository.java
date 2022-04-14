package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.StudentProfile;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

@NoRepositoryBean
public interface ProfileBaseRepository<T, ID> extends CrudRepository<T, ID> {
    T getByProfileAndId(StudentProfile profile, ID id);

    boolean deleteByProfileAndId(StudentProfile profile, ID id);

}
