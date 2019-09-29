RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

CorrectResults:


; Left digit: Sample right after the write. Affected by the PCM read glitch on CGB-C and older
; Right digit: Sample the channel stays on

db $00, $00, $00, $0f, $0f, $ff, $ff, $f0
db $00, $00, $0f, $0f, $0f, $0f, $0f, $0f

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a

    xor a
    ldh [rNR11], a ; Pattern is 0, 0, 0, 0, 0, 0, 0, 1,
                   ; Changes from 0 to 1 after 7 samples
    ld a, $F8
    ldh [rNR12], a

    ld a, $fc ; 4 nops per sample, 8 in double speed
    ldh [rNR13], a

    ld a, $87
    ld hl, rNR14
    ld b, 0

    ld c, rPCM12 & $ff
    ld [hl], a
    nops \1
    ld [hl], b

    ld a, [c]
    ld b, a
    swap b

    nops 16

    ld a, [c]  
    or b
    call StoreResult


    ENDM

RunTest:
    ld de, $c000

    SubTest 22
    SubTest 23
    SubTest 24
    SubTest 25
    SubTest 26
    SubTest 27
    SubTest 28
    SubTest 29

    ld a, 1
    ldh [rKEY1], a
    stop

    SubTest 50
    SubTest 51
    SubTest 52
    SubTest 53
    SubTest 54
    SubTest 55
    SubTest 56
    SubTest 57


    ret


StoreResult::
    ld [de], a
    inc de
    ret

    CGB_MODE
