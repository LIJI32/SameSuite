RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; Restarting channel 3 in the middle of a sample takes effect after
; the same delay calculation as in channel_3_delay. The previous
; sample remains playing until the first "phantom" sample finishes,
; then the new pulse starts with sample 2, as described in
; channel_3_first_sample.


CorrectResults:
db $0F, $0F, $0F, $0F, $0F, $0E, $0E, $0E

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ld hl, $ff31
    ldh [rNR52], a

    REPT 15
    ldi [hl], a
    ENDR

    ld hl, rPCM34
    ldh [rNR30], a
    ld a, $de
    ldh [$ff30], a
    ld a, $20
    ldh [rNR32], a
    ld a, $87
    ldh [rNR34], a

    nops $280 ; Let the sound play for a while
    ldh [rNR34], a ; Restart the sound and see what happens
    nops \1

    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld a, 1
    ldh [rKEY1], a
    stop

    ld de, $c000

    ; Wave length is $2000 T-Cycles, so each sample is $100 M-Cycles long
    SubTest $0
    SubTest $1
    SubTest $0FE
    SubTest $0FF
    SubTest $100
    SubTest $101
    SubTest $102
    SubTest $103

    ret


StoreResult::
    ld [de], a
    inc de
    ret

    CGB_MODE
