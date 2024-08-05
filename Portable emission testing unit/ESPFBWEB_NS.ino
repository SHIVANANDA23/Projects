#include <WiFi.h>
#include <HTTPClient.h>
#include <WebServer.h>
#include <ArduinoJson.h>
#include <FS.h>
#include <SPIFFS.h>

// Store WiFi credentials in flash memory
const char _SSID[] PROGMEM = "Rajesh";//id and password 
const char _PASSWORD[] PROGMEM = "Rajeshnet";
const char FIREBASE_HOST[] PROGMEM = "https://espportableetu-default-rtdb.asia-southeast1.firebasedatabase.app";

// Add your Firebase project's web API key here
const char API_KEY[] PROGMEM = "AIzaSyDymHbsQtNyxir0pXDfxXtJ4AQ2UElC430";

int hcStandardValue = 500;

int coStandardValue = 200;

int noxStandardValue = 300;

int hcSensorValueRaw = analogRead(34);
int coSensorValueRaw = analogRead(35);
int noxSensorValueRaw = analogRead(35);

// Map raw sensor values to meaningful values (example conversion)
float hcSensorValue = map(hcSensorValueRaw, 0, 4095, 0, 500); 
float coSensorValue = map(coSensorValueRaw, 0, 4095, 0, 200);  
float noxSensorValue = map(noxSensorValueRaw, 0, 4095, 0, 300); 

WebServer server(80);

String webpage = R"=====(
<!DOCTYPE html>
<html>
<head>
  <title>Gas Sensor Value</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src='https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js'></script>
  <style>
    * {box-sizing: border-box;}
    body {font-family: Verdana, sans-serif; margin: 0; padding: 0;}
    body { 
      font-family: Arial, sans-serif; 
      background-color: #f2f2f2;
    }
    h1 { 
      color: #333; 
      text-align: center; 
      font-size: 2rem; 
      margin-top: 50px; 
    }
    table { 
      width: 80%; 
      margin: 20px auto; 
      border-collapse: collapse; 
      background-color: rgba(255, 255, 255, 0.7); 
      border-radius: 5px; 
      overflow: hidden; 
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    table, th, td { border: 1px solid #ccc; }
    th, td { padding: 12px; text-align: left; font-size: 1rem; }
    th { background-color: #ddd; color: #333; }
    .pass { color: green; }
    .fail { color: red; }
    .text-center { text-align: center; margin-top: 20px; }

    /* Button Styles */
    button {
      background-color: rgb(188, 74, 188);
      color: gold;
      padding: 10px 20px;
      border: none;
      font-size: 16px;
      font-weight: bold;
      border-radius: 55px;
      cursor: pointer;
      transition: all 0.8s;
      margin: 5px;
      animation: fadeIn 1s ease-in-out;
    }

    /* Button Hover Effect */
    button:hover {
      transform: scale(1.1);
      background-color: purple;
    }

    button:disabled { opacity: 0.6; cursor: default; }

    /* Scrolling Text Animation */
    .scroll-text-container {
      overflow: hidden;
      white-space: nowrap;
      margin-bottom: 20px;
    }

    .scroll-text {
      display: inline-block;
      animation: scrollText 60s linear infinite;
    }

    @keyframes scrollText {
      0% { transform: translateX(100%); }
      100% { transform: translateX(-100%); }
    }

    @keyframes fadeIn { 0% { opacity: 0.0; } 100% { opacity: 1; } }

    /* Blinking Text Animation */
    .blink {
      animation: blinker 2.7s linear infinite;
      color: blue;
      font-family: sans-serif;
    }

    @keyframes blinker {
      50% { opacity: 0.5; }
    }
  </style>
</head>
<body>
  <h1>Gas Sensor Value</h1>
  <div class="scroll-text-container">
    <div class="scroll-text">
      <p class="blink">Gas pollution is harmful to health and the environment. It can lead to respiratory problems, cardiovascular diseases, and environmental degradation. Monitoring gas levels is crucial for maintaining air quality standards.</p>
    </div>
  </div>

  <table>
    <tr>
      <th>Sensor Type</th>
      <th>Value (ppm)</th>
      <th>Standard Value (ppm)</th>
      <th>Pass/Fail</th>
    </tr>
    <tr>
      <td>HC Content</td>
      <td id='hcSensorValue'></td>
      <td id='hcStandardValue'></td>
      <td id='hcPassFail'></td>
    </tr>
    <tr>
      <td>CO Content</td>
      <td id='coSensorValue'></td>
      <td id='coStandardValue'></td>
      <td id='coPassFail'></td>
    </tr>
    <tr>
      <td>NOx Content</td>
      <td id='noxSensorValue'></td>
      <td id='noxStandardValue'></td>
      <td id='noxPassFail'></td>
    </tr>
  </table>
  <form id='inputForm'>
    <label for='storeData'>Store Data on Firebase:</label>
    <input type='checkbox' id='storeData' name='storeData'>
    <br>
    <label for='numberPlate'>Number Plate Number:</label>
    <input type='text' id='numberPlate' name='numberPlate' required>
    <br>
    <button type='submit'>Submit</button>
  </form>
  <div class="text-center">
    <button id='pdfButton' onclick='generatePDF()' disabled>Generate PDF</button>
  </div>
  <script>
    function refreshSensorValue() {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          var data = JSON.parse(this.responseText);
          document.getElementById('hcSensorValue').innerHTML = data.hcSensorValue;
          document.getElementById('hcStandardValue').innerHTML = data.hcStandardValue;
          if (data.hcSensorValue < data.hcStandardValue) {
            document.getElementById('hcPassFail').innerHTML = 'Pass';
            document.getElementById('hcPassFail').className = 'pass';
          } else {
            document.getElementById('hcPassFail').innerHTML = 'Fail';
            document.getElementById('hcPassFail').className = 'fail';
          }
          document.getElementById('coSensorValue').innerHTML = data.coSensorValue;
          document.getElementById('coStandardValue').innerHTML = data.coStandardValue;
          if (data.coSensorValue < data.coStandardValue) {
            document.getElementById('coPassFail').innerHTML = 'Pass';
            document.getElementById('coPassFail').className = 'pass';
          } else {
            document.getElementById('coPassFail').innerHTML = 'Fail';
            document.getElementById('coPassFail').className = 'fail';
          }
          document.getElementById('noxSensorValue').innerHTML = data.noxSensorValue;
          document.getElementById('noxStandardValue').innerHTML = data.noxStandardValue;
          if (data.noxSensorValue < data.noxStandardValue) {
            document.getElementById('noxPassFail').innerHTML = 'Pass';
            document.getElementById('noxPassFail').className = 'pass';
          } else {
            document.getElementById('noxPassFail').innerHTML = 'Fail';
            document.getElementById('noxPassFail').className = 'fail';
          }
          document.getElementById('pdfButton').disabled = false;
        }
      };
      xhttp.open("GET", "/sensorValue", true);
      xhttp.send();
    }
    setInterval(refreshSensorValue, 2000);

    document.getElementById('inputForm').addEventListener('submit', function(event) {
      event.preventDefault(); // Prevent the form from submitting
      var storeData = document.getElementById('storeData').checked;
      var numberPlate = document.getElementById('numberPlate').value;
      sendDataToEsp(storeData, numberPlate);
    });

    function sendDataToEsp(storeData, numberPlate) {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          console.log("Data sent to Esp");
        }
      };
      xhttp.open("GET", "/storeData?storeData=" + storeData + "&numberPlate=" + numberPlate, true);
      xhttp.send();
    }

    function generatePDF() {
      const { jsPDF } = window.jspdf;
      const doc = new jsPDF();
      doc.text("Gas Sensor Report", 10, 10);
      doc.text("HC Content: " + document.getElementById('hcSensorValue').innerHTML, 10, 20);
      doc.text("CO Content: " + document.getElementById('coSensorValue').innerHTML, 10, 30);
      doc.text("NOx Content: " + document.getElementById('noxSensorValue').innerHTML, 10, 40);
      doc.save("gas_sensor_report.pdf");
    }
  </script>
