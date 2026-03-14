ORIG=../EPROMs/Pruefmodul_P222.BIN
NEW=P222_neu.rom

all: $(NEW)


%.rom: %.asm
	z80asm --list --output $@  $<


sum: $(ORIG) $(NEW)
	md5sum $^

jacksum: $(ORIG) $(NEW)
	jacksum -a crc:16,1021,ffff,false,false,0 -X $^

diff: $(ORIG) $(NEW)
	vbindiff $^
