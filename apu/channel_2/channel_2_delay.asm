RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 4

include "base.inc"

; It takes (sample length + 2) ticks from the moment channel 2 is
; enabled until PCM12 is affected. (The read operation itself takes 2
; cycles)

CorrectResults:

db $00, $80, $80, $80, $80, $80, $80, $00
db $00, $80, $80, $80, $80, $80, $80, $00
db $00, $00, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $00, $00

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld hl, rPCM12
    ld a, \2
    ldh [rNR23], a
    ld a, $C0
    ldh [rNR21], a
    ld a, $80
    ldh [rNR22], a
    ld a, $87
    ldh [rNR24], a
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    SubTest $0, $ff
    SubTest $1, $ff
    SubTest $2, $ff
    SubTest $3, $ff
    SubTest $4, $ff
    SubTest $5, $ff
    SubTest $6, $ff
    SubTest $7, $ff
    
    SubTest $8, $ff
    SubTest $9, $ff
    SubTest $a, $ff
    SubTest $b, $ff
    SubTest $c, $ff
    SubTest $d, $ff
    SubTest $e, $ff
    SubTest $f, $ff
    
    SubTest $0, $fe
    SubTest $1, $fe
    SubTest $2, $fe
    SubTest $3, $fe
    SubTest $4, $fe
    SubTest $5, $fe
    SubTest $6, $fe
    SubTest $7, $fe
   
    SubTest $8, $fe
    SubTest $9, $fe
    SubTest $a, $fe
    SubTest $b, $fe
    SubTest $c, $fe
    SubTest $d, $fe
    SubTest $e, $fe
    SubTest $f, $fe
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
