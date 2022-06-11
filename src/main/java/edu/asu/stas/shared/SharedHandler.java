package edu.asu.stas.shared;

import edu.asu.stas.user.User;
import edu.asu.stas.user.UserService;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
@Order(Ordered.HIGHEST_PRECEDENCE)
public class SharedHandler {
    @ModelAttribute("authenticatedUser")
    public User authenticatedUser() {
        return UserService.getAuthenticatedUser();
    }

}
