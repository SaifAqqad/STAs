package edu.asu.stas.data.dto;

import edu.asu.stas.data.models.User;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.*;
import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AccountDetails {
    @Id
    private Long id;

    @NotBlank(message = "First name is required")
    @Pattern(regexp = "[^<>()\\[\\]@#$%^&*!;:\\\\/]+", message = "Special characters are not permitted")
    private String firstName;

    @NotBlank(message = "Last name is required")
    @Pattern(regexp = "[^<>()\\[\\]@#$%^&*!;:\\\\/]+", message = "Special characters are not permitted")
    private String lastName;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email")
    private String email;

    @Past(message = "Date of birth must be in the past")
    @NotNull
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateOfBirth;

    public AccountDetails(@NonNull User user) {
        this.id = user.getId();
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();
        this.email = user.getEmail();
        this.dateOfBirth = user.getDateOfBirth();
    }

}
