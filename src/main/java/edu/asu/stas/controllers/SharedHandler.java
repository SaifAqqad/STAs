package edu.asu.stas.controllers;

import edu.asu.stas.data.models.User;
import edu.asu.stas.service.UserService;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class SharedHandler {
    @ModelAttribute("authenticatedUser")
    public User authenticatedUser() {
        return UserService.getAuthenticatedUser();
    }

}
