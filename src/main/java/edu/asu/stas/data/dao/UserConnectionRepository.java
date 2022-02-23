package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.UserConnection;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserConnectionRepository extends CrudRepository<UserConnection, Long> {
    List<UserConnection> findAllByUserId(Long userId);
}
