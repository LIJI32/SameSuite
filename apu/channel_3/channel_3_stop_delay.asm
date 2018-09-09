RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; Stopping channel 3 manually using the NR30 register affects PCM34
; instantly, or at most after 2 ticks (It is not possible to
; measure lengths shorter than 2 ticks after a write)


CorrectResults:
db $00, $00, $00, $00, $00, $00, $00, $00


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
    ld a, $87 ; Sample length of $100 T-Cycles
    ldh [rNR34], a
    
    nops $180 - 4 ; Let the sound play for $80 cycles after it actually starts
    xor a ; 1
    ldh [rNR30], a ; 3
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    SubTest 0
    SubTest 1
    SubTest 2
    SubTest 3
    
    SubTest $7E
    SubTest $7F
    SubTest $80
    SubTest $81
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    