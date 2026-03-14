; Quelle: P222.BIN
; disassembliert, ergänzt mit Kommentaren aus P1.ASM und P2.ASM (PRUEFMOD.PMA)
; Boert, April 2019 & März 2026



;   Reparaturmodul PK2 für KC 85/4
;   PI/AUMY   2.11.88

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

    ORG 0E000H

; Sprungverteiler für TAB1 (Schalter P2)
PR20:
    JP  TESTB
    NOP

PR21:
    JP  PXTST
    NOP

PR22:
    JP  FARBT
    NOP

PR23:
    JP  RATST
    NOP

PR24:
    JP  SIGT
    NOP

PR25:
    JP  TONT
    NOP

PR26:
    JP  TESTB
    NOP

PR27:
    JP  TESTB
    NOP


; Sprungverteiler für TAB2 (Schalter P1)
PR10:
    JP  REGTE
    NOP

PR11:
    JP  PIOTE
    NOP

PR12:
    JP  IRM5
    NOP

PR13:
    JP  IRMA
    NOP

PR14:
    JP  RAM5
    NOP

PR15:
    JP  RAMA
    NOP

PR16:
    JP  CSCTC
    NOP

PR17:
    JP  RAMVE


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

MW:
    JR      MW


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

MXX:
    JR      MXX




    ; RAMTEST FUER KC 85/4
    ; ====================

RATST:
    LD      IX,RACLS
    JP      CLS

RACLS:
    LD      HL,RAMT
    CALL    TEXT
    LD      IY,8920H
    LD      HL,SCHU
    CALL    TEXT
    LD      B,20H
    LD      DE,100H
    LD      IY,812BH
LIN:
    LD      (IY+0),0FFH
    LD      (IY+1),0FFH
    ADD     IY,DE
    DJNZ    LIN
    DI

    LD      IX,RATA     ; TABELLE DER ZU
    LD      B,6         ; TEST SPEICHERBL
BLOCK0:
    EXX
    LD      B,(IX+7)
    LD      C,(IX+6)
    PUSH    BC
    POP     IY
    LD      H,(IX+9)
    LD      L,(IX+8)
    PUSH    IX
    CALL    TEXT
    POP     IX
    LD      H,(IX+1)
    LD      L,(IX+0)
    LD      A,(IX+2)
    OUT     (REGIRM),A
    LD      A,(IX+3)
    OUT     (REGMEM),A
    LD      A,(IX+4)
    OUT     (PAD),A
    LD      A,(IX+5)
    OUT     (PBD),A
    BIT     0,(IX+10)   ; SCHREIBSCHUTZ?
    JR      Z,KSCH1
    LD      A,(HL)
    LD      B,A
    CPL
    LD      (HL),A
    LD      A,(HL)
    CP      B
    EXX
    JR      Z,SCHTZ
    LD      HL,FEHLER
    JR      KSCH
SCHTZ:
    LD      HL,OK
KSCH:
    LD      A,(IX+7)
    LD      E,(IX+6)
    ADD     A,08H
    LD      D,A
    LD      A,2FH
    OUT     (PAD),A
    LD      A,08H
    OUT     (REGIRM),A
    PUSH    DE
    POP     IY
    PUSH    IX
    CALL    TEXT
    POP     IX
    LD      A,(IX+4)
    OUT     (PAD),A
    LD      A,(IX+2)
    OUT     (REGIRM),A
    EXX
KSCH1:
    LD      B,(IX+0CH)  ; SCHUTZ AUS
    LD      C,(IX+0BH)
    OUT     (C),B
    EX      DE,HL       ; PRUEFBER. LADEN
    LD      HL,RATST
    EXX
    LD      C,81H
UMLA:
    EXX
    LD      HL,RATST
    LD      BC,007FH
    LDIR
    EXX
    DEC     C
    JR      NZ,UMLA
    EXX
    XOR     A
    LD      (DE),A
    LD      H,(IX+01H)  ; VERGLEICH
    LD      L,(IX+0)
    LD      C,81H
VERC:
    LD      B,7FH
    LD      IY,RATST
VERB:
    LD      A,(IY+0)
    CP      (HL)
    JR      NZ,VERFE
    INC     HL
    INC     IY
    DJNZ    VERB
    DEC     C
    JR      NZ,VERC
    XOR     A
    CP      (HL)
    JR      NZ,VERFE
    LD      H,(IX+01H)  ; SPEICHER NEGIER
    LD      L,(IX+0)
    LD      DE,4000H
WE:
    LD      A,(HL)
    CPL
    LD      (HL),A
    INC     HL
    DEC     DE
    XOR     A
    CP      D
    JR      NZ,WE
    CP      E
    JR      NZ,WE
    LD      H,(IX+01H)  ; VERGLEICH
    LD      L,(IX+00H)
    LD      C,81H
VERRC:
    LD      B,7FH
    LD      IY,RATST
VERRB:
    LD      A,(IY+0)
    CPL
    CP      (HL)
    JR      NZ,VERFE
    INC     HL
    INC     IY
    DJNZ    VERRB
    DEC     C
    JR      NZ,VERRC
    LD      A,0FFH
    CP      (HL)
    JR      NZ,VERFE
    LD      HL,OK
    JR      AUGA
VERFE:
    LD      HL,FEHLER
