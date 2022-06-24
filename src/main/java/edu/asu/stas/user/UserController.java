package edu.asu.stas.user;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {
    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public Page<User> getUsers(
        @RequestParam(required = false, defaultValue = "0") int page,
        @RequestParam(required = false, defaultValue = "10") int size,
        @ModelAttribute("authenticatedUser") User authenticatedUser
    ) {
        page = page < 0 ? 0 : page;
        size = size < 0 ? 10 : size;
        return userRepository.findAllByUserIdIsNot(authenticatedUser.getUserId(), PageRequest.of(page, size));
    }

}
