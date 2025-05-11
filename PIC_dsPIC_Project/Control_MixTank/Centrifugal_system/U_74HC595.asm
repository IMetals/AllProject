
_latch_595:

;U_74HC595.c,9 :: 		void latch_595()
;U_74HC595.c,11 :: 		SHIFT_LATCH = 1;
	BSF        PORTC+0, 3
;U_74HC595.c,12 :: 		asm nop;
	NOP
;U_74HC595.c,13 :: 		SHIFT_LATCH = 0;
	BCF        PORTC+0, 3
;U_74HC595.c,14 :: 		}
L_end_latch_595:
	RETURN
; end of _latch_595

_HC595:

;U_74HC595.c,17 :: 		void HC595(unsigned short row1, unsigned short row2)
;U_74HC595.c,20 :: 		tam1 = ma_led[row2] ;
	MOVF       FARG_HC595_row2+0, 0
	ADDLW      _ma_led+0
	MOVWF      R0+0
	MOVLW      hi_addr(_ma_led+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      HC595_tam1_L0+0
;U_74HC595.c,21 :: 		tam2 = ma_led[row1] ;
	MOVF       FARG_HC595_row1+0, 0
	ADDLW      _ma_led+0
	MOVWF      R0+0
	MOVLW      hi_addr(_ma_led+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      HC595_tam2_L0+0
;U_74HC595.c,23 :: 		for (x=0; x<=7; ++x)
	CLRF       HC595_x_L0+0
L_HC5950:
	MOVF       HC595_x_L0+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_HC5951
;U_74HC595.c,25 :: 		if (tam1 & 0x80) SHIFT_DATA = 1;
	BTFSS      HC595_tam1_L0+0, 7
	GOTO       L_HC5953
	BSF        PORTC+0, 1
	GOTO       L_HC5954
L_HC5953:
;U_74HC595.c,26 :: 		else SHIFT_DATA = 0;
	BCF        PORTC+0, 1
L_HC5954:
;U_74HC595.c,27 :: 		tam1 <<= 1;
	RLF        HC595_tam1_L0+0, 1
	BCF        HC595_tam1_L0+0, 0
;U_74HC595.c,28 :: 		SHIFT_CLOCK = 1;
	BSF        PORTC+0, 2
;U_74HC595.c,29 :: 		asm nop;
	NOP
;U_74HC595.c,30 :: 		SHIFT_CLOCK = 0;
	BCF        PORTC+0, 2
;U_74HC595.c,23 :: 		for (x=0; x<=7; ++x)
	INCF       HC595_x_L0+0, 1
;U_74HC595.c,31 :: 		}
	GOTO       L_HC5950
L_HC5951:
;U_74HC595.c,32 :: 		for (x=0; x<=7; ++x)
	CLRF       HC595_x_L0+0
L_HC5955:
	MOVF       HC595_x_L0+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_HC5956
;U_74HC595.c,34 :: 		if (tam2 & 0x80) SHIFT_DATA = 1;
	BTFSS      HC595_tam2_L0+0, 7
	GOTO       L_HC5958
	BSF        PORTC+0, 1
	GOTO       L_HC5959
L_HC5958:
;U_74HC595.c,35 :: 		else SHIFT_DATA = 0;
	BCF        PORTC+0, 1
L_HC5959:
;U_74HC595.c,36 :: 		tam2 <<= 1;
	RLF        HC595_tam2_L0+0, 1
	BCF        HC595_tam2_L0+0, 0
;U_74HC595.c,37 :: 		SHIFT_CLOCK = 1;
	BSF        PORTC+0, 2
;U_74HC595.c,38 :: 		asm nop;
	NOP
;U_74HC595.c,39 :: 		SHIFT_CLOCK = 0;
	BCF        PORTC+0, 2
;U_74HC595.c,32 :: 		for (x=0; x<=7; ++x)
	INCF       HC595_x_L0+0, 1
;U_74HC595.c,40 :: 		}
	GOTO       L_HC5955
L_HC5956:
;U_74HC595.c,41 :: 		}
L_end_HC595:
	RETURN
; end of _HC595

_Led_Column1_ON:

;U_74HC595.c,43 :: 		void Led_Column1_ON()
;U_74HC595.c,45 :: 		LED_C1 = 1;
	BSF        PORTC+0, 4
;U_74HC595.c,46 :: 		LED_C2 = 0;
	BCF        PORTC+0, 5
;U_74HC595.c,47 :: 		LED_C3 = 0;
	BCF        PORTC+0, 6
;U_74HC595.c,48 :: 		}
L_end_Led_Column1_ON:
	RETURN
; end of _Led_Column1_ON

_Led_Column2_ON:

;U_74HC595.c,50 :: 		void Led_Column2_ON()
;U_74HC595.c,52 :: 		LED_C1 = 0;
	BCF        PORTC+0, 4
;U_74HC595.c,53 :: 		LED_C2 = 1;
	BSF        PORTC+0, 5
;U_74HC595.c,54 :: 		LED_C3 = 0;
	BCF        PORTC+0, 6
;U_74HC595.c,55 :: 		}
L_end_Led_Column2_ON:
	RETURN
; end of _Led_Column2_ON

_Led_Column3_ON:

;U_74HC595.c,57 :: 		void Led_Column3_ON()
;U_74HC595.c,59 :: 		LED_C1 = 0;
	BCF        PORTC+0, 4
;U_74HC595.c,60 :: 		LED_C2 = 0;
	BCF        PORTC+0, 5
;U_74HC595.c,61 :: 		LED_C3 = 1;
	BSF        PORTC+0, 6
;U_74HC595.c,62 :: 		}
L_end_Led_Column3_ON:
	RETURN
; end of _Led_Column3_ON
