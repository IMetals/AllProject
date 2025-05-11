#ifndef __U_EEPROM_H__
#define __U_EEPROM_H__

void EEPROM_WriteByte(unsigned char eepromAddress, unsigned char eepromData);
unsigned char EEPROM_ReadByte(unsigned char eepromAddress);

#endif