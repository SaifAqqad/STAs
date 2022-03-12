package edu.asu.stas.controllers;

import edu.asu.stas.data.dto.AccountDetails;
import edu.asu.stas.data.dto.ChangePasswordForm;
import edu.asu.stas.data.dto.ResetPasswordForm;
import edu.asu.stas.data.models.User;
import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Objects;

@Controller
public class AccountController {

    private final UserService userService;

    @Autowired
    public AccountController(UserService userService) {
        this.userService = userService;
    }

    //---  Account information page

    // adds the authenticated user's accountDetails to the model (when needed)
    @ModelAttribute
    public AccountDetails accountDetails() {
        User user = UserService.getAuthenticatedUser();
        return Objects.nonNull(user) ? new AccountDetails(user) : null;
    }

    @GetMapping("/account")
    public String getAccountDetailsPage() {
        return "account/index";
    }

    @PostMapping("/account/update")
    public String updateAccountDetails(@Validated @ModelAttribute AccountDetails accountDetails,
                                       BindingResult bindingResult,
                                       RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            // flash attributes are saved and then passed to the next request as model attributes
            // So we can use it to pass the bindingResults to the redirect request
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.accountDetails", bindingResult);
            redirectAttributes.addFlashAttribute("accountDetails", accountDetails);
            return "redirect:/account?error";
        }
        userService.updateUserByAccountDetails(Objects.requireNonNull(UserService.getAuthenticatedUser()), accountDetails);
        redirectAttributes.addFlashAttribute("toast", "Changes saved successfully");
        return "redirect:/account";
    }

    //---  Account security page

    @ModelAttribute("passwordForm")
    public ChangePasswordForm addPasswordForm() {
        return new ChangePasswordForm();
    }

    @GetMapping("/account/security")
    public String getSecurityPage(Model model) {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        if (Objects.isNull(user.getPassword()))
            model.addAttribute("currentPasswordDisabled", true);
        return "account/security";
    }

    @PostMapping("/account/security/update")
    public String postPasswordForm(
            @Validated @ModelAttribute ChangePasswordForm changePasswordForm,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.passwordForm", bindingResult);
            redirectAttributes.addFlashAttribute("passwordForm", changePasswordForm);
            return "redirect:/account/security?error";
        }
        userService.updateUserPassword(Objects.requireNonNull(UserService.getAuthenticatedUser()), changePasswordForm);
        redirectAttributes.addFlashAttribute("toast", "Password changed successfully");
        return "redirect:/account/security";
    }

    //---  Connections page

    @GetMapping("/account/connections")
    public String getConnectionsPage() {
        return "account/connections";
    }

    //--- Reset password flow

    @GetMapping("/reset-password")
    public String getResetPasswordPage(
            @RequestParam(required = false) String token,
            Model model
    ) {
        if (Objects.nonNull(token) && userService.isResetTokenValid(token)) {
            if (!model.containsAttribute("resetPasswordForm"))
                model.addAttribute("resetPasswordForm", new ResetPasswordForm(token));
            model.addAttribute("showResetForm", true);
        }
        return "account/resetPassword";
    }

    @PostMapping("/reset-password/do")
    public String postResetPassword(
            @Validated @ModelAttribute ResetPasswordForm resetPasswordForm,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.resetPasswordForm", bindingResult);
            redirectAttributes.addFlashAttribute("resetPasswordForm", resetPasswordForm);
            redirectAttributes.addAttribute("token", resetPasswordForm.getResetToken());
        } else {
            userService.resetUserPassword(resetPasswordForm);
            redirectAttributes.addFlashAttribute("resetSuccess", true);
        }
        return "redirect:/reset-password";
    }

    @PostMapping("/reset-password/request-email")
    public String postResetPasswordRequest(
            @RequestParam String email,
            RedirectAttributes redirectAttributes
    ) {
        userService.sendResetPasswordEmail(email);
        redirectAttributes.addFlashAttribute("requestSuccess", true);
        return "redirect:/reset-password";
    }
}
