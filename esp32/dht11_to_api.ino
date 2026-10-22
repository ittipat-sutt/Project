#include <WiFi.h>
#include <HTTPClient.h>
#include <DHT.h>

// Fill these in. Do not commit a real Wi-Fi password or device key to GitHub.
const char* WIFI_SSID = "YOUR_WIFI_NAME";
const char* WIFI_PASSWORD = "YOUR_WIFI_PASSWORD";
const char* API_URL = "https://smart-room-energy.onrender.com/api/telemetry";
const char* DEVICE_KEY = "PUT_THE_SAME_RENDER_SECRET_HERE";

constexpr int DHT_PIN = 4;
#define DHTTYPE DHT11
DHT dht(DHT_PIN, DHTTYPE);

void connectWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
}

void setup() {
  Serial.begin(115200);
  dht.begin();
  connectWiFi();
}

void loop() {
  if (WiFi.status() != WL_CONNECTED) connectWiFi();

  const float temperature = dht.readTemperature();
  const float humidity = dht.readHumidity();
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("DHT11 read failed");
    delay(2000);
    return;
  }

  HTTPClient http;
  http.begin(API_URL);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("x-device-key", DEVICE_KEY);
  const String payload = "{\"temperature\":" + String(temperature, 1) +
      ",\"humidity\":" + String(humidity, 1) + "}";
  const int status = http.POST(payload);
  Serial.printf("API status: %d\n", status);
  http.end();

  delay(5000); // DHT11 should not be read more often than about once per second.
}