AUGA:
    LD      A,(IX+07H)
    LD      E,(IX+06H)
    ADD     A,10H
    LD      D,A
    LD      A,2FH
    OUT     (PAD),A
    LD      A,08H
    OUT     (REGIRM),A
    PUSH    DE
    POP     IY
    PUSH    IX
    CALL    TEXT
    POP     IX
    LD      A,(IX+04H)
    OUT     (PAD),A
    LD      A,(IX+02H)
    OUT     (REGIRM),A
    LD      B,(IX+0CH)
    LD      C,(IX+0BH)
    OUT     (C),B
    JP      OHNRE

OHNRE:
    LD      A,2FH
    OUT     (PAD),A
    LD      A,08H
    OUT     (REGIRM),A
    LD      DE,0010H
    ADD     IX,DE       ; NAECHSTER BLOCK
    EXX
    DJNZ    BLOCK
ENDE:
    JR      ENDE
BLOCK:
    JP      BLOCK0


    ; AUSGABE EINES BYTES (A)
TEXBY:
    PUSH    HL
    PUSH    DE
    PUSH    BC
    PUSH    AF
    SRL     A
    SRL     A
    SRL     A
    SRL     A
    ADD     A,30H
    CP      3AH
    JR      C,TEXTB2
    ADD     A,07H
TEXTB2:
    CALL    TEXAS
    POP     AF
    AND     0FH
    ADD     A,30H
    CP      3AH
    JR      C,TEXB3
    ADD     A,07H
TEXB3:
    CALL    TEXAS
    POP     BC
    POP     DE
    POP     HL
    RET

    ; AUSGABE EINES ASCII-ZEICHENS (A)+INC HL
TEXAS:
    POP     IX
    LD      DE,SPACE
    JP      TEXT2

    ;
    ; UP ZUR TEXTAUSGABE
    ; ------------------
ZG: EQU 0FE00H      ; ZEICHENGENERAT.
    ; IY=ANFANGSPOSITION
    ; HL=STRINGANFANG
    ; -------------------------------
TEXT:
    PUSH    HL
    PUSH    DE
    PUSH    BC
    PUSH    AF
    EX      DE,HL
    LD      IX,TEXEND
TEXT1:
    LD      A,(DE)
    CP      00H
    JR      NZ,TEXT2
    JP      (IX)
TEXT2:
    LD      HL,ZG
    SUB     20H
    LD      B,00H
    LD      C,A
    SLA     C
    SLA     C
    RL      B
    SLA     C
    RL      B
    ADD     HL,BC
    LD      B,08H
TEXT3:
    LD      A,(HL)
    LD      (IY+0),A
    INC     HL
    INC     IY
    DJNZ    TEXT3
    LD      BC,00F8H
    ADD     IY,BC
    INC     DE
    JR      TEXT1
TEXEND:
    POP     AF
    POP     BC
    POP     DE
    POP     HL
    RET

    ;
    ; STRINGSAMMLUNG
    ; --------------
RAMT:
    DEFB ">>> RAMTEST FUER KC 85/4 <<<", 0

SCHU:
    DEFB "SCHUTZ  WR/RD   ", 0

OK:
    DEFB "OK", 0

FEHLER:
    DEFB "FEHLER", 0

RAM0:
    DEFB "RAM 0", 0

RAM4:
    DEFB "RAM 4", 0

PIX2:
    DEFB "PIX 2", 0

FARB2:
    DEFB "FARB 2", 0

RAF3:
    DEFB "RAF 3", 0

RAF4:
    DEFB "RAF 4", 0

TON:
    DEFB "TONTEST", 0

KBD:
    DEFB "KBD", 0

TAPE:
    DEFB "TAPE", 0

RCW:
    DEFB "FEHLER RAS/CAS/WR", 0

KFA:
    DEFB "ADRESSEN  ", 0

KDF:
    DEFB "DATEN     ", 0

ABFEH:
    DEFB "FEHLER BEI AB", 0

DBFEH:
    DEFB "FEHLER BEI DB", 0

PIN:
    DEFB "  PIN ", 0

RT55:
    DEFB "RAMTEST MIT 55H", 0

RTAA:
    DEFB "RAMTEST MIT AAH", 0

TCTC:
    DEFB "CTC-TEST  K0-K2", 0

TPIO:
    DEFB "PIO-TEST  0-255", 0

TREG:
    DEFB "REG-TEST  0-255", 0

TBLOK:
    DEFB "BLOCKTEST OK", 0

TBLER:
    DEFB "BLOCKTEST FEHLER ", 0

TSIC:
    DEFB "SIGNATUR CAOS-ROM C: ", 0

TSIB:
    DEFB "SIGNATUR BASIC-ROM : ", 0

SPACE:
    DEFB " ", 0

    DEFB 0


    ;
    ; SPEICHERBLOCKTABELLE
    ; --------------------
