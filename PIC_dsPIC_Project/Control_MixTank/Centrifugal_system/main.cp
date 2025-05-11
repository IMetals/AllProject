#line 1 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/main.c"
#line 1 "h:/mikroc_pro/project/lytam_system/centrifugal_system/init.h"



void init_timer0();
void init_external();
#line 1 "h:/mikroc_pro/project/lytam_system/centrifugal_system/u_74hc595.h"
#line 12 "h:/mikroc_pro/project/lytam_system/centrifugal_system/u_74hc595.h"
void latch_595();
void HC595(unsigned short row1, unsigned short row2);

void Led_Column1_ON();
void Led_Column2_ON();
void Led_Column3_ON();
#line 1 "h:/mikroc_pro/project/lytam_system/centrifugal_system/u_eeprom.h"



void EEPROM_WriteByte(unsigned char eepromAddress, unsigned char eepromData);
unsigned char EEPROM_ReadByte(unsigned char eepromAddress);
#line 35 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/main.c"
unsigned short n_led = 0;
unsigned short led_r1[3] = {0};
unsigned short led_r2[3] = {0};

bit ready_stt, run, ex_interrupt_flag, relay_stt;
unsigned char setup_stage = 0, stage_stt = 1;
unsigned char time_setup = 0, timerun_minute = 0, timerun_10ms = 0, timerun_1s = 0, level_run = 0;
unsigned char j;


void interrupt() {
 INTCON.GIE = 0;
 if (INTCON.T0IF) {
 INTCON.T0IF = 0;
 n_led++;

 if (n_led == 3)
 {
 n_led = 0;
 HC595(led_r1[0], led_r2[0]);
 latch_595();
 Led_Column3_ON();
 }

 if (n_led == 2)
 {
 HC595(led_r1[1], led_r2[1]);
 latch_595();
 Led_Column2_ON();
 }

 if (n_led == 1)
 {
 HC595(led_r1[2], led_r2[2]);
 latch_595();
 Led_Column1_ON();
 }
 }

 if (INTCON.INTF) {
 ex_interrupt_flag = 1;

 if (run == 1) {
 timerun_10ms++;
 if (timerun_10ms == 100) {
 timerun_10ms = 0;
 timerun_1s++;
 if (timerun_1s == 60) {
 timerun_minute++;
 timerun_1s = 0;
 }
 }
 }

 }

 TMR0 = 6;
 INTCON.INTF = 0;
 INTCON.T0IF = 0;
 INTCON.GIE = 1;
}

void seg7Print_led2(int number) {

 led_r2[0] = number % 10;
 number = number / 10;
 led_r2[1] = number % 10;
 number = number / 10;
 led_r2[2] = number % 10;
}

