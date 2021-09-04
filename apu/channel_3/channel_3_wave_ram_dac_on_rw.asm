; This test verifies the behavior of reading and writing to wave RAM
; to wave RAM while CH3's DAC is active ($80 → NR30),
; but the channel is inactive (NR34 bit 7 never gets set)


RESULTS_N_ROWS EQU 6

SECTION "Results", WRAM0

RESULTS_START:
    ds RESULTS_N_ROWS * 8

include "base.inc"

CorrectResults:
    db $00,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF ; Initial
    db $00,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF ; Read while active
    db $00,$11,$45,$33,$44,$2A,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$04,$FF ; Write while active
.end

RunTest:
    ; First, turn APU off and on again so all registers are reset
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ; Set audio to channel 3 only, full blast
    ; While sound output isn't strictly necessary, additional info is good for debugging
    ; Note that the channel may not be active, but the DAC still will be, and this may make a difference on AGB
    ld a, $44
    ldh [rNR51], a
    ld a, $77
    ldh [rNR50], a
    ; Set CH3's output level and frequency low byte
    ld a, %00100000 ; 1/1
    ldh [rNR32], a

    ; Begin by initalizing wave RAM
    ; Pattern will be 01 23 45 67 89 AB CD EF to identify each nibble
    ld c, LOW(_AUD3WAVERAM)
    xor a
.initWaveRAM
    ldh [c], a
    inc c
    add a, $11
    jr nc, .initWaveRAM

    ld hl, RESULTS_START
    ; Read once while inactive
    call ReadWaveRAM

    ; Now, enable the CH3 DAC
    ld a, $80
    ldh [rNR30], a
    ; See if the data read is any different (it shouldn't)
    call ReadWaveRAM

    ; Write to a couple of places in wave RAM in this state
    ld a, 42
    ldh [_AUD3WAVERAM + 5], a
    ld a, 69
    ldh [_AUD3WAVERAM + 2], a
    ld a, 4
    ldh [_AUD3WAVERAM + 14], a
    ; Kill the channel now to read wave RAM 100% safely
    xor a
    ldh [rNR30], a
    ; fallthrough


ReadWaveRAM:
    ld bc, 16 << 8 | LOW(_AUD3WAVERAM)
.loop
    ldh a, [c]
    inc c
    ld [hli], a
    dec b
    jr nz, .loop
    ret
