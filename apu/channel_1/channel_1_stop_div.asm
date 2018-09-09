RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 7

include "base.inc"

; Channel 1 behave similarly to channel 3, but with a smaller length
; range. See channel_3_stop_div.


CorrectResults:

db $1F, $1F, $1F, $1F, $1F, $1F, $20, $20
db $00, $00, $00, $00, $08, $08, $00, $00
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $00, $08, $08, $00, $00
db $F1, $F1, $F1, $F1, $F1, $F1, $F0, $F0
db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F1, $F1, $F1, $F1, $F1, $F1, $F0, $F0


SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    nops \2
    ldh [rNR11], a
    ld a, 1
    ldh [rNR13], a
    ld a, $80
    ldh [rNR12], a
    ld a, $C0
    ldh [rNR14], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000

    ld hl, rDIV
    call ShortTestGroup    
    ld hl, rPCM12
    call TestGroup
    ld hl, rNR52
    call TestGroup
    ret
    
TestGroup:
    SubTest $7f8, 0
    SubTest $7f9, 0
    SubTest $7fa, 0
    SubTest $7fb, 0
    SubTest $7fc, 0
    SubTest $7fd, 0
    SubTest $7fe, 0
    SubTest $7ff, 0
    
    SubTest $7f8, $800
    SubTest $7f9, $800
    SubTest $7fa, $800
    SubTest $7fb, $800
    SubTest $7fc, $800
    SubTest $7fd, $800
    SubTest $7fe, $800
    SubTest $7ff, $800
    
ShortTestGroup:
    SubTest $7f8, $1000
    SubTest $7f9, $1000
    SubTest $7fa, $1000
    SubTest $7fb, $1000
    SubTest $7fc, $1000
    SubTest $7fd, $1000
    SubTest $7fe, $1000
    SubTest $7ff, $1000
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
