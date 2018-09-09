RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 4

include "base.inc"

CorrectResults:
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $02, $02, $02, $02, $03
db $12, $12, $12, $12, $12, $12, $12, $12
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
    ld a, $86
    ldh [rNR34], a
    nops $20 - 3
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
    
    ld hl, rPCM34
    call TestGroup
    ld hl, $ff30
    call TestGroup
        
    ret
    
TestGroup:
    ; Wave length is $4000 T-Cycles, so each sample is $200 T-Cycles long    
    SubTest $1FC - $20
    SubTest $1FD - $20
    SubTest $1FE - $20
    SubTest $1FF - $20
    SubTest $200 - $20
    SubTest $201 - $20
    SubTest $202 - $20
    SubTest $203 - $20
    
    SubTest $1FE
    SubTest $1FF
    SubTest $200
    SubTest $201
    
    SubTest $3FE
    SubTest $3FF
    SubTest $400
    SubTest $401
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    