</body>
</html>
)=====";

String numberPlate = "";
bool storeDataOnFirebase = false;

void setup() {
  Serial.begin(115200);
  WiFi.begin(FPSTR(_SSID), FPSTR(_PASSWORD));

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to WiFi");
    Serial.println(WiFi.localIP());
  if (!SPIFFS.begin(true)) {
    Serial.println("An error has occurred while mounting SPIFFS");
    return;
  }

  // Web server handlers
  server.on("/", HTTP_GET, []() {
    server.send(200, "text/html", webpage);
  });

  server.on("/sensorValue", HTTP_GET, []() {
    String json = "{\"hcSensorValue\": " + String(hcSensorValue) + ", \"hcStandardValue\": " + String(hcStandardValue) +
                ", \"coSensorValue\": " + String(coSensorValue) + ", \"coStandardValue\": " + String(coStandardValue) +
                ", \"noxSensorValue\": " + String(noxSensorValue) + ", \"noxStandardValue\": " + String(noxStandardValue) + "}";

  // Send JSON response
  server.send(200, "application/json", json);
  });

  server.on("/storeData", HTTP_GET, []() {
    if (server.hasArg("storeData") && server.hasArg("numberPlate")) {
      storeDataOnFirebase = server.arg("storeData") == "true";
      numberPlate = server.arg("numberPlate");
      Serial.println("Received data: storeData = " + String(storeDataOnFirebase) + ", numberPlate = " + numberPlate);
      if (storeDataOnFirebase) {
        storeDataOnFirebaseFunction();
      }
    }
    server.send(200, "text/plain", "Data received");
  });

  server.begin();
}

void loop() {
  server.handleClient();
}

void storeDataOnFirebaseFunction() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String path = String(FIREBASE_HOST) + "/SensorValues/" + numberPlate + ".json";
    http.begin(path.c_str());
    http.addHeader("Content-Type", "application/json");
    StaticJsonDocument<200> doc;
    doc["HC_Content"] = hcSensorValue;  // Replace with actual sensor data
    doc["CO_Content"] = coSensorValue;   // Replace with actual sensor data
    doc["NOx_Content"] = noxSensorValue;  // Replace with actual sensor data
    String requestBody;
    serializeJson(doc, requestBody);
    int httpResponseCode = http.PUT(requestBody);

    if (httpResponseCode > 0) {
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
    } else {
      Serial.print("Error code: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}