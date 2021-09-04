; Tests the behavior of `halt` just after `ei` while an interrupt is buffered
; Expected behavior: the buffered interrupt is handled, but does NOT exit `halt`.


RESULTS_N_ROWS EQU 4

SECTION "Variables", WRAM0[$C000]

; Each interrupt handler pushes 6 bytes, so we have room here for 5
; There is also the very last push!
RESULTS_START:
    ds RESULTS_N_ROWS * 8
.end

wSPSave:
    dw


include "base.inc"

; Each interrupt pushes on the stack, so the results should be read right to left.
; The interrupt pushes, from left to right: int type, return addr, AF (`daa` counter)
; The "int type" is $xxF0, where $xx is the low byte of the handler's address
;
; AF cycles like this:
; $69F0 (start), $0350, $A350, $4350, $E350, $8350, $2350, $C350, $6350, $0350 again, repeat
; Make sure your DAA implementation is up to snuff! :)
; Thus, we can use AF to observe how many times the `daa` has been executed

CorrectResults:
; We left extra room for faulty implementations, but these are normally empty
dw $BEEF, $BEEF, $BEEF, $BEEF
dw $BEEF, $BEEF
; This is the last vlaue of AF we ended up with
dw $0350 ; `daa` only executed once
dw $50F0, RunTest.halt + 1, $69F0 ; Timer int is last ($50), returns after `halt`, no `daa`
dw $48F0, RunTest.halt,     $69F0 ; STAT int is 2nd   ($48), returns into `halt`,  no `daa`
dw $40F0, RunTest.halt,     $69F0 ; VBlank int first  ($40), returns into `halt`,  no `daa`

RunTest:
    ; We need to buffer an interrupt, but we want to fully control when it occurs
    ; We'll use the VBlank and STAT ints, so turn the LCD off to be sure that they
    ; won't be naturally requested.
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

    ; We will use the stack to push results, but we will also need it to return to
    ; the testing framework
    ld [wSPSave], sp
    ; Init the "event queue"
    ld sp, RESULTS_START.end
    ld hl, $BEEF
REPT RESULTS_N_ROWS * 4
    push hl
ENDR
    ld sp, RESULTS_START.end


    ; Buffer an interrupt
    di
    ld a, IEF_VBLANK | IEF_LCDC | IEF_TIMER
    ldh [rIE], a
    ld a, IEF_VBLANK | IEF_LCDC
    ldh [rIF], a

    ; Set up AF for "status counter"
    ld de, $69F0
    push de
    pop af
    ; `ei` is delayed by one instruction; will this trigger the HALT bug?
    ei
.halt
    halt
    daa

    push af


    ; Restore the old stack pointer and return
    ld sp, wSPSave
    pop hl
    ld sp, hl
    ; The results screen expects the PPU to be off
    ret


SECTION "VBlank handler", ROM0[$40]
    pop hl
    push af
    ld d, $40
    push hl
    push de
    push hl
    reti

SECTION "STAT handler", ROM0[$48]
    pop hl
    push af
    ld d, $48
    push hl
    push de
    push hl
    reti

SECTION "Timer handler", ROM0[$50]
    pop hl
    push af
    ld d, $50
    push hl
    push de
    push hl
    reti
