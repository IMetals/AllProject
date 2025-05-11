#include "u_74hc595.h"

const unsigned short ma_led [20] = {0X3F, 0X06, 0X5B, 0X4F, 0X66,
                                   0X6D, 0X7D, 0X07, 0X7F, 0X6F, 
                                   0x00, 0x5E, 0xBD, 0X78, 0XF4,
                                   0XF3, 0XB9, 0X5C, 0x80, 0x40};

//---------------------- ham chot du lieu ic 595 ----------------------
void latch_595() 
{
    SHIFT_LATCH = 1;
    asm nop;
    SHIFT_LATCH = 0;
}

//---------------------- ham dich du lieu vao ic595 ----------------------
void HC595(unsigned short row1, unsigned short row2) 
{
    static char x, tam1, tam2;
    tam1 = ma_led[row2] ;
    tam2 = ma_led[row1] ;

    for (x=0; x<=7; ++x)
    {
        if (tam1 & 0x80) SHIFT_DATA = 1;
        else SHIFT_DATA = 0;
        tam1 <<= 1;
        SHIFT_CLOCK = 1;
        asm nop;
        SHIFT_CLOCK = 0;
    }
    for (x=0; x<=7; ++x)
    {
        if (tam2 & 0x80) SHIFT_DATA = 1;
        else SHIFT_DATA = 0;
        tam2 <<= 1;
        SHIFT_CLOCK = 1;
        asm nop;
        SHIFT_CLOCK = 0;
    }
}

void Led_Column1_ON()
{
    LED_C1 = 1;
    LED_C2 = 0;
    LED_C3 = 0;
}

void Led_Column2_ON()
{
    LED_C1 = 0;
    LED_C2 = 1;
    LED_C3 = 0;
}

void Led_Column3_ON()
{
    LED_C1 = 0;
    LED_C2 = 0;
    LED_C3 = 1;
}