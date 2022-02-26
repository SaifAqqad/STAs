package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.UserVerificationToken;
import org.springframework.data.repository.CrudRepository;

public interface UserVerificationTokenRepository extends CrudRepository<UserVerificationToken, Long> {
    UserVerificationToken findByUserId(Long userId);
    UserVerificationToken findByToken(String token);
}
