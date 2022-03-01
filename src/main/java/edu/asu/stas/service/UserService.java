package edu.asu.stas.service;

import edu.asu.stas.data.dao.UserRepository;
import edu.asu.stas.data.dao.UserTokenRepository;
import edu.asu.stas.data.dto.AccountDetails;
import edu.asu.stas.data.dto.ChangePasswordForm;
import edu.asu.stas.data.dto.RegistrationForm;
import edu.asu.stas.data.dto.ResetPasswordForm;
import edu.asu.stas.data.models.User;
import edu.asu.stas.data.models.UserToken;
import edu.asu.stas.lib.TokenGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Objects;

@Service
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final UserTokenRepository userTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenGenerator tokenGenerator;
    private final MailService mailService;

    @Autowired
    public UserService(UserRepository userRepository, UserTokenRepository userTokenRepository,
                       PasswordEncoder passwordEncoder, TokenGenerator tokenGenerator, MailService mailService) {
        this.userRepository = userRepository;
        this.userTokenRepository = userTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.tokenGenerator = tokenGenerator;
        this.mailService = mailService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return Objects.requireNonNullElseGet(findByEmail(username.toLowerCase()), () -> {
            throw new UsernameNotFoundException("User not found");
        });
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
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
        UserToken token = new UserToken(
                tokenGenerator.generateToken(64),
                LocalDateTime.now().plusDays(1),
                UserToken.Type.VERIFICATION,
                user
        );
        token = userTokenRepository.save(token);
        // send verification email
        mailService.sendVerificationEmail(user, token);
    }

    public void sendVerificationEmail(String email) {
        // check if there's a user with the email
        User user = findByEmail(email.toLowerCase());
        if (Objects.isNull(user) || user.isEnabled())
            return;
        // check if the user has an existing verification token
        UserToken existingToken = userTokenRepository.findByUserIdAndTypeEquals(user.getId(), UserToken.Type.VERIFICATION);
        if (Objects.nonNull(existingToken))
            userTokenRepository.delete(existingToken);
        // generate a new token
        UserToken newToken = new UserToken(
                tokenGenerator.generateToken(64),
                LocalDateTime.now().plusDays(1),
                UserToken.Type.VERIFICATION,
                user
        );
        newToken = userTokenRepository.save(newToken);
        // send verification email
        mailService.sendVerificationEmail(user, newToken);
    }

    public boolean enableUser(String token) {
        // check if the token exists and is not expired
        UserToken verificationToken = userTokenRepository.findByToken(token);
        if (Objects.isNull(verificationToken) || verificationToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            return false;
        }
        User user = verificationToken.getUser();
        user.setEnabled(true);
        userRepository.save(user);
        userTokenRepository.delete(verificationToken);
        return true;
    }

    public void updateUserByAccountDetails(User user, AccountDetails accountDetails) {
        user.setFirstName(accountDetails.getFirstName().trim());
        user.setLastName(accountDetails.getLastName().trim());
        user.setEmail(accountDetails.getEmail().trim().toLowerCase());
        user.setDateOfBirth(accountDetails.getDateOfBirth());
        userRepository.save(user);
    }

    public void updateUserPassword(User user, ChangePasswordForm changePasswordForm) {
        user.setPassword(passwordEncoder.encode(changePasswordForm.getNewPassword()));
        userRepository.save(user);
    }

    public void resetUserPassword(ResetPasswordForm resetPasswordForm) {
        UserToken token = userTokenRepository.findByToken(resetPasswordForm.getResetToken());
        // if the token doesn't exist or is expired
        if (Objects.isNull(token) || token.getExpiryDate().isBefore(LocalDateTime.now()))
            return;
        User user = token.getUser();
        user.setPassword(passwordEncoder.encode(resetPasswordForm.getNewPassword()));
        userRepository.save(user);
        userTokenRepository.delete(token);
    }

    public boolean isResetTokenValid(String token) {
        UserToken userToken = userTokenRepository.findByToken(token);
        return Objects.nonNull(userToken) && UserToken.Type.RESET_PASSWORD.equals(userToken.getType());
    }

    public void sendResetPasswordEmail(String email) {
        User user = findByEmail(email);
        // if the user exists and is enabled
        if (Objects.nonNull(user) && user.isEnabled()) {
            // if an existing reset token exists -> remove it first
            UserToken existingToken = userTokenRepository.findByUserIdAndTypeEquals(user.getId(), UserToken.Type.RESET_PASSWORD);
            if (Objects.nonNull(existingToken))
                userTokenRepository.delete(existingToken);
            // generate the new token
            UserToken token = new UserToken();
            token.setUser(user);
            token.setExpiryDate(LocalDateTime.now().plusHours(3));
            token.setType(UserToken.Type.RESET_PASSWORD);
            token.setToken(tokenGenerator.generateToken(64));
            token = userTokenRepository.save(token);
            // send the email
            mailService.sendResetEmail(user, token);
        }
    }
}
