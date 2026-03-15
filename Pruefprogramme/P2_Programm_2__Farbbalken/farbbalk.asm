
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
    DEFB    'FARBBALK.KCC'  ; Dateiname
    DEFS    4, 0            ; frei
    DEFB    3               ; Argumente (3=Autostart)
    DEFW    BEGIN,END,START
    DEFS    105, 0

BEGIN:

    ; Menüeintrag
    DEFW    7F7FH
    DEFB    'FARBBALKEN'
    DEFB    1

START:

; ---------------------------------------

FARBT:
    LD      A,28H       ; Pixelspeicher
    OUT     (REGIRM),A
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
    LDIR                ; 2 REIHEN SW
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
    LD      A,28H       ; Pixelspeicher
    OUT     (REGIRM),A
    JP      PROGENDE

FATAB:
    DEFW    4808H       ; VIOL,BL
    DEFW    5810H       ; PUP-RT,RT
    DEFW    1868H       ; PUR,BLGN
    DEFW    2251H       ; GN/RT,OR/BL
    DEFW    2C63H       ; TUR/GR,GRBL/PUR
    DEFW    3675H       ; GB/GB,GBGN/TUR


PROGENDE:
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
