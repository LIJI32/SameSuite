RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; Changing channel 1's frequency takes effect after the current sample
; finishes.

CorrectResults:

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $08, $08, $08, $08, $08, $08
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $08, $08, $08, $08, $08, $08, $08
db $00, $00, $00, $00, $00, $00, $00, $00
db $08, $08, $08, $08, $08, $08, $08, $08
db $00, $00, $00, $00, $00, $00, $00, $08
db $08, $08, $08, $08, $08, $08, $08, $00
db $00, $00, $00, $00, $00, $00, $08, $08
db $08, $08, $00, $00, $00, $00, $08, $08
db $00, $00, $00, $00, $00, $08, $08, $08
db $08, $00, $00, $00, $00, $08, $08, $08
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $08, $08, $08, $08, $00
db $00, $00, $00, $08, $08, $08, $08, $00

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld c, rPCM12 & $ff
    ld hl, rNR13
    ld a, $fc
    ld [hl], a
    ld a, $80
    ldh [rNR11], a
    ldh [rNR12], a
    ld a, $87
    ldh [rNR14], a
    nops \2
    ld [hl], b
    nops \1
    ld a, [c]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld b, $fe
    call TestGroup
    ld b, $ff
    call TestGroup
    ret
    
TestGroup:
    SubTest $0, 0
    SubTest $1, 0
    SubTest $2, 0
    SubTest $3, 0
    SubTest $4, 0
    SubTest $5, 0
    SubTest $6, 0
    SubTest $7, 0
    
    SubTest $8, 0
    SubTest $9, 0
    SubTest $a, 0
    SubTest $b, 0
    SubTest $c, 0
    SubTest $d, 0
    SubTest $e, 0
    SubTest $f, 0
    
    SubTest $0,  1
    SubTest $1,  1
    SubTest $2,  1
    SubTest $3,  1
    SubTest $4,  1
    SubTest $5,  1
    SubTest $6,  1
    SubTest $7,  1
    
    SubTest $8,  1
    SubTest $9,  1
    SubTest $a,  1
    SubTest $b,  1
    SubTest $c,  1
    SubTest $d,  1
    SubTest $e,  1
    SubTest $f,  1
    
    SubTest $0, 2
    SubTest $1, 2
    SubTest $2, 2
    SubTest $3, 2
    SubTest $4, 2
    SubTest $5, 2
    SubTest $6, 2
    SubTest $7, 2
    
    SubTest $8, 2
    SubTest $9, 2
    SubTest $a, 2
    SubTest $b, 2
    SubTest $c, 2
    SubTest $d, 2
    SubTest $e, 2
    SubTest $f, 2
    
    SubTest $0, 3
    SubTest $1, 3
    SubTest $2, 3
    SubTest $3, 3
    SubTest $4, 3
    SubTest $5, 3
    SubTest $6, 3
    SubTest $7, 3
    
    SubTest $8, 3
    SubTest $9, 3
    SubTest $a, 3
    SubTest $b, 3
    SubTest $c, 3
    SubTest $d, 3
    SubTest $e, 3
    SubTest $f, 3
    
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
