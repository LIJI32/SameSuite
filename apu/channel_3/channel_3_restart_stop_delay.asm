RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; This test verifies that starting a pulse after stopping
; a previous one behaves the same as just starting a pulse. 

CorrectResults:
db $00, $00, $00, $00, $00, $00, $00, $0E

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ld hl, $ff31
    ldh [rNR52], a
    
    REPT 15
    ldi [hl], a
    sub a, $11
    ENDR
    
    ld hl, rPCM34
    ldh [rNR30], a
    ld a, $de
    ldh [$ff30], a
    ld a, $20
    ldh [rNR32], a
    ld a, $87
    ldh [rNR34], a
    
    nops $280 ; Let the sound play for a while
    xor a
    ldh [rNR30], a
    ld a, $87
    ldh [rNR30], a
    ldh [rNR34], a ; Restart the sound and see what happens    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld de, $c000

    ; Wave length is $2000 T-Cycles, so each sample is $100 M-Cycles long    
    SubTest $0 
    SubTest $1
    SubTest $2
    SubTest $3
    SubTest $0FE
    SubTest $0FF
    SubTest $100
    SubTest $101
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    