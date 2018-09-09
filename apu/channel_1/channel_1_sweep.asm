RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 18

include "base.inc"

CorrectResults:

db $00, $00, $08, $08, $08, $08, $00, $00
db $00, $00, $08, $08, $08, $08, $00, $00
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $08, $08, $08, $08, $00, $00

db $00, $00, $08, $08, $08, $08, $00, $00
db $00, $00, $08, $08, $08, $08, $00, $00
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $00, $08, $08, $08, $08
db $00, $00, $00, $00, $00, $00, $00, $00
db $08, $08, $08, $08, $08, $08, $08, $08

db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $08, $08, $08
db $08, $08, $08, $08, $08, $08, $08, $08
db $08, $08, $08, $08, $08, $08, $08, $08
db $00, $00, $00, $00, $00, $00, $00, $00
db $00, $00, $00, $00, $00, $00, $00, $00

SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld a, \2
    nops $800 ; Let DIV tick the APU once, so we know we're aligned to the APU start time
    ldh [rNR10], a
    ld a, $80
    ldh [rNR11], a
    ld a, \3
    ldh [rNR13], a
    ld a, $80
    ldh [rNR12], a
    ld a, $87
    ldh [rNR14], a 
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    ld hl, rPCM12
    
    ; Round one: no sweep (sanity, for comparison)
    SubTest $0000, 0, $ff
    SubTest $0001, 0, $ff
    SubTest $0002, 0, $ff
    SubTest $0003, 0, $ff
    SubTest $0004, 0, $ff
    SubTest $0005, 0, $ff
    SubTest $0006, 0, $ff
    SubTest $0007, 0, $ff
    
    SubTest $0048, 0, $ff
    SubTest $0049, 0, $ff
    SubTest $004a, 0, $ff
    SubTest $004b, 0, $ff
    SubTest $004c, 0, $ff
    SubTest $004d, 0, $ff
    SubTest $004e, 0, $ff
    SubTest $004f, 0, $ff
    
    SubTest $0fee, 0, $ff
    SubTest $0fef, 0, $ff
    SubTest $0ff0, 0, $ff
    SubTest $0ff1, 0, $ff
    SubTest $0ff2, 0, $ff
    SubTest $0ff3, 0, $ff
    SubTest $0ff4, 0, $ff
    SubTest $0ff5, 0, $ff
    
    SubTest $0ff6, 0, $ff
    SubTest $0ff7, 0, $ff
    SubTest $0ff8, 0, $ff
    SubTest $0ff9, 0, $ff
    SubTest $0ffa, 0, $ff
    SubTest $0ffb, 0, $ff
    SubTest $0ffc, 0, $ff
    SubTest $0ffd, 0, $ff
    
    SubTest $0ffe, 0, $ff ; DIV ticks the APU at this moment, but no sweep is active
    SubTest $0fff, 0, $ff
    SubTest $1000, 0, $ff
    SubTest $1001, 0, $ff
    SubTest $1002, 0, $ff
    SubTest $1003, 0, $ff
    SubTest $1004, 0, $ff
    SubTest $1005, 0, $ff
    
    SubTest $1048, 0, $ff 
    SubTest $1049, 0, $ff
    SubTest $104a, 0, $ff
    SubTest $104b, 0, $ff
    SubTest $104c, 0, $ff
    SubTest $104d, 0, $ff
    SubTest $104e, 0, $ff
    SubTest $104f, 0, $ff
    
    ; Round two: Sweep after 1/128Hz
    ; Frequency is $7ff, sample length is 1, the "high" phase is 4 cycles long
    SubTest $0000, $1f, $ff
    SubTest $0001, $1f, $ff
    SubTest $0002, $1f, $ff
    SubTest $0003, $1f, $ff
    SubTest $0004, $1f, $ff
    SubTest $0005, $1f, $ff
    SubTest $0006, $1f, $ff
    SubTest $0007, $1f, $ff
    
    SubTest $0048, $1f, $ff
    SubTest $0049, $1f, $ff
    SubTest $004a, $1f, $ff
    SubTest $004b, $1f, $ff
    SubTest $004c, $1f, $ff
    SubTest $004d, $1f, $ff
    SubTest $004e, $1f, $ff
    SubTest $004f, $1f, $ff

    SubTest $0fee, $1f, $ff
    SubTest $0fef, $1f, $ff
    SubTest $0ff0, $1f, $ff
    SubTest $0ff1, $1f, $ff
    SubTest $0ff2, $1f, $ff
    SubTest $0ff3, $1f, $ff
    SubTest $0ff4, $1f, $ff
    SubTest $0ff5, $1f, $ff
    
    SubTest $0ff6, $1f, $ff
    SubTest $0ff7, $1f, $ff
    SubTest $0ff8, $1f, $ff
    SubTest $0ff9, $1f, $ff
    SubTest $0ffa, $1f, $ff
    SubTest $0ffb, $1f, $ff
    SubTest $0ffc, $1f, $ff
    SubTest $0ffd, $1f, $ff
    
    ; DIV ticks the APU at this moment. This point is 3 DIV-APU ticks after enabling the APU.
    ; Frequency is $7f0, sample length is $10, the "high" phase is $40 cycles long
    SubTest $0ffe, $1f, $ff 
    SubTest $0fff, $1f, $ff
    SubTest $1000, $1f, $ff
    SubTest $1001, $1f, $ff
    SubTest $1002, $1f, $ff
    SubTest $1003, $1f, $ff
    SubTest $1004, $1f, $ff
    SubTest $1005, $1f, $ff
    
    SubTest $1048, $1f, $ff 
    SubTest $1049, $1f, $ff
    SubTest $104a, $1f, $ff
    SubTest $104b, $1f, $ff
    SubTest $104c, $1f, $ff
    SubTest $104d, $1f, $ff
    SubTest $104e, $1f, $ff
    SubTest $104f, $1f, $ff
    
    
    ; Round three: Sweep after 2/128Hz
    ; Frequency is $7f0, sample length is $10, the "high" phase is $40 cycles long
    SubTest $0000, $27, $f0
    SubTest $0001, $27, $f0
    SubTest $0002, $27, $f0
    SubTest $0003, $27, $f0
    SubTest $0004, $27, $f0
    SubTest $0005, $27, $f0
    SubTest $0006, $27, $f0
    SubTest $0007, $27, $f0
    
    SubTest $0048, $27, $f0
    SubTest $0049, $27, $f0
    SubTest $004a, $27, $f0
    SubTest $004b, $27, $f0
    SubTest $004c, $27, $f0
    SubTest $004d, $27, $f0
    SubTest $004e, $27, $f0
    SubTest $004f, $27, $f0
    
    SubTest $2ff6, $27, $f0
    SubTest $2ff7, $27, $f0
    SubTest $2ff8, $27, $f0
    SubTest $2ff9, $27, $f0
    SubTest $2ffa, $27, $f0
    SubTest $2ffb, $27, $f0
    SubTest $2ffc, $27, $f0
    SubTest $2ffd, $27, $f0
    
    ; DIV ticks the APU at this moment
    ; Frequency is $7ff, sample length is 1, the "high" phase is 4 cycles long
    SubTest $2ffe, $27, $f0
    SubTest $2fff, $27, $f0
    SubTest $3000, $27, $f0
    SubTest $3001, $27, $f0
    SubTest $3002, $27, $f0
    SubTest $3003, $27, $f0
    SubTest $3004, $27, $f0
    SubTest $3005, $27, $f0
    
    ; 8 cycles after trigger, the APU checks if the NEXT trigger overflows the
    ; frequency. If it does, stop the channel.
    SubTest $3006, $27, $f0 
    SubTest $3007, $27, $f0
    SubTest $3008, $27, $f0
    SubTest $3009, $27, $f0
    SubTest $300a, $27, $f0
    SubTest $300b, $27, $f0
    SubTest $300c, $27, $f0
    SubTest $300d, $27, $f0
    
    SubTest $300e, $27, $f0 
    SubTest $300f, $27, $f0
    SubTest $3010, $27, $f0
    SubTest $3011, $27, $f0
    SubTest $3012, $27, $f0
    SubTest $3013, $27, $f0
    SubTest $3014, $27, $f0
    SubTest $3015, $27, $f0
    
    ret

StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
