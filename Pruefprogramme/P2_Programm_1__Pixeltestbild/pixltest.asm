
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
    DEFB    'PIXELTST.KCC'  ; Dateiname
    DEFS    4, 0            ; frei
    DEFB    3               ; Argumente (3=Autostart)
    DEFW    BEGIN,END,START
    DEFS    105, 0

BEGIN:

    ; Menüeintrag
    DEFW    7F7FH
    DEFB    'PIXELTEST'
    DEFB    1

START:

    ; TESTPROGRAMM FUER PIXELMODUS
    ; ============================

PXTST:
    LD      A,4FH
    OUT     (PAC),A
    LD      A,1FH
    OUT     (PAD),A
    LD      A,0FH
    OUT     (PAC),A
    OUT     (PBC),A
    LD      A,03H
    OUT     (PAC),A
    LD      A,00H
    OUT     (PBD),A
    OUT     (REGIRM),A  ; SPEICHER FARBE1
    LD      HL,8000H    ; LINKER TEIL
    LD      DE,8001H
    LD      BC,0080H
    LD      (HL),00H
    LDIR
    LD      BC,007FH
    LD      (HL),0FFH
    LDIR
    LD      HL,8000H
    LD      DE,8100H
    LD      BC,1100H
    LDIR
    LD      HL,8280H    ; SENKR. LINIEN
    LD      DE,8281H
    LD      BC,007FH
    LD      (HL),7FH
    LDIR
    LD      HL,8600H
    LD      DE,8601H
    LD      BC,007FH
    LD      (HL),80H
    LDIR
    LD      HL,8200H
    LD      DE,8A00H
    LD      BC,0500H
    LDIR
    LD      IY,7F90H    ; SCHRAEGE LIN.1
    LD      DE,0100H
    LD      C,10H
    LD      H,80H
MSC:
    LD      B,08H
    ADD     IY,DE
MSB:
    LD      L,(IY+0)
    LD      A,H
    CPL
    AND     L
    LD      (IY+0),A
    LD      L,(IY+20H)
    LD      A,H
    OR      L
    LD      (IY+20H),A
    LD      L,(IY+40H)
    LD      A,H
    CPL
    AND     L
    LD      (IY+40H),A
    LD      L,(IY+60H)
    LD      A,H
    OR      L
    LD      (IY+60H),A
    RRC     H
    DEC     IY
    DJNZ    MSB
    DEC     C
    JR      NZ, MSC
    LD      IY,7F10H    ; SCHRAEGE LIN.2
    LD      DE,0100H
    LD      C,10H
    LD      H,80H
MTC:
    LD      B,08H
    ADD     IY,DE
MTB:
    LD      L,(IY+0)
    LD      A,H
    OR      L
    LD      (IY+0),A
    LD      L,(IY+20H)
    LD      A,H
    CPL
    AND     L
    LD      (IY+20H),A
    LD      L,(IY+40H)
    LD      A,H
    OR      L
    LD      (IY+40H),A
    LD      L,(IY+60H)
    LD      A,H
    CPL
    AND     L
    LD      (IY+60H),A
    RRC     H
    INC     IY
    DJNZ    MTB
    DEC     C
    JR      NZ, MTC
    LD      HL,9000H    ; AUFLOESUNGSRAS-
    LD      DE,9001H    ; TER
    LD      BC,0040H
    LD      (HL),55H
    LDIR
    LD      BC,0040H
    LD      (HL),33H
    LDIR
    LD      BC,0040H
    LD      (HL),0FH
    LDIR
    LD      BC,0040H
    LD      (HL),00H
    LDIR
    LD      HL,9000H
    LD      DE,9100H
    LD      BC,00C0H
    LDIR
    LD      HL,9000H
    LD      DE,9200H
    LD      BC,0200H
    LDIR
    LD      HL,9400H
    LD      DE,9401H
    LD      BC,03FFH
    LD      (HL),0FFH
    LDIR
    LD      HL,9400H    ; ZEILEN LOESCHEN
MTA:
    LD      A,H
    CP      98H
    JR      Z, MTE
    LD      A,L
    AND     0C1H
    CP      00H
    JR      Z, LOET
    LD      A,L
    AND     0C2H
    CP      40H
    JR      Z, LOET
    LD      A,L
    AND     0C4H
    CP      80H
    JR      Z, LOET
    LD      A,L
    AND     0C8H
    CP      0C0H
    JR      NZ, MTZ
LOET:
    LD      (HL),00H
MTZ:
    INC     HL
    JR      MTA

