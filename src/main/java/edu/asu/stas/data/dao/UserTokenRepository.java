package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.UserToken;
import edu.asu.stas.data.models.UserToken.Type;
import org.springframework.data.repository.CrudRepository;

public interface UserTokenRepository extends CrudRepository<UserToken, Long> {
    UserToken findByUserIdAndTypeEquals(Long userId, Type type);

    UserToken findByToken(String token);
}
