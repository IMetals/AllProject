
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;main.c,45 :: 		void interrupt() {
;main.c,46 :: 		INTCON.GIE = 0; // tat cac ngat
	BCF        INTCON+0, 7
;main.c,47 :: 		if (INTCON.T0IF) { //Ngat timer0
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;main.c,48 :: 		INTCON.T0IF = 0; // xoa co ngat
	BCF        INTCON+0, 2
;main.c,49 :: 		n_led++; //Quet Led
	INCF       _n_led+0, 1
;main.c,51 :: 		if (n_led == 3) // hien thi led don vi
	MOVF       _n_led+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;main.c,53 :: 		n_led = 0;
	CLRF       _n_led+0
;main.c,54 :: 		HC595(led_r1[0], led_r2[0]);
	MOVF       _led_r1+0, 0
	MOVWF      FARG_HC595_row1+0
	MOVF       _led_r2+0, 0
	MOVWF      FARG_HC595_row2+0
	CALL       _HC595+0
;main.c,55 :: 		latch_595();
	CALL       _latch_595+0
;main.c,56 :: 		Led_Column3_ON();
	CALL       _Led_Column3_ON+0
;main.c,57 :: 		}
L_interrupt1:
;main.c,59 :: 		if (n_led == 2) // hien thi led hang chuc
	MOVF       _n_led+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;main.c,61 :: 		HC595(led_r1[1], led_r2[1]);
	MOVF       _led_r1+1, 0
	MOVWF      FARG_HC595_row1+0
	MOVF       _led_r2+1, 0
	MOVWF      FARG_HC595_row2+0
	CALL       _HC595+0
;main.c,62 :: 		latch_595();
	CALL       _latch_595+0
;main.c,63 :: 		Led_Column2_ON();
	CALL       _Led_Column2_ON+0
;main.c,64 :: 		}
L_interrupt2:
;main.c,66 :: 		if (n_led == 1) // hien thi led hang tram
	MOVF       _n_led+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;main.c,68 :: 		HC595(led_r1[2], led_r2[2]);
	MOVF       _led_r1+2, 0
	MOVWF      FARG_HC595_row1+0
	MOVF       _led_r2+2, 0
	MOVWF      FARG_HC595_row2+0
	CALL       _HC595+0
;main.c,69 :: 		latch_595();
	CALL       _latch_595+0
;main.c,70 :: 		Led_Column1_ON();
	CALL       _Led_Column1_ON+0
;main.c,71 :: 		}
L_interrupt3:
;main.c,72 :: 		}
L_interrupt0:
;main.c,74 :: 		if (INTCON.INTF) {// phat hien co ngat ngoai
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt4
;main.c,75 :: 		ex_interrupt_flag = 1;
	BSF        _ex_interrupt_flag+0, BitPos(_ex_interrupt_flag+0)
;main.c,77 :: 		if (run == 1) {
	BTFSS      _run+0, BitPos(_run+0)
	GOTO       L_interrupt5
;main.c,78 :: 		timerun_10ms++;
	INCF       _timerun_10ms+0, 1
;main.c,79 :: 		if (timerun_10ms == 100) {
	MOVF       _timerun_10ms+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;main.c,80 :: 		timerun_10ms = 0;
	CLRF       _timerun_10ms+0
;main.c,81 :: 		timerun_1s++;
	INCF       _timerun_1s+0, 1
;main.c,82 :: 		if (timerun_1s == 60) {
	MOVF       _timerun_1s+0, 0
	XORLW      60
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
;main.c,83 :: 		timerun_minute++;
	INCF       _timerun_minute+0, 1
;main.c,84 :: 		timerun_1s = 0;
	CLRF       _timerun_1s+0
;main.c,85 :: 		}
L_interrupt7:
;main.c,86 :: 		}
L_interrupt6:
;main.c,87 :: 		}
L_interrupt5:
;main.c,89 :: 		}
L_interrupt4:
;main.c,91 :: 		TMR0 = 6;
	MOVLW      6
	MOVWF      TMR0+0
;main.c,92 :: 		INTCON.INTF = 0; // co ngat = 0
	BCF        INTCON+0, 1
;main.c,93 :: 		INTCON.T0IF = 0; // xoa co ngat
	BCF        INTCON+0, 2
