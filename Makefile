# --
# Copyright (c) 2016, Lukasz Marcin Podkalicki <lpodkalicki@gmail.com>
# --

MCU=attiny13
FUSE_L=0x6A
FUSE_H=0xFF
F_CPU=1200000
CC=avr-gcc
LD=avr-ld
OBJCOPY=avr-objcopy
SIZE=avr-size
AVRDUDE=avrdude
CFLAGS=-std=c99 -Wall -g -Os -mmcu=${MCU} -DF_CPU=${F_CPU} -I.
TARGET=main

SRCS = main.c

main:
	${CC} ${CFLAGS} -o ${TARGET}.o ${SRCS}
	${LD} -o ${TARGET}.elf ${TARGET}.o
	${OBJCOPY} -j .text -j .data -O ihex ${TARGET}.o ${TARGET}.hex
	#${SIZE} -C --mcu=${MCU} ${TARGET}.elf
	#${AVRDUDE} -p ${MCU} -c usbasp -B 4 -U flash:w:${TARGET}.hex

flash:
	${AVRDUDE} -p ${MCU} -c usbasp -B 4 -U flash:w:${TARGET}.hex

fuse:
	$(AVRDUDE) -p ${MCU} -c usbasp -B 4 -U hfuse:w:${FUSE_H}:m -U lfuse:w:${FUSE_L}:m

clean:
	rm -f *.c~ *.h~ *.o *.elf *.hex
	
dump:
	${AVRDUDE} -p ${MCU} -c usbasp -B 4 -U flash:r:flashdump.hex:i
	
dumpeep:
	${AVRDUDE} -p ${MCU} -c usbasp -B 4 -U eeprom:r:eepromdump.hex:i
dumpsram:
	${AVRDUDE} -p ${MCU} -c usbasp -B 4 -U ram:r:sramdump.hex:i