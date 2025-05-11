#line 1 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/init.c"
void init_timer0()
{
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISC = 0x00U;
 PORTC = 0x00U;

 TRISA = 0x00U;
 PORTA = 0x00U;

 TRISE = 0x00U;

 TRISB = 0x01;

 TRISD = 0xFF;


 OPTION_REG.T0CS = 0;
 OPTION_REG.PSA = 0;

 OPTION_REG.PS0 = 0;
 OPTION_REG.PS1 = 1;
 OPTION_REG.PS2 = 0;

 TMR0 = 6;

 INTCON.T0IF = 0;
 INTCON.T0IE = 1;
 INTCON.GIE = 1;
}

void init_external()
{
 INTCON.INTE = 1;
 OPTION_REG.INTEDG = 0;

 INTCON.INTF = 0;
 ANSELH.ANS12 = 0;
}
