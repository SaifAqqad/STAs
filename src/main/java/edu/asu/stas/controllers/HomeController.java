package edu.asu.stas.controllers;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String getHomePage() {
        return "home/index";
    }

    @GetMapping("/login")
    public String getLoginPage(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated())
            return "redirect:/";
        return "home/login";
    }
}