RATA:
    DEFB    00H
    DEFB    00H
    DEFB    08H
    DEFB    00H
    DEFB    07H
    DEFB    00H
    DEFB    30H
    DEFB    81H
    DEFW    RAM0
    DEFB    01H
    DEFB    PAD
    DEFB    0FH
    DEFB    00H
    DEFB    00H
    DEFB    00H
    ;
    DEFB    00H
    DEFB    40H
    DEFB    08H
    DEFB    01H
    DEFB    05H
    DEFB    00H
    DEFB    40H
    DEFB    81H
    DEFW    RAM4
    DEFB    01H
    DEFB    86H
    DEFB    03H
    DEFB    00H
    DEFB    00H
    DEFB    00H
    ;
    DEFB    00H
    DEFB    80H
    DEFB    0CH
    DEFB    00H
    DEFB    05H
    DEFB    00H
    DEFB    50H
    DEFB    81H
    DEFW    PIX2
    DEFB    00H
    DEFB    REGIRM
    DEFB    0CH
    DEFB    00H
    DEFB    00H
    DEFB    00H
    ;
    DEFB    00H
    DEFB    80H
    DEFB    0EH
    DEFB    00H
    DEFB    05H
    DEFB    00H
    DEFB    60H
    DEFB    81H
    DEFW    FARB2
    DEFB    00H
    DEFB    REGIRM
    DEFB    0EH
    DEFB    00H
    DEFB    00H
    DEFB    00H
    ;
    DEFB    00H
    DEFB    80H
    DEFB    28H
    DEFB    00H
    DEFB    01H
    DEFB    20H
    DEFB    70H
    DEFB    81H
    DEFW    RAF3
    DEFB    01H
    DEFB    PBD
    DEFB    60H
    DEFB    00H
    DEFB    00H
    DEFB    00H
    ;
    DEFB    00H
    DEFB    80H
    DEFB    38H
    DEFB    00H
    DEFB    01H
    DEFB    20H
    DEFB    80H
    DEFB    81H
    DEFW    RAF4
    DEFB    01H
    DEFB    PBD
    DEFB    60H
    DEFB    00H
    DEFB    00H
    DEFB    00H


    ; ----------------
    ;
    ;  TONTEST KC85/4
    ;
    ; ----------------
TONT:
    LD      IX,TONCLS
    JP      CLS

TONCLS:
    LD      HL, INTER
    LD      (98F4H),HL
    LD      HL,TON      ; TEXTAUSGABE
    CALL    TEXT
    LD      IX,98F8H
    LD      (IX+0),00H
    LD      A,0F0H
    OUT     (CTCK0),A
TONI2:
    LD      HL,TABELLE
    LD      B,20        ; 16+4 TOENE
TONI1:
    PUSH    BC
    LD      C,(HL)
    INC     HL
    LD      B,(HL)
    INC     HL
    LD      E,(HL)
    INC     HL
    LD      D,(HL)
    INC     HL
    LD      A,(HL)
    INC     HL
    INC     HL
    PUSH    HL
    DEC     HL
    LD      H,(HL)
    LD      L,A
    CALL    TON0
    POP     HL
    POP     BC
    DJNZ    TONI1
    JR      TONI2

TON0:
    BIT     1,(IX+0)
    JR      NZ,TON0

TONB:
    LD      A,C
    XOR     1FH
    LD      C,A
    LD      A,B
    AND     A           ; TONLAENGE=0?
    JR      Z,TON1
    SET     1,(IX+0)
    LD      A,0C7H      ; ZAEHLER M. INT.
    OUT     (CTCK2),A
    LD      A,B
    OUT     (CTCK2),A

TON1:
    LD      A,C
    SCF
    RLA
    OUT     (PBD),A     ; LAUTSTAERKE
    LD      C,CTCK1     ; 2. KANAL
    CALL    TON2
    DEC     C           ; 1. KANAL
    EX      DE,HL

TON2:
    LD      A,L         ; TONHOEHE
    AND     A           ; =0?
    LD      L,03H       ; BEI L=0
    JR      Z,TON4
    LD      L,A
    LD      A,07H
    BIT     0,H         ; VORTEILER?
    JR      Z,TON3      ; VORTEILER 16
    OR      20H         ; VORTEILER 256

TON3:
    OUT     (C),A       ; STEUERWORT
TON4:
    OUT     (C),L       ; TONHOEHE (BEI
                        ; L=0 STEUERWORT)
    RET

INTER:
    PUSH    AF
    LD      A,03H
    OUT     (CTCK0),A
    OUT     (CTCK1),A
    RES     1,(IX+0)
    POP     AF
    EI
    RETI

TABELLE:
    DEFW    0201H       ; TON1
    DEFW    010H
    DEFW    120H
    ;
    DEFW    0302H       ; TON2
    DEFW    018H
    DEFW    128H
    ;
    DEFW    0403H       ; TON3
    DEFW    020H
    DEFW    130H
    ;
    DEFW    0504H       ; TON4
    DEFW    028H
    DEFW    138H
    ;
    DEFW    0605H       ; TON5
    DEFW    030H
    DEFW    140H
    ;
    DEFW    0706H       ; TON6
    DEFW    038H
    DEFW    148H
    ;
    DEFW    0807H       ; TON7
    DEFW    040H
    DEFW    150H
    ;
    DEFW    0908H       ; TON8
    DEFW    048H
    DEFW    158H
    ;
    DEFW    0A09H       ; TON9
    DEFW    050H
    DEFW    160H
    ;
    DEFW    0B0AH       ; TON10
    DEFW    058H
    DEFW    168H
    ;
    DEFW    0C0BH       ; TON11
    DEFW    060H
    DEFW    170H
    ;
    DEFW    0D0CH       ; TON12
    DEFW    068H
    DEFW    178H
    ;
    DEFW    0E0DH       ; TON13
    DEFW    070H
    DEFW    180H
    ;
    DEFW    0F0EH       ; TON14
    DEFW    078H
    DEFW    188H
    ;
    DEFW    100FH       ; TON15
    DEFW    080H
    DEFW    190H
    ;
    DEFW    1100H       ; TON16
    DEFW    088H
    DEFW    198H

    DEFW    1101H
    DEFW    VTZK1
    DEFW    VTZK2
    DEFW    1102H
    DEFW    VTZK1
    DEFW    VTZK2
    DEFW    1104H
    DEFW    VTZK1
    DEFW    VTZK2
    DEFW    1108H
    DEFW    VTZK1
    DEFW    VTZK2
    ;---------------------------------------

    ; UNTERPROGRAMME
    ; --------------

