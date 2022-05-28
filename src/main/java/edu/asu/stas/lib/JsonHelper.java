package edu.asu.stas.lib;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.util.StdDateFormat;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

import java.util.Collections;
import java.util.Map;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class JsonHelper {
    private static final ObjectMapper defaultObjectMapper = new ObjectMapper();
    public static final TypeReference<Map<String, Object>> MAP_STRING_TYPE_REFERENCE = new TypeReference<>() {
    };

    private static void setDefaultConfig() {
        JsonHelper.defaultObjectMapper.registerModule(new JavaTimeModule())
                                      .setDateFormat(new StdDateFormat())
                                      .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
                                      .setPropertyNamingStrategy(PropertyNamingStrategies.LOWER_CAMEL_CASE)
                                      .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    public static ObjectMapper objectMapper() {
        setDefaultConfig();
        return JsonHelper.defaultObjectMapper;
    }

    public static Map<String, Object> jsonToMap(String json) {
        try {
            return new ObjectMapper().readValue(json, MAP_STRING_TYPE_REFERENCE);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }

}
