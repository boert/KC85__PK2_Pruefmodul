TARGET=bws55.kcc

all: $(TARGET)
	truncate --size=%128 $<

%.kcc: %.asm
	z80asm  --output $@  $<

