package edu.asu.stas.user;

import dev.samstevens.totp.code.CodeVerifier;
import dev.samstevens.totp.exceptions.QrGenerationException;
import dev.samstevens.totp.qr.QrData;
import dev.samstevens.totp.qr.QrDataFactory;
import dev.samstevens.totp.qr.QrGenerator;
import dev.samstevens.totp.secret.SecretGenerator;
import dev.samstevens.totp.util.Utils;
import edu.asu.stas.connnection.Connection;
import edu.asu.stas.connnection.ConnectionRepository;
import edu.asu.stas.connnection.oauth.OAuthProfile;
import edu.asu.stas.lib.TokenGenerator;
import edu.asu.stas.login.ResetPasswordForm;
import edu.asu.stas.mail.MailService;
import edu.asu.stas.registration.RegistrationForm;
import edu.asu.stas.studentprofile.StudentProfile;
import edu.asu.stas.studentprofile.StudentProfileService;
import edu.asu.stas.user.account.AccountDetails;
import edu.asu.stas.user.account.ChangePasswordForm;
import edu.asu.stas.user.account.MfaSecret;
import edu.asu.stas.user.token.UserToken;
import edu.asu.stas.user.token.UserTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2ErrorCodes;
import org.springframework.security.oauth2.core.endpoint.OAuth2ParameterNames;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Objects;

@Service
public class UserService implements UserDetailsService, OAuth2UserService<OAuth2UserRequest, OAuth2User> {
    private static UserRepository userRepository;
    private static ConnectionRepository connectionRepository;
    private final UserTokenRepository userTokenRepository;
    private final StudentProfileService studentProfileService;
    private final PasswordEncoder passwordEncoder;
    private final TokenGenerator tokenGenerator;
    private final MailService mailService;
    private final CodeVerifier totpVerifier;
    private final SecretGenerator secretGenerator;
    private final QrDataFactory qrDataFactory;
    private final QrGenerator qrGenerator;


    @Autowired
    public UserService(
        UserRepository userRepository,
        UserTokenRepository userTokenRepository,
        StudentProfileService studentProfileService,
        PasswordEncoder passwordEncoder,
        TokenGenerator tokenGenerator,
        MailService mailService,
        ConnectionRepository connectionRepository,
        CodeVerifier totpVerifier,
        SecretGenerator secretGenerator,
        QrDataFactory qrDataFactory,
        QrGenerator qrGenerator
    ) {
        UserService.userRepository = userRepository;
        UserService.connectionRepository = connectionRepository;
        this.userTokenRepository = userTokenRepository;
        this.studentProfileService = studentProfileService;
        this.passwordEncoder = passwordEncoder;
        this.tokenGenerator = tokenGenerator;
        this.mailService = mailService;
        this.totpVerifier = totpVerifier;
        this.secretGenerator = secretGenerator;
        this.qrDataFactory = qrDataFactory;
        this.qrGenerator = qrGenerator;
    }

    public static User getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (Objects.nonNull(authentication) && !(authentication instanceof AnonymousAuthenticationToken)) {
            Object principle = authentication.getPrincipal();
            if (principle instanceof User user) {
                return userRepository.findById(user.getUserId()).orElse(null);
            } else if (principle instanceof Connection connection) {
                return userRepository.findById(connection.getUser().getUserId()).orElse(null);
            }
        }
        return null;
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
        if (Objects.isNull(user) || user.isEnabled()) {
            return;
        }
        // check if the user has an existing verification token
        UserToken existingToken = userTokenRepository.findByUserAndType(user, UserToken.Type.VERIFICATION);
        if (Objects.nonNull(existingToken)) {
            userTokenRepository.delete(existingToken);
        }
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


