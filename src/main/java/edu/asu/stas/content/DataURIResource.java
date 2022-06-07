package edu.asu.stas.content;

import lombok.Data;
import lombok.NonNull;
import org.springframework.util.Base64Utils;

@Data
public class DataURIResource {
    private byte[] data;
    private String encoding;
    private String type;

    public DataURIResource(@NonNull String dataUri) {
        if (!dataUri.startsWith("data:")) {
            throw new IllegalArgumentException("Data URI must start with 'data:'");
        }
        int comma = dataUri.indexOf(','); // separates the info and data
        String[] dataInfoParts = dataUri.substring(5, comma) // remove 'data:'
                                        .split(";"); // split on ';'
        type = dataInfoParts[0];
        if(dataInfoParts.length > 1) {
            encoding = dataInfoParts[1];
        }
        data = Base64Utils.decodeFromUrlSafeString(dataUri.substring(comma + 1));
    }
}
