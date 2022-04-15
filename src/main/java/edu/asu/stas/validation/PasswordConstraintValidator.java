package edu.asu.stas.validation;

import org.passay.*;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class PasswordConstraintValidator implements ConstraintValidator<Password, String> {

    @Override
    public void initialize(Password constraintAnnotation) {
        // will only run once
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        PasswordValidator validator = new PasswordValidator(
                // length between 8 and 40 characters
                new LengthRule(8, 40),

                // at least one upper-case character
                new CharacterRule(EnglishCharacterData.UpperCase, 1),

                // at least one lower-case character
                new CharacterRule(EnglishCharacterData.LowerCase, 1),

                // at least one digit character
                new CharacterRule(EnglishCharacterData.Digit, 1),

                // no whitespace
                new WhitespaceRule(),

                // no sequence of 3 (or more) alphabetical/numerical/qwerty characters
                // e.g. 123 or abc or asdfg
                new IllegalSequenceRule(EnglishSequenceData.Alphabetical, 3, false),
                new IllegalSequenceRule(EnglishSequenceData.Numerical, 3, false),
                new IllegalSequenceRule(EnglishSequenceData.USQwerty, 5, false)
        );
        RuleResult result = validator.validate(new PasswordData(value));
        if (result.isValid()) {
            return true;
        }
        String msgTemplate = String.join("-", validator.getMessages(result));
        context.disableDefaultConstraintViolation();
        context.buildConstraintViolationWithTemplate(msgTemplate).addConstraintViolation();
        return false;
    }
}
