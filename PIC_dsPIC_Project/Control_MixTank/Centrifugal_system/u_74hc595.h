#ifndef __U_74HC595_H__
#define __U_74HC595_H__

#define SHIFT_DATA     PORTC.F1         // 74HC595 Data
#define SHIFT_LATCH    PORTC.F3         // 74HC595 Latch
#define SHIFT_CLOCK    PORTC.F2         // 74HC595 Clock

#define LED_C1         PORTC.F4
#define LED_C2         PORTC.F5
#define LED_C3         PORTC.F6

void latch_595();
void HC595(unsigned short row1, unsigned short row2);

void Led_Column1_ON();
void Led_Column2_ON();
void Led_Column3_ON();

#endif