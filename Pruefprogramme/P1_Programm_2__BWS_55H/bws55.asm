
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

PV1:        EQU 0F003H
UP_CRT:     EQU 00H
UP_KBDS:    EQU 0CH
UP_BYE:     EQU 0DH
UP_BRKT:    EQU 2AH
UP_ZKOUT:   EQU 45H

    ; KCC-Header
    ORG 0180H
    DEFB    'BWS55.KCC'     ; Dateiname
    DEFS    7, 0            ; frei
    DEFB    3               ; Argumente (3=Autostart)
    DEFW    BEGIN,END,START
    DEFS    105, 0

BEGIN:

    ; Menüeintrag
    DEFW    7F7FH
    DEFB    'BWS55'
    DEFB    1

START:

    ; LDIR    BWS-TEST FUER KC85/4
    ; ============================
IRM5:
    CALL    CLS
    LD      A,55H
IRMLOP:
    LD      HL,8000H
    LD      DE,8001H
    ;LD      BC,3FFFH
    LD      BC,27FFH
    LD      (HL),A
    LDIR

    CALL    PV1
    DEFB    UP_KBDS

    JR      NC,IRMLOP
    JP      PROGENDE



    ; UNTERPROGRAMME
    ; --------------
CLS:
    LD      A,0CH
    CALL    PV1
    DEFB    UP_CRT
    LD      IY,8108H    ; Next Druckpos.
    RET

PROGENDE:
    ; Programmende


    CALL    PV1
    DEFB    UP_BYE

END:
