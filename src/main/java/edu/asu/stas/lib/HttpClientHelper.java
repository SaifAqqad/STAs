package edu.asu.stas.lib;

import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;

@Component
public class HttpClientHelper {

    private final HttpClient client;

    public HttpClientHelper() {
        this.client = HttpClient.newBuilder().build();
    }

    public String get(String url) throws HttpClientHelperException {
        return get(url, Map.of());
    }

    public String get(String url, Map<String, String> header) throws HttpClientHelperException {
        HttpRequest.Builder requestBuilder = HttpRequest.newBuilder();
        header.forEach(requestBuilder::setHeader);
        HttpRequest request = requestBuilder.GET().uri(URI.create(url)).build();
        HttpResponse<String> response;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException | IOException e) {
            Thread.currentThread().interrupt();
            throw new HttpClientHelperException(e);
        }
        return response != null ? response.body() : null;
    }

    public static class HttpClientHelperException extends RuntimeException {
        public HttpClientHelperException(Throwable e) {
            super(e);
        }
    }
}
