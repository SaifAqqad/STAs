package edu.asu.stas.login;

import edu.asu.stas.connnection.Connection;
import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.savedrequest.DefaultSavedRequest;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Objects;

@Controller
@SessionAttributes({"tempAuthentication", "redirectUri"})
public class LoginController {
    private final AuthenticationManager authenticationManager;
    private final UserService userService;

    public LoginController(AuthenticationManager authenticationManager, UserService userService) {
        this.authenticationManager = authenticationManager;
        this.userService = userService;
    }

    //---  Login page

    @ModelAttribute("loginForm")
    public LoginForm loginForm() {
        return new LoginForm();
    }

    @GetMapping("/login")
    public String getLoginPage(
        Authentication authentication,
        Model model,
        HttpServletRequest request,
        HttpServletResponse response
    ) {
        if (authentication != null && authentication.isAuthenticated()) {
            return "redirect:/";
        }
        model.addAttribute("redirectUri", getRedirectUri(request, response));
        return "login/index";
    }

    @PostMapping("/login/do")
    public String postLoginForm(
        @Validated LoginForm loginForm,
        BindingResult bindingResult,
        Model model,
        RedirectAttributes redirectAttributes,
        SessionStatus sessionStatus
    ) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute(
                "org.springframework.validation.BindingResult.loginForm",
                bindingResult
            );
            redirectAttributes.addFlashAttribute("loginForm", loginForm);
            return "redirect:/login?error";
        }
        return doLogin(loginForm, model, redirectAttributes, sessionStatus);
    }

    private String doLogin(
        LoginForm loginForm,
        Model model,
        RedirectAttributes redirectAttributes,
        SessionStatus sessionStatus
    ) {
        Authentication authentication;
        try {
            authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    loginForm.getEmail(),
                    loginForm.getPassword()
                )
            );
        } catch (AuthenticationException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("authError", true);
            if (e instanceof DisabledException) {
                redirectAttributes.addFlashAttribute("errorType", 1);
            }
            return "redirect:/login?error";
        }
        if (isUsing2FA(authentication)) {
            redirectAttributes.addFlashAttribute("tempAuthentication", authentication);
            return "redirect:/login/2fa";
        }
        String redirectUri = (String) model.getAttribute("redirectUri");
        sessionStatus.setComplete();
        SecurityContextHolder.getContext().setAuthentication(authentication);
        return "redirect:" + redirectUri;
    }

    @GetMapping("/login/2fa")
    public String get2FAPage(Model model) {
        if (!model.containsAttribute("tempAuthentication")) {
            return "redirect:/login";
        }
        return "login/2fa";
    }

    @PostMapping("/login/2fa/do")
    public String post2FA(
        String code,
        Model model,
        SessionStatus sessionStatus,
        RedirectAttributes redirectAttributes
    ) {
        Authentication tempAuth = (Authentication) model.getAttribute("tempAuthentication");
        User user = Objects.requireNonNull(getUser(tempAuth));
        if (userService.is2FACodeValid(user, code)) {
            String redirectUri = (String) model.getAttribute("redirectUri");
            sessionStatus.setComplete();
            SecurityContextHolder.getContext().setAuthentication(tempAuth);
            return "redirect:" + redirectUri;
        } else {
            redirectAttributes.addFlashAttribute("tempAuthentication", tempAuth);
            redirectAttributes.addFlashAttribute("auth2FAError", true);
            return "redirect:/login/2fa";
        }
    }

    private boolean isUsing2FA(Authentication authentication) {
        if (Objects.nonNull(authentication) && authentication.isAuthenticated()) {
            Object principle = authentication.getPrincipal();
            if (principle instanceof User user) {
                return user.isUsing2FA();
            } else if (principle instanceof Connection connection) {
                return connection.getUser().isUsing2FA();
            }
        }
        return false;
    }

    private User getUser(Authentication authentication) {
        if (Objects.nonNull(authentication) && authentication.isAuthenticated()) {
            Object principle = authentication.getPrincipal();
            if (principle instanceof User user) {
                return user;
            } else if (principle instanceof Connection connection) {
                return connection.getUser();
            }
        }
        return null;
    }

    private String getRedirectUri(HttpServletRequest request, HttpServletResponse response) {
        var savedRequest = (DefaultSavedRequest) (new HttpSessionRequestCache().getRequest(request, response));
        return Objects.nonNull(savedRequest) ? savedRequest.getRequestURI() : "/";
    }
}
