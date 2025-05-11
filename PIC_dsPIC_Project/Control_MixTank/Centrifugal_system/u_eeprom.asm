
_EEPROM_WriteByte:

;u_eeprom.c,3 :: 		void EEPROM_WriteByte(unsigned char eepromAddress, unsigned char eepromData) {
;u_eeprom.c,6 :: 		EEADR = eepromAddress;
	MOVF       FARG_EEPROM_WriteByte_eepromAddress+0, 0
	MOVWF      EEADR+0
;u_eeprom.c,7 :: 		EEDATA = eepromData;
	MOVF       FARG_EEPROM_WriteByte_eepromData+0, 0
	MOVWF      EEDATA+0
;u_eeprom.c,8 :: 		EECON1.EEPGD = 0;
	BCF        EECON1+0, 7
;u_eeprom.c,9 :: 		EECON1.WREN = 1;
	BSF        EECON1+0, 2
;u_eeprom.c,10 :: 		INTCON_SAVE = INTCON;
	MOVF       INTCON+0, 0
	MOVWF      R0+0
;u_eeprom.c,11 :: 		INTCON = 0;
	CLRF       INTCON+0
;u_eeprom.c,12 :: 		EECON2 = 0x55;
	MOVLW      85
	MOVWF      EECON2+0
;u_eeprom.c,13 :: 		EECON2 = 0xaa;
	MOVLW      170
	MOVWF      EECON2+0
;u_eeprom.c,14 :: 		EECON1.WR = 1;
	BSF        EECON1+0, 1
;u_eeprom.c,15 :: 		INTCON = INTCON_SAVE;
	MOVF       R0+0, 0
	MOVWF      INTCON+0
;u_eeprom.c,16 :: 		EECON1.WREN = 0;
	BCF        EECON1+0, 2
;u_eeprom.c,17 :: 		while (PIR2.EEIF == 0)
L_EEPROM_WriteByte0:
	BTFSC      PIR2+0, 4
	GOTO       L_EEPROM_WriteByte1
;u_eeprom.c,19 :: 		}
	GOTO       L_EEPROM_WriteByte0
L_EEPROM_WriteByte1:
;u_eeprom.c,20 :: 		PIR2.EEIF = 0;
	BCF        PIR2+0, 4
;u_eeprom.c,21 :: 		}
L_end_EEPROM_WriteByte:
	RETURN
; end of _EEPROM_WriteByte

_EEPROM_ReadByte:

;u_eeprom.c,23 :: 		unsigned char EEPROM_ReadByte(unsigned char eepromAddress) {
;u_eeprom.c,24 :: 		EEADR = eepromAddress;
	MOVF       FARG_EEPROM_ReadByte_eepromAddress+0, 0
	MOVWF      EEADR+0
;u_eeprom.c,25 :: 		EECON1.EEPGD = 0;
	BCF        EECON1+0, 7
;u_eeprom.c,26 :: 		EECON1.RD = 1;
	BSF        EECON1+0, 0
;u_eeprom.c,27 :: 		return (EEDATA);
	MOVF       EEDATA+0, 0
	MOVWF      R0+0
;u_eeprom.c,28 :: 		}
L_end_EEPROM_ReadByte:
	RETURN
; end of _EEPROM_ReadByte
