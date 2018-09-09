RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; It takes (wavelength / 32) (i.e sample length) + 3 ticks from the
; moment channel 3 is enabled until PCM34 is affected. (The read
; operation itself takes 2 cycles). See first_sample for details.

CorrectResults:

db $00, $00, $00, $00, $00, $0F, $0F, $0F
db $00, $00, $00, $00, $00, $0F, $0F, $0F

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ld hl, $ff30
    ldh [rNR52], a
    
    REPT 16
    ldi [hl], a
    ENDR
    
    ld hl, rPCM34
    ldh [rNR30], a
    ld a, $20
    ldh [rNR32], a
    ld a, $80 | \2
    ldh [rNR34], a
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld de, $c000
    
    ; Wave length is $8000 T-Cycles, so each sample is $400 T-Cycles long
    SubTest $3FC, 4
    SubTest $3FD, 4
    SubTest $3FE, 4
    SubTest $3FF, 4
    SubTest $400, 4
    SubTest $401, 4
    SubTest $402, 4
    SubTest $403, 4

    ; Wave length is $4000 T-Cycles, so each sample is $200 T-Cycles long    
    SubTest $1FC, 6
    SubTest $1FD, 6
    SubTest $1FE, 6
    SubTest $1FF, 6
    SubTest $200, 6
    SubTest $201, 6
    SubTest $202, 6
    SubTest $203, 6
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    