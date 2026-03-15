TARGET=testbild.kcc

all: $(TARGET)
	truncate --size=%128 $<

%.kcc: %.asm
	z80asm --list --output $@  $<

