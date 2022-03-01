package edu.asu.stas.data.validation;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Optional;

public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void initialize(UniqueEmail constraintAnnotation) {
        // empty
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        Optional<User> userWithEmail = userRepository.findByEmail(value.toLowerCase());
        if (userWithEmail.isEmpty()) // if there's no user with the email
            return true;
        // if there is a user -> check if it's the same as the authenticated user -> still true, else -> false
        Object authPrinciple = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return authPrinciple instanceof User authedUser && authedUser.getEmail().equalsIgnoreCase(value.toLowerCase());
    }
}
