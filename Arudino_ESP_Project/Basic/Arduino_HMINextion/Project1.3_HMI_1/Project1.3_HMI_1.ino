#include "Nextion.h"
int CurrentPage = 0;
int temp = 321;
int salinity;
int conductivity;

long single;
long lo;
long hi;
String sensorstring = "";
String inputstring = "";
boolean sensor_string_complete = false;
boolean input_string_complete = false;

NexButton b20 = NexButton(2, 10, "b20");
NexButton b21 = NexButton(2, 11, "b21");
NexVariable va = NexVariable(2, 8, "va");

NexButton bclr = NexButton(3, 4, "bclr");
NexButton bdry = NexButton(3, 5, "bdry");
NexButton bsin = NexButton(4, 6, "bsin");
NexVariable va0 = NexVariable(4, 11, "va0");

NexButton blo = NexButton(5, 8, "blo");
NexButton bhi = NexButton(5, 9, "bhi");
NexVariable v = NexVariable(5, 13, "v");

NexPage logo = NexPage(0, 0, "logo");
NexPage disp = NexPage(1, 0, "disp");
NexPage set = NexPage(2, 0, "set");
NexPage calib1 = NexPage(3, 0, "calib1");
NexPage calib2 = NexPage(4, 0, "calib2");
NexPage calib3 = NexPage(5, 0, "calib3");

char buffer[10] = {0};

NexTouch *nex_listen_list[] =
{
  &b20,
  &b21,
  &bclr,
  &bdry,
  &bsin,
  &blo,
  &bhi,
  &va,
  &va0,
  &v,
  &logo,
  &disp,
  &set,
  &calib1,
  &calib2,
  &calib3,
  NULL
};

void b20PopCallback(void *ptr)
{

  memset(buffer, 0, sizeof(buffer));
  va.getText(buffer, sizeof(buffer));
  Serial.println(buffer);
  delay(200);
}

void b21PopCallback(void *ptr)
{

  memset(buffer, 0, sizeof(buffer));
  va.getText(buffer, sizeof(buffer));
  Serial.println(buffer);
  delay(200);
}

void bsinPopCallback(void *ptr) //release bt5
{

  memset(buffer, 0, sizeof(buffer));
  va0.getText(buffer, sizeof(buffer));
  Serial.println(buffer);
  delay(200);
}

void bloPopCallback(void *ptr) //release bt5
{

  memset(buffer, 0, sizeof(buffer));
  v.getText(buffer, sizeof(buffer));
  Serial.println(buffer);
  delay(200);
}

void bhiPopCallback(void *ptr) //release bt5
{

  memset(buffer, 0, sizeof(buffer));
  v.getText(buffer, sizeof(buffer));
  Serial.println(buffer);
  delay(200);
}

void bdryPopCallback(void *ptr)
{
  Serial2.print("Cal,dry"); //add2
  Serial2.print('\r');
}

void bclrPopCallback(void *ptr)
{
  Serial2.print("Cal,clear");//add2
  Serial2.print('\r');
}

void logoPushCallback(void *ptr)
{
  CurrentPage = 0;
  Serial.println(CurrentPage);
}

void dispPushCallback(void *ptr)
{
  CurrentPage = 1;
  Serial.println(CurrentPage);
}

void setPushCallback(void *ptr)
{
  CurrentPage = 2;
  Serial.println(CurrentPage);
}

void calib1PushCallback(void *ptr)
{
  CurrentPage = 3;
  Serial.println(CurrentPage);
}

void calib2PushCallback(void *ptr)
{
  CurrentPage = 4;
  Serial.println(CurrentPage);
}

void calib3PushCallback(void *ptr)
{
  CurrentPage = 5;
  Serial.println(CurrentPage);
}

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
  Serial2.begin(9600);

  inputstring.reserve(10);
  sensorstring.reserve(30);

  b20.attachPop(b20PopCallback);
  b21.attachPop(b21PopCallback);
  bsin.attachPop(bsinPopCallback);
  bhi.attachPop(bhiPopCallback);
  blo.attachPop(bloPopCallback);
  bclr.attachPop(bclrPopCallback);
  bdry.attachPop(bdryPopCallback);
  logo.attachPush(logoPushCallback);
  disp.attachPush(dispPushCallback);
  set.attachPush(setPushCallback);
  calib1.attachPush(calib1PushCallback);
  calib2.attachPush(calib2PushCallback);
  calib3.attachPush(calib3PushCallback);
  Serial2.print("C,10");
  Serial2.print('\r');
}
/*
void serialEvent() {                                  //if the hardware serial port_0 receives a char
  inputstring = Serial.readStringUntil(13);           //read the string until we see a <CR>
  input_string_complete = true;                       //set the flag used to tell if we have received a completed string from the PC
}
*/
void loop() {
  delay(10);

  // Gan gia tri
  Serial1.print("temp.val=");
  Serial1.print(temp);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("tempca1.val=");
  Serial1.print(temp);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("tempca2.val=");
  Serial1.print(temp);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("tempca3.val=");
  Serial1.print(temp);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("sal.val=");
  Serial1.print(salinity);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("conca1.val=");
  Serial1.print(conductivity);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("conca2.val=");
  Serial1.print(conductivity);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("conca3.val=");
  Serial1.print(conductivity);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  if (Serial2.available() > 0) {                     //if we see that the Atlas Scientific product has sent a character
    char inchar = (char)Serial2.read();              //get the char we just received
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

  if (buffer[0] == 'c') {
    Calibration();
  }
nexLoop(nex_listen_list);
}


void print_EC_data(void) {                            //this function will pars the string

  char sensorstring_array[30];                        //we make a char array
  char *EC;                                           //char pointer used in string parsing
  char *TDS;                                          //char pointer used in string parsing
  char *SAL;                                          //char pointer used in string parsing
  char *GRAV;                                         //char pointer used in string parsing
  float f_sal;
  float f_ec;

  sensorstring.toCharArray(sensorstring_array, 30);
  EC = strtok(sensorstring_array, ",");
  TDS = strtok(NULL, ",");
  SAL = strtok(NULL, ",");
  GRAV = strtok(NULL, ",");

  Serial.print("EC:");
  Serial.println(EC);

  Serial.print("TDS:");
  Serial.println(TDS);

  Serial.print("SAL:");
  Serial.println(SAL);

  Serial.print("GRAV:");
  Serial.println(GRAV);
  Serial.println();

  f_sal = atof(SAL);
  salinity = f_sal * 100;
  f_ec = atof(EC);
  conductivity = f_ec;
}

void Calibration() {
  if (buffer[1] == 's') {
    single = 0;
    single = (buffer[8] - 48) + 10 * (buffer[7] - 48) + 100 * (buffer[6] - 48) + 1000 * (buffer[5] - 48) + 10000 * (buffer[4] - 48) + 100000 * (buffer[3] - 48);
    Serial2.print("Cal,");
    Serial2.print(single);
    Serial2.print('\r');
    memset(buffer, 0, sizeof(buffer));
  }

  if (buffer[1] == 'l') {
    lo = 0;
    lo = (buffer[8] - 48) + 10 * (buffer[7] - 48) + 100 * (buffer[6] - 48) + 1000 * (buffer[5] - 48) + 10000 * (buffer[4] - 48) + 100000 * (buffer[3] - 48);
    buffer[10] = {0};
    Serial2.print("Cal,low,");
    Serial2.print(lo);
    Serial2.print('\r');
    memset(buffer, 0, sizeof(buffer));
  }

  if (buffer[1] == 'h') {
    hi = 0;
    hi = (buffer[8] - 48) + 10 * (buffer[7] - 48) + 100 * (buffer[6] - 48) + 1000 * (buffer[5] - 48) + 10000 * (buffer[4] - 48) + 100000 * (buffer[3] - 48);
    buffer[10] = {0};
    Serial2.print("Cal,high,");
    Serial2.print(hi);
    Serial2.print('\r');
    memset(buffer, 0, sizeof(buffer));
  }
}
