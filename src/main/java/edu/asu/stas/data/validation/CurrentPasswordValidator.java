package edu.asu.stas.data.validation;

import edu.asu.stas.data.models.User;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Objects;

public class CurrentPasswordValidator implements ConstraintValidator<CurrentPassword, String> {
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void initialize(CurrentPassword constraintAnnotation) {
        // empty
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        User authedUser = UserService.getAuthenticatedUser();

        return Objects.nonNull(authedUser)
                && (Objects.isNull(authedUser.getPassword()) || passwordEncoder.matches(value, authedUser.getPassword()));
    }
}
