#include <Nextion.h>

NexButton j0 = NexButton(1, 7, "j0");
NexDSButton bt0 = NexDSButton(1, 8, "bt0");
char buffer[100] = {0};

NexTouch *nex_listen_list[] =
{
  &j0,
  &bt0,
  NULL
};

void bt0PopCallback(void *ptr)  // Release event for dual state button bt0
{
  uint32_t number5 = 0;  // Create variable to store value we are going to get
  bt0.getValue(&number5);  // Read value of dual state button to know the state (0 or 1)
  if (number5 == 1) { // If dual state button is equal to 1 (meaning is ON)...
    Serial1.print("temp.txt=");
    Serial1.print("\"");
    Serial1.print("hi");
    Serial1.print("\"");
    Serial1.write(0xff);
    Serial1.write(0xff);
    Serial1.write(0xff);
  } else { // Since the dual state button is OFF...
    Serial1.print("temp.txt=");
    Serial1.print("\"");
    Serial1.print("bye");
    Serial1.print("\"");
    Serial1.write(0xff);
    Serial1.write(0xff);
    Serial1.write(0xff);
  }
}



void setup() {
  Serial1.begin(9600);
  delay(500);
  Serial1.print("baud=115200");
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.end();
  Serial1.begin(115200);

  bt0.attachPop(bt0PopCallback, &bt0);

}

void loop() {
  delay(30);
  //Serial1.print("temp.txt=");
  //Serial1.print("\"");
  //Serial1.print("aa");
  //Serial1.print("\"");
  //Serial1.write(0xff);
  //Serial1.write(0xff);
  //Serial1.write(0xff);

  Serial1.print("sal.txt=");
  Serial1.print("\"");
  Serial1.print("lk");
  Serial1.print("\"");
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("t1.txt=");
  Serial1.print("\"");
  Serial1.print("78");
  Serial1.print("\"");
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);

  Serial1.print("j0.val=");
  Serial1.print(100);
  Serial1.write(0xff);
  Serial1.write(0xff);
  Serial1.write(0xff);


  nexLoop(nex_listen_list);

}
