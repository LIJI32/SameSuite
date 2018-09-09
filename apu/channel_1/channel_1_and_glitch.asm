RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; The volume envelope is triggered by the DIV register after it ticks
; the APU (8 * (NR12 & 7)) times (at 512Hz).

CorrectResults:
db $08, $08, $07, $07, $07, $00, $00, $00
db $07, $07, $06, $06, $06, $00, $00, $00
db $06, $06, $05, $05, $05, $00, $00, $00
db $05, $05, $04, $04, $04, $00, $00, $00
db $04, $04, $03, $03, $03, $00, $00, $00
db $03, $03, $02, $02, $02, $00, $00, $00
db $02, $02, $01, $01, $01, $00, $00, $00
db $01, $01, $00, $00, $00, $00, $00, $00

db $08, $08, $07, $07, $07, $07, $07, $07
db $07, $07, $06, $06, $06, $06, $06, $06
db $06, $06, $05, $05, $05, $05, $05, $05
db $05, $05, $04, $04, $04, $04, $04, $04
db $04, $04, $03, $03, $03, $03, $03, $03
db $03, $03, $02, $02, $02, $02, $02, $02
db $02, $02, $01, $01, $01, $01, $01, $01
db $01, $01, $00, $00, $00, $00, $00, $00


SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld a, $80
    ldh [rNR11], a
    ld a, $fc
    ldh [rNR13], a
    ld a, \2
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
    SubTest $3ffc, $89
    SubTest $3ffd, $89
    SubTest $3ffe, $89
    SubTest $3fff, $89
    SubTest $4000, $89
    SubTest $4001, $89
    SubTest $4002, $89
    SubTest $4003, $89
    
    SubTest $3ffc, $79
    SubTest $3ffd, $79
    SubTest $3ffe, $79
    SubTest $3fff, $79
    SubTest $4000, $79
    SubTest $4001, $79
    SubTest $4002, $79
    SubTest $4003, $79
    
    SubTest $3ffc, $69
    SubTest $3ffd, $69
    SubTest $3ffe, $69
    SubTest $3fff, $69
    SubTest $4000, $69
    SubTest $4001, $69
    SubTest $4002, $69
    SubTest $4003, $69
    
    SubTest $3ffc, $59
    SubTest $3ffd, $59
    SubTest $3ffe, $59
    SubTest $3fff, $59
    SubTest $4000, $59
    SubTest $4001, $59
    SubTest $4002, $59
    SubTest $4003, $59
    
    SubTest $3ffc, $49
    SubTest $3ffd, $49
    SubTest $3ffe, $49
    SubTest $3fff, $49
    SubTest $4000, $49
    SubTest $4001, $49
    SubTest $4002, $49
    SubTest $4003, $49
    
    SubTest $3ffc, $39
    SubTest $3ffd, $39
    SubTest $3ffe, $39
    SubTest $3fff, $39
    SubTest $4000, $39
    SubTest $4001, $39
    SubTest $4002, $39
    SubTest $4003, $39
    
    SubTest $3ffc, $29
    SubTest $3ffd, $29
    SubTest $3ffe, $29
    SubTest $3fff, $29
    SubTest $4000, $29
    SubTest $4001, $29
    SubTest $4002, $29
    SubTest $4003, $29
    
    SubTest $3ffc, $19
    SubTest $3ffd, $19
    SubTest $3ffe, $19
    SubTest $3fff, $19
    SubTest $4000, $19
    SubTest $4001, $19
    SubTest $4002, $19
    SubTest $4003, $19
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    SubTest $7ffc, $89
    SubTest $7ffd, $89
    SubTest $7ffe, $89
    SubTest $7fff, $89
    SubTest $8000, $89
    SubTest $8001, $89
    SubTest $8002, $89
    SubTest $8003, $89
    
    SubTest $7ffc, $79
    SubTest $7ffd, $79
    SubTest $7ffe, $79
    SubTest $7fff, $79
    SubTest $8000, $79
    SubTest $8001, $79
    SubTest $8002, $79
    SubTest $8003, $79
    
    SubTest $7ffc, $69
    SubTest $7ffd, $69
    SubTest $7ffe, $69
    SubTest $7fff, $69
    SubTest $8000, $69
    SubTest $8001, $69
    SubTest $8002, $69
    SubTest $8003, $69
    
    SubTest $7ffc, $59
    SubTest $7ffd, $59
    SubTest $7ffe, $59
    SubTest $7fff, $59
    SubTest $8000, $59
    SubTest $8001, $59
    SubTest $8002, $59
    SubTest $8003, $59
    
    SubTest $7ffc, $49
    SubTest $7ffd, $49
    SubTest $7ffe, $49
    SubTest $7fff, $49
    SubTest $8000, $49
    SubTest $8001, $49
    SubTest $8002, $49
    SubTest $8003, $49
    
    SubTest $7ffc, $39
    SubTest $7ffd, $39
    SubTest $7ffe, $39
    SubTest $7fff, $39
    SubTest $8000, $39
    SubTest $8001, $39
    SubTest $8002, $39
    SubTest $8003, $39
    
    SubTest $7ffc, $29
    SubTest $7ffd, $29
    SubTest $7ffe, $29
    SubTest $7fff, $29
    SubTest $8000, $29
    SubTest $8001, $29
    SubTest $8002, $29
    SubTest $8003, $29
    
    SubTest $7ffc, $19
    SubTest $7ffd, $19
    SubTest $7ffe, $19
    SubTest $7fff, $19
    SubTest $8000, $19
    SubTest $8001, $19
    SubTest $8002, $19
    SubTest $8003, $19
    
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
