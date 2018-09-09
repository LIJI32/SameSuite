RESULTS_START  EQU $c006
RESULTS_N_ROWS EQU 16

include "base.inc"

; This test verifies the LFSR algorithm used is correct,
; this time using 15-bit LFSR.
; For convinence, it proccesses the results into
; reconsructed LFSR values.

CorrectResults:
db $00, $00, $00, $80, $C0, $E0, $F0, $F8
db $FC, $FE, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $7F, $BF, $DF, $EF, $F7, $FB, $FD
db $FE, $FF, $FF, $FF, $FF, $FF, $FF, $7F
db $3F, $9F, $CF, $E7, $F3, $F9, $FC, $FE
db $FF, $FF, $FF, $FF, $FF, $7F, $BF, $5F
db $AF, $D7, $EB, $F5, $FA, $FD, $FE, $FF
db $FF, $FF, $FF, $7F, $3F, $1F, $0F, $87
db $C3, $E1, $F0, $F8, $FC, $FE, $FF, $FF
db $FF, $7F, $BF, $DF, $EF, $77, $BB, $DD
db $EE, $F7, $FB, $FD, $FE, $FF, $FF, $7F
db $3F, $9F, $CF, $67, $33, $99, $CC, $E6
db $F3, $F9, $FC, $FE, $FF, $7F, $BF, $5F
db $AF, $57, $AB, $55, $AA, $D5, $EA, $F5
db $FA, $FD, $FE, $7F, $3F, $1F, $0F, $07
db $03, $01, $00, $80, $C0, $E0, $F0, $F8

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

    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    
    ld de, $c000
    xor a
    ld [de], a
    
    ; Frequency is 512KHz, each sample is 2 cycles long
    
    SubTest $00d
    SubTest $00f
    SubTest $011
    SubTest $013
    SubTest $015
    SubTest $017
    SubTest $019
    SubTest $01b

    SubTest $01d
    SubTest $01f
    SubTest $021
    SubTest $023
    SubTest $025
    SubTest $027
    SubTest $029
    SubTest $02b
    
    SubTest $02d
    SubTest $02f
    SubTest $031
    SubTest $033
    SubTest $035
    SubTest $037
    SubTest $039
    SubTest $03b
    
    SubTest $03d
    SubTest $03f
    SubTest $041
    SubTest $043
    SubTest $045
    SubTest $047
    SubTest $049
    SubTest $04b
    
    SubTest $04d
    SubTest $04f
    SubTest $051
    SubTest $053
    SubTest $055
    SubTest $057
    SubTest $059
    SubTest $05b
    
    SubTest $05d
    SubTest $05f
    SubTest $061
    SubTest $063
    SubTest $065
    SubTest $067
    SubTest $069
    SubTest $06b
    
    SubTest $06d
    SubTest $06f
    SubTest $071
    SubTest $073
    SubTest $075
    SubTest $077
    SubTest $079
    SubTest $07b
    
    SubTest $07d
    SubTest $07f
    SubTest $081
    SubTest $083
    SubTest $085
    SubTest $087
    SubTest $089
    SubTest $08b
    
    SubTest $08d
    SubTest $08f
    SubTest $091
    SubTest $093
    SubTest $095
    SubTest $097
    SubTest $099
    SubTest $09b
    
    SubTest $09d
    SubTest $09f
    SubTest $0a1
    SubTest $0a3
    SubTest $0a5
    SubTest $0a7
    SubTest $0a9
    SubTest $0ab
    
    SubTest $0ad
    SubTest $0af
    SubTest $0b1
    SubTest $0b3
    SubTest $0b5
    SubTest $0b7
    SubTest $0b9
    SubTest $0bb
    
    SubTest $0bd
    SubTest $0bf
    SubTest $0c1
    SubTest $0c3
    SubTest $0c5
    SubTest $0c7
    SubTest $0c9
    SubTest $0cb
    
    SubTest $0cd
    SubTest $0cf
    SubTest $0d1
    SubTest $0d3
    SubTest $0d5
    SubTest $0d7
    SubTest $0d9
    SubTest $0db
    
    SubTest $0dd
    SubTest $0df
    SubTest $0e1
    SubTest $0e3
    SubTest $0e5
    SubTest $0e7
    SubTest $0e9
    SubTest $0eb
    
    SubTest $0ed
    SubTest $0ef
    SubTest $0f1
    SubTest $0f3
    SubTest $0f5
    SubTest $0f7
    SubTest $0f9
    SubTest $0fb
    
    SubTest $0fd
    SubTest $0ff
    SubTest $101
    SubTest $103
    SubTest $105
    SubTest $107
    SubTest $109
    SubTest $10b
    
    SubTest $10d
    SubTest $10f
    SubTest $111
    SubTest $113
    SubTest $115
    SubTest $117
    SubTest $119
    SubTest $11b

    ret
    
    
StoreResult::
    and $80
    ld b, a
    ld a, [de]
    srl a
    or b
    inc de
    ld [de], a
    ret

    CGB_MODE
