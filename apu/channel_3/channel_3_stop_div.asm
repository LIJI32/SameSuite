RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 6

include "base.inc"

; Channel 3's stop timer is ticked by the DIV register at 512Hz. The
; sound stops instantly in the same cycle DIV's bit 5 turns from 1 to
; 0. (Or bit 4 in when in single speed mode). The length of the sound
; is ((255 - NR31) * 2 + 1) DIV-APU ticks.

CorrectResults:
db $3F, $3F, $40, $40, $BF, $BF, $C0, $C0
db $BF, $BF, $C0, $C0, $7F, $7F, $80, $80
db $0F, $0F, $00, $00, $0F, $0F, $0F, $0F
db $0F, $0F, $00, $00, $0F, $0F, $00, $00
db $F4, $F4, $F0, $F0, $F4, $F4, $F4, $F4
db $F4, $F4, $F0, $F0, $F4, $F4, $F0, $F0

SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    
    nops \3
    
    push hl
    ld hl, $ff30
    REPT 16
    ldi [hl], a
    ENDR
    pop hl
    
    ldh [rNR30], a
    ld a, \2
    ldh [rNR31], a
    ld a, $20
    ldh [rNR32], a
    ld a, $C0
    ldh [rNR34], a
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    
    nops \1
    
    ld a, [hl]
    call StoreResult
    xor a
    ldh [rNR52], a
    ENDM

RunTest:
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ld de, $c000
    
    ld hl, rDIV
    call SubTestGroup
    ld hl, rPCM34
    call SubTestGroup
    ld hl, rNR52
    call SubTestGroup
        
    ret

SubTestGroup:
    ; Length is 1, enabling length occurs when the DIV-divider is 0
    SubTest $ffc, $ff, 0
    SubTest $ffd, $ff, 0
    SubTest $ffe, $ff, 0
    SubTest $fff, $ff, 0
    
    ; Length is 1, but enabling length occurs while the DIV-divider is 1,
    ; causing the length counter to click at enable time, making the effective
    ; length 0, but since we're also triggering the sound at the same time, the
    ; length then becomes 256.
    SubTest $2ffc, $ff, $1000
    SubTest $2ffd, $ff, $1000
    SubTest $2ffe, $ff, $1000
    SubTest $2fff, $ff, $1000

    ; Length is 2, enabling length occurs when the DIV-divider is 0
    SubTest $2ffc, $fe, 0
    SubTest $2ffd, $fe, 0
    SubTest $2ffe, $fe, 0
    SubTest $2fff, $fe, 0

    ; Length is 1, but enabling length occurs while the DIV-divider is 1,
    ; causing the length counter to click at enable time, making the effective
    ; length 1. Verify sound stops at the correct time
    SubTest $1ffc, $fe, $1000
    SubTest $1ffd, $fe, $1000
    SubTest $1ffe, $fe, $1000
    SubTest $1fff, $fe, $1000
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE