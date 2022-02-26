package edu.asu.stas.data.dto;

import edu.asu.stas.data.validation.Password;
import edu.asu.stas.data.validation.UniqueEmail;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.*;
import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RegistrationForm {

    @NotBlank(message = "First name is required")
    @Pattern(regexp = "[^<>()\\[\\]@#$%^&*!;:\\\\/]+", message = "Special characters are not permitted")
    private String firstName;

    @NotBlank(message = "Last name is required")
    @Pattern(regexp = "[^<>()\\[\\]@#$%^&*!;:\\\\/]+", message = "Special characters are not permitted")
    private String lastName;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email")
    @UniqueEmail
    private String email;

    @Password
    private String password;

    @Past(message = "Date of birth must be in the past")
    @NotNull
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateOfBirth;

}
