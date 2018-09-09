RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 18

include "base.inc"

; This test shows that even after stopping the channel, the current
; sample index/phase remains unchanged. It is only reset by turning
; the APU off (NR52).

CorrectResults:

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $80, $80, $80, $80

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $80, $80, $80, $80

db $00, $00, $00, $00, $00, $00, $00, $00
db $80, $80, $80, $80, $80, $80, $80, $80

db $00, $00, $00, $00, $00, $00, $00, $00
db $80, $80, $80, $80, $80, $80, $80, $80

db $00, $00, $00, $00, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80

db $00, $00, $00, $00, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80

db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80

db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80

db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $00, $00, $00, $00

SubTest: MACRO
    xor a
    ld c, rNR22 & $ff
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
    nops \2
    xor a
    ld [c], a
    ld a, $80
    ld [c], a
    ld a, $87
    ldh [rNR24], a
    nops \1
    ld a, [hl]

    call StoreResult
    ENDM

RunTest:
    ld de, $c000

    SubTest $8, 0
    SubTest $9, 0
    SubTest $a, 0
    SubTest $b, 0
    SubTest $c, 0
    SubTest $d, 0
    SubTest $e, 0
    SubTest $f, 0
    
    SubTest $10, 0
    SubTest $11, 0
    SubTest $12, 0
    SubTest $13, 0
    SubTest $14, 0
    SubTest $15, 0
    SubTest $16, 0
    SubTest $17, 0
    
    SubTest $8, 2
    SubTest $9, 2
    SubTest $a, 2
    SubTest $b, 2
    SubTest $c, 2
    SubTest $d, 2
    SubTest $e, 2
    SubTest $f, 2
    
    SubTest $10, 2
    SubTest $11, 2
    SubTest $12, 2
    SubTest $13, 2
    SubTest $14, 2
    SubTest $15, 2
    SubTest $16, 2
    SubTest $17, 2
    
    SubTest $8, 3
    SubTest $9, 3
    SubTest $a, 3
    SubTest $b, 3
    SubTest $c, 3
    SubTest $d, 3
    SubTest $e, 3
    SubTest $f, 3
    
    SubTest $10, 3
    SubTest $11, 3
    SubTest $12, 3
    SubTest $13, 3
    SubTest $14, 3
    SubTest $15, 3
    SubTest $16, 3
    SubTest $17, 3
    
    SubTest $8, 6
    SubTest $9, 6
    SubTest $a, 6
    SubTest $b, 6
    SubTest $c, 6
    SubTest $d, 6
    SubTest $e, 6
    SubTest $f, 6
    
    SubTest $10, 6
    SubTest $11, 6
    SubTest $12, 6
    SubTest $13, 6
    SubTest $14, 6
    SubTest $15, 6
    SubTest $16, 6
    SubTest $17, 6
    
    SubTest $8, 7
    SubTest $9, 7
    SubTest $a, 7
    SubTest $b, 7
    SubTest $c, 7
    SubTest $d, 7
    SubTest $e, 7
    SubTest $f, 7
    
    SubTest $10, 7
    SubTest $11, 7
    SubTest $12, 7
    SubTest $13, 7
    SubTest $14, 7
    SubTest $15, 7
    SubTest $16, 7
    SubTest $17, 7
    
    SubTest $8, 10
    SubTest $9, 10
    SubTest $a, 10
    SubTest $b, 10
    SubTest $c, 10
    SubTest $d, 10
    SubTest $e, 10
    SubTest $f, 10
    
    SubTest $10, 10
    SubTest $11, 10
    SubTest $12, 10
    SubTest $13, 10
    SubTest $14, 10
    SubTest $15, 10
    SubTest $16, 10
    SubTest $17, 10
    
    SubTest $8, 11
    SubTest $9, 11
    SubTest $a, 11
    SubTest $b, 11
    SubTest $c, 11
    SubTest $d, 11
    SubTest $e, 11
    SubTest $f, 11
    
    SubTest $10, 11
    SubTest $11, 11
    SubTest $12, 11
    SubTest $13, 11
    SubTest $14, 11
    SubTest $15, 11
    SubTest $16, 11
    SubTest $17, 11
    
    SubTest $8, 14
    SubTest $9, 14
    SubTest $a, 14
    SubTest $b, 14
    SubTest $c, 14
    SubTest $d, 14
    SubTest $e, 14
    SubTest $f, 14
    
    SubTest $10, 14
    SubTest $11, 14
    SubTest $12, 14
    SubTest $13, 14
    SubTest $14, 14
    SubTest $15, 14
    SubTest $16, 14
    SubTest $17, 14
    
    SubTest $8, 15
    SubTest $9, 15
    SubTest $a, 15
    SubTest $b, 15
    SubTest $c, 15
    SubTest $d, 15
    SubTest $e, 15
    SubTest $f, 15
    
    SubTest $10, 15
    SubTest $11, 15
    SubTest $12, 15
    SubTest $13, 15
    SubTest $14, 15
    SubTest $15, 15
    SubTest $16, 15
    SubTest $17, 15
    ret
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