;main.c,94 :: 		INTCON.GIE = 1; // bat lai cac ngat
	BSF        INTCON+0, 7
;main.c,95 :: 		}
L_end_interrupt:
L__interrupt132:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_seg7Print_led2:

;main.c,97 :: 		void seg7Print_led2(int number) {
;main.c,99 :: 		led_r2[0] = number % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_seg7Print_led2_number+0, 0
	MOVWF      R0+0
	MOVF       FARG_seg7Print_led2_number+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _led_r2+0
;main.c,100 :: 		number = number / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_seg7Print_led2_number+0, 0
	MOVWF      R0+0
	MOVF       FARG_seg7Print_led2_number+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FLOC__seg7Print_led2+0
	MOVF       R0+1, 0
	MOVWF      FLOC__seg7Print_led2+1
	MOVF       FLOC__seg7Print_led2+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	MOVF       FLOC__seg7Print_led2+1, 0
	MOVWF      FARG_seg7Print_led2_number+1
;main.c,101 :: 		led_r2[1] = number % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__seg7Print_led2+0, 0
	MOVWF      R0+0
	MOVF       FLOC__seg7Print_led2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _led_r2+1
;main.c,102 :: 		number = number / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__seg7Print_led2+0, 0
	MOVWF      R0+0
	MOVF       FLOC__seg7Print_led2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	MOVF       R0+1, 0
	MOVWF      FARG_seg7Print_led2_number+1
;main.c,103 :: 		led_r2[2] = number % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _led_r2+2
;main.c,104 :: 		}
L_end_seg7Print_led2:
	RETURN
; end of _seg7Print_led2

_stage:

;main.c,106 :: 		void stage() {
;main.c,107 :: 		while (setup_stage == 0) {
L_stage8:
	MOVF       _setup_stage+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_stage9
;main.c,108 :: 		led_r1[0] = stage_stt;        led_r1[1] = d_letter;        led_r1[2] = g_letter;
	MOVF       _stage_stt+0, 0
	MOVWF      _led_r1+0
	MOVLW      11
	MOVWF      _led_r1+1
	MOVLW      12
	MOVWF      _led_r1+2
;main.c,109 :: 		while ((ready_stt == 1) && (mode_button == 0) &&(down_button == 0) && (run_button == 0) && (up_button == 0) &&(stage_stt == 1)) {
L_stage10:
	BTFSS      _ready_stt+0, BitPos(_ready_stt+0)
	GOTO       L_stage11
	BTFSC      PORTD+0, 6
	GOTO       L_stage11
	BTFSC      PORTD+0, 5
	GOTO       L_stage11
	BTFSC      PORTD+0, 7
	GOTO       L_stage11
	BTFSC      PORTD+0, 4
	GOTO       L_stage11
	MOVF       _stage_stt+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_stage11
L__stage128:
;main.c,110 :: 		led_r2[0] = sub_letter;    led_r2[1] = 10;            led_r2[2] = 10;
	MOVLW      19
	MOVWF      _led_r2+0
	MOVLW      10
	MOVWF      _led_r2+1
	MOVLW      10
	MOVWF      _led_r2+2
;main.c,111 :: 		delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_stage14:
	DECFSZ     R13+0, 1
	GOTO       L_stage14
	DECFSZ     R12+0, 1
	GOTO       L_stage14
	NOP
	NOP
;main.c,112 :: 		led_r2[0] = 10;            led_r2[1] = sub_letter;    led_r2[2] = 10;
	MOVLW      10
	MOVWF      _led_r2+0
	MOVLW      19
	MOVWF      _led_r2+1
	MOVLW      10
	MOVWF      _led_r2+2
;main.c,113 :: 		delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_stage15:
	DECFSZ     R13+0, 1
	GOTO       L_stage15
	DECFSZ     R12+0, 1
	GOTO       L_stage15
	NOP
	NOP
;main.c,114 :: 		led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = sub_letter;
	MOVLW      10
	MOVWF      _led_r2+0
	MOVLW      10
	MOVWF      _led_r2+1
	MOVLW      19
	MOVWF      _led_r2+2
;main.c,115 :: 		delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_stage16:
	DECFSZ     R13+0, 1
	GOTO       L_stage16
	DECFSZ     R12+0, 1
	GOTO       L_stage16
	NOP
	NOP
;main.c,116 :: 		led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = 10;
	MOVLW      10
	MOVWF      _led_r2+0
	MOVLW      10
	MOVWF      _led_r2+1
	MOVLW      10
	MOVWF      _led_r2+2
;main.c,117 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage17:
	DECFSZ     R13+0, 1
	GOTO       L_stage17
	DECFSZ     R12+0, 1
	GOTO       L_stage17
	NOP
;main.c,118 :: 		}
	GOTO       L_stage10
L_stage11:
;main.c,119 :: 		if ((ready_stt == 1) && (stage_stt != 1)) {
	BTFSS      _ready_stt+0, BitPos(_ready_stt+0)
	GOTO       L_stage20
	MOVF       _stage_stt+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_stage20
L__stage127:
;main.c,120 :: 		led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = 10;
	MOVLW      10
	MOVWF      _led_r2+0
	MOVLW      10
	MOVWF      _led_r2+1
	MOVLW      10
	MOVWF      _led_r2+2
;main.c,121 :: 		}
L_stage20:
;main.c,122 :: 		if (ready_stt == 0) {
	BTFSC      _ready_stt+0, BitPos(_ready_stt+0)
	GOTO       L_stage21
;main.c,123 :: 		led_r2[0] = 10;            led_r2[1] = 10;            led_r2[2] = 10;
	MOVLW      10
	MOVWF      _led_r2+0
	MOVLW      10
	MOVWF      _led_r2+1
	MOVLW      10
	MOVWF      _led_r2+2
;main.c,124 :: 		}
L_stage21:
;main.c,126 :: 		if ((mode_button == 1)&&(ready_stt == 0)) {
	BTFSS      PORTD+0, 6
	GOTO       L_stage24
	BTFSC      _ready_stt+0, BitPos(_ready_stt+0)
	GOTO       L_stage24
L__stage126:
;main.c,127 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage25:
	DECFSZ     R13+0, 1
	GOTO       L_stage25
	DECFSZ     R12+0, 1
	GOTO       L_stage25
	NOP
;main.c,128 :: 		if (mode_button == 1) {
	BTFSS      PORTD+0, 6
	GOTO       L_stage26
;main.c,129 :: 		setup_stage++;
	INCF       _setup_stage+0, 1
;main.c,130 :: 		if (setup_stage == 3)
	MOVF       _setup_stage+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_stage27
;main.c,131 :: 		setup_stage = 0;
	CLRF       _setup_stage+0
L_stage27:
;main.c,132 :: 		while (mode_button == 1);
L_stage28:
	BTFSS      PORTD+0, 6
	GOTO       L_stage29
	GOTO       L_stage28
L_stage29:
;main.c,133 :: 		}
L_stage26:
;main.c,134 :: 		}
L_stage24:
;main.c,136 :: 		if ((down_button == 1)&&(stage_stt == 1)) {
	BTFSS      PORTD+0, 5
	GOTO       L_stage32
	MOVF       _stage_stt+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_stage32
L__stage125:
;main.c,137 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage33:
	DECFSZ     R13+0, 1
	GOTO       L_stage33
	DECFSZ     R12+0, 1
	GOTO       L_stage33
	NOP
;main.c,138 :: 		if (down_button == 1) {
	BTFSS      PORTD+0, 5
	GOTO       L_stage34
;main.c,139 :: 		ready_stt = ~ready_stt;
	MOVLW
	XORWF      _ready_stt+0, 1
;main.c,140 :: 		while (down_button == 1);
L_stage35:
	BTFSS      PORTD+0, 5
	GOTO       L_stage36
	GOTO       L_stage35
L_stage36:
;main.c,141 :: 		}
L_stage34:
;main.c,142 :: 		}
L_stage32:
;main.c,144 :: 		if ((run_button == 1) && (ready_stt == 1)) {
	BTFSS      PORTD+0, 7
	GOTO       L_stage39
	BTFSS      _ready_stt+0, BitPos(_ready_stt+0)
	GOTO       L_stage39
L__stage124:
;main.c,145 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage40:
	DECFSZ     R13+0, 1
	GOTO       L_stage40
	DECFSZ     R12+0, 1
	GOTO       L_stage40
	NOP
;main.c,146 :: 		if (run_button == 1) {
	BTFSS      PORTD+0, 7
	GOTO       L_stage41
;main.c,147 :: 		setup_stage = 5;
	MOVLW      5
	MOVWF      _setup_stage+0
;main.c,148 :: 		run = 1;
	BSF        _run+0, BitPos(_run+0)
;main.c,149 :: 		while (run_button == 1);
L_stage42:
	BTFSS      PORTD+0, 7
	GOTO       L_stage43
	GOTO       L_stage42
L_stage43:
;main.c,150 :: 		}
L_stage41:
;main.c,151 :: 		}
L_stage39:
;main.c,153 :: 		if ((up_button == 1) && (ready_stt == 0)) {
	BTFSS      PORTD+0, 4
	GOTO       L_stage46
	BTFSC      _ready_stt+0, BitPos(_ready_stt+0)
	GOTO       L_stage46
L__stage123:
;main.c,154 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage47:
	DECFSZ     R13+0, 1
	GOTO       L_stage47
	DECFSZ     R12+0, 1
	GOTO       L_stage47
	NOP
;main.c,155 :: 		if (up_button == 1) {
	BTFSS      PORTD+0, 4
	GOTO       L_stage48
;main.c,156 :: 		stage_stt++;
	INCF       _stage_stt+0, 1
;main.c,157 :: 		if (stage_stt == 6)
	MOVF       _stage_stt+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_stage49
;main.c,158 :: 		stage_stt = 1;
	MOVLW      1
	MOVWF      _stage_stt+0
L_stage49:
;main.c,159 :: 		while (up_button == 1);
L_stage50:
	BTFSS      PORTD+0, 4
	GOTO       L_stage51
	GOTO       L_stage50
L_stage51:
;main.c,160 :: 		}
L_stage48:
;main.c,161 :: 		}
L_stage46:
;main.c,162 :: 		}
	GOTO       L_stage8
L_stage9:
;main.c,166 :: 		while (setup_stage == 1) {
L_stage52:
	MOVF       _setup_stage+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_stage53
;main.c,167 :: 		led_r1[0] = 9;
	MOVLW      9
	MOVWF      _led_r1+0
;main.c,168 :: 		led_r1[1] = h_letter;
	MOVLW      14
	MOVWF      _led_r1+1
;main.c,169 :: 		led_r1[2] = t_letter;
	MOVLW      13
	MOVWF      _led_r1+2
;main.c,170 :: 		seg7Print_led2(time_setup);
	MOVF       _time_setup+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	CLRF       FARG_seg7Print_led2_number+1
	CALL       _seg7Print_led2+0
;main.c,171 :: 		time_setup = EEPROM_ReadByte(stage_stt);
	MOVF       _stage_stt+0, 0
	MOVWF      FARG_EEPROM_ReadByte_eepromAddress+0
	CALL       _EEPROM_ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _time_setup+0
;main.c,172 :: 		if (up_button == 1) {
	BTFSS      PORTD+0, 4
	GOTO       L_stage54
;main.c,173 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage55:
	DECFSZ     R13+0, 1
	GOTO       L_stage55
	DECFSZ     R12+0, 1
	GOTO       L_stage55
	NOP
;main.c,174 :: 		while (up_button == 1) {
L_stage56:
	BTFSS      PORTD+0, 4
	GOTO       L_stage57
;main.c,175 :: 		time_setup++;
	INCF       _time_setup+0, 1
;main.c,176 :: 		delay_ms(60);
	MOVLW      156
	MOVWF      R12+0
	MOVLW      215
	MOVWF      R13+0
L_stage58:
	DECFSZ     R13+0, 1
	GOTO       L_stage58
	DECFSZ     R12+0, 1
	GOTO       L_stage58
;main.c,177 :: 		if (time_setup > 200)
	MOVF       _time_setup+0, 0
	SUBLW      200
	BTFSC      STATUS+0, 0
	GOTO       L_stage59
;main.c,178 :: 		time_setup = 0;
	CLRF       _time_setup+0
L_stage59:
;main.c,179 :: 		EEPROM_WriteByte(stage_stt, time_setup);
	MOVF       _stage_stt+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromAddress+0
	MOVF       _time_setup+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromData+0
	CALL       _EEPROM_WriteByte+0
;main.c,180 :: 		seg7Print_led2(time_setup);
	MOVF       _time_setup+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	CLRF       FARG_seg7Print_led2_number+1
	CALL       _seg7Print_led2+0
;main.c,182 :: 		}
	GOTO       L_stage56
L_stage57:
;main.c,183 :: 		}
L_stage54:
;main.c,185 :: 		if (down_button == 1) {
	BTFSS      PORTD+0, 5
	GOTO       L_stage60
;main.c,186 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage61:
	DECFSZ     R13+0, 1
	GOTO       L_stage61
	DECFSZ     R12+0, 1
	GOTO       L_stage61
	NOP
;main.c,187 :: 		if (down_button == 1) {
	BTFSS      PORTD+0, 5
	GOTO       L_stage62
;main.c,188 :: 		time_setup--;
	DECF       _time_setup+0, 1
;main.c,189 :: 		delay_ms(60);
	MOVLW      156
	MOVWF      R12+0
	MOVLW      215
	MOVWF      R13+0
L_stage63:
	DECFSZ     R13+0, 1
	GOTO       L_stage63
	DECFSZ     R12+0, 1
	GOTO       L_stage63
;main.c,190 :: 		if (time_setup == 255)
	MOVF       _time_setup+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_stage64
;main.c,191 :: 		time_setup = 0;
	CLRF       _time_setup+0
L_stage64:
;main.c,192 :: 		EEPROM_WriteByte(stage_stt, time_setup);
	MOVF       _stage_stt+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromAddress+0
	MOVF       _time_setup+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromData+0
	CALL       _EEPROM_WriteByte+0
;main.c,193 :: 		seg7Print_led2(time_setup);
	MOVF       _time_setup+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	CLRF       FARG_seg7Print_led2_number+1
	CALL       _seg7Print_led2+0
;main.c,194 :: 		}
L_stage62:
;main.c,195 :: 		}
L_stage60:
;main.c,197 :: 		if (mode_button == 1) {
	BTFSS      PORTD+0, 6
	GOTO       L_stage65
;main.c,198 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage66:
	DECFSZ     R13+0, 1
	GOTO       L_stage66
	DECFSZ     R12+0, 1
	GOTO       L_stage66
	NOP
;main.c,199 :: 		if (mode_button == 1) {
	BTFSS      PORTD+0, 6
	GOTO       L_stage67
;main.c,200 :: 		setup_stage++;
	INCF       _setup_stage+0, 1
;main.c,201 :: 		if (setup_stage == 3)
	MOVF       _setup_stage+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_stage68
;main.c,202 :: 		setup_stage = 0;
	CLRF       _setup_stage+0
L_stage68:
;main.c,203 :: 		while (mode_button == 1);
L_stage69:
	BTFSS      PORTD+0, 6
	GOTO       L_stage70
	GOTO       L_stage69
L_stage70:
;main.c,204 :: 		}
L_stage67:
;main.c,205 :: 		}
L_stage65:
;main.c,206 :: 		}
	GOTO       L_stage52
L_stage53:
;main.c,209 :: 		while (setup_stage == 2) {
L_stage71:
	MOVF       _setup_stage+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_stage72
;main.c,210 :: 		led_r1[0] = o_letter;
	MOVLW      17
	MOVWF      _led_r1+0
;main.c,211 :: 		led_r1[1] = d_letter;
	MOVLW      11
	MOVWF      _led_r1+1
;main.c,212 :: 		led_r1[2] = c_letter;
	MOVLW      16
	MOVWF      _led_r1+2
;main.c,213 :: 		seg7Print_led2(level_run);
	MOVF       _level_run+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	CLRF       FARG_seg7Print_led2_number+1
	CALL       _seg7Print_led2+0
;main.c,214 :: 		level_run = EEPROM_ReadByte(stage_stt + 5);
	MOVLW      5
	ADDWF      _stage_stt+0, 0
	MOVWF      FARG_EEPROM_ReadByte_eepromAddress+0
	CALL       _EEPROM_ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _level_run+0
;main.c,215 :: 		if (up_button == 1) {
	BTFSS      PORTD+0, 4
	GOTO       L_stage73
;main.c,216 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage74:
	DECFSZ     R13+0, 1
	GOTO       L_stage74
	DECFSZ     R12+0, 1
	GOTO       L_stage74
	NOP
;main.c,217 :: 		if (up_button == 1) {
	BTFSS      PORTD+0, 4
	GOTO       L_stage75
;main.c,218 :: 		level_run++;
	INCF       _level_run+0, 1
;main.c,219 :: 		if (level_run > 3)
	MOVF       _level_run+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_stage76
;main.c,220 :: 		level_run = 0;
	CLRF       _level_run+0
L_stage76:
;main.c,221 :: 		EEPROM_WriteByte(stage_stt + 5, level_run);
	MOVLW      5
	ADDWF      _stage_stt+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromAddress+0
	MOVF       _level_run+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromData+0
	CALL       _EEPROM_WriteByte+0
;main.c,222 :: 		while (up_button == 1);
L_stage77:
	BTFSS      PORTD+0, 4
	GOTO       L_stage78
	GOTO       L_stage77
L_stage78:
;main.c,223 :: 		}
L_stage75:
;main.c,224 :: 		}
L_stage73:
;main.c,226 :: 		if (down_button == 1) {
	BTFSS      PORTD+0, 5
	GOTO       L_stage79
;main.c,227 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage80:
	DECFSZ     R13+0, 1
	GOTO       L_stage80
	DECFSZ     R12+0, 1
	GOTO       L_stage80
	NOP
;main.c,228 :: 		if (down_button == 1) {
	BTFSS      PORTD+0, 5
	GOTO       L_stage81
;main.c,229 :: 		level_run--;
	DECF       _level_run+0, 1
;main.c,230 :: 		if (level_run == 255)
	MOVF       _level_run+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_stage82
;main.c,231 :: 		level_run = 3;
	MOVLW      3
	MOVWF      _level_run+0
L_stage82:
;main.c,232 :: 		EEPROM_WriteByte(stage_stt + 5, level_run);
	MOVLW      5
	ADDWF      _stage_stt+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromAddress+0
	MOVF       _level_run+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromData+0
	CALL       _EEPROM_WriteByte+0
;main.c,233 :: 		while (down_button == 1);
L_stage83:
	BTFSS      PORTD+0, 5
	GOTO       L_stage84
	GOTO       L_stage83
L_stage84:
;main.c,234 :: 		}
L_stage81:
;main.c,235 :: 		}
L_stage79:
;main.c,236 :: 		if (mode_button == 1) {
	BTFSS      PORTD+0, 6
	GOTO       L_stage85
;main.c,237 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_stage86:
	DECFSZ     R13+0, 1
	GOTO       L_stage86
	DECFSZ     R12+0, 1
	GOTO       L_stage86
	NOP
;main.c,238 :: 		if (mode_button == 1) {
	BTFSS      PORTD+0, 6
	GOTO       L_stage87
;main.c,239 :: 		setup_stage++;
	INCF       _setup_stage+0, 1
;main.c,240 :: 		if (setup_stage == 3)
	MOVF       _setup_stage+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_stage88
;main.c,241 :: 		setup_stage = 0;
	CLRF       _setup_stage+0
L_stage88:
;main.c,242 :: 		while (mode_button == 1);
L_stage89:
	BTFSS      PORTD+0, 6
	GOTO       L_stage90
	GOTO       L_stage89
L_stage90:
;main.c,243 :: 		}
L_stage87:
;main.c,244 :: 		}
L_stage85:
;main.c,245 :: 		}
	GOTO       L_stage71
L_stage72:
;main.c,246 :: 		}
L_end_stage:
	RETURN
