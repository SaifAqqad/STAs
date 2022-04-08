package edu.asu.stas.config;

import edu.asu.stas.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.endpoint.DefaultAuthorizationCodeTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AccessTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AuthorizationCodeGrantRequest;
import org.springframework.security.oauth2.client.http.OAuth2ErrorResponseErrorHandler;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.http.converter.OAuth2AccessTokenResponseHttpMessageConverter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.support.SessionFlashMapManager;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    private final UserService userService;

    @Autowired
    public SecurityConfig(UserService userService) {
        this.userService = userService;
    }

    @Bean
    public static PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http

                .authorizeRequests()
                    .mvcMatchers("/account/**", "/connect/**", "/profile/**").authenticated()
                    .mvcMatchers(HttpMethod.POST, "/login").denyAll()
                .and()

                .formLogin()
                    .loginPage("/login")
                    .usernameParameter("email")
                .and()

                .logout()
                    .logoutSuccessUrl("/")
                    .deleteCookies("JSESSIONID")
                .and()

                .oauth2Login()
                    // set custom oauth login page
                    .loginPage("/login")
                    // set the user service responsible for getting the appropriate user.principle
                    .userInfoEndpoint()
                        .userService(userService) // assign the userService to use for oauth2 users
                    .and()
                    // set authorization url to {baseUrl}/login/oauth/{registrationId}
                    .authorizationEndpoint()
                        .baseUri("/login/oauth/")
                    .and()
                    // set redirect url to {baseUrl}/oauth/redirect/{registrationId}
                    .redirectionEndpoint()
                        .baseUri("/oauth/redirect/*")
                    .and()

                    .tokenEndpoint()
                        .accessTokenResponseClient(authorizationCodeTokenResponseClient())
                    .and()

                    .failureHandler((request, response, exception) -> {
                        if (exception != null) {
                            String errorMsg;
                            if (exception instanceof OAuth2AuthenticationException e)
                                errorMsg = e.getError().getDescription();
                            else
                                errorMsg = exception.getMessage();
                            final FlashMap flashMap = new FlashMap();
                            flashMap.put("oauthError", errorMsg);
                            final FlashMapManager flashMapManager = new SessionFlashMapManager();
                            flashMapManager.saveOutputFlashMap(flashMap, request, response);
                        }
                        response.sendRedirect("/error");
                    })
                .and()
        ;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
                .userDetailsService(userService)
                .passwordEncoder(passwordEncoder())
        ;
    }

    private OAuth2AccessTokenResponseClient<OAuth2AuthorizationCodeGrantRequest> authorizationCodeTokenResponseClient() {
        OAuth2AccessTokenResponseHttpMessageConverter tokenResponseHttpMessageConverter =
                new OAuth2AccessTokenResponseHttpMessageConverter();
        tokenResponseHttpMessageConverter.setAccessTokenResponseConverter(new CustomAccessTokenResponseConverter());

        RestTemplate restTemplate = new RestTemplate(Arrays.asList(
                new FormHttpMessageConverter(), tokenResponseHttpMessageConverter));
        restTemplate.setErrorHandler(new OAuth2ErrorResponseErrorHandler());

        DefaultAuthorizationCodeTokenResponseClient tokenResponseClient = new DefaultAuthorizationCodeTokenResponseClient();
        tokenResponseClient.setRestOperations(restTemplate);

        return tokenResponseClient;
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

}
