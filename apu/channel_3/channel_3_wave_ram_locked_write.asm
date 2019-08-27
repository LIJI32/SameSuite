RESULTS_N_ROWS EQU 18 ; Max available
NB_RUNS EQU RESULTS_N_ROWS / 2 ; Only half a run can be displayed per row
NB_NOPS EQU NB_RUNS - 1


SECTION "Wave RAM test memory", WRAM0[$C000]

RESULTS_START::
    ds 16 * NB_RUNS
ResultsBufferEnd:

SelfModifyingCodeBuffer:
    ; ld [hl], imm8 = 2 bytes
    ; ldh [c], a = 1 byte
    ; ret = 1 byte
    ; The rest will be some NOPs
    ds 2 + 1 + 1 + NB_NOPS
SelfModifyingCodeBufferEnd:

SMCWritePtrLow:
    db


include "base.inc"

CH3_FREQ EQU 2047 ; CH3 ticks every 1 MHz

; The byte is written at the offset CH3 is currently reading
; Except on AGB, where the write is simply ignored
; TODO: does that affect the byte CH3 is reading? Probably not?
CorrectResults:
    db $2A,$11,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$2A,$22,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$2A,$33,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$22,$2A,$44,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$22,$33,$2A,$55,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$22,$33,$44,$2A,$66,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$22,$33,$44,$55,$2A,$77,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$22,$33,$44,$55,$66,$2A,$88,$99,$AA,$BB,$CC,$DD,$EE,$FF
    db $00,$11,$22,$33,$44,$55,$66,$77,$2A,$99,$AA,$BB,$CC,$DD,$EE,$FF

RunTest:
    ; Do init common to all sub-tests
    
    ; First, turn APU off and on again so all registers are reset
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ; Set audio to channel 3 only, full blast
    ; While sound output isn't strictly necessary, additional info is good for debugging
    ld a, $44
    ldh [rNR51], a
    ld a, $77
    ldh [rNR50], a
    ; Set CH3's output level and frequency low byte
    ld a, %00100000 ; 1/1
    ldh [rNR32], a
    ld a, LOW(CH3_FREQ)
    ldh [rNR33], a

    ; Write the self-modifying code buffer
    ld hl, SelfModifyingCodeBuffer
    ld a, $36 ; ld [hl], imm8
    ld [hli], a
    ld a, HIGH(CH3_FREQ) | $80
    ld [hli], a
    ; NOPs
    ld c, NB_NOPS
    xor a
.clearSMCBuffer
    ld [hli], a
    dec c
    jr nz, .clearSMCBuffer
    ld a, $E2 ; ldh [c], a
    ld [hli], a
    ld [hl], $C9 ; ret
    ld a, l
    ld [SMCWritePtrLow], a


    ld de, ResultsBufferEnd
.subTest
    ; Begin by initalizing wave RAM
    ; Pattern will be 01 23 45 67 89 AB CD EF to identify each nibble
    ld c, LOW(_AUD3WAVERAM)
    xor a
.initWaveRAM
    ldh [c], a
    inc c
    add a, $11
    jr nc, .initWaveRAM

    ; Now, enable the CH3 DAC
    ld a, $80
    ldh [rNR30], a
    ; And jump to the SMC buffer!
    call .doSubTest
    ; We can kill the channel now
    xor a
    ldh [rNR30], a

    ; Now, copy wave RAM to the results buffer
    ld bc, 16 << 8 | LOW(_AUD3WAVERAM + 16)
.copyWaveRAM
    dec c
    ldh a, [c]
    dec e ; dec de
    ld [de], a
    ret z ; Bail out if we finished writing the buffer
    dec b
    jr nz, .copyWaveRAM

    ; Remove a NOP from the SMC buffer
    ld hl, SMCWritePtrLow
    dec [hl]
    ld l, [hl]
    ld a, $C9 ; ret
    ld [hld], a
    ld [hl], $E2 ; ldh [c], a
    jr .subTest

.doSubTest
    ld hl, rNR34 ; For enabling CH3
    ld c, LOW(_AUD3WAVERAM + 6)
    ld a, $2A ; This is a value that's not in the buffer by default
    jp SelfModifyingCodeBuffer
