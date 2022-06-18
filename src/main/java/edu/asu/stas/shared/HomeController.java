package edu.asu.stas.shared;

import edu.asu.stas.user.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
public class HomeController {

    @GetMapping("/")
    public String getHomePage(@ModelAttribute User authenticatedUser) {
        if (authenticatedUser != null) {
            return "redirect:/profile";
        }
        return "redirect:/login";
    }

}
