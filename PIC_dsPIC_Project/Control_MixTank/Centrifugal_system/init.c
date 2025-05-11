void init_timer0()
{
    ANSEL = 0; // Configure AN pins as digital
    ANSELH = 0;
    C1ON_bit = 0; // Disable comparators
    C2ON_bit = 0;

    TRISC = 0x00U;
    PORTC = 0x00U;

    TRISA = 0x00U;
    PORTA = 0x00U;

    TRISE = 0x00U;

    TRISB = 0x01;       //RB0 la input.

    TRISD = 0xFF;

  //--------------- cho phep ngat timer 0 -------------------------
    OPTION_REG.T0CS = 0;    // xung den tu thach anh
    OPTION_REG.PSA  = 0;    // bo chia tan so duoc gan cho timer0

    OPTION_REG.PS0 = 0;
    OPTION_REG.PS1 = 1;    // 1 : 8*4
    OPTION_REG.PS2 = 0;

    TMR0 = 6;

    INTCON.T0IF = 0;
    INTCON.T0IE = 1;    // cho phep ngat timer 0
    INTCON.GIE  = 1;    // bat lai cac ngat
}

void init_external()
{
    INTCON.INTE = 1; // cho phep ngat chan B0
    OPTION_REG.INTEDG = 0; // chon canh ngat o muc logic 0

    INTCON.INTF = 0; // co ngat chan B0 = 0
    ANSELH.ANS12 = 0;
}