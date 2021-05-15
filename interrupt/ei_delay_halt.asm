; Tests the behavior of `halt` just after `ei` while an interrupt is buffered
; Expected behavior: the buffered interrupt is handled, but does NOT exit `halt`.


RESULTS_N_ROWS EQU 1

SECTION "Variables", WRAM0[$C000]

RESULTS_START:
    ds RESULTS_N_ROWS * 8

wSPSave:
    dw


include "base.inc"

CorrectResults:
;   L    H    E    D    C    B    F    A
db $FF, $FF, $FF, $FF, $FE, $00, $00, $02
; Only the last four are meaningful:
; A is 2 without HALT bug, 3 with
; F is $00 if `inc a` was last, $04 if `dec c` was last, $0A if `inc b` was last
; B is $FF if the VBlank int didn't trigger, $00 otherwise
; C is $FF if the timer int didn't trigger, $FE otherwise

RunTest:
    ; We need to buffer an interrupt, but we want to fully control when it occurs
    ; We'll use the VBlank handler, and turn the LCD off to be sure that it won't
    ; be naturally requested.
    ; We will also enable and schedule a timer interrupt, so that emulators don't
    ; hang on the `halt` should things go wrong.
    call LCDOff
    ; Reset DIV, TIMA, and TMA to make the test more consistent
    xor a
    ldh [rDIV], a
    ldh [rTIMA], a
    ldh [rTMA], a
    ; Start timer
    ld a, TACF_START
    ldh [rTAC], a


    ; Set all registers to known values (0)
    ld b, $FF
    ld c, b
    ld d, b
    ld e, b
    ld h, b
    ld l, b

    ; Buffer an interrupt
    di
    ld a, IEF_VBLANK | IEF_TIMER
    ldh [rIE], a
    ld a, IEF_VBLANK
    ldh [rIF], a
    ; `ei` is delayed by one instruction; will this trigger the HALT bug?
    ei
    halt
    inc a


    ; Write all registers
    ; Note that none of these instructions affect flags
    ld [wSPSave], sp
    ld sp, RESULTS_START + 8
    push af
    push bc
    push de
    push hl

    ; Restore the old stack pointer and return
    ld sp, wSPSave
    pop hl
    ld sp, hl
    ; The results screen expects the PPU to be off
    ret


SECTION "VBlank handler", ROM0[$40]
    inc b
    reti

SECTION "Timer handler", ROM0[$50]
    dec c
    reti
