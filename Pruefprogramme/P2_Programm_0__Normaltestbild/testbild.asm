
REGIRM: EQU 84H
REGMEM: EQU 86H
PAD:    EQU 88H
PAC:    EQU 8AH
PBD:    EQU 89H
PBC:    EQU 8BH
CTCK0:  EQU 8CH
CTCK1:  EQU 8DH
CTCK2:  EQU 8EH
VTZK1:  EQU 50H
VTZK2:  EQU 150H

    ; KCC-Header
    ORG 0180H
    DEFB    'TESTBILD.KCC'  ; Dateiname
    DEFS    4, 0            ; frei
    DEFB    3               ; Argumente (3=Autostart)
    DEFW    BEGIN,END,START
    DEFS    105, 0

BEGIN:

    ; Menüeintrag
    DEFW    7F7FH
    DEFB    'TESTBILD'
    DEFB    0

START:

    ; TESTBILD FUER KC 85/4
    ; =====================
TESTB:
    LD      A,4FH
    OUT     (PAC),A
    LD      A,1FH
    OUT     (PAD),A
    LD      A,0FH
    OUT     (PAC),A
    LD      A,03H
    OUT     (PAC),A
    LD      A,08H       ; PIXELSPEICHER1
    OUT     (REGIRM),A
    LD      HL,8000H    ; PIXEL-RAM LADEN
    LD      DE,8001H
    LD      BC,0800H
    LD      (HL),33H
    LDIR
    LD      BC,0800H
    LD      (HL),55H
    LDIR
    LD      BC,0800H
    LD      (HL),00H
    LDIR
    LD      BC,0800H
    LD      (HL),0FH
    LDIR
    LD      BC,0100H
    LD      (HL),00H
    LDIR
    LD      BC,0100H
    LD      (HL),0FFH
    LDIR
    LD      BC,0100H
    LD      (HL),00H
    LDIR
    LD      BC,0100H
    LD      (HL),0FFH
    LDIR
    LD      BC,0100H
    LD      (HL),00H
    LDIR
    LD      BC,0100H
    LD      (HL),0FFH
    LDIR
    LD      BC,0100H
    LD      (HL),00H
    LDIR
    LD      BC,00FFH
    LD      (HL),0FFH
    LDIR
    LD      HL,8000H    ; ZEILEN LOESCHEN
MA:
    LD      A,H
    CP      0A8H
    JR      Z, ME
    LD      A,L
    AND     0C1H
    CP      00H
    JR      Z, LOE
    LD      A,L
    AND     0C2H
    CP      40H
    JR      Z, LOE
    LD      A,L
    AND     0C4H
    CP      80H
    JR      Z, LOE
    LD      A,L
    AND     0C8H
    CP      0C0H
    JR      NZ, MZ
LOE:
    LD      (HL),00H
MZ:
    INC     HL
    JR      MA

ME:
    LD      HL,8F40H    ; 2xBYTE 0 BIS FF
    LD      DE,00C0H
    LD      C,08H
    XOR     A
MC:
    LD      B,40H
    ADD     HL,DE
MB:
    LD      (HL),A
    INC     A
    INC     HL
    DJNZ    MB
    DEC     C
    JR      NZ, MC
    LD      HL,8F7FH    ; SCHRAEGE LINIE
    LD      DE,0100H
    LD      C,08H
    LD      A,80H
MLC:
    LD      B,08H
    ADD     HL,DE
MLB:
    LD      (HL),A
    RRCA
    DEC     HL
    DJNZ    MLB
    DEC     C
    JR      NZ, MLC
    LD      HL,9000H
MFA:                    ; VORDERGRUND-
    BIT     3,H         ; FARBBALKEN
    JR      NZ, MFE
    LD      A,L
    AND     0C0H
    CP      0C0H
    JR      NZ, MFZ
    LD      (HL),0FFH
MFZ:
    INC     HL
    JR      MFA

    LD      A,3FH
    OUT     (PAD),A
MFE:
    LD      A,0AH       ; FARBSPEICHER1
    OUT     (REGIRM),A
    LD      HL,8000H    ; FARB-RAM LADEN
    LD      DE,8001H
    LD      BC,27FFH
    LD      (HL),39H    ; WEISS AUF BLAU
    LDIR
    LD      HL,9400H    ; BLINKFELD
MBA:
    LD      A,H
    CP      98H
    JR      Z, MBE
    LD      A,L
    AND     0C0H
    CP      00H
    JR      NZ, MBZ
    LD      (HL),99H
MBZ:
    INC     HL
    JR      MBA

MBE:
    LD      HL,9000H    ; FARBBALKEN
    LD      DE,0080H
    LD      C,08H
    XOR     A
MFC:
    LD      B,80H
    ADD     HL,DE
MFB:
    RES     6,A
    BIT     5,L
    JR      Z, MFR
    SET     6,A
MFR:
    LD      (HL),A
    INC     HL
    DJNZ    MFB
    ADD     A,09H
    DEC     C
    JR      NZ, MFC
    LD      A,45H
    OUT     (CTCK2),A
    LD      A,19H
    OUT     (CTCK2),A


    ; Programmende
    ; warten auf Tastendruck
PV1:        EQU 0F003H
UP_KBDS:    EQU 0CH
UP_BYE:     EQU 0DH
UP_BRKT:    EQU 2AH

btest:
    CALL    PV1
    ;DEFB    UP_BRKT
    DEFB    UP_KBDS
    JR      NC,btest

    CALL    PV1
    DEFB    UP_BYE

END:
