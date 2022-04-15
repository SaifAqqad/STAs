package edu.asu.stas.user.account;


import edu.asu.stas.validation.CurrentPassword;
import edu.asu.stas.validation.Password;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
public class ChangePasswordForm {

    @CurrentPassword
    private String currentPassword="";

    @NotBlank(message = "New password is required")
    @Password
    private String newPassword="";

}
