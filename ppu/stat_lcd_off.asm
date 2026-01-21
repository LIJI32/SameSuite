RESULTS_START EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

CorrectResults:
; The first byte is $E0 on CGB, since there is no STAT write bug there
db $E2, $E0, $00, $E0, $E0, $E0, $E0, $00

RunTest:
    ; Disable all interrupts
    di
    xor a
    ldh [rIE], a
    call LCDOn

    ; Wait for the first scanline of VBlank, to have more reliable PPU timing
.waitVBlank
    ldh a, [rLY]
    cp $90
    jr nz, .waitVBlank

    ; Clear any pending interrupts
    xor a
    ldh [rIF], a
    ; Request STAT to only occur on Mode 0
    ld a, STATF_MODE00
    ldh [rSTAT], a
    ; On DMG, this requests the interrupt due to the STAT write glitch
    ; (This is only part of the test's results as a sanity check)
    ldh a, [rIF]
    ld [RESULTS_START], a

    ; We must be in Mode 1 at this point, and turning the LCD off has STAT report Mode 0
    ; But does that actually request a Mode 0 interrupt?
    xor a
    ldh [rIF], a
    call LCDOff
    ldh a, [rIF]
    ld [RESULTS_START + 1], a

    ; While we're at this, check which scanline LY reports
    ldh a, [rLY]
    ld [RESULTS_START + 2], a
    inc a
    ldh [rLYC], a ; Ensure LYC doesn't match it

    ; Now, if we write to STAT, is the STAT write bug triggered?
    xor a
    ldh [rIF], a
    ld a, STATF_LYC
    ldh [rSTAT], a
    ldh a, [rIF]
    ld [RESULTS_START + 3], a

    ; The only condition active is LYC, which we ensured is not fulfilled;
    ; fulfill it, and see if the STAT interrupt is triggered
    xor a
    ldh [rIF], a
    ld a, [RESULTS_START + 2] ; Get back the value written earlier, in case LY changed fsr
    ldh [rLYC], a
    ldh a, [rIF]
    ld [RESULTS_START + 4], a

    ; What if we request Mode 1?
    xor a
    ldh [rIF], a
    ld a, STATF_MODE01
    ldh [rSTAT], a
    ldh a, [rIF]
    ld [RESULTS_START + 5], a

    ; Screw it, request everything! (The Xmas test of STAT write glitch...)
    xor a
    ldh [rIF], a
    ld a, $FF
    ldh [rSTAT], a
    ldh a, [rIF]
    ld [RESULTS_START + 6], a

    ; LY shouldn't change, and we need to pad the remaining byte somehow, so read it as
    ; a sanity check
    ldh a, [rLY]
    ld [RESULTS_START + 7], a
    ret
