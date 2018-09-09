RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 18

include "base.inc"

; Several tests involving restarting the channel while
; sweep is active

CorrectResults:

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $08, $08, $08, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $08, $08, $08, $08, $08, $08, $08, $08
db $08, $08, $00, $00, $00, $00, $08, $08
db $08, $08, $08, $08, $08, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $08, $08, $08, $08, $08, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f0
db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f0, $f0, $f0
db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
db $f1, $f1, $f1, $f1, $f1, $f0, $f0, $f0
db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0


SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld a, \5
    nops $800 ; Let DIV tick the APU once, so we know we're aligned to the APU start time
    ldh [rNR10], a
    ld a, $80
    ldh [rNR11], a
    ld a, \4
    ldh [rNR13], a
    ld a, $80
    ldh [rNR12], a
    ld a, $87
    ldh [rNR14], a 
    ld a, \3
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    nops $0ffe ; Tick DIV
    ldh [\2], a
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    ld hl, rPCM12
    
    ; SubTest Time, Register to Write, Value to Write, Initial Frequency, Initial Sweep
    
    ; Round 1
    ; Start at frequency $7ff, then let DIV tick so it becomes $7f0.
    ; Then, we restart the channel. This round verify the restarted sound
    ; retains the new ($7f0) frequency.
    
    
    SubTest $0000, rNR14, $87, $ff, $1f
    SubTest $0001, rNR14, $87, $ff, $1f
    SubTest $0002, rNR14, $87, $ff, $1f
    SubTest $0003, rNR14, $87, $ff, $1f
    SubTest $0004, rNR14, $87, $ff, $1f
    SubTest $0005, rNR14, $87, $ff, $1f
    SubTest $0006, rNR14, $87, $ff, $1f
    SubTest $0007, rNR14, $87, $ff, $1f
    
    SubTest $0008, rNR14, $87, $ff, $1f
    SubTest $0009, rNR14, $87, $ff, $1f
    SubTest $000a, rNR14, $87, $ff, $1f
    SubTest $000b, rNR14, $87, $ff, $1f
    SubTest $000c, rNR14, $87, $ff, $1f
    SubTest $000d, rNR14, $87, $ff, $1f
    SubTest $000e, rNR14, $87, $ff, $1f
    SubTest $000f, rNR14, $87, $ff, $1f
    
.round_6
    ; Round 2
    ; Start at frequency $7f0, then let DIV tick so it becomes $7ff.
    ; The channel should stop after 8 cycles, but we restart it before
    ; then.
    SubTest $0000, rNR14, $87, $f0, $17
    SubTest $0001, rNR14, $87, $f0, $17
    SubTest $0002, rNR14, $87, $f0, $17
    SubTest $0003, rNR14, $87, $f0, $17
    SubTest $0004, rNR14, $87, $f0, $17
    SubTest $0005, rNR14, $87, $f0, $17
    SubTest $0006, rNR14, $87, $f0, $17
    SubTest $0007, rNR14, $87, $f0, $17
    
    SubTest $0008, rNR14, $87, $f0, $17
    SubTest $0009, rNR14, $87, $f0, $17
    SubTest $000a, rNR14, $87, $f0, $17
    SubTest $000b, rNR14, $87, $f0, $17
    SubTest $000c, rNR14, $87, $f0, $17
    SubTest $000d, rNR14, $87, $f0, $17
    SubTest $000e, rNR14, $87, $f0, $17
    SubTest $000f, rNR14, $87, $f0, $17
    
    ; Round 3
    ; Start at frequency $7f0, then let DIV tick so it becomes $7ff. Due to an
    ; APU bug, the channel should stop after 8 cycles, but we disable sweep
    ; before then
    SubTest $0000, rNR10, 0, $f0, $17
    SubTest $0001, rNR10, 0, $f0, $17
    SubTest $0002, rNR10, 0, $f0, $17
    SubTest $0003, rNR10, 0, $f0, $17
    SubTest $0004, rNR10, 0, $f0, $17
    SubTest $0005, rNR10, 0, $f0, $17
    SubTest $0006, rNR10, 0, $f0, $17
    SubTest $0007, rNR10, 0, $f0, $17
    
    SubTest $0008, rNR10, 0, $f0, $17
    SubTest $0009, rNR10, 0, $f0, $17
    SubTest $000a, rNR10, 0, $f0, $17
    SubTest $000b, rNR10, 0, $f0, $17
    SubTest $000c, rNR10, 0, $f0, $17
    SubTest $000d, rNR10, 0, $f0, $17
    SubTest $000e, rNR10, 0, $f0, $17
    SubTest $000f, rNR10, 0, $f0, $17

    ; Round 4
    ; Start at frequency $7f0, then let DIV tick so it becomes $7ff. Due to an
    ; APU bug, the channel should stop after 8 cycles, change the sweep shift
    ; before then.
    
    SubTest $0000, rNR10, $11, $f0, $17
    SubTest $0001, rNR10, $11, $f0, $17
    SubTest $0002, rNR10, $11, $f0, $17
    SubTest $0003, rNR10, $11, $f0, $17
    SubTest $0004, rNR10, $11, $f0, $17
    SubTest $0005, rNR10, $11, $f0, $17
    SubTest $0006, rNR10, $11, $f0, $17
    SubTest $0007, rNR10, $11, $f0, $17
    
    SubTest $0008, rNR10, $11, $f0, $17
    SubTest $0009, rNR10, $11, $f0, $17
    SubTest $000a, rNR10, $11, $f0, $17
    SubTest $000b, rNR10, $11, $f0, $17
    SubTest $000c, rNR10, $11, $f0, $17
    SubTest $000d, rNR10, $11, $f0, $17
    SubTest $000e, rNR10, $11, $f0, $17
    SubTest $000f, rNR10, $11, $f0, $17
    
    ; Round 5
    ; Start at frequency $7f0, then let DIV tick so it becomes $7ff. Due to an
    ; APU bug, the channel should stop after 8 cycles, rewrite NR10's value
    ; before then.
    
    SubTest $0000, rNR10, $17, $f0, $17
    SubTest $0001, rNR10, $17, $f0, $17
    SubTest $0002, rNR10, $17, $f0, $17
    SubTest $0003, rNR10, $17, $f0, $17
    SubTest $0004, rNR10, $17, $f0, $17
    SubTest $0005, rNR10, $17, $f0, $17
    SubTest $0006, rNR10, $17, $f0, $17
    SubTest $0007, rNR10, $17, $f0, $17
    
    SubTest $0008, rNR10, $17, $f0, $17
    SubTest $0009, rNR10, $17, $f0, $17
    SubTest $000a, rNR10, $17, $f0, $17
    SubTest $000b, rNR10, $17, $f0, $17
    SubTest $000c, rNR10, $17, $f0, $17
    SubTest $000d, rNR10, $17, $f0, $17
    SubTest $000e, rNR10, $17, $f0, $17
    SubTest $000f, rNR10, $17, $f0, $17
    
    
    ; Run rounds 2-5 testing NR52 instead of PCM12 as round 6-9
    ld a, l
    cp rPCM12 & $ff
    ret nz
    ld l, rNR52 & $ff
    jp .round_6
    

StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
