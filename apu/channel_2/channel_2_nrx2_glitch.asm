RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; This tests the NRx2 write glitch ("Zombie Mode"). It appears to
; be different across revisions

CorrectResults:

db $20, $10, $20, $30, $D0, $F0, $C0, $F0
db $20, $10, $10, $20, $D0, $E0, $C0, $D0

SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld hl, rPCM12
    ld a, $8f
    ldh [rNR23], a
    ld a, $C0
    ldh [rNR21], a
    ld a, \2
    ldh [rNR22], a
    ld a, $87
    ldh [rNR24], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    
    ld a, \3
    nops $400
    ldh [rNR22], a
    nops \1
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    SubTest 4, $20, $20
    SubTest 4, $08, $08
    SubTest 4, $22, $22
    SubTest 4, $32, $32
    SubTest 4, $20, $08
    SubTest 4, $08, $47
    SubTest 4, $22, $08
    SubTest 4, $08, $32
    
    SubTest $8004, $20, $20
    SubTest $8004, $08, $08
    SubTest $8004, $22, $22
    SubTest $8004, $32, $32
    SubTest $8004, $20, $08
    SubTest $8004, $08, $47
    SubTest $8004, $22, $08
    SubTest $8004, $08, $32
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
