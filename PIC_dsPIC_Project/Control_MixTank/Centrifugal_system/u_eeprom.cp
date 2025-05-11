#line 1 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/u_eeprom.c"
#line 1 "h:/mikroc_pro/project/lytam_system/centrifugal_system/u_eeprom.h"



void EEPROM_WriteByte(unsigned char eepromAddress, unsigned char eepromData);
unsigned char EEPROM_ReadByte(unsigned char eepromAddress);
#line 3 "H:/MikroC_PRO/Project/Lytam_system/Centrifugal_system/u_eeprom.c"
void EEPROM_WriteByte(unsigned char eepromAddress, unsigned char eepromData) {
 unsigned char INTCON_SAVE;

 EEADR = eepromAddress;
 EEDATA = eepromData;
 EECON1.EEPGD = 0;
 EECON1.WREN = 1;
 INTCON_SAVE = INTCON;
 INTCON = 0;
 EECON2 = 0x55;
 EECON2 = 0xaa;
 EECON1.WR = 1;
 INTCON = INTCON_SAVE;
 EECON1.WREN = 0;
 while (PIR2.EEIF == 0)
 {
 }
 PIR2.EEIF = 0;
}

unsigned char EEPROM_ReadByte(unsigned char eepromAddress) {
 EEADR = eepromAddress;
 EECON1.EEPGD = 0;
 EECON1.RD = 1;
 return (EEDATA);
}
