RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 4

include "base.inc"

; This test measures the delay between between the NR44 write and
; the first sample. Although SameBoy does pass this test, I'm not
; completely sure about this logic yet. It appears to be related
; to how the noise frequency is made out of two different values.
; Generally speaking, the delay is `sample length + 3` M-cycles,
; but it might be one M-cycle more or less.
; For more details, see channel_4_frequency_alignment.

CorrectResults:
db $00, $00, $00, $00, $00, $F0, $F0, $F0
db $00, $00, $00, $00, $00, $F0, $F0, $F0
db $00, $00, $F0, $F0, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
        
    ld hl, rPCM34
    ld a, $F0
    ldh [rNR42], a
    ld a, \2
    ldh [rNR43], a
    ld a, $80
    ldh [rNR44], a
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    
    ld de, $c000
    xor a
    ld [de], a
    
    ; The values in this test are not affected by "frequency alignment"
    
    ; Frequency is 512KHz, each sample is 2 cycles long

    SubTest $008, $8
    SubTest $009, $8
    SubTest $00a, $8
    SubTest $00b, $8
    SubTest $00c, $8
    SubTest $00d, $8
    SubTest $00e, $8
    SubTest $00f, $8

    
    ; Frequency is 512KHz, each sample is 2 cycles long, but we use 15 bit LFSR
    
    SubTest $018, $0
    SubTest $019, $0
    SubTest $01a, $0
    SubTest $01b, $0
    SubTest $01c, $0
    SubTest $01d, $0
    SubTest $01e, $0
    SubTest $01f, $0
    
    ; Frequency is 256KHz, each sample is 4 cycles long
    
    SubTest $018, $18
    SubTest $019, $18
    SubTest $01a, $18
    SubTest $01b, $18
    SubTest $01c, $18
    SubTest $01d, $18
    SubTest $01e, $18
    SubTest $01f, $18
    
    
    ; Frequency is 128KHz, each sample is 8 cycles long
    
    SubTest $030, $28
    SubTest $031, $28
    SubTest $032, $28
    SubTest $033, $28
    SubTest $034, $28
    SubTest $035, $28
    SubTest $036, $28
    SubTest $037, $28
    
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
