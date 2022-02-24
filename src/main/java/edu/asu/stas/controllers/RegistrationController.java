package edu.asu.stas.controllers;

import edu.asu.stas.data.dto.RegistrationForm;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/register")
public class RegistrationController {

    @ModelAttribute("registrationForm")
    public RegistrationForm addRegistrationFormToModel() {
        return new RegistrationForm();
    }

    @GetMapping("")
    public String getRegistrationPage() {
        return "registration/index";
    }

    @PostMapping("")
    public String postRegistrationForm(@Validated @ModelAttribute RegistrationForm registrationForm, BindingResult bindingResult, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.spring.validation.BindingResult.registrationForm", bindingResult);
            redirectAttributes.addFlashAttribute("registrationForm", registrationForm);
            return "redirect:/register?error";
        }
        // TODO: register the user using UserService
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
