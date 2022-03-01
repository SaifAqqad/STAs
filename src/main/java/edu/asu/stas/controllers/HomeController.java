package edu.asu.stas.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String getHomePage() {
        return "home/index";
    }

    @GetMapping("/about")
    public String getAboutPage() {
        return "home/about";
    }

}
