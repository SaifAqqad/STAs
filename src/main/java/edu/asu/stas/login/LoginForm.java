package edu.asu.stas.login;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class LoginForm {

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email")
    private String email="";

    @NotBlank(message = "Password is required")
    private String password="";

}
