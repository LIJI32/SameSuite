RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 8

include "base.inc"

; This test verifies that channel 1 ticks at 1MHz

CorrectResults:

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $F0, $F0, $F0
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $F0, $F0, $F0


SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    nops \2
    
    ld hl, rPCM34
    ld a, $F0
    ldh [rNR42], a
    ld a, $08
    ldh [rNR43], a
    ld a, $80
    ldh [rNR44], a
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld de, $c000
    
    SubTest $10, 0
    SubTest $11, 0
    SubTest $12, 0
    SubTest $13, 0
    SubTest $14, 0
    SubTest $15, 0
    SubTest $16, 0
    SubTest $17, 0
    
    SubTest $18, 0
    SubTest $19, 0
    SubTest $1a, 0
    SubTest $1b, 0
    SubTest $1c, 0
    SubTest $1d, 0
    SubTest $1e, 0
    SubTest $1f, 0
    
    SubTest $10, 1
    SubTest $11, 1
    SubTest $12, 1
    SubTest $13, 1
    SubTest $14, 1
    SubTest $15, 1
    SubTest $16, 1
    SubTest $17, 1
    
    SubTest $18, 1
    SubTest $19, 1
    SubTest $1a, 1
    SubTest $1b, 1
    SubTest $1c, 1
    SubTest $1d, 1
    SubTest $1e, 1
    SubTest $1f, 1
    
    SubTest $10, 2
    SubTest $11, 2
    SubTest $12, 2
    SubTest $13, 2
    SubTest $14, 2
    SubTest $15, 2
    SubTest $16, 2
    SubTest $17, 2
    
    SubTest $18, 2
    SubTest $19, 2
    SubTest $1a, 2
    SubTest $1b, 2
    SubTest $1c, 2
    SubTest $1d, 2
    SubTest $1e, 2
    SubTest $1f, 2
    
    SubTest $10, 3
    SubTest $11, 3
    SubTest $12, 3
    SubTest $13, 3
    SubTest $14, 3
    SubTest $15, 3
    SubTest $16, 3
    SubTest $17, 3
    
    SubTest $18, 3
    SubTest $19, 3
    SubTest $1a, 3
    SubTest $1b, 3
    SubTest $1c, 3
    SubTest $1d, 3
    SubTest $1e, 3
    SubTest $1f, 3
    
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
