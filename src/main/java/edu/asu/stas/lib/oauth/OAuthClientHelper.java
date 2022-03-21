package edu.asu.stas.lib.oauth;

import edu.asu.stas.config.CustomAccessTokenResponseConverter;
import edu.asu.stas.lib.HttpClientHelper;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.endpoint.OAuth2AccessTokenResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.DefaultUriBuilderFactory;
import org.springframework.web.util.UriBuilder;
import org.springframework.web.util.UriBuilderFactory;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import static org.springframework.http.HttpHeaders.ACCEPT;
import static org.springframework.http.HttpHeaders.CONTENT_TYPE;
import static org.springframework.security.oauth2.core.endpoint.OAuth2ParameterNames.*;

@Component
public class OAuthClientHelper {

    private final UriBuilderFactory uriBuilderFactory = new DefaultUriBuilderFactory();

    public String getAuthorizationUri(ClientRegistration clientRegistration, String state) {
        final String baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();
        final String redirectUri = clientRegistration.getRedirectUri() + "/connect";
        UriBuilder uriBuilder = uriBuilderFactory.uriString(clientRegistration.getProviderDetails().getAuthorizationUri());
        uriBuilder.queryParam(CLIENT_ID, clientRegistration.getClientId())
                .queryParam(REDIRECT_URI, redirectUri)
                .queryParam(RESPONSE_TYPE, "code")
                .queryParam(SCOPE, String.join(" ", clientRegistration.getScopes()))
                .queryParam(STATE, state);
        Map<String, String> variables = Map.of(
                "baseUrl", baseUrl,
                "registrationId", clientRegistration.getRegistrationId());
        return uriBuilder.build(variables).toString();
    }

    public OAuth2UserRequest exchangeOAuthCode(String code, ClientRegistration clientRegistration) {
        String redirectURL = getRedirectURL(clientRegistration);

        // set up the httpClient
        HttpClientHelper httpClient = new HttpClientHelper();

        // set up the request
        Map<String, String> header = Map.of(
                CONTENT_TYPE, "application/x-www-form-urlencoded",
                ACCEPT, "application/json"
        );
        String body = Map.of(
                        GRANT_TYPE, clientRegistration.getAuthorizationGrantType().getValue(),
                        CODE, code,
                        CLIENT_ID, clientRegistration.getClientId(),
                        CLIENT_SECRET, clientRegistration.getClientSecret(),
                        REDIRECT_URI, redirectURL
                ).entrySet()
                .stream()
                .map(e -> e.getKey() + "=" + URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8))
                .collect(Collectors.joining("&"));

        // POST the code to get the access-token
        String response = httpClient.post(clientRegistration.getProviderDetails().getTokenUri(), header, body);
        if (Objects.isNull(response))
            return null;

        // convert the response map to an OAuth2AccessTokenResponse and then create a new OAuth2UserRequest
        Map<String, Object> responseMap = HttpClientHelper.jsonToMap(response);
        if (Objects.isNull(responseMap))
            return null;
        OAuth2AccessTokenResponse accessTokenResponse = Objects.requireNonNull(new CustomAccessTokenResponseConverter().convert(responseMap));
        return new OAuth2UserRequest(
                clientRegistration,
                accessTokenResponse.getAccessToken(),
                accessTokenResponse.getAdditionalParameters()
        );
    }

    private String getRedirectURL(ClientRegistration clientRegistration) {
        final String baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();
        final Map<String, String> variables = Map.of(
                "baseUrl", baseUrl,
                "registrationId", clientRegistration.getRegistrationId()
        );
        return UriComponentsBuilder
                .fromUriString(clientRegistration.getRedirectUri() + "/connect")
                .buildAndExpand(variables)
                .toUriString();

    }
}
