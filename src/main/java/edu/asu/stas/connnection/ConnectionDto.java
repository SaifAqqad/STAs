package edu.asu.stas.connnection;

import edu.asu.stas.connnection.oauth.OAuthProfile;

import java.io.Serializable;

public record ConnectionDto(Long id, String serviceName, OAuthProfile serviceUserProfile) implements Serializable {
}
