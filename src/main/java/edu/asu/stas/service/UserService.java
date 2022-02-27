package edu.asu.stas.service;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.dao.UserVerificationTokenRepository;
import edu.asu.stas.data.dto.AccountDetails;
import edu.asu.stas.data.dto.RegistrationForm;
import edu.asu.stas.data.models.User;
import edu.asu.stas.data.models.UserVerificationToken;
import edu.asu.stas.lib.TokenGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Objects;

@Service
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;

    private final UserVerificationTokenRepository verificationTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenGenerator tokenGenerator;
    private final MailService mailService;

    @Autowired
    public UserService(UserRepository userRepository, UserVerificationTokenRepository verificationTokenRepository, PasswordEncoder passwordEncoder, TokenGenerator tokenGenerator, MailService mailService) {
        this.userRepository = userRepository;
        this.verificationTokenRepository = verificationTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.tokenGenerator = tokenGenerator;
        this.mailService = mailService;
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return Objects.requireNonNullElseGet(findByEmail(username.toLowerCase()), () -> {
            throw new UsernameNotFoundException("User not found");
        });
    }

    public void registerUser(RegistrationForm form) {
        // create the user
        User user = new User();
        user.setFirstName(form.getFirstName().trim());
        user.setLastName(form.getLastName().trim());
        user.setEmail(form.getEmail().trim().toLowerCase());
        user.setDateOfBirth(form.getDateOfBirth());
        user.setPassword(passwordEncoder.encode(form.getPassword()));
        user.setRole(User.Roles.STUDENT);
        user.setEnabled(false);
        user = userRepository.save(user);
        // generate verification token
        UserVerificationToken token = new UserVerificationToken();
        token.setToken(tokenGenerator.generateToken(64));
        token.setUser(user);
        token.setExpiryDate(LocalDate.now().plusDays(1));
        token = verificationTokenRepository.save(token);
        // send verification email
        mailService.sendVerificationEmail(user, token);
    }

    public void sendVerificationEmail(String email) {
        // check if there's a user with the email
        User user = findByEmail(email.toLowerCase());
        if (Objects.isNull(user) || user.isEnabled())
            return;
        // check if the user has an existing verification token
        var existingToken = verificationTokenRepository.findByUserId(user.getId());
        if (Objects.nonNull(existingToken))
            verificationTokenRepository.delete(existingToken);
        // generate a new token
        UserVerificationToken newToken = new UserVerificationToken();
        newToken.setToken(tokenGenerator.generateToken(64));
        newToken.setUser(user);
        newToken.setExpiryDate(LocalDate.now().plusDays(1));
        newToken = verificationTokenRepository.save(newToken);
        // send verification email
        mailService.sendVerificationEmail(user, newToken);
    }

    public boolean enableUser(String token) {
        UserVerificationToken verificationToken = verificationTokenRepository.findByToken(token);
        if (Objects.isNull(verificationToken) || verificationToken.getExpiryDate().isBefore(LocalDate.now())) {
            return false;
        }
        User user = verificationToken.getUser();
        user.setEnabled(true);
        userRepository.save(user);
        verificationTokenRepository.delete(verificationToken);
        return true;
    }

    public void updateUserByAccountDetails(User user, AccountDetails accountDetails) {
        user.setFirstName(accountDetails.getFirstName().trim());
        user.setLastName(accountDetails.getLastName().trim());
        user.setEmail(accountDetails.getEmail().trim().toLowerCase());
        user.setDateOfBirth(accountDetails.getDateOfBirth());
        userRepository.save(user);
    }

}
