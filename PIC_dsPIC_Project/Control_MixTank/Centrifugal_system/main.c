/***        ready_stt: trang thai san sang                      ***
****              run: trang thai hoat dong he thong            ***
****ex_interrupt_flag: co ngat ngoai                            ***
****        relay_stt: trang thai relay                         ***
****      setup_stage: bien cai dat thong so giua cac giai doan ***
****        stage_stt: thu tu giai doan                         ***
****       time_setup: thoi gian cai dat cho tung giai doan     ***
****   timerun_minute: thoi gian 1 phut/ don vi                 ***
****     timerun_10ms: thoi gian 10 ms / don vi                 ***
****       timerun_1s: thoi gian 1 s / don vi                   ***
****        level_run: cap do dong co                           ***/

#include "init.h"
#include "u_74hc595.h"
#include "u_eeprom.h"

#define relay_pin    PORTE.F0
#define up_button    PORTD.F4
#define down_button  PORTD.F5
#define mode_button  PORTD.F6
#define run_button   PORTD.F7

#define d_letter 	11
#define g_letter 	12
#define t_letter 	13
#define h_letter 	14
#define p_letter 	15
#define c_letter 	16
#define o_letter 	17
#define dot_letter 	18
#define sub_letter 	19

//---------------------- khai bao cac bien ----------------------
//Led 7 doan
unsigned short n_led = 0;
unsigned short led_r1[3] = {0};
unsigned short led_r2[3] = {0};

bit ready_stt, run, ex_interrupt_flag, relay_stt;
unsigned char setup_stage = 0, stage_stt = 1;
unsigned char time_setup = 0, timerun_minute = 0, timerun_10ms = 0, timerun_1s = 0, level_run = 0;
unsigned char j;
//////////////////////// HAM THUC HIEN NGAT /////////////////////////

void interrupt() {
    INTCON.GIE = 0; // tat cac ngat
    if (INTCON.T0IF) { //Ngat timer0
        INTCON.T0IF = 0; // xoa co ngat
        n_led++; //Quet Led

        if (n_led == 3) // hien thi led don vi
        {
            n_led = 0;
            HC595(led_r1[0], led_r2[0]);
            latch_595();
            Led_Column3_ON();
        }

        if (n_led == 2) // hien thi led hang chuc
        {
            HC595(led_r1[1], led_r2[1]);
            latch_595();
            Led_Column2_ON();
        }

        if (n_led == 1) // hien thi led hang tram
        {
            HC595(led_r1[2], led_r2[2]);
            latch_595();
            Led_Column1_ON();
        }
    }

    if (INTCON.INTF) {// phat hien co ngat ngoai
        ex_interrupt_flag = 1;
        //----------------DEM THOI GIAN KHI DONG CO CHAY----------------------///
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
        //--------------------------------------------------------------------//
    }

    TMR0 = 6;
    INTCON.INTF = 0; // co ngat = 0
    INTCON.T0IF = 0; // xoa co ngat
    INTCON.GIE = 1; // bat lai cac ngat
}

void seg7Print_led2(int number) {
    /* separating munber to digit */
    led_r2[0] = number % 10;
    number = number / 10;
    led_r2[1] = number % 10;
    number = number / 10;
    led_r2[2] = number % 10;
}

