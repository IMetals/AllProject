String  dfd = "";
void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);

}

void loop() {
  
  Serial1.print("temp.val=");
  Serial1.print(15);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

    if(Serial1.available()){
     dfd += char(Serial1.read());
     Serial.println(dfd);
  }

}
