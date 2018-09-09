RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; This tests the NRx2 write glitch ("Zombie Mode"). It appears to
; be different across revisions

CorrectResults:

db $02, $01, $02, $03, $0D, $0F, $0C, $0F
db $02, $01, $01, $02, $0D, $0E, $0C, $0D

SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld hl, rPCM12
    ld a, $8f
    ldh [rNR13], a
    ld a, $C0
    ldh [rNR11], a
    ld a, \2
    ldh [rNR12], a
    ld a, $87
    ldh [rNR14], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    
    ld a, \3
    nops $400
    ldh [rNR12], a
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