MTE:
    LD      HL,8000H    ; RECHTER TEIL
    LD      DE,9800H
    LD      BC,1000H
    LDIR
    LD      A,3FH
    OUT     (PAD),A
    LD      A,02H
    OUT     (REGIRM),A  ; SPEICHER FARBE2
    LD      HL,8000H
    LD      DE,8001H
    LD      BC,1000H
    LD      (HL),00H
    LDIR
    LD      BC,0400H
    LD      (HL),0FFH
    LDIR
    LD      BC,0100H
    LD      (HL),00H
    LDIR
    LD      BC,12FFH
    LD      (HL),0FFH
    LDIR
    LD      HL,9000H    ; ZEILEN LOESCHEN
MUA:
    LD      A,H
    CP      94H
    JR      Z, MUE
    LD      A,L
    AND     0C1H
    CP      00H
    JR      Z, LOEU
    LD      A,L
    AND     0C2H
    CP      40H
    JR      Z, LOEU
    LD      A,L
    AND     0C4H
    CP      80H
    JR      Z, LOEU
    LD      A,L
    AND     0C8H
    CP      0C0H
    JR      NZ,MUZ
LOEU:
    LD      (HL),00H
MUZ:
    INC     HL
    JR      MUA

MUE:
    LD      HL,9400H
    LD      DE,9401H
    LD      BC,0040H
    LD      (HL),55H
    LDIR
    LD      BC,0040H
    LD      (HL),33H
    LDIR
    LD      BC,003FH
    LD      (HL),0FH
    LDIR
    LD      HL,9400H
    LD      DE,9500H
    LD      BC,00C0H
    LDIR
    LD      HL,9400H
    LD      DE,9600H
    LD      BC,0200H
    LDIR
    LD      HL,8A00H    ; SENKR. LINIEN
    LD      DE,8A01H
    LD      BC,00FFH
    LD      (HL),80H
    LDIR
    LD      HL,8A00H
    LD      DE,8E00H
    LD      BC,0100H
    LDIR
    LD      HL,9A00H
    LD      DE,9A01H
    LD      BC,00FFH
    LD      (HL),7FH
    LDIR
    LD      HL,9A00H
    LD      DE,9E00H
    LD      BC,0100H
    LDIR
    LD      IY,7F90H    ; SCHRAEGE LINIE1
    LD      DE,0100H
    LD      C,10H
    LD      H,80H
MUC:
    LD      B,08H
    ADD     IY,DE
MUB:
    LD      L,(IY+40H)
    LD      A,H
    OR      L
    LD      (IY+40H),A
    LD      L,(IY+60H)
    LD      A,H
    OR      L
    LD      (IY+60H),A
    RRC     H
    DEC     IY
    DJNZ    MUB
    DEC     C
    JR      NZ, MUC
    LD      IY,7F10H    ; SCHRAEGE LINIE2
    LD      DE,0100H
    LD      C,10H
    LD      H,80H
MVC:
    LD      B,08H
    ADD     IY,DE
MVB:
    LD      L,(IY+0)
    LD      A,H
    OR      L
    LD      (IY+0),A
    LD      L,(IY+20H)
    LD      A,H
    OR      L
    LD      (IY+20H),A
    RRC     H
    INC     IY
    DJNZ    MVB
    DEC     C
    JR      NZ, MVC
    LD      IY,9790H    ; SCHRAEGE LINIE3
    LD      DE,0100H
    LD      C,10H
    LD      H,80H
MWC:
    LD      B,08H
    ADD     IY,DE
MWB:
    LD      L,(IY+0)
    LD      A,H
    CPL
    AND     L
    LD      (IY+0),A
    LD      L,(IY+20H)
    LD      A,H
    CPL
    AND     L
    LD      (IY+20H),A
    RRC     H
    DEC     IY
    DJNZ    MWB
    DEC     C
    JR      NZ, MWC
    LD      IY,9710H    ; SCHRAEGE LINIE4
    LD      DE,0100H
    LD      C,10H
    LD      H,80H
MXC:
    LD      B,08H
    ADD     IY,DE
MXB:
    LD      L,(IY+40H)
    LD      A,H
    CPL
    AND     L
    LD      (IY+40H),A
    LD      L,(IY+60H)
    LD      A,H
    CPL
    AND     L
    LD      (IY+60H),A
    RRC     H
    INC     IY
    DJNZ    MXB
    DEC     C
    JR      NZ, MXC



    ; Programmende
    ; warten auf Tastendruck
PV1:        EQU 0F003H
UP_KBDS:    EQU 0CH
UP_BYE:     EQU 0DH
UP_BRKT:    EQU 2AH

btest:
    CALL    PV1
    DEFB    UP_KBDS
    JR      NC,btest

    CALL    PV1
    DEFB    UP_BYE

END:
