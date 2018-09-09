RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; Attempts to change the volume of channel 1 without triggering
; the NRx2 write glitch

CorrectResults:

db $00, $01, $04, $07, $08, $0A, $0E, $0F
db $00, $01, $04, $07, $08, $0A, $0E, $0F
db $00, $0F, $0C, $09, $08, $06, $02, $01
db $00, $0F, $0C, $09, $08, $06, $02, $01

db $00, $00, $03, $06, $07, $09, $0D, $0E
db $00, $01, $04, $07, $08, $0A, $0E, $0F
db $0F, $0E, $0B, $08, $07, $05, $01, $00
db $00, $0F, $0C, $09, $08, $06, $02, $01

db $00, $0E, $0B, $08, $07, $05, $01, $00
db $00, $0D, $0A, $07, $06, $04, $00, $0F
db $01, $02, $05, $08, $09, $0B, $0F, $00
db $00, $01, $04, $07, $08, $0A, $0E, $0F

db $00, $0E, $0B, $08, $07, $05, $01, $00
db $00, $0D, $0A, $07, $06, $04, $00, $0F
db $01, $02, $05, $08, $09, $0B, $0F, $00
db $00, $01, $04, $07, $08, $0A, $0E, $0F

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ldh [rDIV], a
    ld hl, rPCM12
    ld a, $ff
    ldh [rNR13], a
    ld a, $C0
    ldh [rNR11], a
    ld a,\1
    ldh [rNR12], a
    ld a, $87
    ldh [rDIV], a
    ldh [rNR14], a
    ld a, b
    ldh [rNR12], a
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld b, $F0
    call SubTestGroup
    ld b, $F1
    call SubTestGroup
    ld b, $F8
    call SubTestGroup
    ld b, $F9
    call SubTestGroup
    
    ret
    
SubTestGroup:
    SubTest $00
    SubTest $10
    SubTest $40
    SubTest $70
    SubTest $80
    SubTest $A0
    SubTest $E0
    SubTest $F0
    
    SubTest $01
    SubTest $11
    SubTest $41
    SubTest $71
    SubTest $81
    SubTest $A1
    SubTest $E1
    SubTest $F1
    
    SubTest $08
    SubTest $18
    SubTest $48
    SubTest $78
    SubTest $88
    SubTest $A8
    SubTest $E8
    SubTest $F8
    
    SubTest $09
    SubTest $19
    SubTest $49
    SubTest $79
    SubTest $89
    SubTest $A9
    SubTest $E9
    SubTest $F9
    
    ret
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