CLS:
    DI
    IM      2
    LD      SP,0A000H
    LD      A,98H
    LD      I,A
    LD      A,0FH
    OUT     (PAC),A
    OUT     (PBC),A
    LD      A,0EH
    OUT     (PAD),A
    LD      A,60H
    OUT     (PBD),A
    LD      A,03H
    OUT     (REGMEM),A
    LD      A,0AH       ; Farbspeicher
    OUT     (REGIRM),A  ; füllen
    EI
    LD      HL,8000H
    LD      DE,8001H
    LD      BC,27FFH
    LD      (HL),39H    ; Weiß-/Blau
    LDIR
    LD      A,28H       ; Pixelspeicher
    OUT     (REGIRM),A  ; löschen
    LD      HL,8000H
    LD      DE,8001H
    LD      BC,27FFH
    LD      (HL),00H
    LDIR
    LD      IY,8108H    ; Next Druckpos.
    JP      (IX)        ; RET

; ***************************************
; ******** UP Signatur *****************
;
;   PE: HL     = Startadresse
;       DE     = Laenge Speicherbereich
;   PA: DE     = IST-Signatur
;
;   VR: AF/BC/DE/HL
;
; ***************************************
;
SIGN:
    PUSH    DE
    POP     BC
PRUSU:
    LD      DE,-1
PRUS1:
    LD      A,(HL)
    XOR     D
    LD      D,A
    RRCA
    RRCA
    RRCA
    RRCA
    AND     0FH
    XOR     D
    LD      D,A
    RRCA
    RRCA
    RRCA
    PUSH    AF
    AND     1FH
    XOR     E
    LD      E,A
    POP     AF
    PUSH    AF
    RRCA
    AND     0F0H
    XOR     E
    LD      E,A
    POP     AF
    AND     0E0H
    XOR     D
    LD      D,E
    LD      E,A
    INC     HL
    DEC     BC
    LD      A,B
    OR      C
    JR      NZ,PRUS1
    RET


    ; LDIR    BWS-TEST FUER KC85/4
    ; ============================
IRM5:
    LD      IX,IRM5CLS
    JP      CLS
IRM5CLS:
    LD      A,55H
    JR      IRMLOP
IRMA:
    LD      IX,IRMACLS
    JP      CLS
IRMACLS:
    LD      A,0AAH
IRMLOP:
    LD      HL,8000H
    LD      DE,8001H
    LD      BC,3FFFH
    LD      (HL),A
    LDIR
    JR      IRMLOP


    ;LDIR    RAMTEST FUER KC 85/4
    ;============================
RAM5:
    LD      IX,RAM5CLS
    JP      CLS
RAM5CLS:
    LD      SP,5555H
    LD      IX,RAM
    LD      DE,RT55
    JP      TEXT1
RAMA:
    LD      IX,RAMACLS
    JP      CLS
RAMACLS:
    LD      SP,0AAAAH
    LD      IX,RAM
    LD      DE,RTAA
    JP      TEXT1
RAM:
    LD      A,0AH       ; BWS AUS
    OUT     (PAD),A
    LD      HL,0
    ADD     HL,SP
    LD      A,L
RAMLOP:
    LD      HL,0
    LD      DE,1
    LD      BC,0BFFFH
    LD      (HL),A
    LDIR
    JR      RAMLOP


; Verkopplungstest und Bittest RAM
; --------------------------------

;---------------------------------------
ADTAB:  EQU 0A001H
FEHL:   EQU 0A000H+20

RAMVE:
    LD      IX,VECLS
    JP      CLS
VECLS:
    LD      IX,09000H
    LD      (IX+0),0
    LD      HL,0        ; RAM0
    LD      (HL),0      ; löschen
    LD      DE,1
    LD      BC,3FFFH
    LDIR
    LD      HL,0
    LD      DE,3FFFH    ; ANZAHL
    XOR     A
    LD      (FEHL),A    ; FEHLER-MZ
    LD      (HL),55H    ; ERSTE ZELLE
    LD      A,(HL)      ; WIEDER LESEN
    XOR     55H         ; NOCh GLEICH
    JR      Z,AD1
    LD      B,8
AD4:
    RL      A           ; NUR 1 BIT FALS?
    JP      Z,ERR1      ; (1BIT IN CY)
    DJNZ    AD4
    PUSH    HL
    LD      IY,8108H
    LD      HL,RCW
    CALL    TEXT        ; FEHLER RCW
    POP     HL

WAIT:
    LD      A,55H       ; Warteschleife
AD41:
    LD      (HL),A      ; WR
    LD      C,(HL)      ; RD
    JR      AD41

AD1:
    PUSH    HL
    LD      HL,KFA
    CALL    TEXT
    POP     HL
AD11:
    LD      A,55H       ; ALTER WERT
    INC     HL          ; NAECHSTE ZELLE
    LD      C,(HL)      ; LESEN
    CP      C           ; GLEICH ?
    CALL    Z,ERR3      ; JA->FEHLER!
    DEC     DE
    LD      A,D         ; GESAMTER
    OR      E           ; BEREICH?
    JP      NZ,AD11
    LD      A,(FEHL)
    CP      0           ; FEHLER AUFGE-
    JP      NZ,DRAD     ; TRETEN ?
    LD      HL,OK
    CALL    TEXT
    JR      BBBT        ; BLOCKTEST

ERR3:
    PUSH    HL
    LD      A,55H
    LD      (FEHL),A    ; FEHLER !
    LD      B,16
ER4:
    SLA     L           ; SUCHEN UND
    RL      H           ; EINTRAGEN DER
    JP      NC,ER5      ; FEHLERHAFTEN
    PUSH    HL          ; ADRESSLEITGN.
    LD      A,B
    DEC     A
    LD      HL,ADTAB
    ADD     A,L         ; PLATZ IN ADTAB
    JR      NC,ER6      ; BESTIMMEN
    INC     H
ER6:
    LD      L,A
    LD      (HL),1      ; 1=FEHLER
    POP     HL
ER5:
    DJNZ    ER4         ; ALLE 16 BIT
    POP     HL
    RET

DRAD:
    LD      HL,ADTAB+15
    LD      IY,8110H
    LD      B,16        ; AUSDRUCKEN DER
DR0:
    XOR     A           ; FEHLER-AB DURCH
    CP      (HL)        ; AUSLESEN ADTAB
    CALL    NZ,DR1
    DEC     HL
    DJNZ    DR0         ; ALLE 16 BIT
    HALT

DR1:
    PUSH    IY          ; POS
    PUSH    HL
    LD      HL,ABFEH
    CALL    TEXT
    LD      A,B         ; AUS OFFSET WIRD
    DEC     A           ; BIT BESTIMMT
    ADD     0
    DAA
    CALL    TEXBY
    LD      HL,PIN
    CALL    TEXT
    LD      HL,PITAB    ; PINTABELLE
    LD      A,B         ; ZUR UMRECHNUNG
    AND     7           ; A0-A7 = A8-A15
    ADD     L
    JR      NC,DR2
    INC     H
DR2:
    LD      L,A
    LD      A,(HL)      ; AUSLESEN PIN
    CALL    TEXBY       ; DRUCK
    POP     HL
    POP     IY
    LD      DE,8
    ADD     IY,DE
    RET
PITAB:
    DEFW    0509H       ; PINTABELLE
    DEFW    0607H
    DEFW    1112H
    DEFW    1310H
; ---------------------------------------


; BLOCKTEST MIT 1 BYTE
BBBT:
    LD      A,0FH
    OUT     (PAC),A
    OUT     (PBC),A
    LD      A,0AH
    OUT     (PAD),A     ; BWS OFF
    LD      A,60H
    OUT     (PBD),A
    LD      A,28H
    OUT     (REGIRM),A  ; RAF3
    LD      A,3
    OUT     (REGMEM),A
    LD      HL,0
    LD      (HL),0
    LD      HL,4000H
    LD      (HL),0
    LD      HL,8000H
    LD      (HL),0
    LD      HL,0C000H
    LD      (HL),0CCH
    LD      A,(0)
    CP      0
    JP      NZ,BLER
    LD      A,(4000H)
    CP      0
    JP      NZ,BLER
    LD      A,(8000H)
    CP      0
    JP      NZ,BLER

    LD      HL,8000H
    LD      (HL),88H    ; RAF3
    LD      A,(0)
    CP      0
    JR      NZ,BLER
    LD      A,(4000H)
    CP      0
    JR      NZ,BLER
    LD      A,(8000H)
    CP      88H
    JR      NZ,BLER

    LD      A,38H
    OUT     (REGIRM),A  ; RAF4
    LD      (HL),99H
    LD      A,(8000H)
    CP      99H
    JR      NZ,BLER
    LD      A,28H
    OUT     (REGIRM),A  ; RAF3

    LD      HL,4000H
    LD      (HL),44H
    LD      A,(0)
    CP      0
    JR      NZ,BLER
    LD      A,(4000H)
    CP      44H
    JR      NZ,BLER
    LD      A,(8000H)
    CP      88H
    JR      NZ,BLER

    LD      HL,0
    LD      (HL),11H
    LD      A,(0)
    CP      11H
    JR      NZ,BLER
    LD      A,(4000H)
    CP      44H
    JR      NZ,BLER
    LD      A,(8000H)
    CP      88H
    JR      NZ,BLER
    LD      HL,TBLOK
    LD      IY,8118H
    LD      A,0EH
    OUT     (PAD),A     ; BWS ON
    CALL    TEXT
    JR      BLT1

