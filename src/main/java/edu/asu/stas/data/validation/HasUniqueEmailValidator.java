package edu.asu.stas.data.validation;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.dto.AccountDetails;
import edu.asu.stas.data.models.User;
import org.springframework.beans.factory.annotation.Autowired;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.Optional;

public class HasUniqueEmailValidator implements ConstraintValidator<HasUniqueEmail, AccountDetails> {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void initialize(HasUniqueEmail constraintAnnotation) {
        // empty
    }

    @Override
    public boolean isValid(AccountDetails value, ConstraintValidatorContext context) {
        Optional<User> userOptional = userRepository.findByEmail(value.getEmail());
        boolean valid = userOptional.isEmpty() // its valid if there is no user
                || userOptional.get().getId().equals(value.getId()); // or if the user is the authenticated user
        if (valid)
            return true;
        context.disableDefaultConstraintViolation();
        context.buildConstraintViolationWithTemplate(context.getDefaultConstraintMessageTemplate()).addPropertyNode("email").addConstraintViolation();
        return false;
    }
}
