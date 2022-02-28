package edu.asu.stas.data.validation;

import edu.asu.stas.data.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class CurrentPasswordValidator implements ConstraintValidator<CurrentPassword, String> {
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void initialize(CurrentPassword constraintAnnotation) {
        // empty
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return principal instanceof User user
                && passwordEncoder.matches(value, user.getPassword());
    }
}
