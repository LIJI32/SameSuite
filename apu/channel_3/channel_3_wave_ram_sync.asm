RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; This test verifies the value read from PCM34 and value read from the
; wave RAM are synced

CorrectResults:
db $00, $00, $00, $02, $02, $02, $02, $03
db $12, $12, $12, $12, $12, $12, $12, $34

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    push hl
    ld a, $12
    ld c, $22
    ld hl, $ff30
    REPT 16
    ldi [hl], a
    add a, c
    ENDR
    pop hl
    
    ld a, $80
    ldh [rNR30], a
    ld a, $20
    ldh [rNR32], a
    ld a, $87
    ldh [rNR34], a
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld hl, rPCM34
    call TestGroup
    
    ld hl, $ff32
    call TestGroup
        
    ret

TestGroup:
    ; Wave length is $2000 T-Cycles, so each sample is $100 T-Cycles long
    SubTest $0FE
    SubTest $0FF
    SubTest $100
    SubTest $101
    SubTest $1FE
    SubTest $1FF
    SubTest $200
    SubTest $201
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE