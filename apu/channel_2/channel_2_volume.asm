RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; Attempts to change the volume of channel 2 without triggering
; the NRx2 write glitch

CorrectResults:

db $80, $80, $00, $00, $80, $80, $80, $80

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld hl, rPCM12
    ld a, $ff
    ldh [rNR23], a
    ld a, $C0
    ldh [rNR21], a
    ld a, $80
    ldh [rNR22], a
    ld a, $87
    ldh [rDIV], a
    ldh [rNR24], a
    ld a, $F0
    ldh [rNR22], a
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    SubTest $ff8
    SubTest $ff9
    SubTest $ffa
    SubTest $ffb
    SubTest $ffc
    SubTest $ffd
    SubTest $ffe
    SubTest $fff
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
