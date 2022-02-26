package edu.asu.stas.data.validation;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.models.User;
import org.springframework.beans.factory.annotation.Autowired;

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
        Optional<User> userOptional = userRepository.findByEmail(value.toLowerCase());
        return userOptional.isEmpty();
    }
}
