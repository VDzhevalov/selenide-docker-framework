package ua.kuli.data;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.params.provider.Arguments;

import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

public class GameData {
    public String searchQuery;
    public String expectedTitle;

    private static String resourcePath = "/test-data/data.json";

    public static void setResourcePath(String path) {
        resourcePath = path;
    }

    public static Stream<Arguments> getDataFromJson() throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        InputStream is = GameData.class.getResourceAsStream(resourcePath);
        List<GameData> data = Arrays.asList(mapper.readValue(is, GameData[].class));
        return data.stream().map(g -> Arguments.of(g.searchQuery, g.expectedTitle));
    }
}
