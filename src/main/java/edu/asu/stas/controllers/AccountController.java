package edu.asu.stas.controllers;

import edu.asu.stas.data.dto.AccountDetails;
import edu.asu.stas.data.dto.PasswordForm;
import edu.asu.stas.data.models.User;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/account")
public class AccountController {

    private final UserService userService;

    @Autowired
    public AccountController(UserService userService) {
        this.userService = userService;
    }

    //---  Account information page

    // adds the authenticated user's accountDetails to the model (when needed)
    @ModelAttribute("accountDetails")
    public AccountDetails accountDetails(Authentication authentication) {
        return new AccountDetails((User) authentication.getPrincipal());
    }

    @GetMapping("")
    public String getAccountDetailsPage() {
        return "account/index";
    }

    @PostMapping("update")
    public String updateAccountDetails(@Validated @ModelAttribute AccountDetails accountDetails,
                                       BindingResult bindingResult,
                                       Authentication authentication,
                                       RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            // flash attributes are saved and then passed to the next request as model attributes
            // So we can use it to pass the bindingResults to the redirect request
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.accountDetails", bindingResult);
            redirectAttributes.addFlashAttribute("accountDetails", accountDetails);
            return "redirect:/account?error";
        }
        userService.updateUserByAccountDetails((User) authentication.getPrincipal(), accountDetails);
        redirectAttributes.addFlashAttribute("toast", "Changes saved successfully");
        return "redirect:/account";
    }

    //---  Account security page

    @ModelAttribute("passwordForm")
    public PasswordForm addPasswordForm() {
        return new PasswordForm();
    }

    @GetMapping("security")
    public String getSecurityPage() {
        return "account/security";
    }

    @PostMapping("security/update")
    public String postPasswordForm(
            @Validated @ModelAttribute PasswordForm passwordForm,
            BindingResult bindingResult,
            Authentication authentication,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.passwordForm", bindingResult);
            redirectAttributes.addFlashAttribute("passwordForm", passwordForm);
            return "redirect:/account/security?error";
        }
        userService.updateUserPassword((User) authentication.getPrincipal(), passwordForm);
        redirectAttributes.addFlashAttribute("toast", "Password changed successfully");
        return "redirect:/account/security";
    }


}
