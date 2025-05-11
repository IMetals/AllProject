#line 1 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/U_74HC595.c"
#line 1 "h:/mikroc_pro/project/lytam_system/centrifugal_system/u_74hc595.h"
#line 12 "h:/mikroc_pro/project/lytam_system/centrifugal_system/u_74hc595.h"
void latch_595();
void HC595(unsigned short row1, unsigned short row2);

void Led_Column1_ON();
void Led_Column2_ON();
void Led_Column3_ON();
#line 3 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/U_74HC595.c"
const unsigned short ma_led [20] = {0X3F, 0X06, 0X5B, 0X4F, 0X66,
 0X6D, 0X7D, 0X07, 0X7F, 0X6F,
 0x00, 0x5E, 0xBD, 0X78, 0XF4,
 0XF3, 0XB9, 0X5C, 0x80, 0x40};


void latch_595()
{
  PORTC.F3  = 1;
 asm nop;
  PORTC.F3  = 0;
}


void HC595(unsigned short row1, unsigned short row2)
{
 static char x, tam1, tam2;
 tam1 = ma_led[row2] ;
 tam2 = ma_led[row1] ;

 for (x=0; x<=7; ++x)
 {
 if (tam1 & 0x80)  PORTC.F1  = 1;
 else  PORTC.F1  = 0;
 tam1 <<= 1;
  PORTC.F2  = 1;
 asm nop;
  PORTC.F2  = 0;
 }
 for (x=0; x<=7; ++x)
 {
 if (tam2 & 0x80)  PORTC.F1  = 1;
 else  PORTC.F1  = 0;
 tam2 <<= 1;
  PORTC.F2  = 1;
 asm nop;
  PORTC.F2  = 0;
 }
}

void Led_Column1_ON()
{
  PORTC.F4  = 1;
  PORTC.F5  = 0;
  PORTC.F6  = 0;
}

void Led_Column2_ON()
{
  PORTC.F4  = 0;
  PORTC.F5  = 1;
  PORTC.F6  = 0;
}

void Led_Column3_ON()
{
  PORTC.F4  = 0;
  PORTC.F5  = 0;
  PORTC.F6  = 1;
}
