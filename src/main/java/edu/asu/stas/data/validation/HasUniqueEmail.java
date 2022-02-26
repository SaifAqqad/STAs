package edu.asu.stas.data.validation;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = HasUniqueEmailValidator.class)
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface HasUniqueEmail {
    String message() default "Email has already been taken";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
