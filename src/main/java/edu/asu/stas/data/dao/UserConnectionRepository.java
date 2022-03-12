package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.UserConnection;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface UserConnectionRepository extends CrudRepository<UserConnection, Long> {
    List<UserConnection> findAllByUserId(Long userId);
    UserConnection findByServiceNameAndServiceUserId(String serviceName, String serviceUserId);
}