    public void enableUser(Long userId) {
        // enable the user's account
        User user = userRepository.findById(userId).orElseThrow();
        user.setEnabled(true);
        userRepository.save(user);
        // if there's an existing verification token, delete it
        UserToken verificationToken = userTokenRepository.findByUserAndType(user, UserToken.Type.VERIFICATION);
        if (Objects.nonNull(verificationToken)) {
            userTokenRepository.delete(verificationToken);
        }
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
        if (Objects.isNull(token) || token.getExpiryDate().isBefore(LocalDateTime.now())) {
            return;
        }
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
            UserToken existingToken = userTokenRepository.findByUserAndType(user, UserToken.Type.RESET_PASSWORD);
            if (Objects.nonNull(existingToken)) {
                userTokenRepository.delete(existingToken);
            }
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

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // use the default service to get the user's info
        DefaultOAuth2UserService defaultService = new DefaultOAuth2UserService();
        OAuthProfile userProfile = OAuthProfile.getOAuthProfile(userRequest, defaultService.loadUser(userRequest));

        User authedUser = getAuthenticatedUser();

        String serviceName = userRequest.getClientRegistration().getRegistrationId();
        String serviceUserId = userProfile.getUniqueId();

        // check if there's an existing UserConnection
        Connection existingConnection = connectionRepository.findByServiceNameAndServiceUserId(
            serviceName,
            serviceUserId
        );
        if (existingConnection != null) {
            // if there is no authenticated user OR the existing userConnection belongs to the authenticated user
            if (authedUser == null || authedUser.getUserId().equals(existingConnection.getUser().getUserId())) {
                return updateUserConnection(existingConnection, userRequest, userProfile);
            } else {
                throw new OAuth2AuthenticationException(new OAuth2Error(
                    OAuth2ErrorCodes.ACCESS_DENIED,
                    "This %s account is already connected to another user."
                        .formatted(userRequest.getClientRegistration().getClientName()),
                    ""
                ));
            }
        }

        // check if the user is already authenticated and tried to oauth
        if (authedUser != null) {
            // check if the user is already connected to another account from the service
            if (Objects.nonNull(connectionRepository.findByUserAndServiceName(authedUser, serviceName))) {
                throw new OAuth2AuthenticationException(new OAuth2Error(
                    OAuth2ErrorCodes.ACCESS_DENIED,
                    "You can only connect a single %s account."
                        .formatted(userRequest.getClientRegistration().getClientName()),
                    ""
                ));
            } else {
                return createUserConnection(authedUser, userRequest, userProfile);
            }
        }

        // check if there's an existing user with a matching email address
        User existingUser = findByEmail(userProfile.getEmail());
        if (existingUser == null) {
            // register the new user
            return registerOAuthUser(userRequest, userProfile);
        }
        return createUserConnection(existingUser, userRequest, userProfile);
    }

    private Connection updateUserConnection(
        Connection connection,
        OAuth2UserRequest userRequest,
        OAuthProfile userProfile
    ) {
        connection.setServiceToken(userRequest.getAccessToken().getTokenValue());
        connection.setServiceRefreshToken((String) userRequest.getAdditionalParameters()
                                                              .get(OAuth2ParameterNames.REFRESH_TOKEN));
        Instant expiresAt = userRequest.getAccessToken().getExpiresAt();
        if (expiresAt != null && Duration.between(expiresAt, Instant.now()).abs().toSeconds() > 60L) {
            connection.setServiceTokenExpiry(LocalDateTime.ofInstant(expiresAt, ZoneOffset.UTC));
        }
        connection.setServiceUserProfile(userProfile);
        return connectionRepository.save(connection);
    }

    private Connection createUserConnection(User user, OAuth2UserRequest userRequest, OAuthProfile userProfile) {
        Connection newConnection = new Connection();
        newConnection.setUser(user);
        newConnection.setServiceName(userRequest.getClientRegistration().getRegistrationId());
        newConnection.setServiceUserId(userProfile.getUniqueId());
        return updateUserConnection(newConnection, userRequest, userProfile);
    }

    private Connection registerOAuthUser(OAuth2UserRequest userRequest, OAuthProfile userProfile) {
        User user = new User();
        user.setEmail(userProfile.getEmail());
        user.setFirstName(userProfile.getFirstName());
        user.setLastName(userProfile.getLastName());
        user.setRole(User.Roles.STUDENT);
        user.setEnabled(true);
        user = userRepository.save(user);
        return createUserConnection(user, userRequest, userProfile);
    }

    public boolean is2FACodeValid(User user, String code) {
        return isValidLong(code) && totpVerifier.isValidCode(user.getToken2FA(), code);
    }

    private boolean isValidLong(String code) {
        try {
            Long.parseLong(code);
        } catch (NumberFormatException e) {
            return false;
        }
        return true;
    }

    public MfaSecret enable2FA(User user) {
        String secret = secretGenerator.generate();
        user.setUsing2FA(true);
        user.setToken2FA(secret);
        userRepository.save(user);
        return new MfaSecret(
            secret,
            generateQrUri(secret, user.getEmail())
        );
    }

    private String generateQrUri(String secret, String label) {
        QrData data = qrDataFactory.newBuilder()
                                   .label(label)
                                   .secret(secret)
                                   .issuer("STAs")
                                   .build();

        try {
            return Utils.getDataUriForImage(
                qrGenerator.generate(data),
                qrGenerator.getImageMimeType()
            );
        } catch (QrGenerationException e) {
            return null;
        }
    }

    public void disable2FA(User user) {
        user.setToken2FA(null);
        user.setUsing2FA(false);
        userRepository.save(user);
    }

    @Transactional
    public boolean deleteUserById(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        StudentProfile profile = studentProfileService.getProfileByUser(user);
        try {
            if (Objects.nonNull(profile)) {
                studentProfileService.deleteProfile(profile);
            }
            userRepository.delete(user);
        } catch (DataAccessException exception) {
            return false;
        }
        return true;
    }

    public boolean existsById(Long userId) {
        return userRepository.existsById(userId);
    }

    public User findById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public void save(User user) {
        userRepository.save(user);
    }

    public Page<User> findAllExcept(Long userId, PageRequest pageable) {
        return userRepository.findAllByUserIdIsNot(userId, pageable);
    }
}
