package edu.asu.stas.data.validation;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.models.User;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Objects;
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
        if (userWithEmail.isEmpty()) // if there's no user with the email -> valid
            return true;
        // else -> get the authenticated user
        User authedUser = UserService.getAuthenticatedUser();
        // check if it's the same as the authenticated user -> still valid, else -> invalid
        return Objects.nonNull(authedUser) && authedUser.getEmail().equalsIgnoreCase(value.toLowerCase());
    }
}
