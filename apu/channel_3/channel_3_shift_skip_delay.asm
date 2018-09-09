RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; This test verifies the delay cannot be skipped or shortened by
; modifying the shift value.


CorrectResults:
db $00, $00, $00, $00, $00, $0E, $0E, $0E

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ld hl, $ff31
    ldh [rNR52], a
    
    REPT 15
    ldi [hl], a
    ENDR
    
    ld a, $de
    ld [$ff30], a
    
    ld hl, rPCM34
    ldh [rNR30], a
    ldh [rNR32], a
    ld a, $87
    ldh [rNR34], a
    ld a, $20
    ldh [rNR32], a
    
    nops \1 - 5
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ; Wave length is $2000 T-Cycles, so each sample is $100 T-Cycles long
    SubTest $0FC
    SubTest $0FD
    SubTest $0FE
    SubTest $0FF
    SubTest $100
    SubTest $101
    SubTest $102
    SubTest $103
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    