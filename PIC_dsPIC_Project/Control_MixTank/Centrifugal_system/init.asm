
_init_timer0:

;init.c,1 :: 		void init_timer0()
;init.c,3 :: 		ANSEL = 0; // Configure AN pins as digital
	CLRF       ANSEL+0
;init.c,4 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;init.c,5 :: 		C1ON_bit = 0; // Disable comparators
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;init.c,6 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;init.c,8 :: 		TRISC = 0x00U;
	CLRF       TRISC+0
;init.c,9 :: 		PORTC = 0x00U;
	CLRF       PORTC+0
;init.c,11 :: 		TRISA = 0x00U;
	CLRF       TRISA+0
;init.c,12 :: 		PORTA = 0x00U;
	CLRF       PORTA+0
;init.c,14 :: 		TRISE = 0x00U;
	CLRF       TRISE+0
;init.c,16 :: 		TRISB = 0x01;       //RB0 la input.
	MOVLW      1
	MOVWF      TRISB+0
;init.c,18 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;init.c,21 :: 		OPTION_REG.T0CS = 0;    // xung den tu thach anh
	BCF        OPTION_REG+0, 5
;init.c,22 :: 		OPTION_REG.PSA  = 0;    // bo chia tan so duoc gan cho timer0
	BCF        OPTION_REG+0, 3
;init.c,24 :: 		OPTION_REG.PS0 = 0;
	BCF        OPTION_REG+0, 0
;init.c,25 :: 		OPTION_REG.PS1 = 1;    // 1 : 8*4
	BSF        OPTION_REG+0, 1
;init.c,26 :: 		OPTION_REG.PS2 = 0;
	BCF        OPTION_REG+0, 2
;init.c,28 :: 		TMR0 = 6;
	MOVLW      6
	MOVWF      TMR0+0
;init.c,30 :: 		INTCON.T0IF = 0;
	BCF        INTCON+0, 2
;init.c,31 :: 		INTCON.T0IE = 1;    // cho phep ngat timer 0
	BSF        INTCON+0, 5
;init.c,32 :: 		INTCON.GIE  = 1;    // bat lai cac ngat
	BSF        INTCON+0, 7
;init.c,33 :: 		}
L_end_init_timer0:
	RETURN
; end of _init_timer0

_init_external:

;init.c,35 :: 		void init_external()
;init.c,37 :: 		INTCON.INTE = 1; // cho phep ngat chan B0
	BSF        INTCON+0, 4
;init.c,38 :: 		OPTION_REG.INTEDG = 0; // chon canh ngat o muc logic 0
	BCF        OPTION_REG+0, 6
;init.c,40 :: 		INTCON.INTF = 0; // co ngat chan B0 = 0
	BCF        INTCON+0, 1
;init.c,41 :: 		ANSELH.ANS12 = 0;
	BCF        ANSELH+0, 4
;init.c,42 :: 		}
L_end_init_external:
	RETURN
; end of _init_external
