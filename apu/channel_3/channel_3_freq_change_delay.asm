RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; Modifying the wave length while the channel is playing will take
; effect only for the next sample. i.e., it cannot shorten or extend
; the length of the currently playing sample.

CorrectResults:

db $00, $00, $00, $00, $00, $00, $00, $0F
db $00, $00, $0F, $0F, $0F, $0F, $0F, $0F

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
    ld c, rNR34 & $FF
    ld a, $80 | \2
    ld [c], a
    ld a, \3 ; 2 cycles
    ld [c], a ; 2 cycles
    
    nops \1 - 4
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld de, $c000
    
    ; Wave length is $8000 T-Cycles, so each sample is $400 T-Cycles long
    SubTest $1FF, 4, 6
    SubTest $200, 4, 6
    SubTest $201, 4, 6
    SubTest $202, 4, 6
    SubTest $3FE, 4, 6
    SubTest $3FF, 4, 6
    SubTest $400, 4, 6
    SubTest $401, 4, 6

    ; Wave length is $4000 T-Cycles, so each sample is $200 T-Cycles long    
    SubTest $1FF, 6, 4
    SubTest $200, 6, 4
    SubTest $201, 6, 4
    SubTest $202, 6, 4
    SubTest $3FE, 6, 4
    SubTest $3FF, 6, 4
    SubTest $400, 6, 4
    SubTest $401, 6, 4
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    