RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 8

include "base.inc"

; The volume envelope is triggered by the DIV register after it ticks
; the APU (8 * (NR12 & 7)) times (at 512Hz).

CorrectResults:
db $08, $08, $07, $07, $07, $00, $00, $00
db $08, $08, $07, $07, $07, $00, $00, $00
db $07, $07, $07, $07, $07, $00, $00, $00
db $07, $07, $07, $07, $07, $00, $00, $00
db $FF, $FF, $00, $00, $00, $00, $00, $00
db $FF, $FF, $00, $00, $00, $00, $00, $00
db $FF, $FF, $00, $00, $00, $00, $00, $00
db $FF, $FF, $00, $00, $00, $00, $00, $00


SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    nops \2
    ld a, $80
    ldh [rNR11], a
    ld a, $fc
    ldh [rNR13], a
    ld a, $80 | \3
    ldh [rNR12], a
    ld a, $87
    ldh [rNR14], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld hl, rPCM12
    call TestGroup
    ld hl, rDIV
    call TestGroup
    ret
    
TestGroup:
    SubTest $3ffc, 0,  1
    SubTest $3ffd, 0,  1
    SubTest $3ffe, 0,  1
    SubTest $3fff, 0,  1
    SubTest $4000, 0,  1
    SubTest $4001, 0,  1
    SubTest $4002, 0,  1
    SubTest $4003, 0,  1
    
    SubTest $7ffc, 0,  2
    SubTest $7ffd, 0,  2
    SubTest $7ffe, 0,  2
    SubTest $7fff, 0,  2
    SubTest $8000, 0,  2
    SubTest $8001, 0,  2
    SubTest $8002, 0,  2
    SubTest $8003, 0,  2
    
    SubTest $3ffc, $800, 1
    SubTest $3ffd, $800, 1
    SubTest $3ffe, $800, 1
    SubTest $3fff, $800, 1
    SubTest $4000, $800, 1
    SubTest $4001, $800, 1
    SubTest $4002, $800, 1
    SubTest $4003, $800, 1
    
    SubTest $7ffc, $800, 2
    SubTest $7ffd, $800, 2
    SubTest $7ffe, $800, 2
    SubTest $7fff, $800, 2
    SubTest $8000, $800, 2
    SubTest $8001, $800, 2
    SubTest $8002, $800, 2
    SubTest $8003, $800, 2
    
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
