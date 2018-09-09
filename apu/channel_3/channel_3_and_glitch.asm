RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 6

include "base.inc"

; Channel 3 is not affected by the PCM34 AND glitch in neither single
; not double speed mode

CorrectResults:
db $00, $00, $00, $00, $00, $0E, $0E, $0E
db $0E, $0E, $0E, $0E, $0E, $0D, $0D, $0D
db $0D, $0D, $0D, $0D, $0D, $0C, $0C, $0C

db $00, $00, $00, $00, $0E, $0E, $0E, $0E
db $0E, $0E, $0E, $0E, $0D, $0D, $0D, $0D
db $0D, $0D, $0D, $0D, $0C, $0C, $0C, $0C


SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ld hl, $ff30
    ldh [rNR52], a
    
    REPT 16
    sub $11
    ldi [hl], a
    ENDR
    
    
    ld hl, rPCM34
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
    
    ; Wave length is $2000 T-Cycles, so each sample is $100 T-Cycles long
    SubTest $0FC
    SubTest $0FD
    SubTest $0FE
    SubTest $0FF
    SubTest $100
    SubTest $101
    SubTest $102
    SubTest $103
    
    SubTest $1FC
    SubTest $1FD
    SubTest $1FE
    SubTest $1FF
    SubTest $200
    SubTest $201
    SubTest $202
    SubTest $203
    
    SubTest $3FC
    SubTest $3FD
    SubTest $3FE
    SubTest $3FF
    SubTest $400
    SubTest $401
    SubTest $402
    SubTest $403
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ; Wave length is $1000 T-Cycles, so each sample is $800 T-Cycles long
    SubTest $7C
    SubTest $7D
    SubTest $7E
    SubTest $7F
    SubTest $80
    SubTest $81
    SubTest $82
    SubTest $83
    
    SubTest $0FC
    SubTest $0FD
    SubTest $0FE
    SubTest $0FF
    SubTest $100
    SubTest $101
    SubTest $102
    SubTest $103
    
    SubTest $1FC
    SubTest $1FD
    SubTest $1FE
    SubTest $1FF
    SubTest $200
    SubTest $201
    SubTest $202
    SubTest $203
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    