RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 9

include "base.inc"

; This verifies that the envelope speed can be changed
; while it's active, and the change takes effect after
; the next time it ticks.
; Enabling and disabling the envelope takes effect
; instantly.
; Enabling the envelope trigger an APU bug - in the next
; *even* DIV-APU tick, the APU will tick the volume
; envelope of that apropriate channel, even if it would
; not tick volume envelope at that tick otherwise

CorrectResults:

db $00, $01, $01, $02, $02, $03, $03, $04
db $00, $00, $01, $02, $03, $04, $05, $06
db $01, $03, $04, $05, $06, $07, $08, $09
db $01, $02, $03, $03, $04, $04, $05, $05
db $00, $00, $00, $00, $00, $00, $00, $00
db $01, $01, $02, $02, $02, $02, $02, $02
db $02, $02, $02, $02, $02, $02, $03, $03
db $01, $02, $02, $02, $02, $02, $02, $02
db $02, $02, $02, $02, $02, $03, $03, $03

_SubTest: MACRO
    ld c, 8
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    ld hl, rPCM12
    ld a, $ff
    ldh [rNR13], a
    ld a, $C0
    ldh [rNR11], a
    ld a, \2
    ldh [rNR12], a
    ld a, $87
    ldh [rNR14], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    
    ld a, \3
    nops $400 + \4
    ldh [rNR12], a
    nops \1
    ld a, [hl]
    ld b, a
    nops $8
    ld a, [hl]
    or b
    ld b, a
    nops $8
    ld a, [hl]
    or b
    call StoreResult
    ENDM
    
SubTest: MACRO
    _SubTest 4 + $4000 * \1, \2, \3, 0
    ENDM

RunTest:
    ld de, $c000
    
    ; Test 1 - decrease speed
    SubTest 0, $09, $0A
    SubTest 1, $09, $0A
    SubTest 2, $09, $0A
    SubTest 3, $09, $0A
    SubTest 4, $09, $0A
    SubTest 5, $09, $0A
    SubTest 6, $09, $0A
    SubTest 7, $09, $0A
    
    ; Test 2 - increase speed
    SubTest 0, $0A, $09
    SubTest 1, $0A, $09
    SubTest 2, $0A, $09
    SubTest 3, $0A, $09
    SubTest 4, $0A, $09
    SubTest 5, $0A, $09
    SubTest 6, $0A, $09
    SubTest 7, $0A, $09
    
    ; Test 3 - Enable
    SubTest 0, $08, $09
    SubTest 1, $08, $09
    SubTest 2, $08, $09
    SubTest 3, $08, $09
    SubTest 4, $08, $09
    SubTest 5, $08, $09
    SubTest 6, $08, $09
    SubTest 7, $08, $09

    ; Test 4 - Enable, with different speed
    SubTest 0, $08, $0A
    SubTest 1, $08, $0A
    SubTest 2, $08, $0A
    SubTest 3, $08, $0A
    SubTest 4, $08, $0A
    SubTest 5, $08, $0A
    SubTest 6, $08, $0A
    SubTest 7, $08, $0A

    ; Test 5 - Disable
    SubTest 0, $09, $08
    SubTest 1, $09, $08
    SubTest 2, $09, $08
    SubTest 3, $09, $08
    SubTest 4, $09, $08
    SubTest 5, $09, $08
    SubTest 6, $09, $08
    SubTest 7, $09, $08
    
    ; Test 6 - Higher resolution version of Test 3
    _SubTest $0400, $08, $09, $0
    _SubTest $0800, $08, $09, $0
    _SubTest $0C00, $08, $09, $0
    _SubTest $1000, $08, $09, $0
    _SubTest $1400, $08, $09, $0
    _SubTest $1800, $08, $09, $0
    _SubTest $1C00, $08, $09, $0
    _SubTest $2000, $08, $09, $0
    
    _SubTest $2400, $08, $09, $0
    _SubTest $2800, $08, $09, $0
    _SubTest $2C00, $08, $09, $0
    _SubTest $3000, $08, $09, $0
    _SubTest $3400, $08, $09, $0
    _SubTest $3800, $08, $09, $0
    _SubTest $3C00, $08, $09, $0
    _SubTest $4000, $08, $09, $0
    
    ; Test 7 - Like Test 6, but with different alignment to the DIV-APU ticks
    _SubTest $0400, $08, $09, $400
    _SubTest $0800, $08, $09, $400
    _SubTest $0C00, $08, $09, $400
    _SubTest $1000, $08, $09, $400
    _SubTest $1400, $08, $09, $400
    _SubTest $1800, $08, $09, $400
    _SubTest $1C00, $08, $09, $400
    _SubTest $2000, $08, $09, $400
    
    _SubTest $2400, $08, $09, $400
    _SubTest $2800, $08, $09, $400
    _SubTest $2C00, $08, $09, $400
    _SubTest $3000, $08, $09, $400
    _SubTest $3400, $08, $09, $400
    _SubTest $3800, $08, $09, $400
    _SubTest $3C00, $08, $09, $400
    _SubTest $4000, $08, $09, $400
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
