package edu.asu.stas.content;

import edu.asu.stas.lib.TokenGenerator;
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Objects;

import static java.nio.file.StandardOpenOption.*;

@Component
public class ContentService {
    private static final List<String> SUPPORTED_CONTENT_TYPES = List.of("image/jpeg", "image/png", "image/gif");
    private final TokenGenerator tokenGenerator;
    private final String basePath;
    private final String baseUri;

    @Autowired
    public ContentService(
        TokenGenerator tokenGenerator,
        @Value("${stas.content.basePath}") String basePath,
        @Value("${stas.content.baseUri}") String baseUri
    ) {
        String rootPath = new FileSystemResource("").getFile().getAbsolutePath();
        this.tokenGenerator = tokenGenerator;
        this.basePath = Path.of(rootPath, basePath).toString();
        this.baseUri = baseUri;
    }

    // Stores a resource and returns its relative URI
    public String storeResource(Resource resource, String type, String baseName) throws IOException {
        String fileName = generateRandomFileName(Objects.requireNonNull(resource.getFilename()), baseName);
        Path filePath = Path.of(basePath, type, fileName);
        // create parent dirs recursively
        Files.createDirectories(filePath.getParent());
        // create output stream for the resource file
        try (OutputStream file = Files.newOutputStream(filePath, CREATE, WRITE, TRUNCATE_EXISTING)) {
            // transfer the resource to the file
            resource.getInputStream().transferTo(file);
        }
        // generate the resource URI
        return generateResourceUri(type, fileName);
    }

    // If a resource data URI is passed, it will be decoded and stored
    // If a resource URL is passed, it will be downloaded and stored
    // If a relative URI is passed, it will be returned as is
    public String storeResource(@NonNull String resource, String type, String baseName) throws IOException {
        if (resource.startsWith("/")) {
            return resource;
        } else if (resource.startsWith("data")) {
            return storeResourceFromDataURI(resource, type, baseName);
        } else if (resource.startsWith("http")) {
            return storeResourceFromURL(resource, type, baseName);
        }
        return null;
    }

    private String storeResourceFromDataURI(@NonNull String dataUri, String type, String baseName) throws IOException {
        DataURIResource resource = new DataURIResource(dataUri);
        if (!SUPPORTED_CONTENT_TYPES.contains(resource.getType())) {
            return null;
        }
        String extension = resource.getType().split("/")[1];
        String fileName = generateRandomFileName("." + extension, baseName);
        Path filePath = Path.of(basePath, type, fileName);
        // create parent dirs recursively
        Files.createDirectories(filePath.getParent());
        // create output stream for the resource file
        try (OutputStream file = Files.newOutputStream(filePath, CREATE, WRITE, TRUNCATE_EXISTING)) {
            // transfer the resource to the file
            file.write(resource.getData());
        }
        // generate the resource URI
        return generateResourceUri(type, fileName);
    }

    private String storeResourceFromURL(@NonNull String url, String type, String baseName) throws IOException {
        URLConnection urlConnection = new URL(url).openConnection();
        if (!SUPPORTED_CONTENT_TYPES.contains(urlConnection.getContentType())) {
            throw new IllegalArgumentException("Unsupported content type: " + urlConnection.getContentType());
        }
        String extension = urlConnection.getContentType().split("/")[1];
        String fileName = generateRandomFileName("." + extension, baseName);
        Path filePath = Path.of(basePath, type, fileName);
        // create parent dirs recursively
        Files.createDirectories(filePath.getParent());
        // create output stream for the resource file
        try (OutputStream file = Files.newOutputStream(filePath, CREATE, WRITE, TRUNCATE_EXISTING)) {
            // transfer the resource to the file
            urlConnection.getInputStream().transferTo(file);
        }
        return generateResourceUri(type, fileName);
    }

    public Resource loadResource(String type, String name) {
        Path filePath = Path.of(basePath, type, name);
        // create a resource for the file
        var resource = new FileSystemResource(filePath);
        if (resource.exists()) {
            return resource;
        }
        return null;
    }

    public boolean removeResource(String type, String name) {
        Path filePath = Path.of(basePath, type, name);
        try {
            return Files.deleteIfExists(filePath);
        } catch (IOException ignored) {
            return false;
        }
    }

    private String generateResourceUri(String resourceType, String resourceName) {
        return baseUri + "/" + resourceType + "/" + resourceName.replaceFirst("_", "/");
    }

    private String generateRandomFileName(@NonNull String originalName, String baseName) {
        String fileExtension = originalName.substring(originalName.lastIndexOf('.') + 1);
        return baseName + '_' + tokenGenerator.generateToken(12) + '.' + fileExtension;
    }
}