BLER:
    LD      B,A
    LD      A,0EH
    OUT     (PAD),A     ; BWS ON
    PUSH    HL
    LD      HL,TBLER
    LD      IY,8118H
    CALL    TEXT
    POP     HL
    LD      A,H
    CALL    TEXBY
    LD      A,L
    CALL    TEXBY       ; BLOCKADRESSE

; DATENTEST MIT 16K-BLOECKEN
BLT1:
    LD      HL,KDF
    LD      IY,8128H
    CALL    TEXT
    LD      HL,0
    CALL    DAT         ; 0-4000
    LD      HL,4000H
    CALL    DAT         ; 4000-8000
    LD      SP,100H
    LD      A,0AH
    OUT     (PAD),A     ; BWS OFF
    LD      HL,8000H
    CALL    DAT         ; RAF3
    LD      A,38H
    OUT     (REGIRM),A
    LD      HL,8000H
    CALL    DAT         ; RAF4

    LD      A,0EH
    OUT     (PAD),A     ; BWS ON
DA1:
    LD      HL,OK       ; ENDE
    CALL    TEXT
    HALT

; UP 16K-BLOCK DATENTEST

; PE: HL=ANFANGSADRESSE
DAT:
    PUSH    HL
    LD      (HL),55H    ; TEST MIT 55,AA
    INC     HL
    LD      (HL),0AAH
    LD      D,H
    LD      E,L
    DEC     HL          ; QUELLE
    INC     DE          ; ZIEL
    LD      BC,3FFEH
    LDIR                ; FILL 55,AA
    LD      BC,019AH    ; RUND 6ms
DA8:
    DEC     BC
    LD      A,B
    OR      C
    JR      NZ,DA8      ; ZEITSCHLEIFE

    POP     HL
    PUSH    HL
    LD      BC,2000H
    LD      D,55H
    LD      E,0AAH
DA7:
    LD      A,(HL)
    XOR     D
    JR      NZ,ERR55
    INC     HL
    LD      A,(HL)
    XOR     E
    JR      NZ,ERRAA
    INC     HL
    DEC     BC
    LD      A,B         ; GESAMTER BER.
    OR      C
    JR      NZ,DA7
    POP     HL          ; ANFANGSADR.

    PUSH    HL
    LD      (HL),0AAH   ; TEST MIT AA,55
    INC     HL
    LD      (HL),55H
    LD      D,H
    LD      E,L
    DEC     HL          ; QUELLE
    INC     DE          ; ZIEL
    LD      BC,3FFEH
    LDIR                ; FILL AA,55
    LD      BC,410      ; RUND 6ms
DA18:
    DEC     BC
    LD      A,B
    OR      C
    JR      NZ,DA18     ; ZEITSCHLEIFE

    POP     HL
    LD      BC,2000H
    LD      D,0AAH
    LD      E,55H
DA17:
    LD      A,(HL)
    XOR     D
    JR      NZ,ERRAA
    INC     HL
    LD      A,(HL)
    XOR     E
    JR      NZ,ERR55
    INC     HL
    DEC     BC
    LD      A,B         ; GESAMTER BER.
    OR      C
    JR      NZ,DA17
    RET

ERR55:
    LD      C,55H       ; FEHLERBYTE
    JR      ERR1
ERRAA:
    LD      C,0AAH
ERR1:
    LD      IY,8130H
    LD      B,A
    LD      A,0EH
    OUT     (PAD),A     ; BWS ON
    LD      A,B
    LD      B,8         ; SUCHEN UND
ER2:
    RLA                 ; DRUCKEN DER
    CALL    C,DRDA      ; FEHLER-BITS
    DJNZ    ER2
    LD      A,C         ; FEHLERBYTE
    JP      AD41        ; ZELLE WR/RD

DRDA:
    PUSH    AF
    PUSH    HL
    PUSH    IY
    LD      HL,DBFEH
    CALL    TEXT
    LD      A,B         ; B AUS SUCHE
    DEC     A           ; WIRD ZU BIT
    CALL    TEXBY       ; DRUCK
    POP     IY
    LD      DE,0008H
    ADD     IY,DE
    POP     HL
    POP     AF
    RET

; ---------------------------------------

FARBT:
    LD      IX,FARBCLS
    JP      CLS
FARBCLS:
    LD      HL,8000H
    LD      DE,8001H
    LD      BC,27FFH
    LD      (HL),0FFH
    LDIR                ; /CLS

    LD      C,20
    LD      DE,0080H
    LD      HL,9480H
FARB0:
    LD      B,80H
FARB1:
    LD      (HL),00H
    INC     HL
    DJNZ    FARB1       ; SW (Hintergrun)
    ADD     HL,DE
    DEC     C
    JR      NZ,FARB0

    LD      A,0AH
    OUT     (REGIRM),A  ; FARBE
    LD      IY,FATAB
    LD      HL,8000H
    LD      DE,8001H
    LD      BC,0200H
    LD      (HL),00H
    LDIR                ; 2 REIHEN SE
FARB4:
    LD      A,(IY+0)
    LD      (HL),A
    INC     IY
    LD      BC,0300H
    LDIR
    CP      36H         ; LETZT?
    JR      NZ,FARB4
    LD      BC,0200H
    LD      (HL),3FH
    LDIR                ; 2 REIHEN WS
    HALT

