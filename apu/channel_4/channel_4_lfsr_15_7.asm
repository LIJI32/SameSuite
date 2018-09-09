RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; This test verifies the contents of the LFSR are retained
; correctly when switching from 15-bit LFSR to 7-bit LFSR.

CorrectResults:
db $f0, $f0, $f0, $f0, $00, $00, $f0, $f0
db $f0, $f0, $00, $f0, $00, $f0, $f0, $f0
db $00, $00, $00, $00, $f0, $f0, $00, $f0
db $f0, $f0, $00, $f0, $00, $00, $f0, $f0
db $f0, $f0, $00, $f0, $00, $00, $f0, $f0
db $00, $00, $00, $f0, $00, $f0, $00, $f0
db $f0, $00, $00, $00, $00, $00, $f0, $00
db $f0, $f0, $f0, $f0, $00, $00, $00, $f0
db $f0, $f0, $00, $f0, $f0, $00, $f0, $f0
db $00, $00, $f0, $00, $00, $f0, $00, $f0
db $00, $00, $f0, $00, $00, $00, $00, $f0
db $00, $00, $f0, $f0, $f0, $00, $00, $f0
db $00, $f0, $f0, $00, $f0, $00, $00, $00
db $f0, $00, $00, $00, $f0, $f0, $00, $00
db $f0, $f0, $00, $f0, $00, $f0, $00, $f0
db $00, $00, $00, $00, $00, $00, $00, $f0

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld hl, rPCM34
    ld a, $F0
    ldh [rNR42], a
    xor a
    ldh [rNR43], a
    ld a, $80
    ldh [rNR44], a
    nops $80
    ld a, $8
    ldh [rNR43], a

    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    
    ld de, $c000
    
    ; Frequency is 512KHz, each sample is 2 cycles long
    
    SubTest $000
    SubTest $002
    SubTest $004
    SubTest $006
    SubTest $008
    SubTest $00a
    SubTest $00c
    SubTest $00e
    
    SubTest $010
    SubTest $012
    SubTest $014
    SubTest $016
    SubTest $018
    SubTest $01a
    SubTest $01c
    SubTest $01e
    
    SubTest $020
    SubTest $022
    SubTest $024
    SubTest $026
    SubTest $028
    SubTest $02a
    SubTest $02c
    SubTest $02e
    
    SubTest $030
    SubTest $032
    SubTest $034
    SubTest $036
    SubTest $038
    SubTest $03a
    SubTest $03c
    SubTest $03e
    
    SubTest $030
    SubTest $032
    SubTest $034
    SubTest $036
    SubTest $038
    SubTest $03a
    SubTest $03c
    SubTest $03e
    
    SubTest $040
    SubTest $042
    SubTest $044
    SubTest $046
    SubTest $048
    SubTest $04a
    SubTest $04c
    SubTest $04e
    
    SubTest $050
    SubTest $052
    SubTest $054
    SubTest $056
    SubTest $058
    SubTest $05a
    SubTest $05c
    SubTest $05e
    
    SubTest $060
    SubTest $062
    SubTest $064
    SubTest $066
    SubTest $068
    SubTest $06a
    SubTest $06c
    SubTest $06e
    
    SubTest $070
    SubTest $072
    SubTest $074
    SubTest $076
    SubTest $078
    SubTest $07a
    SubTest $07c
    SubTest $07e
    
    SubTest $080
    SubTest $082
    SubTest $084
    SubTest $086
    SubTest $088
    SubTest $08a
    SubTest $08c
    SubTest $08e
    
    SubTest $090
    SubTest $092
    SubTest $094
    SubTest $096
    SubTest $098
    SubTest $09a
    SubTest $09c
    SubTest $09e
    
    SubTest $0a0
    SubTest $0a2
    SubTest $0a4
    SubTest $0a6
    SubTest $0a8
    SubTest $0aa
    SubTest $0ac
    SubTest $0ae
    
    SubTest $0b0
    SubTest $0b2
    SubTest $0b4
    SubTest $0b6
    SubTest $0b8
    SubTest $0ba
    SubTest $0bc
    SubTest $0be
    
    SubTest $0c0
    SubTest $0c2
    SubTest $0c4
    SubTest $0c6
    SubTest $0c8
    SubTest $0ca
    SubTest $0cc
    SubTest $0ce
    
    SubTest $0d0
    SubTest $0d2
    SubTest $0d4
    SubTest $0d6
    SubTest $0d8
    SubTest $0da
    SubTest $0dc
    SubTest $0de
    
    SubTest $0e0
    SubTest $0e2
    SubTest $0e4
    SubTest $0e6
    SubTest $0e8
    SubTest $0ea
    SubTest $0ec
    SubTest $0ee
    
    SubTest $0f0
    SubTest $0f2
    SubTest $0f4
    SubTest $0f6
    SubTest $0f8
    SubTest $0fa
    SubTest $0fc
    SubTest $0fe
    
    SubTest $100
    SubTest $102
    SubTest $104
    SubTest $106
    SubTest $108
    SubTest $10a
    SubTest $10c
    SubTest $10e

    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret

    CGB_MODE
