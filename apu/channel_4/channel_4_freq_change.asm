RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 8

include "base.inc"

; This test tests what happens when changing the frequency
; of channel 4 while it's playing. Unfortunately the logic
; behind it is still unclear.

CorrectResults:
db $f0, $f0, $00, $00, $00, $00, $00, $00
db $f0, $f0, $f0, $f0, $f0, $00, $00, $00
db $f0, $00, $00, $00, $00, $00, $00, $00
db $f0, $f0, $f0, $f0, $f0, $f0, $00, $00
db $f0, $00, $00, $00, $00, $00, $00, $00
db $f0, $00, $00, $00, $00, $00, $00, $00
db $f0, $00, $00, $00, $00, $00, $00, $00
db $f0, $f0, $f0, $00, $00, $00, $00, $00


SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld hl, rPCM34
    ld a, $F0
    ldh [rNR42], a
    ld a, \2
    ldh [rNR43], a
    ld a, $80
    ldh [rNR44], a
    nops $70 + \4
    ld a, \3
    ldh [rNR43], a

    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    
    ld de, $c000
    
    ; All cases represent a sample length of $4 changing to $10, but the lengths are expressed differently
    
    SubTest $11, $18, $38, 0
    SubTest $12, $18, $38, 0
    SubTest $13, $18, $38, 0
    SubTest $14, $18, $38, 0
    SubTest $15, $18, $38, 0
    SubTest $16, $18, $38, 0
    SubTest $17, $18, $38, 0
    SubTest $18, $18, $38, 0
    
    SubTest $15, $18, $1a, 0
    SubTest $16, $18, $1a, 0
    SubTest $17, $18, $1a, 0
    SubTest $18, $18, $1a, 0
    SubTest $19, $18, $1a, 0
    SubTest $1a, $18, $1a, 0
    SubTest $1b, $18, $1a, 0
    SubTest $1c, $18, $1a, 0
    
    SubTest $11, $18, $38, 1
    SubTest $12, $18, $38, 1
    SubTest $13, $18, $38, 1
    SubTest $14, $18, $38, 1
    SubTest $15, $18, $38, 1
    SubTest $16, $18, $38, 1
    SubTest $17, $18, $38, 1
    SubTest $18, $18, $38, 1
    
    SubTest $11, $18, $1a, 1
    SubTest $12, $18, $1a, 1
    SubTest $13, $18, $1a, 1
    SubTest $14, $18, $1a, 1
    SubTest $15, $18, $1a, 1
    SubTest $16, $18, $1a, 1
    SubTest $17, $18, $1a, 1
    SubTest $18, $18, $1a, 1
    
    SubTest $1c, $09, $38, 0
    SubTest $1d, $09, $38, 0
    SubTest $1e, $09, $38, 0
    SubTest $1f, $09, $38, 0
    SubTest $20, $09, $38, 0
    SubTest $21, $09, $38, 0
    SubTest $22, $09, $38, 0
    SubTest $23, $09, $38, 0
    
    SubTest $11, $09, $1a, 0
    SubTest $12, $09, $1a, 0
    SubTest $13, $09, $1a, 0
    SubTest $14, $09, $1a, 0
    SubTest $15, $09, $1a, 0
    SubTest $16, $09, $1a, 0
    SubTest $17, $09, $1a, 0
    SubTest $18, $09, $1a, 0
    
    SubTest $1c, $09, $38, 1
    SubTest $1d, $09, $38, 1
    SubTest $1e, $09, $38, 1
    SubTest $1f, $09, $38, 1
    SubTest $20, $09, $38, 1
    SubTest $21, $09, $38, 1
    SubTest $22, $09, $38, 1
    SubTest $23, $09, $38, 1
    
    SubTest $0c, $09, $1a, 1
    SubTest $0d, $09, $1a, 1
    SubTest $0e, $09, $1a, 1
    SubTest $0f, $09, $1a, 1
    SubTest $10, $09, $1a, 1
    SubTest $11, $09, $1a, 1
    SubTest $12, $09, $1a, 1
    SubTest $13, $09, $1a, 1
    

    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