FATAB:
    DEFW    4808H       ; VIOL,BL
    DEFW    5810H       ; PUP-RT,RT
    DEFW    1868H       ; PUR,BLGN
    DEFW    2251H       ; GN/RT,OR/BL
    DEFW    2C63H       ; TUR/GR,GRBL/PUR
    DEFW    3675H       ; GB/GB,GBGN/TUR


CSCTC:
    LD      IX,CSCLS
    JP      CLS
CSCLS:
    LD      HL,TCTC
    CALL    TEXT
    LD      HL,INTK0    ; INTTAB
    LD      (98F0H),HL
    LD      HL,INTK1
    LD      (98F2H),HL
    LD      HL,INTK2
    LD      (98F4H),HL
    LD      A,0F0H
    OUT     (CTCK0),A   ; INTVEK
CS0:
    LD      C,CTCK0
    LD      B,03H
CS1:
    LD      A,87H       ; ZEITGEBER
    OUT     (C),A
    LD      A,02H       ; TC
    OUT     (C),A
    DI                  ;  4T
    LD      A,02H
CS2:
    DEC     A
    JR      NZ,CS2
    EI                  ;  4T
    INC     C
    DJNZ    CS1
    JR      CS0

INTK0:
    PUSH    AF
    LD      A,03H
    OUT     (CTCK0),A
    POP     AF
    EI
    RETI

INTK1:
    PUSH    AF
    LD      A,03H
    OUT     (CTCK1),A
    POP     AF
    EI
    RETI

INTK2:
    PUSH    AF
    LD      A,03H
    OUT     (CTCK2),A
    POP     AF
    EI
    RETI

PIOTE:
    LD      IX,PIOCLS
    JP      CLS
PIOCLS:
    LD      DE,TPIO
    LD      IX,PIO0
    JP      TEXT1
PIO0:
    LD      B,00H
PIO1:
    LD      A,B
    OUT     (PAD),A     ; Ausg:0,FF...0
    OUT     (PBD),A
    DJNZ    PIO1
    JR      PIO1

REGTE:
    LD      IX,REGCLS
    JP      CLS
REGCLS:
    LD      DE,TREG
    LD      IX,REG0
    JP      TEXT1
REG0:
    LD      A,2CH
    OUT     (REGIRM),A
    LD      HL,08000H
    LD      (HL),0
    LD      DE,08001H
    LD      BC,27FFH
    LDIR
    LD      A,2EH
    OUT     (REGIRM),A
    LD      HL,08000H
    LD      (HL),39H
    LD      DE,08001H
    LD      BC,27FFH
    LDIR
    LD      B,0
REG1:
    LD      A,B         ; wie PIO
    OUT     (REGIRM),A
    OUT     (REGMEM),A
    DJNZ    REG1
    JR      REG1

SIGT:
    LD      IX,SIGCLS
    JP      CLS
SIGCLS:
    LD      HL,TSIC
    CALL    TEXT
Mxx:
    LD      A,80H
    OUT     (REGMEM),A  ; C-ROM ON
    LD      HL,0C000H
    LD      DE,0FFAH
    CALL    SIGN        ; C-ROM
    LD      A,D
    CALL    TEXBY       ; AUSGABE
    LD      A,E
    CALL    TEXBY
    LD      HL,SPACE
    CALL    TEXT
    LD      HL,(0CFFAH) ; Sollsign.
    SBC     HL,DE
    JR      NZ,SI2
    LD      HL,OK
    JR      SI3
SI2:
    LD      HL,FEHLER
SI3:
    CALL    TEXT

    LD      IY,8120H
    LD      HL,TSIB
    CALL    TEXT
    LD      A,60H
    OUT     (REGMEM),A  ; ROM AUS
    LD      A,0FH
    OUT     (PAC),A
    LD      A,8EH       ; BASIC ON
    OUT     (PAD),A
    LD      HL,0C000H
    LD      DE,2000H
    CALL    SIGN        ; BASIC
    LD      A,D
    CALL    TEXBY       ; AUSGABE
    LD      A,E
    CALL    TEXBY
    LD      HL,SPACE
    CALL    TEXT
    LD      A,80H
    OUT     (REGMEM),A  ; ROM C ON
    LD      HL,(0CFFCH) ; Sollsig.
    SBC     HL,DE
    JR      NZ,SI4
    LD      HL,OK
    JR      SI5
SI4:
    LD      HL,FEHLER
SI5:
    CALL    TEXT

    LD      HL,0D555H
    LD      A,0E0H