void stage() {
    while (setup_stage == 0) {
        led_r1[0] = stage_stt;        led_r1[1] = d_letter;        led_r1[2] = g_letter;
        while ((ready_stt == 1) && (mode_button == 0) &&(down_button == 0) && (run_button == 0) && (up_button == 0) &&(stage_stt == 1)) {
            led_r2[0] = sub_letter;    led_r2[1] = 10;            led_r2[2] = 10;
            delay_ms(20);
            led_r2[0] = 10;            led_r2[1] = sub_letter;    led_r2[2] = 10;
            delay_ms(20);
            led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = sub_letter;
            delay_ms(20);
            led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = 10;
            delay_ms(10);
        }
        if ((ready_stt == 1) && (stage_stt != 1)) {
            led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = 10;
        }
        if (ready_stt == 0) {
            led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = 10;
        }

        if ((mode_button == 1)&&(ready_stt == 0)) {
            delay_ms(10);
            if (mode_button == 1) {
                setup_stage++;
                if (setup_stage == 3)
                    setup_stage = 0;
                while (mode_button == 1);
            }
        }

        if ((down_button == 1)&&(stage_stt == 1)) {
            delay_ms(10);
            if (down_button == 1) {
                ready_stt = ~ready_stt;
                while (down_button == 1);
            }
        }

        if ((run_button == 1) && (ready_stt == 1)) {
            delay_ms(10);
            if (run_button == 1) {
                setup_stage = 5;
                run = 1;
                while (run_button == 1);
            }
        }

        if ((up_button == 1) && (ready_stt == 0)) {
            delay_ms(10);
            if (up_button == 1) {
                stage_stt++;
                if (stage_stt == 6)
                    stage_stt = 1;
                while (up_button == 1);
            }
        }
    }

    //////////////////Settime///////////////////

    while (setup_stage == 1) {
        led_r1[0] = 9;
        led_r1[1] = h_letter;
        led_r1[2] = t_letter;
        seg7Print_led2(time_setup);
        time_setup = EEPROM_ReadByte(stage_stt);
        if (up_button == 1) {
            delay_ms(10);
            while (up_button == 1) {
                time_setup++;
                delay_ms(60);
                if (time_setup > 200)
                    time_setup = 0;
                EEPROM_WriteByte(stage_stt, time_setup);
                seg7Print_led2(time_setup);

            }
        }

        if (down_button == 1) {
            delay_ms(10);
            if (down_button == 1) {
                time_setup--;
                delay_ms(60);
                if (time_setup == 255)
                    time_setup = 0;
                EEPROM_WriteByte(stage_stt, time_setup);
                seg7Print_led2(time_setup);
            }
        }

        if (mode_button == 1) {
            delay_ms(10);
            if (mode_button == 1) {
                setup_stage++;
                if (setup_stage == 3)
                    setup_stage = 0;
                while (mode_button == 1);
            }
        }
    }

    ///////////////Set toc do///////////////////
    while (setup_stage == 2) {
        led_r1[0] = o_letter;
        led_r1[1] = d_letter;
        led_r1[2] = c_letter;
        seg7Print_led2(level_run);
        level_run = EEPROM_ReadByte(stage_stt + 5);
        if (up_button == 1) {
            delay_ms(10);
            if (up_button == 1) {
                level_run++;
                if (level_run > 3)
                    level_run = 0;
                EEPROM_WriteByte(stage_stt + 5, level_run);
                while (up_button == 1);
            }
        }

        if (down_button == 1) {
            delay_ms(10);
            if (down_button == 1) {
                level_run--;
                if (level_run == 255)
                    level_run = 3;
                EEPROM_WriteByte(stage_stt + 5, level_run);
                while (down_button == 1);
            }
        }
        if (mode_button == 1) {
            delay_ms(10);
            if (mode_button == 1) {
                setup_stage++;
                if (setup_stage == 3)
                    setup_stage = 0;
                while (mode_button == 1);
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////
////////////////////////////// HAM MAIN ////////////////////////////
///////////////////////////////////////////////////////////////////

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
            led_r1[1] = d_letter;
            led_r1[2] = g_letter;
            seg7Print_led2(timerun_1s);
            //Bat tat relay theo giai doan
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
            if (run_button == 1) {
                delay_ms(10);
                if (run_button == 1) {
                    setup_stage = 0;
                    run = 0;
                    relay_stt = 0;
                    RA3_bit = 0;
                    while (run_button == 1);
                }
            }
        }

        relay_pin = relay_stt;
        if (ex_interrupt_flag == 1) {
            if (level_run == 1) {
                delay_ms(1); // 0-10 tuong ung thoi gian kich TRIAC 0-10000 us / phat hien diem 0.
                RA3_bit = 1;
                delay_ms(8);
                RA3_bit = 0;
            }
            if (level_run == 2) {
                delay_ms(4); // 0-10 tuong ung thoi gian kich TRIAC 0-10000 us / phat hien diem 0.
                RA3_bit = 1;
                delay_ms(5);
                RA3_bit = 0;
            }
            if (level_run == 3) {
                delay_ms(8); // 0-10 tuong ung thoi gian kich TRIAC 0-10000 us / phat hien diem 0.
                RA3_bit = 1;
                delay_ms(1);
                RA3_bit = 0;
            }
            if (level_run == 0) {
                RA3_bit = 0;
                relay_pin = 0;
            }
            ex_interrupt_flag = 0;
        }
    }
}