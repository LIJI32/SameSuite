RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 4

include "base.inc"

; The volume envelope is triggered by the DIV register after it ticks
; the APU (8 * (NR12 & 7)) times (at 512Hz)

CorrectResults:
db $80, $80, $70, $70, $70, $00, $00, $00
db $80, $80, $70, $70, $70, $00, $00, $00
db $FF, $FF, $00, $00, $00, $00, $00, $00
db $FF, $FF, $00, $00, $00, $00, $00, $00

SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld a, $80
    ldh [rNR21], a
    ld a, $fc
    ldh [rNR23], a
    ld a, $80 | \2
    ldh [rNR22], a
    ld a, $87
    ldh [rNR24], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld hl, rPCM12
    call TestGroup
    ld hl, rDIV
    call TestGroup
    ret
    
TestGroup:
    SubTest $3ffc, 1
    SubTest $3ffd, 1
    SubTest $3ffe, 1
    SubTest $3fff, 1
    SubTest $4000, 1
    SubTest $4001, 1
    SubTest $4002, 1
    SubTest $4003, 1
    
    SubTest $7ffc, 2
    SubTest $7ffd, 2
    SubTest $7ffe, 2
    SubTest $7fff, 2
    SubTest $8000, 2
    SubTest $8001, 2
    SubTest $8002, 2
    SubTest $8003, 2
    
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
