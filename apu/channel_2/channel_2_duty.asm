RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; The duty patterns are:
; 00: 00000010
; 01: 00000011
; 10: 00001111
; 11: 11111100
; The starting positions can be assumed from the other tests

CorrectResults:

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $80, $80, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $80, $80, $80, $80, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $80, $80, $80, $80
db $80, $80, $80, $80, $00, $00, $00, $00
db $00, $00, $00, $00, $80, $80, $80, $80
db $00, $00, $00, $00, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80
db $00, $00, $00, $00, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld a, $ff
    ldh [rNR23], a
    ld a, c
    ld hl, rPCM12
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
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld de, $c000
    
    ld c, $00
    call TestGroup
    ld c, $40
    call TestGroup
    ld c, $80
    call TestGroup
    ld c, $C0
    call TestGroup
    ret
    
TestGroup:
    SubTest $0
    SubTest $1
    SubTest $2
    SubTest $3
    SubTest $4
    SubTest $5
    SubTest $6
    SubTest $7
    
    SubTest $8
    SubTest $9
    SubTest $a
    SubTest $b
    SubTest $c
    SubTest $d
    SubTest $e
    SubTest $f
    
    SubTest $10
    SubTest $11
    SubTest $12
    SubTest $13
    SubTest $14
    SubTest $15
    SubTest $16
    SubTest $17
    
    SubTest $18
    SubTest $19
    SubTest $1a
    SubTest $1b
    SubTest $1c
    SubTest $1d
    SubTest $1e
    SubTest $1f
    
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
