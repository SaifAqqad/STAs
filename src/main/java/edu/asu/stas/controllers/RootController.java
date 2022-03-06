package edu.asu.stas.controllers;

import edu.asu.stas.data.models.User;
import edu.asu.stas.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
public class RootController {
    @ModelAttribute("authenticatedUser")
    public User authenticatedUser() {
        return getAuthenticatedUser();
    }

    public User getAuthenticatedUser(){
        return UserService.getAuthenticatedUser();
    }
}
