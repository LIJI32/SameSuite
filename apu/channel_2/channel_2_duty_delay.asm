RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; Changing the duty becomes effective only after the current sample finishes.

CorrectResults:

db $00, $00, $00, $00, $00, $00, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $80, $80
db $80, $80, $80, $80, $80, $80, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $80, $80, $80, $80, $80, $80, $00, $00
db $80, $80, $80, $80, $80, $80, $00, $00
db $80, $80, $80, $80, $80, $80, $00, $00
db $80, $80, $80, $80, $80, $80, $00, $00
db $80, $80, $80, $80, $80, $80, $00, $00
db $80, $80, $80, $80, $80, $80, $80, $80
db $00, $00, $00, $00, $00, $00, $00, $00

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld c, rPCM12 & $ff
    ld a, $f8
    ldh [rNR23], a
    ld a, $C0
    ld hl, rNR21
    ld [hl], a
    ld a, $80
    ldh [rNR22], a
    ld a, $87
    ldh [rNR24], a
    
    nops \1
    ld [hl], b
    
    ld a, [c]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld b, $C0
    call TestGroup
    ld b, 0
    call TestGroup
    ret
    
TestGroup:
    SubTest $0, $C0
    SubTest $1, $C0
    SubTest $2, $C0
    SubTest $3, $C0
    SubTest $4, $C0
    SubTest $5, $C0
    SubTest $6, $C0
    SubTest $7, $C0
    
    SubTest $8, $C0
    SubTest $9, $C0
    SubTest $a, $C0
    SubTest $b, $C0
    SubTest $c, $C0
    SubTest $d, $C0
    SubTest $e, $C0
    SubTest $f, $C0
    
    SubTest $10, $C0
    SubTest $11, $C0
    SubTest $12, $C0
    SubTest $13, $C0
    SubTest $14, $C0
    SubTest $15, $C0
    SubTest $16, $C0
    SubTest $17, $C0
    
    SubTest $18, $C0
    SubTest $19, $C0
    SubTest $1a, $C0
    SubTest $1b, $C0
    SubTest $1c, $C0
    SubTest $1d, $C0
    SubTest $1e, $C0
    SubTest $1f, $C0
    
    SubTest $20, $C0
    SubTest $21, $C0
    SubTest $22, $C0
    SubTest $23, $C0
    SubTest $24, $C0
    SubTest $25, $C0
    SubTest $26, $C0
    SubTest $27, $C0
    
    SubTest $28, $C0
    SubTest $29, $C0
    SubTest $2a, $C0
    SubTest $2b, $C0
    SubTest $2c, $C0
    SubTest $2d, $C0
    SubTest $2e, $C0
    SubTest $2f, $C0
    
    SubTest $30, $C0
    SubTest $31, $C0
    SubTest $32, $C0
    SubTest $33, $C0
    SubTest $34, $C0
    SubTest $35, $C0
    SubTest $36, $C0
    SubTest $37, $C0
    
    SubTest $38, $C0
    SubTest $39, $C0
    SubTest $3a, $C0
    SubTest $3b, $C0
    SubTest $3c, $C0
    SubTest $3d, $C0
    SubTest $3e, $C0
    SubTest $3f, $C0
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
