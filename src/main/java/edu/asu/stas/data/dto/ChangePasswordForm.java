package edu.asu.stas.data.dto;


import edu.asu.stas.data.validation.CurrentPassword;
import edu.asu.stas.data.validation.Password;
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
