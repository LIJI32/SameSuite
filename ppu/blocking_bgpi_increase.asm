RESULTS_START EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

CorrectResults:
; Bit 6 is always set, bits 0-5 reflect the current value, TODO: what about bit 7?
db $C4, $C5, $C4, $C5, $C4, $C5, $C4, $C5


TEST0_STAT EQU STATF_MODE00
TEST1_STAT EQU STATF_MODE01
TEST2_STAT EQU STATF_MODE10
TEST3_STAT EQU STATF_MODE10

SubTest: MACRO
    ; Set STAT to trigger on the mode we want
    ld a, TEST\1_STAT
    ldh [rSTAT], a
    ld a, $84
    ld [$ff00+c], a ; Write to BCPS, enabling auto-increment (on writes only!!)
    ld a, [$ff00+c] ; Immediately read it again, just to be sure it's correctly emulated as-is
    ld [hli], a
    xor a

    IF \1 != 3
    ; Clear any pending interrupts, we need the write to trigger at the correct time
    ei ; Allow the write to occur
    ldh [rIF], a
    ; (Note: ei actually takes effect here)

    ELSE
    ; Unfortunately there's no way to trigger the interrupt in Mode 3
    ; Therefore, we will delay the interrupt trigger manually
    ldh [rIF], a
    halt ; Wait until Mode 2
    ; Delay a bit, Mode 2 normally takes 20 "nop" cycles but we'll be lenient
    ld a, 20 / 4 + 2 ; Each iteration delays by 4 cycles except the last
.delay\@
    dec a
    jr nz, .delay\@
    ei ; Now allow the write to occur, we're in Mode 3
    ENDC

.waitWrite\@
    jr z, .waitWrite\@ ; Wait until the interrupt triggered, which clears the Z flag
    ld a, [$ff00+c] ; Read BCPS again, to see if it incremented
    ld [hli], a
ENDM

RunTest:
    ld hl, $c000
    ld c, LOW(rBCPS)
    ; Ensure the test doesn't trigger spuriously
    xor a
    ldh [rSTAT], a
    ld a, IEF_LCDC
    ldh [rIE], a
    di
    ; Make sure to not turn on the LCD before writing to all interrupt regs, to avoid breakage
    call LCDOn

    SubTest 0
    SubTest 1
    SubTest 2
    SubTest 3
    
    jp LCDOff ; The results screen expects the PPU to be off


SECTION "LCD handler", ROM0[$48]
    xor a ; Purposefully trash the Z flag to signal completion
    ldh [rBCPD], a
    inc a
    ret ; Keep interrupts disabled to avoid spurious writes

    CGB_MODE
