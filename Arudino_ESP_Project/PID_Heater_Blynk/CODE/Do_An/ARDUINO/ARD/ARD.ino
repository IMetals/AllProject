#include <SoftwareSerial.h>
#include "max6675.h"
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x27,16,2); 
SoftwareSerial SoftSerial(4,5); // RX,TX

//Inputs and outputs
int firing_pin = 3; //xung kich
int increase_pin = 12; //tang
int decrease_pin = 11; //giam
int zero_cross = 8; //diem 0
int thermoDO = 9;
int thermoCS = 10;
int thermoCLK = 13;

//Start a MAX6675 communication with the selected pins
MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);


//Variables
//int last_CH1_state = 0;
bool zero_cross_detected = false;
int firing_delay = 7600;


int maximum_firing_delay = 7600;

unsigned long previousMillis = 0; 
unsigned long currentMillis = 0;
int temp_read_Delay = 500;
float real_temperature = 0;
int setpoint = 50;
bool pressed_1 = false;
bool pressed_2 = false;

//PID variables
float PID_error = 0;
float previous_error = 0;
int PID_value = 0;
//PID constants
int kp =150;   int ki=0.85;   int kd = 0.001;
int PID_p = 0;    int PID_i = 0;    int PID_d = 0;

String combineValue = ""; // Bien luu chuoi nhan tu nodemcu
String combineTemp = ""; // Bien luu chuoi gui nhiet do den nodemcu
int temp_send_Delay = 2000; // Gui nhiet do den nodemcu moi 2s
unsigned long timeUpdateStamp = 0; // Bien ho tro cho viec dung timer

void setup() {
  //Define the pins

  
  pinMode (firing_pin,OUTPUT); 
  pinMode (zero_cross,INPUT); 
  pinMode (increase_pin,INPUT); 
  pinMode (decrease_pin,INPUT);   

  lcd.init();
  lcd.backlight();

  Serial.begin(9600);
  SoftSerial.begin(9600);
}


void loop() {    
  
  currentMillis = millis();
  if(currentMillis - previousMillis >= temp_read_Delay){

    //previousMillis += temp_read_Delay;
    previousMillis = currentMillis;
    
    real_temperature = thermocouple.readCelsius();
    previous_error = PID_error;
    PID_error = setpoint - real_temperature;
    
    PID_p = kp * PID_error;
    PID_i = PID_i + (ki * PID_error)*temp_read_Delay/1000;
    PID_d = kd*((PID_error - previous_error)/(temp_read_Delay/1000));
    if(PID_i > 5400)
    {PID_i = 5400;}
    
    PID_value = PID_p + PID_i + PID_d;

   
    if(PID_value < 0)
    {      PID_value = 0;       }
    if(PID_value > 7400)
    {      PID_value = 7400;    }
   
    //Printe the values on the LCD
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Set: ");
    lcd.setCursor(5,0);
    lcd.print(setpoint);
    lcd.setCursor(0,1);
    lcd.print("Real temp: ");
    lcd.setCursor(11,1);
    lcd.print(real_temperature);
}


  if (zero_cross_detected)     
    {
      delayMicroseconds(maximum_firing_delay - PID_value); //This delay controls the power
      digitalWrite(firing_pin,HIGH);
      delayMicroseconds(100);
      digitalWrite(firing_pin,LOW);
      zero_cross_detected = false;
    } 


  if(digitalRead(zero_cross) == 1){
      zero_cross_detected = true;
  }


  if(digitalRead(decrease_pin) == 1){
    while(digitalRead(decrease_pin) == 1);    
      if (!pressed_1)
      {
       setpoint = setpoint + 2;
       delay(20);
       pressed_1 = true;
      }
    }
    else if (pressed_1)
    {
      pressed_1 = false;
    }

  if(digitalRead(increase_pin) == 1){         
    while(digitalRead(increase_pin) == 1); 
      if (!pressed_2)
      {
        setpoint = setpoint - 2;
        delay(20);
        pressed_2 = true;
      }
    }
    else if (pressed_2)
    {
      pressed_2 = false;
    }

/*
  if(SoftSerial.available())
  { 
    char tmp = SoftSerial.read();
    if(tmp != '/')
      combineValue += tmp;
    else
    { 
      Serial.println(combineValue); 
      float convertToFloat = combineValue.toFloat();
      setpoint = convertToFloat;
      combineValue = "";
    }
  }

  if(millis() - timeUpdateStamp >= temp_send_Delay){
    timeUpdateStamp = millis();              
    combineTemp += (String)real_temperature + "/";
    SoftSerial.print(combineTemp);
    combineTemp = "";
  }*/ 
}
