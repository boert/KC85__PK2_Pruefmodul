
# P222_neu.asm
Die Binärdatei 'P222.BIN' wurde rückübersetzt (Disassmbler[^1]). Zusammen mit den Marken und Kommentaren aus P1.ASM und P2.ASM wurde der Assmbler-Quellcode neu erstellt.
Als Assembler kommt z80asm[^2] zum Einsatz.

Ein Kontrolle der Prüfsummen[^3] ergibt Übereinstimmung mit dem Original:
```
make jacksum

jacksum -a crc:16,1021,ffff,false,false,0 -X ../EPROMs/Pruefmodul_P222.BIN P222_neu.rom
3578    8192    ../EPROMs/Pruefmodul_P222.BIN
3578    8192    P222_neu.rom
```

## Referenzen

[^1]: [Z80-Disassmbler](https://github.com/lvitals/z80dasm/)
[^2]: [Z80-Assembler z80asm](https://www.nongnu.org/z80asm/)
[^3]: [Jacksum, checksum untility](https://jacksum.net/en/index.html)
