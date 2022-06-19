package edu.asu.stas.user.account;

import edu.asu.stas.user.User;
import edu.asu.stas.validation.UniqueEmail;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.*;
import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AccountDetails {

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

    @Past(message = "Date of birth must be in the past")
    @NotNull
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateOfBirth;

    public AccountDetails(@NonNull User user) {
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();
        this.email = user.getEmail().contains("stas.oauth") ? "" : user.getEmail();
        this.dateOfBirth = user.getDateOfBirth();
    }

}
