package edu.asu.stas.studentprofile;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

import java.util.stream.Stream;

@NoRepositoryBean
public interface StudentProfileBaseRepository<T, ID> extends CrudRepository<T, ID> {
    T getByProfileAndId(StudentProfile profile, ID id);

    Stream<T> getAllByProfile(StudentProfile profile);

    void deleteByProfileAndId(StudentProfile profile, ID id);

    boolean existsByProfileAndId(StudentProfile profile, ID id);
}
