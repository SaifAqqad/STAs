package edu.asu.stas.connnection;

import edu.asu.stas.user.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ConnectionRepository extends CrudRepository<Connection, Long> {
    List<Connection> findAllByUser(User user);

    Connection findByServiceNameAndServiceUserId(String serviceName, String serviceUserId);

    Connection findByUserAndServiceName(User user, String serviceName);
}
