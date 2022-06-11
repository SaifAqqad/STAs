package edu.asu.stas.user.token;

import edu.asu.stas.user.User;
import edu.asu.stas.user.token.UserToken.Type;
import org.springframework.data.repository.CrudRepository;

public interface UserTokenRepository extends CrudRepository<UserToken, Long> {
    UserToken findByUserAndType(User user, Type type);

    UserToken findByToken(String token);
}