; end of _stage

_main:

;main.c,252 :: 		void main() {
;main.c,253 :: 		init_timer0();
	CALL       _init_timer0+0
;main.c,254 :: 		init_external();
	CALL       _init_external+0
;main.c,255 :: 		ready_stt = 0;
	BCF        _ready_stt+0, BitPos(_ready_stt+0)
;main.c,256 :: 		run = 0;
	BCF        _run+0, BitPos(_run+0)
;main.c,257 :: 		ex_interrupt_flag = 0;
	BCF        _ex_interrupt_flag+0, BitPos(_ex_interrupt_flag+0)
;main.c,258 :: 		relay_stt = 0;
	BCF        _relay_stt+0, BitPos(_relay_stt+0)
;main.c,259 :: 		for (j = 1; j < 11; j++)
	MOVLW      1
	MOVWF      _j+0
L_main91:
	MOVLW      11
	SUBWF      _j+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main92
;main.c,260 :: 		if (EEPROM_ReadByte(j) == 255) EEPROM_WriteByte(j, 0);
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_ReadByte_eepromAddress+0
	CALL       _EEPROM_ReadByte+0
	MOVF       R0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_main94
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_WriteByte_eepromAddress+0
	CLRF       FARG_EEPROM_WriteByte_eepromData+0
	CALL       _EEPROM_WriteByte+0
L_main94:
;main.c,259 :: 		for (j = 1; j < 11; j++)
	INCF       _j+0, 1
;main.c,260 :: 		if (EEPROM_ReadByte(j) == 255) EEPROM_WriteByte(j, 0);
	GOTO       L_main91
L_main92:
;main.c,262 :: 		while (1) {
L_main95:
;main.c,263 :: 		if (run == 0) {
	BTFSC      _run+0, BitPos(_run+0)
	GOTO       L_main97
;main.c,264 :: 		stage();
	CALL       _stage+0
;main.c,265 :: 		}
L_main97:
;main.c,266 :: 		if ((run == 1) && (setup_stage == 5)) {
	BTFSS      _run+0, BitPos(_run+0)
	GOTO       L_main100
	MOVF       _setup_stage+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_main100
L__main130:
;main.c,267 :: 		led_r1[0] = stage_stt;
	MOVF       _stage_stt+0, 0
	MOVWF      _led_r1+0
;main.c,268 :: 		led_r1[1] = d_letter;
	MOVLW      11
	MOVWF      _led_r1+1
;main.c,269 :: 		led_r1[2] = g_letter;
	MOVLW      12
	MOVWF      _led_r1+2
;main.c,270 :: 		seg7Print_led2(timerun_1s);
	MOVF       _timerun_1s+0, 0
	MOVWF      FARG_seg7Print_led2_number+0
	CLRF       FARG_seg7Print_led2_number+1
	CALL       _seg7Print_led2+0
;main.c,272 :: 		if (stage_stt == 2)
	MOVF       _stage_stt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main101
;main.c,273 :: 		relay_stt = 1;
	BSF        _relay_stt+0, BitPos(_relay_stt+0)
	GOTO       L_main102
L_main101:
;main.c,275 :: 		relay_stt = 0;
	BCF        _relay_stt+0, BitPos(_relay_stt+0)
L_main102:
;main.c,277 :: 		level_run = EEPROM_ReadByte(stage_stt + 5);
	MOVLW      5
	ADDWF      _stage_stt+0, 0
	MOVWF      FARG_EEPROM_ReadByte_eepromAddress+0
	CALL       _EEPROM_ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _level_run+0
;main.c,278 :: 		time_setup = EEPROM_ReadByte(stage_stt);
	MOVF       _stage_stt+0, 0
	MOVWF      FARG_EEPROM_ReadByte_eepromAddress+0
	CALL       _EEPROM_ReadByte+0
	MOVF       R0+0, 0
	MOVWF      _time_setup+0
;main.c,279 :: 		if ((timerun_minute >= time_setup) || (level_run == 0)) {
	MOVF       R0+0, 0
	SUBWF      _timerun_minute+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main129
	MOVF       _level_run+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main129
	GOTO       L_main105
L__main129:
;main.c,280 :: 		stage_stt++;
	INCF       _stage_stt+0, 1
;main.c,281 :: 		timerun_minute = 0;
	CLRF       _timerun_minute+0
;main.c,282 :: 		if (stage_stt == 6) {
	MOVF       _stage_stt+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_main106
;main.c,283 :: 		run = 0;
	BCF        _run+0, BitPos(_run+0)
;main.c,284 :: 		setup_stage = 0;
	CLRF       _setup_stage+0
;main.c,285 :: 		stage_stt = 1;
	MOVLW      1
	MOVWF      _stage_stt+0
;main.c,286 :: 		}
L_main106:
;main.c,287 :: 		}
L_main105:
;main.c,288 :: 		if (run_button == 1) {
	BTFSS      PORTD+0, 7
	GOTO       L_main107
;main.c,289 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main108:
	DECFSZ     R13+0, 1
	GOTO       L_main108
	DECFSZ     R12+0, 1
	GOTO       L_main108
	NOP
;main.c,290 :: 		if (run_button == 1) {
	BTFSS      PORTD+0, 7
	GOTO       L_main109
;main.c,291 :: 		setup_stage = 0;
	CLRF       _setup_stage+0
;main.c,292 :: 		run = 0;
	BCF        _run+0, BitPos(_run+0)
;main.c,293 :: 		relay_stt = 0;
	BCF        _relay_stt+0, BitPos(_relay_stt+0)
;main.c,294 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,295 :: 		while (run_button == 1);
L_main110:
	BTFSS      PORTD+0, 7
	GOTO       L_main111
	GOTO       L_main110
L_main111:
;main.c,296 :: 		}
L_main109:
;main.c,297 :: 		}
L_main107:
;main.c,298 :: 		}
L_main100:
;main.c,300 :: 		relay_pin = relay_stt;
	BTFSC      _relay_stt+0, BitPos(_relay_stt+0)
	GOTO       L__main136
	BCF        PORTE+0, 0
	GOTO       L__main137
L__main136:
	BSF        PORTE+0, 0
L__main137:
;main.c,301 :: 		if (ex_interrupt_flag == 1) {
	BTFSS      _ex_interrupt_flag+0, BitPos(_ex_interrupt_flag+0)
	GOTO       L_main112
;main.c,302 :: 		if (level_run == 1) {
	MOVF       _level_run+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main113
;main.c,303 :: 		delay_ms(1); // 0-10 tuong ung thoi gian kich TRIAC 0-10000 us / phat hien diem 0.
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_main114:
	DECFSZ     R13+0, 1
	GOTO       L_main114
	DECFSZ     R12+0, 1
	GOTO       L_main114
	NOP
	NOP
;main.c,304 :: 		RA3_bit = 1;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,305 :: 		delay_ms(8);
	MOVLW      21
	MOVWF      R12+0
	MOVLW      198
	MOVWF      R13+0
L_main115:
	DECFSZ     R13+0, 1
	GOTO       L_main115
	DECFSZ     R12+0, 1
	GOTO       L_main115
	NOP
;main.c,306 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,307 :: 		}
L_main113:
;main.c,308 :: 		if (level_run == 2) {
	MOVF       _level_run+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main116
;main.c,309 :: 		delay_ms(4); // 0-10 tuong ung thoi gian kich TRIAC 0-10000 us / phat hien diem 0.
	MOVLW      11
	MOVWF      R12+0
	MOVLW      98
	MOVWF      R13+0
L_main117:
	DECFSZ     R13+0, 1
	GOTO       L_main117
	DECFSZ     R12+0, 1
	GOTO       L_main117
	NOP
;main.c,310 :: 		RA3_bit = 1;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,311 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main118:
	DECFSZ     R13+0, 1
	GOTO       L_main118
	DECFSZ     R12+0, 1
	GOTO       L_main118
	NOP
	NOP
;main.c,312 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,313 :: 		}
L_main116:
;main.c,314 :: 		if (level_run == 3) {
	MOVF       _level_run+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main119
;main.c,315 :: 		delay_ms(8); // 0-10 tuong ung thoi gian kich TRIAC 0-10000 us / phat hien diem 0.
	MOVLW      21
	MOVWF      R12+0
	MOVLW      198
	MOVWF      R13+0
L_main120:
	DECFSZ     R13+0, 1
	GOTO       L_main120
	DECFSZ     R12+0, 1
	GOTO       L_main120
	NOP
;main.c,316 :: 		RA3_bit = 1;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,317 :: 		delay_ms(1);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_main121:
	DECFSZ     R13+0, 1
	GOTO       L_main121
	DECFSZ     R12+0, 1
	GOTO       L_main121
	NOP
	NOP
;main.c,318 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,319 :: 		}
L_main119:
;main.c,320 :: 		if (level_run == 0) {
	MOVF       _level_run+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main122
;main.c,321 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;main.c,322 :: 		relay_pin = 0;
	BCF        PORTE+0, 0
;main.c,323 :: 		}
L_main122:
;main.c,324 :: 		ex_interrupt_flag = 0;
	BCF        _ex_interrupt_flag+0, BitPos(_ex_interrupt_flag+0)
;main.c,325 :: 		}
L_main112:
;main.c,326 :: 		}
	GOTO       L_main95
;main.c,327 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
