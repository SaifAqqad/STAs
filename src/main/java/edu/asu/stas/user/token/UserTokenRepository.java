package edu.asu.stas.user.token;

import edu.asu.stas.user.token.UserToken.Type;
import org.springframework.data.repository.CrudRepository;

public interface UserTokenRepository extends CrudRepository<UserToken, Long> {
    UserToken findByUserIdAndTypeEquals(Long userId, Type type);

    UserToken findByToken(String token);
}
