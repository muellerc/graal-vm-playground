package cloud.newnormal.example;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class App {

    public static void main(String[] args) throws IOException {
        URL u = new URL("https://api.weather.gov/points/39.7456,-97.0892");
        HttpURLConnection c = (HttpURLConnection) u.openConnection();
        c.setRequestMethod("GET");
        c.setRequestProperty("Content-length", "0");
        c.setUseCaches(false);
        c.setAllowUserInteraction(false);
        c.setConnectTimeout(5000);
        c.setReadTimeout(5000);
        c.connect();

        int status = c.getResponseCode();
        System.out.println("HTTP status code: " + status);

        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode dataNode = objectMapper.readTree(c.getInputStream());
//        JsonNode bodyNode = objectMapper.readTree(inputNode.get("body").asText());

        System.out.println(objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(dataNode));

        try {
            c.disconnect();
        } catch (Exception ex) {
        }
    }
}
