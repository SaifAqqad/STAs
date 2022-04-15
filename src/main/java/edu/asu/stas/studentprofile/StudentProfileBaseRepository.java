package edu.asu.stas.studentprofile;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

@NoRepositoryBean
public interface StudentProfileBaseRepository<T, ID> extends CrudRepository<T, ID> {
    T getByProfileAndId(StudentProfile profile, ID id);

    boolean deleteByProfileAndId(StudentProfile profile, ID id);

}
