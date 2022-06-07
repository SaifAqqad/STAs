package edu.asu.stas.user.account;

import edu.asu.stas.connnection.Connection;
import edu.asu.stas.connnection.ConnectionRepository;
import edu.asu.stas.login.ResetPasswordForm;
import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import java.util.Objects;
import java.util.stream.Collectors;

@Controller
public class AccountController {

    private final UserService userService;
    private final ConnectionRepository connectionRepository;

    @Autowired
    public AccountController(UserService userService, ConnectionRepository connectionRepository) {
        this.userService = userService;
        this.connectionRepository = connectionRepository;
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
    public String updateAccountDetails(
            @Validated @ModelAttribute AccountDetails accountDetails,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            // flash attributes are saved and then passed to the next request as model attributes
            // So we can use it to pass the bindingResults to the redirect request
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.accountDetails",
                                                 bindingResult);
            redirectAttributes.addFlashAttribute("accountDetails", accountDetails);
            return "redirect:/account?error";
        }
        userService.updateUserByAccountDetails(Objects.requireNonNull(UserService.getAuthenticatedUser()),
                                               accountDetails);
        redirectAttributes.addFlashAttribute("toast", "Changes saved successfully");
        return "redirect:/account";
    }

    //---  Account security page

    private void setupSecurityPage(Model model) {
        // add empty password form
        if (!model.containsAttribute("changePasswordForm")) {
            model.addAttribute("changePasswordForm", new ChangePasswordForm());
        }

        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        // check if the user has a current password
        if (Objects.isNull(user.getPassword())) {
            model.addAttribute("isCurrentPasswordDisabled", true);
        }
        // add 2FA state
        model.addAttribute("twoFactorState", user.isUsing2FA());
    }

    @GetMapping("/account/security")
    public String getSecurityPage(Model model) {
        setupSecurityPage(model);
        return "account/security";
    }

    @PostMapping("/account/security/update-password")
    public String postPasswordForm(
            @Validated @ModelAttribute ChangePasswordForm changePasswordForm,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.changePasswordForm",
                                                 bindingResult);
            redirectAttributes.addFlashAttribute("changePasswordForm", changePasswordForm);
            return "redirect:/account/security?error";
        }
        userService.updateUserPassword(Objects.requireNonNull(UserService.getAuthenticatedUser()), changePasswordForm);
        redirectAttributes.addFlashAttribute("toast", "Password changed successfully");
        return "redirect:/account/security";
    }

    @PostMapping("/account/security/update-2fa")
    public String post2FAState(
            boolean state,
            String code,
            RedirectAttributes redirectAttributes
    ) {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        if (state) { // turned on 2FA
            MfaSecret secret = userService.enable2FA(user);
            redirectAttributes.addFlashAttribute("twoFactorSecret", secret.getSecret());
            redirectAttributes.addFlashAttribute("twoFactorSecretQR", secret.getQrImageData());
            return "redirect:/account/security";
        } else { // turned off 2FA
            if (Objects.nonNull(code) && (userService.is2FACodeValid(user, code) || user.getToken2FA().equals(code))) {
                userService.disable2FA(user);
                redirectAttributes.addFlashAttribute("toast", "Two-factor authentication disabled successfully");
                return "redirect:/account/security";
            }
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "Authentication code invalid");
            return "redirect:/account/security?error";
        }
    }

    @PostMapping("/account/security/delete")
    public String deleteAccount(
            @RequestParam(required = false) String code2FA,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) throws ServletException {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        if (user.isUsing2FA() && !userService.is2FACodeValid(user, code2FA)) {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "Authentication code invalid");
            return "redirect:/account/security";
        }
        boolean isDeleted = userService.deleteUserById(user.getId());
        if(!isDeleted){
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "Account deletion failed");
            return "redirect:/account/security";
        }
        request.logout();
        redirectAttributes.addFlashAttribute("toast", "Account deleted successfully");
        return "redirect:/";
    }

    //---  Connections page

    @GetMapping("/account/connections")
    public String getConnectionsPage(Model model) {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        model.addAllAttributes(connectionRepository
                                       .findAllByUser(user)
                                       .stream()
                                       .collect(Collectors.toMap(conn -> "service_" + conn.getServiceName(),
                                                                 conn -> conn)));
        return "account/connections";
    }

    @GetMapping("/account/connections/disconnect/{serviceName}")
    public String disconnectService(@PathVariable String serviceName, RedirectAttributes redirectAttributes) {
        User user = Objects.requireNonNull(UserService.getAuthenticatedUser());
        Connection connection = connectionRepository.findByUserAndServiceName(user, serviceName);
        if (Objects.isNull(connection)) {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred");
            return "redirect:/account/connections?error";
        }
        connectionRepository.delete(connection);
        redirectAttributes.addFlashAttribute("toast",
                                             StringUtils.capitalize(serviceName) +
                                                     " account disconnected successfully");
        return "redirect:/account/connections";
    }

    //--- Reset password flow

    @GetMapping("/reset-password")
    public String getResetPasswordPage(
            @RequestParam(required = false) String token,
            Model model
    ) {
        if (Objects.nonNull(token) && userService.isResetTokenValid(token)) {
            if (!model.containsAttribute("resetPasswordForm")) {
                model.addAttribute("resetPasswordForm", new ResetPasswordForm(token));
            }
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
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.resetPasswordForm",
                                                 bindingResult);
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
