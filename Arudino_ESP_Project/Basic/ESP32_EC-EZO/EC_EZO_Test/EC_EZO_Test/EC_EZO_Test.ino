#include <HardwareSerial.h>

HardwareSerial SerialPort(2); 

String inputstring = "";                              //a string to hold incoming data from the PC
String sensorstring = "";                             //a string to hold the data from the Atlas Scientific product
boolean sensor_string_complete = false;               //have we received all the data from the Atlas Scientific product

void setup() {                                        //set up the hardware
  Serial.begin(9600);                                 //set baud rate for the hardware serial port_0 to 9600
  SerialPort.begin(9600, SERIAL_8N1, 16, 17); 
  inputstring.reserve(10);                            //set aside some bytes for receiving data from the PC
  sensorstring.reserve(30);                           //set aside some bytes for receiving data from Atlas Scientific product
}

void loop() {                                         //here we go...
  if (Serial.available()) {                //if a string from the PC has been received in its entirety
    inputstring = Serial.readStringUntil(13);           //read the string until we see a <CR>
    SerialPort.print(inputstring);                      //send that string to the Atlas Scientific product
    SerialPort.print('\r');                             //add a <CR> to the end of the string
    inputstring = "";                                 //clear the string
  }

  if (SerialPort.available() > 0) {                     //if we see that the Atlas Scientific product has sent a character
    char inchar = (char)SerialPort.read();              //get the char we just received
    sensorstring += inchar;                           //add the char to the var called sensorstring
    if (inchar == '\r') {                             //if the incoming character is a <CR>
      sensor_string_complete = true;                  //set the flag
    }
  }


  if (sensor_string_complete == true) {               //if a string from the Atlas Scientific product has been received in its entirety
    if (isdigit(sensorstring[0]) == false) {          //if the first character in the string is a digit
      Serial.println(sensorstring);                   //send that string to the PC's serial monitor
    }
    else                                              //if the first character in the string is NOT a digit
    {
      print_EC_data();                                //then call this function 
    }
    sensorstring = "";                                //clear the string
    sensor_string_complete = false;                   //reset the flag used to tell if we have received a completed string from the Atlas Scientific product
  }
}



void print_EC_data(void) {                            //this function will pars the string  

  char sensorstring_array[30];                        //we make a char array
  char *EC;                                           //char pointer used in string parsing
  char *TDS;                                          //char pointer used in string parsing
  char *SAL;                                          //char pointer used in string parsing
  char *GRAV;                                         //char pointer used in string parsing
  float f_ec;                                         //used to hold a floating point number that is the EC
  
  sensorstring.toCharArray(sensorstring_array, 30);   //convert the string to a char array 
  EC = strtok(sensorstring_array, ",");               //let's pars the array at each comma
  TDS = strtok(NULL, ",");                            //let's pars the array at each comma
  SAL = strtok(NULL, ",");                            //let's pars the array at each comma
  GRAV = strtok(NULL, ",");                           //let's pars the array at each comma

  Serial.print("EC:");                                //we now print each value we parsed separately
  Serial.println(EC);                                 //this is the EC value

  Serial.print("TDS:");                               //we now print each value we parsed separately
  Serial.println(TDS);                                //this is the TDS value

  Serial.print("SAL:");                               //we now print each value we parsed separately
  Serial.println(SAL);                                //this is the salinity value

  Serial.print("GRAV:");                              //we now print each value we parsed separately
  Serial.println(GRAV);                               //this is the specific gravity
  Serial.println();                                   //this just makes the output easier to read
  
//f_ec= atof(EC);                                     //uncomment this line to convert the char to a float
}