void stage() {
 while (setup_stage == 0) {
 led_r1[0] = stage_stt; led_r1[1] =  11 ; led_r1[2] =  12 ;
 while ((ready_stt == 1) && ( PORTD.F6  == 0) &&( PORTD.F5  == 0) && ( PORTD.F7  == 0) && ( PORTD.F4  == 0) &&(stage_stt == 1)) {
 led_r2[0] =  19 ; led_r2[1] = 10; led_r2[2] = 10;
 delay_ms(20);
 led_r2[0] = 10; led_r2[1] =  19 ; led_r2[2] = 10;
 delay_ms(20);
 led_r2[0] = 10; led_r2[1] = 10; led_r2[2] =  19 ;
 delay_ms(20);
 led_r2[0] = 10; led_r2[1] = 10; led_r2[2] = 10;
 delay_ms(10);
 }
 if ((ready_stt == 1) && (stage_stt != 1)) {
 led_r2[0] = 10; led_r2[1] = 10; led_r2[2] = 10;
 }
 if (ready_stt == 0) {
 led_r2[0] = 10; led_r2[1] = 10; led_r2[2] = 10;
 }

 if (( PORTD.F6  == 1)&&(ready_stt == 0)) {
 delay_ms(10);
 if ( PORTD.F6  == 1) {
 setup_stage++;
 if (setup_stage == 3)
 setup_stage = 0;
 while ( PORTD.F6  == 1);
 }
 }

 if (( PORTD.F5  == 1)&&(stage_stt == 1)) {
 delay_ms(10);
 if ( PORTD.F5  == 1) {
 ready_stt = ~ready_stt;
 while ( PORTD.F5  == 1);
 }
 }

 if (( PORTD.F7  == 1) && (ready_stt == 1)) {
 delay_ms(10);
 if ( PORTD.F7  == 1) {
 setup_stage = 5;
 run = 1;
 while ( PORTD.F7  == 1);
 }
 }

 if (( PORTD.F4  == 1) && (ready_stt == 0)) {
 delay_ms(10);
 if ( PORTD.F4  == 1) {
 stage_stt++;
 if (stage_stt == 6)
 stage_stt = 1;
 while ( PORTD.F4  == 1);
 }
 }
 }



 while (setup_stage == 1) {
 led_r1[0] = 9;
 led_r1[1] =  14 ;
 led_r1[2] =  13 ;
 seg7Print_led2(time_setup);
 time_setup = EEPROM_ReadByte(stage_stt);
 if ( PORTD.F4  == 1) {
 delay_ms(10);
 while ( PORTD.F4  == 1) {
 time_setup++;
 delay_ms(60);
 if (time_setup > 200)
 time_setup = 0;
 EEPROM_WriteByte(stage_stt, time_setup);
 seg7Print_led2(time_setup);

 }
 }

 if ( PORTD.F5  == 1) {
 delay_ms(10);
 if ( PORTD.F5  == 1) {
 time_setup--;
 delay_ms(60);
 if (time_setup == 255)
 time_setup = 0;
 EEPROM_WriteByte(stage_stt, time_setup);
 seg7Print_led2(time_setup);
 }
 }

 if ( PORTD.F6  == 1) {
 delay_ms(10);
 if ( PORTD.F6  == 1) {
 setup_stage++;
 if (setup_stage == 3)
 setup_stage = 0;
 while ( PORTD.F6  == 1);
 }
 }
 }


 while (setup_stage == 2) {
 led_r1[0] =  17 ;
 led_r1[1] =  11 ;
 led_r1[2] =  16 ;
 seg7Print_led2(level_run);
 level_run = EEPROM_ReadByte(stage_stt + 5);
 if ( PORTD.F4  == 1) {
 delay_ms(10);
 if ( PORTD.F4  == 1) {
 level_run++;
 if (level_run > 3)
 level_run = 0;
 EEPROM_WriteByte(stage_stt + 5, level_run);
 while ( PORTD.F4  == 1);
 }
 }

 if ( PORTD.F5  == 1) {
 delay_ms(10);
 if ( PORTD.F5  == 1) {
 level_run--;
 if (level_run == 255)
 level_run = 3;
 EEPROM_WriteByte(stage_stt + 5, level_run);
 while ( PORTD.F5  == 1);
 }
 }
 if ( PORTD.F6  == 1) {
 delay_ms(10);
 if ( PORTD.F6  == 1) {
 setup_stage++;
 if (setup_stage == 3)
 setup_stage = 0;
 while ( PORTD.F6  == 1);
 }
 }
 }
}





void main() {
 init_timer0();
 init_external();
 ready_stt = 0;
 run = 0;
 ex_interrupt_flag = 0;
 relay_stt = 0;
 for (j = 1; j < 11; j++)
 if (EEPROM_ReadByte(j) == 255) EEPROM_WriteByte(j, 0);

 while (1) {
 if (run == 0) {
 stage();
 }
 if ((run == 1) && (setup_stage == 5)) {
 led_r1[0] = stage_stt;
 led_r1[1] =  11 ;
 led_r1[2] =  12 ;
 seg7Print_led2(timerun_1s);

 if (stage_stt == 2)
 relay_stt = 1;
 else
 relay_stt = 0;

 level_run = EEPROM_ReadByte(stage_stt + 5);
 time_setup = EEPROM_ReadByte(stage_stt);
 if ((timerun_minute >= time_setup) || (level_run == 0)) {
 stage_stt++;
 timerun_minute = 0;
 if (stage_stt == 6) {
 run = 0;
 setup_stage = 0;
 stage_stt = 1;
 }
 }
 if ( PORTD.F7  == 1) {
 delay_ms(10);
 if ( PORTD.F7  == 1) {
 setup_stage = 0;
 run = 0;
 relay_stt = 0;
 RA3_bit = 0;
 while ( PORTD.F7  == 1);
 }
 }
 }

  PORTE.F0  = relay_stt;
 if (ex_interrupt_flag == 1) {
 if (level_run == 1) {
 delay_ms(1);
 RA3_bit = 1;
 delay_ms(8);
 RA3_bit = 0;
 }
 if (level_run == 2) {
 delay_ms(4);
 RA3_bit = 1;
 delay_ms(5);
 RA3_bit = 0;
 }
 if (level_run == 3) {
 delay_ms(8);
 RA3_bit = 1;
 delay_ms(1);
 RA3_bit = 0;
 }
 if (level_run == 0) {
 RA3_bit = 0;
  PORTE.F0  = 0;
 }
 ex_interrupt_flag = 0;
 }
 }
}
