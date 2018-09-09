RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; This test verifies restarting the channel after
; triggering the NRx2 write glitch works as expected

CorrectResults:

db $20, $20, $20, $20, $20, $20, $20, $20
db $20, $20, $20, $20, $20, $20, $20, $00

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld hl, rPCM12
    ld a, $fc
    ldh [rNR23], a
    ld a, $80
    ldh [rNR21], a
    ldh [rNR22], a
    ld a, $87
    ldh [rNR24], a
    ld a, $28
    ldh [rNR22], a
    ld a, $87
    nops \2
    ldh [rNR24], a
    nops \1
    ld a, [hl]

    call StoreResult
    ENDM

RunTest:
    ld de, $c000

    SubTest $0, 12
    SubTest $1, 12
    SubTest $2, 12
    SubTest $3, 12
    SubTest $4, 12
    SubTest $5, 12
    SubTest $6, 12
    SubTest $7, 12
    
    SubTest $8, 12
    SubTest $9, 12
    SubTest $a, 12
    SubTest $b, 12
    SubTest $c, 12
    SubTest $d, 12
    SubTest $e, 12
    SubTest $f, 12

    ret

StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
