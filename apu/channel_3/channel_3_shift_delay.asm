RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; Modifying the channel 3 shift while the channel is playing affects
; PCM34 instantly, or at most after 2 ticks, even if done in the
; middle of a sample.

CorrectResults:
db $01, $01, $01, $01, $01, $03, $03, $03

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ldh [rNR30], a
    
    ld hl, $ff30
    ld a, $F7
    REPT 16
    ldi [hl], a
    ENDR
    ld hl, rPCM34
    
    ld a, $20
    ldh [rNR32], a
    ld a, $87 ; Sample length of $100 T-Cycles
    ldh [rNR34], a
    
    nops $180 - 4 ; Let the sound play for $80 cycles after it actually starts
    cpl ; 1 (Bits 6-5 are now 3, so the volume shift is 2)
    ldh [rNR32], a ; 3
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    SubTest $0
    SubTest $1    
    SubTest $7E
    SubTest $7F
    SubTest $80
    SubTest $81
    SubTest $82
    SubTest $83
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    