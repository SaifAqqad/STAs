package edu.asu.stas.controllers;

import edu.asu.stas.data.dto.RegistrationForm;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Objects;

@Controller
@RequestMapping("/register")
public class RegistrationController {

    private final UserService userService;

    @Autowired
    public RegistrationController(UserService userService) {
        this.userService = userService;
    }

    @ModelAttribute("registrationForm")
    public RegistrationForm addRegistrationFormToModel() {
        return new RegistrationForm("", "", "", "", null);
    }

    @GetMapping("")
    public String getRegistrationPage() {
        return "registration/index";
    }

    @PostMapping("")
    public String postRegistrationForm(
            @Validated @ModelAttribute RegistrationForm registrationForm,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.registrationForm", bindingResult);
            redirectAttributes.addFlashAttribute("registrationForm", registrationForm);
            return "redirect:/register?error";
        }
        userService.registerUser(registrationForm);
        redirectAttributes.addFlashAttribute("registrationSuccess", true);
        return "redirect:/register/verify";
    }

    @GetMapping("verify")
    public String getVerifyPage(Model model) {
        // this prevents anyone from opening the page without being redirected by a successful registration
        if (model.containsAttribute("registrationSuccess")) return "registration/verify";
        else return "redirect:/";
    }

}
