package edu.asu.stas.user;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;


@RestController
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
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
        return userService.findAllExcept(authenticatedUser.getUserId(), PageRequest.of(page, size));
    }

    @PostMapping("/users/{userId}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> setRole(
        @PathVariable("userId") Long userId,
        @RequestParam("role") String role
    ) {
        User user = userService.findById(userId);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        user.setRole(role);
        userService.save(user);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/users/{userId}/disable-2FA")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> disable2FA(
        @PathVariable("userId") Long userId
    ) {
        User user = userService.findById(userId);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        user.setUsing2FA(false);
        user.setToken2FA(null);
        userService.save(user);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/users/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteUser(
        @PathVariable("userId") Long userId
    ) {
        if (!userService.existsById(userId)) {
            return ResponseEntity.notFound().build();
        }
        userService.deleteUserById(userId);
        return ResponseEntity.ok().build();
    }


}
