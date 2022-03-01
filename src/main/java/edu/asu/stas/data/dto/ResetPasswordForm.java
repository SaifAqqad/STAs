package edu.asu.stas.data.dto;

import edu.asu.stas.data.validation.Password;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
public class ResetPasswordForm {

    @NotBlank
    private String resetToken="";

    @NotBlank(message = "New password is required")
    @Password
    private String newPassword="";

    public ResetPasswordForm(String resetToken) {
        this.resetToken = resetToken;
    }
}
