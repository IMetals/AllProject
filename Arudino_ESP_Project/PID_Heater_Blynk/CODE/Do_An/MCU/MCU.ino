#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
SoftwareSerial SoftSerial(12,14); // RX,TX
//BlynkTimer timer;

char auth[] = "afzWIITHDFXKyMFmB39H-26AWK5mhXho";
char ssid[] = "HUAWEI nova 3i";
char pass[] = "1hai3bon";

float valueTempControl = 0;
boolean checkRecData = false;
String combineValue = "";

// Dong bo blynk va phan cung
BLYNK_CONNECTED() {
  Blynk.syncAll();
}

// Nhan gia tri tu bien V1 duoc gui xuong tu Blynk
BLYNK_WRITE(V1)
{
  valueTempControl = param.asFloat(); // lay bien ra va doi sang dang float
  checkRecData = true;
}
 
void setup()
{
  Serial.begin(9600);             
  SoftSerial.begin(9600);
  Blynk.begin(auth, ssid, pass);
}
 
void loop()
{
  Blynk.run();
  //timer.run();

  if(checkRecData == true)
  {
    checkRecData = false;
    String tmp = "";
    tmp = (String)valueTempControl + '/';
    SoftSerial.print(tmp);
    Serial.println(tmp);
  }

//Gui den blynk
  if(SoftSerial.available())
  { 
    char tmp = SoftSerial.read();
    if(tmp != '/')
      combineValue += tmp;
    else
    { 
      Serial.println(combineValue);
      float convertToFloat = combineValue.toFloat();
      Blynk.virtualWrite(V0, convertToFloat);
      combineValue = "";
    }
  }
}
