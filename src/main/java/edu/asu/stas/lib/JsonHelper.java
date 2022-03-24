package edu.asu.stas.lib;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

import java.util.Collections;
import java.util.Map;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class JsonHelper {
    private static final ObjectMapper defaultObjectMapper = new ObjectMapper();
    private static final TypeReference<Map<String, Object>> MAP_STRING_TYPE_REFERENCE = new TypeReference<>() {};

    static {
        defaultObjectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public static ObjectMapper objectMapper(){return JsonHelper.defaultObjectMapper;}

    public static Map<String, Object> jsonToMap(String json) {
        try {
            return new ObjectMapper().readValue(json, MAP_STRING_TYPE_REFERENCE);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }

}
