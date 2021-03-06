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


    public String post(String url) throws HttpClientHelperException {
        return post(url, Map.of());
    }

    public String post(String url, Map<String, String> header) throws HttpClientHelperException {
        return request("POST", url, header);
    }

    public String post(String url, Map<String, String> header, String body) throws HttpClientHelperException {
        return request("POST", url, header, HttpRequest.BodyPublishers.ofString(body));
    }

    public String get(String url) throws HttpClientHelperException {
        return get(url, Map.of());
    }

    public String get(String url, Map<String, String> header) throws HttpClientHelperException {
        return request("GET", url, header);
    }

    public String request(String method, String url, Map<String, String> header) throws HttpClientHelperException {
        return request(method, url, header, HttpRequest.BodyPublishers.noBody());
    }

    public String request(String method, String url, Map<String, String> header, HttpRequest.BodyPublisher bodyPublisher) throws HttpClientHelperException {
        HttpRequest.Builder requestBuilder = HttpRequest.newBuilder();
        header.forEach(requestBuilder::setHeader);
        HttpRequest request = requestBuilder.method(method, bodyPublisher).uri(URI.create(url)).build();
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
