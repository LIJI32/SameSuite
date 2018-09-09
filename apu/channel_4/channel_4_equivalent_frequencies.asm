RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; This test verifies that identical frequencies that are
; expressed differently generate the same output, other than
; a potential off-by-one sample caused by the start delay.

CorrectResults:
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F0, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0

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
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    
    ld de, $c000
    xor a
    ld [de], a
    
    ; All tests here have an equivalent sample length of $10 samples.
        
    SubTest $0c0, $c
    SubTest $0c1, $c
    SubTest $0c2, $c
    SubTest $0c3, $c
    SubTest $0c4, $c
    SubTest $0c5, $c
    SubTest $0c6, $c
    SubTest $0c7, $c

    SubTest $0c8, $c
    SubTest $0c9, $c
    SubTest $0ca, $c
    SubTest $0cb, $c
    SubTest $0cc, $c
    SubTest $0cd, $c
    SubTest $0ce, $c
    SubTest $0cf, $c
    
    SubTest $0d0, $c
    SubTest $0d1, $c
    SubTest $0d2, $c
    SubTest $0d3, $c
    SubTest $0d4, $c
    SubTest $0d5, $c
    SubTest $0d6, $c
    SubTest $0d7, $c
    
    SubTest $0d8, $c
    SubTest $0d9, $c
    SubTest $0da, $c
    SubTest $0db, $c
    SubTest $0dc, $c
    SubTest $0dd, $c
    SubTest $0de, $c
    SubTest $0df, $c

    SubTest $0c0, $1a
    SubTest $0c1, $1a
    SubTest $0c2, $1a
    SubTest $0c3, $1a
    SubTest $0c4, $1a
    SubTest $0c5, $1a
    SubTest $0c6, $1a
    SubTest $0c7, $1a
    
    SubTest $0c8, $1a
    SubTest $0c9, $1a
    SubTest $0ca, $1a
    SubTest $0cb, $1a
    SubTest $0cc, $1a
    SubTest $0cd, $1a
    SubTest $0ce, $1a
    SubTest $0cf, $1a
    
    SubTest $0d0, $1a
    SubTest $0d1, $1a
    SubTest $0d2, $1a
    SubTest $0d3, $1a
    SubTest $0d4, $1a
    SubTest $0d5, $1a
    SubTest $0d6, $1a
    SubTest $0d7, $1a
    
    SubTest $0d8, $1a
    SubTest $0d9, $1a
    SubTest $0da, $1a
    SubTest $0db, $1a
    SubTest $0dc, $1a
    SubTest $0dd, $1a
    SubTest $0de, $1a
    SubTest $0df, $1a
    
    SubTest $0c0, $29
    SubTest $0c1, $29
    SubTest $0c2, $29
    SubTest $0c3, $29
    SubTest $0c4, $29
    SubTest $0c5, $29
    SubTest $0c6, $29
    SubTest $0c7, $29
    
    SubTest $0c8, $29
    SubTest $0c9, $29
    SubTest $0ca, $29
    SubTest $0cb, $29
    SubTest $0cc, $29
    SubTest $0cd, $29
    SubTest $0ce, $29
    SubTest $0cf, $29
    
    SubTest $0d0, $29
    SubTest $0d1, $29
    SubTest $0d2, $29
    SubTest $0d3, $29
    SubTest $0d4, $29
    SubTest $0d5, $29
    SubTest $0d6, $29
    SubTest $0d7, $29
    
    SubTest $0d8, $29
    SubTest $0d9, $29
    SubTest $0da, $29
    SubTest $0db, $29
    SubTest $0dc, $29
    SubTest $0dd, $29
    SubTest $0de, $29
    SubTest $0df, $29
    
    SubTest $0c0, $38
    SubTest $0c1, $38
    SubTest $0c2, $38
    SubTest $0c3, $38
    SubTest $0c4, $38
    SubTest $0c5, $38
    SubTest $0c6, $38
    SubTest $0c7, $38
    
    SubTest $0c8, $38
    SubTest $0c9, $38
    SubTest $0ca, $38
    SubTest $0cb, $38
    SubTest $0cc, $38
    SubTest $0cd, $38
    SubTest $0ce, $38
    SubTest $0cf, $38
    
    SubTest $0d0, $38
    SubTest $0d1, $38
    SubTest $0d2, $38
    SubTest $0d3, $38
    SubTest $0d4, $38
    SubTest $0d5, $38
    SubTest $0d6, $38
    SubTest $0d7, $38
    
    SubTest $0d8, $38
    SubTest $0d9, $38
    SubTest $0da, $38
    SubTest $0db, $38
    SubTest $0dc, $38
    SubTest $0dd, $38
    SubTest $0de, $38
    SubTest $0df, $38
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
