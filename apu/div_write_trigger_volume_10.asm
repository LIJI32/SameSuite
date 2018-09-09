RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 4

include "base.inc"

CorrectResults:

db $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F 
db $0F, $0E, $0E, $0E, $0E, $0E, $0E, $0E 
db $0E, $0D, $0D, $0D, $0D, $0D, $0D, $0D 
db $0D, $0C, $0C, $0C, $0C, $0C, $0C, $0C 



TriggerAPU:
    call WaitDIV10
    ld [hl], a
    ret

WaitDIV10:
    ld a, $10
.waitDIV 
    cp [hl]
    jr nz, .waitDIV
    ret

SubTest: MACRO
    ld hl, rDIV
    ld [hl], a
    call WaitDIV10

    ld c, rNR52 & $FF
    xor a
    ld [c], a
    cpl
    ld [c], a    
    ldh [rNR13], a
    ld a, $80
    ldh [rNR11], a
    ld a, $F1
    ldh [rNR12], a

    ld a, $83
    ldh [rNR14], a
REPT \1
    call TriggerAPU
ENDR
    ld hl, rPCM12
    xor a
    
; Ugly way to make sure we don't sample a zero
REPT 8
    or [hl]
    jr nz, .done\@
    nops $400
.done\@
ENDR

    call StoreResult
    ENDM

RunTest:
    ld de, $c000

    SubTest $00
    SubTest $01
    SubTest $02
    SubTest $03
    SubTest $04
    SubTest $05
    SubTest $06
    SubTest $07
    SubTest $08
    SubTest $09
    SubTest $0A
    SubTest $0B
    SubTest $0C
    SubTest $0D
    SubTest $0E
    SubTest $0F
    SubTest $10
    SubTest $11
    SubTest $12
    SubTest $13
    SubTest $14
    SubTest $15
    SubTest $16
    SubTest $17
    SubTest $18
    SubTest $19
    SubTest $1A
    SubTest $1B
    SubTest $1C
    SubTest $1D
    SubTest $1E
    SubTest $1F
    

    ret


StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
