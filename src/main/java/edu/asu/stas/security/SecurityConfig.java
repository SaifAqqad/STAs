package edu.asu.stas.security;

import edu.asu.stas.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.endpoint.DefaultAuthorizationCodeTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AccessTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AuthorizationCodeGrantRequest;
import org.springframework.security.oauth2.client.http.OAuth2ErrorResponseErrorHandler;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.http.converter.OAuth2AccessTokenResponseHttpMessageConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.HeaderWriterLogoutHandler;
import org.springframework.security.web.header.writers.ClearSiteDataHeaderWriter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.support.SessionFlashMapManager;

import java.util.Arrays;

import static org.springframework.security.web.header.writers.ClearSiteDataHeaderWriter.Directive.*;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    private final UserService userService;

    @Autowired
    public SecurityConfig(UserService userService) {
        this.userService = userService;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http

            .authorizeHttpRequests(authorizeRequests ->
                authorizeRequests
                    .mvcMatchers(HttpMethod.POST, "/profile/**").authenticated()
                    .mvcMatchers(HttpMethod.POST, "/login").denyAll()
                    .mvcMatchers(
                        "/account/**",
                        "/connect/**",
                        "/profile/create/**",
                        "/profile/privacy/**",
                        "/profile/activities/**",
                        "/profile/courses/**",
                        "/profile/experiences/**",
                        "/profile/projects/**",
                        "/profile",
                        "/connections/**").authenticated()
                    .mvcMatchers(
                        "/profile/{uuid}",
                        "/profile/{uuid}/**",
                        "/profile/search").permitAll()

            )

            .formLogin(formLogin ->
                formLogin
                    .loginPage("/login")
                    .usernameParameter("email")
            )

            .logout(logout ->
                logout
                    .logoutSuccessUrl("/")
                    .deleteCookies("JSESSIONID")
                    .addLogoutHandler(new HeaderWriterLogoutHandler(
                        new ClearSiteDataHeaderWriter(CACHE, COOKIES, STORAGE)
                    ))
            )

            .oauth2Login(oauth2 ->
                oauth2
                    // set custom oauth login page
                    .loginPage("/login")

                    .userInfoEndpoint(userInfo ->
                        userInfo
                            // set the user service responsible for getting the appropriate user.principle
                            .userService(userService)
                    )

                    // set authorization url to {baseUrl}/login/oauth/{registrationId}
                    .authorizationEndpoint(authorizationEndpoint ->
                        authorizationEndpoint
                            .baseUri("/login/oauth/")
                    )

                    // set redirect url to {baseUrl}/oauth/redirect/{registrationId}
                    .redirectionEndpoint(redirectionEndpoint ->
                        redirectionEndpoint
                            .baseUri("/oauth/redirect/*")
                    )

                    .tokenEndpoint(tokenEndpoint ->
                        tokenEndpoint
                            .accessTokenResponseClient(authorizationCodeTokenResponseClient())
                    )

                    .failureHandler((request, response, exception) -> {
                        if (exception != null) {
                            String errorMsg;
                            if (exception instanceof OAuth2AuthenticationException e) {
                                errorMsg = e.getError().getDescription();
                            } else {
                                errorMsg = exception.getMessage();
                            }
                            final FlashMap flashMap = new FlashMap();
                            flashMap.put("oauthError", errorMsg);
                            final FlashMapManager flashMapManager = new SessionFlashMapManager();
                            flashMapManager.saveOutputFlashMap(flashMap, request, response);
                        }
                        response.sendRedirect("/error");
                    })
            )
        ;
        return http.build();
    }

    @Bean
    public static PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }


    private OAuth2AccessTokenResponseClient<OAuth2AuthorizationCodeGrantRequest> authorizationCodeTokenResponseClient() {
        var messageConverter = new OAuth2AccessTokenResponseHttpMessageConverter();
        messageConverter.setAccessTokenResponseConverter(new CustomAccessTokenResponseConverter());

        var restTemplate = new RestTemplate(Arrays.asList(new FormHttpMessageConverter(), messageConverter));
        restTemplate.setErrorHandler(new OAuth2ErrorResponseErrorHandler());

        DefaultAuthorizationCodeTokenResponseClient tokenResponseClient = new DefaultAuthorizationCodeTokenResponseClient();
        tokenResponseClient.setRestOperations(restTemplate);

        return tokenResponseClient;
    }

}
