package edu.asu.stas.content;

import edu.asu.stas.lib.TokenGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Objects;

import static java.nio.file.StandardOpenOption.*;

@SuppressWarnings("ClassCanBeRecord")
@Component
public class ContentService {
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

    // Stores a resource and returns its URI
    public String storeResource(Resource resource, String type, String baseName) throws IOException {
        String fileName = generateRandomFileName(resource, baseName);
        Path filePath = Path.of(basePath, type, fileName);
        // create parent dirs recursively
        Files.createDirectories(filePath.getParent());
        // create output stream for the resource file
        OutputStream file = Files.newOutputStream(filePath, CREATE, WRITE, TRUNCATE_EXISTING);
        // transfer the resource to the file
        resource.getInputStream().transferTo(file);
        // generate the resource URI
        return generateResourceUri(type, fileName);
    }

    public Resource loadResource(String type, String name) {
        Path filePath = Path.of(basePath, type, name);
        // create a resource for the file
        var resource = new FileSystemResource(filePath);
        if (resource.exists())
            return resource;
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

    private String generateRandomFileName(Resource resource, String baseName) {
        String originalName = Objects.requireNonNull(resource.getFilename());
        String fileExtension = originalName.substring(originalName.lastIndexOf('.') + 1);
        return baseName + '_' + tokenGenerator.generateToken(48) + '.' + fileExtension;
    }
}
