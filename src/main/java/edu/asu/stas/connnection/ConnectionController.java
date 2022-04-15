package edu.asu.stas.connnection;

import edu.asu.stas.connnection.oauth.OAuthClientHelper;
import edu.asu.stas.lib.TokenGenerator;
import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Objects;


@Controller
@SessionAttributes({"clientRegistration", "state", "redirectUri"})
public class ConnectionController {
    private final TokenGenerator keyGenerator;
    private final ClientRegistrationRepository clientRegistrationRepository;
    private final OAuthClientHelper oAuthClientHelper;
    private final UserService userService;


    @Autowired
    public ConnectionController(
            TokenGenerator keyGenerator,
            ClientRegistrationRepository clientRegistrationRepository,
            OAuthClientHelper oAuthClientHelper,
            UserService userService
    ) {
        this.keyGenerator = keyGenerator;
        this.clientRegistrationRepository = clientRegistrationRepository;
        this.oAuthClientHelper = oAuthClientHelper;
        this.userService = userService;
    }

    @GetMapping("/connect/{clientId}")
    public String connectToService(
            @PathVariable String clientId,
            @RequestParam(required = false, defaultValue = "/") String redirectUri,
            Model model
    ) {
        ClientRegistration clientRegistration = clientRegistrationRepository.findByRegistrationId(clientId);
        String state = keyGenerator.generateToken(46);
        model.addAttribute("clientRegistration", clientRegistration);
        model.addAttribute("state", state);
        model.addAttribute("redirectUri", redirectUri);
        return "redirect:" + oAuthClientHelper.getAuthorizationUri(clientRegistration, state);
    }

    @GetMapping("/oauth/redirect/{registrationId}/connect")
    public String redirectFromService(
            @RequestParam(required = false) String code,
            @RequestParam String state,
            @RequestParam(required = false) String error,
            @RequestParam(required = false, name = "error_description") String errorDesc,
            @PathVariable(name = "registrationId") String registrationId,
            @SessionAttribute("state") String savedState,
            @SessionAttribute("redirectUri") String redirectUri,
            @SessionAttribute("clientRegistration") ClientRegistration clientRegistration,
            RedirectAttributes redirectAttributes,
            SessionStatus sessionStatus
    ) {
        // clear the session
        sessionStatus.setComplete();
        // check the csrf token (state)
        if (!state.equals(savedState) || !registrationId.equalsIgnoreCase(clientRegistration.getClientName())) {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", "An error occurred during redirection");
            return "redirect:" + (redirectUri + "?error");
        }
        // check for an oauth-provider error
        if(Objects.nonNull(error)){
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", errorDesc);
            return "redirect:" + (redirectUri + "?error");
        }
        // Exchange the temp code for an OAuth2UserRequest
        OAuth2UserRequest oAuth2UserRequest = oAuthClientHelper.exchangeOAuthCode(code, clientRegistration);
        // Connect the userRequest to the authed user
        try {
            userService.loadUser(oAuth2UserRequest);
        } catch (OAuth2AuthenticationException e) {
            redirectAttributes.addFlashAttribute("toastColor", "danger");
            redirectAttributes.addFlashAttribute("toast", e.getError().getDescription());
            return "redirect:" + (redirectUri + "?error");
        }
        redirectAttributes.addFlashAttribute("toast", StringUtils.capitalize(clientRegistration.getClientName()) + " account connected successfully");
        return "redirect:" + redirectUri;
    }

}