SI6:
    XOR     80H         ; ROM C ON/OFF
    OUT     (REGMEM),A
    LD      D,(HL)
    JR      SI6

    ; ENDE der Programme

    ;
    DEFS 4255, 0FFH

    ; Zeichensatz groß, ab Adress 0FE80H
    DEFB 000H,000H,000H,000H,000H,000H,000H,000H
    DEFB 030H,030H,030H,030H,030H,000H,030H,000H
    DEFB 077H,033H,066H,000H,000H,000H,000H,000H
    DEFB 036H,036H,0FEH,06CH,0FEH,0D8H,0D8H,000H
    DEFB 018H,03EH,06CH,03EH,01BH,01BH,07EH,018H
    DEFB 000H,0C6H,0CCH,018H,030H,066H,0C6H,000H
    DEFB 038H,06CH,038H,076H,0DCH,0CCH,076H,000H
    DEFB 01CH,00CH,018H,000H,000H,000H,000H,000H
    DEFB 018H,030H,060H,060H,060H,030H,018H,000H
    DEFB 060H,030H,018H,018H,018H,030H,060H,000H
    DEFB 000H,066H,03CH,0FFH,03CH,066H,000H,000H
    DEFB 000H,030H,030H,0FCH,030H,030H,000H,000H
    DEFB 000H,000H,000H,000H,000H,01CH,00CH,018H
    DEFB 000H,000H,000H,0FEH,000H,000H,000H,000H
    DEFB 000H,000H,000H,000H,000H,030H,030H,000H
    DEFB 006H,00CH,018H,030H,060H,0C0H,080H,000H
    DEFB 07CH,0C6H,0CEH,0DEH,0F6H,0E6H,07CH,000H
    DEFB 030H,070H,030H,030H,030H,030H,0FCH,000H
    DEFB 078H,0CCH,00CH,038H,060H,0CCH,0FCH,000H
    DEFB 0FCH,018H,030H,078H,00CH,0CCH,078H,000H
    DEFB 01CH,03CH,06CH,0CCH,0FEH,00CH,01EH,000H
    DEFB 0FCH,0C0H,0F8H,00CH,00CH,0CCH,078H,000H
    DEFB 038H,060H,0C0H,0F8H,0CCH,0CCH,078H,000H
    DEFB 0FCH,0CCH,00CH,018H,030H,030H,030H,000H
    DEFB 078H,0CCH,0CCH,078H,0CCH,0CCH,078H,000H
    DEFB 078H,0CCH,0CCH,07CH,00CH,018H,070H,000H
    DEFB 000H,000H,030H,030H,000H,030H,030H,000H
    DEFB 000H,000H,030H,030H,000H,030H,030H,060H
    DEFB 018H,030H,060H,0C0H,060H,030H,018H,000H
    DEFB 000H,000H,0FCH,000H,0FCH,000H,000H,000H
    DEFB 060H,030H,018H,00CH,018H,030H,060H,000H
    DEFB 078H,0CCH,00CH,018H,030H,000H,030H,000H
    DEFB 07CH,0C6H,0DEH,0DEH,0DEH,0C0H,078H,000H
    DEFB 030H,078H,0CCH,0CCH,0FCH,0CCH,0CCH,000H
    DEFB 0FCH,066H,066H,07CH,066H,066H,0FCH,000H
    DEFB 03CH,066H,0C0H,0C0H,0C0H,066H,03CH,000H
    DEFB 0F8H,06CH,066H,066H,066H,06CH,0F8H,000H
    DEFB 0FEH,062H,068H,078H,068H,062H,0FEH,000H
    DEFB 0FEH,062H,068H,078H,068H,060H,0F0H,000H
    DEFB 03CH,066H,0C0H,0C0H,0CEH,066H,03CH,000H
    DEFB 0CCH,0CCH,0CCH,0FCH,0CCH,0CCH,0CCH,000H
    DEFB 078H,030H,030H,030H,030H,030H,078H,000H
    DEFB 01EH,00CH,00CH,00CH,0CCH,0CCH,078H,000H
    DEFB 0E6H,066H,06CH,070H,06CH,066H,0E6H,000H
    DEFB 0F0H,060H,060H,060H,062H,066H,0FEH,000H
    DEFB 0C6H,0EEH,0FEH,0D6H,0C6H,0C6H,0C6H,000H
    DEFB 0C6H,0E6H,0F6H,0DEH,0CEH,0C6H,0C6H,000H
    DEFB 038H,06CH,0C6H,0C6H,0C6H,06CH,038H,000H
    DEFB 0FCH,066H,066H,07CH,060H,060H,0F0H,000H
    DEFB 078H,0CCH,0CCH,0CCH,0DCH,078H,01CH,000H
    DEFB 0FCH,066H,066H,07CH,06CH,066H,0E6H,000H
    DEFB 07CH,0C6H,0F0H,03CH,00EH,0C6H,07CH,000H
    DEFB 0FCH,0B4H,030H,030H,030H,030H,078H,000H
    DEFB 0CCH,0CCH,0CCH,0CCH,0CCH,0CCH,078H,000H
    DEFB 0CCH,0CCH,0CCH,078H,078H,030H,030H,000H
    DEFB 0C6H,0C6H,0C6H,0D6H,0FEH,0EEH,0C6H,000H
    DEFB 0C6H,0C6H,06CH,038H,06CH,0C6H,0C6H,000H
    DEFB 0CCH,0CCH,0CCH,078H,030H,030H,078H,000H
    DEFB 0FEH,0C6H,08CH,018H,032H,066H,0FEH,000H
    DEFB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH
    DEFB 018H,018H,018H,018H,018H,018H,018H,000H
    DEFB 000H,0FEH,006H,006H,000H,000H,000H,000H
    DEFB 010H,038H,06CH,0C6H,000H,000H,000H,000H
    DEFB 000H,000H,000H,000H,000H,000H,000H,0FFH
    ;
    END
