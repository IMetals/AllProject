#include <Nextion.h>

String  endChar = String(char(0xff)) + String(char(0xff)) + String(char(0xff));
String  dfd = ""; //data from display
int     temp = 321;
int     sal  = 9;  
//unsigned long asyncDelay = 0; //4,294,967,295
//int     delayLength = 500;  

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);

}

void loop() {
  if(Serial1.available()){
     dfd += char(Serial1.read());
     Serial.print(dfd);
  }
  
  dfd="";

  
 
  Serial1.print("temp.val=");
  Serial1.print(temp);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);
  
  Serial1.print("sal.val=");
  Serial1.print(sal);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  if(dfd.endsWith(endChar)){
    Serial.println(dfd);
    Serial.println("error");
    dfd="";
  }
}
