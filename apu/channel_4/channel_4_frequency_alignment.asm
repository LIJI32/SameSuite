RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 18

include "base.inc"

CorrectResults:
db $00, $00, $00, $F0, $F0, $F0, $F0, $F0 ; $09, affected
db $00, $00, $F0, $F0, $F0, $F0, $F0, $F0 ; $18, not affected
db $00, $00, $00, $F0, $F0, $F0, $F0, $F0 ; $0a, affected
db $00, $00, $00, $00, $F0, $F0, $F0, $F0 ; $28, not affected
db $00, $00, $00, $00, $00, $F0, $F0, $F0 ; $0b, affected
db $00, $00, $00, $F0, $F0, $F0, $F0, $F0 ; $1a, affected
db $00, $00, $00, $F0, $F0, $F0, $F0, $F0 ; $0c, affected
db $00, $00, $00, $00, $00, $F0, $F0, $F0 ; $29, affected
db $00, $00, $00, $00, $F0, $F0, $F0, $F0 ; $38, not affected

db $00, $00, $F0, $F0, $F0, $F0, $F0, $F0
db $00, $00, $F0, $F0, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $00, $00, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0
db $00, $00, $00, $00, $F0, $F0, $F0, $F0

SubTest: MACRO
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a

    nops \3 + 2

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


    ; Sample is 4 cycles long

    SubTest $018, $9, 0
    SubTest $019, $9, 0
    SubTest $01a, $9, 0
    SubTest $01b, $9, 0
    SubTest $01c, $9, 0
    SubTest $01d, $9, 0
    SubTest $01e, $9, 0
    SubTest $01f, $9, 0

    ; Sample is 4 cycles long (expressed differently)

    SubTest $018, $18, 0
    SubTest $019, $18, 0
    SubTest $01a, $18, 0
    SubTest $01b, $18, 0
    SubTest $01c, $18, 0
    SubTest $01d, $18, 0
    SubTest $01e, $18, 0
    SubTest $01f, $18, 0

    ; Sample is 8 cycles long

    SubTest $030, $a, 0
    SubTest $031, $a, 0
    SubTest $032, $a, 0
    SubTest $033, $a, 0
    SubTest $034, $a, 0
    SubTest $035, $a, 0
    SubTest $036, $a, 0
    SubTest $037, $a, 0

    ; Sample is 8 cycles long (expressed differently)

    SubTest $030, $28, 0
    SubTest $031, $28, 0
    SubTest $032, $28, 0
    SubTest $033, $28, 0
    SubTest $034, $28, 0
    SubTest $035, $28, 0
    SubTest $036, $28, 0
    SubTest $037, $28, 0
    
    ; Sample is 12 cycles long
    
    SubTest $048, $0B, 0
    SubTest $049, $0B, 0
    SubTest $04a, $0B, 0
    SubTest $04b, $0B, 0
    SubTest $04c, $0B, 0
    SubTest $04d, $0B, 0
    SubTest $04e, $0B, 0
    SubTest $04f, $0B, 0
    
    ; Sample is 16 cycles long (Next 4 tests)
    
    SubTest $064, $1A, 0
    SubTest $065, $1A, 0
    SubTest $066, $1A, 0
    SubTest $067, $1A, 0
    SubTest $068, $1A, 0
    SubTest $069, $1A, 0
    SubTest $06a, $1A, 0
    SubTest $06b, $1A, 0
    
    SubTest $064, $0C, 0
    SubTest $065, $0C, 0
    SubTest $066, $0C, 0
    SubTest $067, $0C, 0
    SubTest $068, $0C, 0
    SubTest $069, $0C, 0
    SubTest $06a, $0C, 0
    SubTest $06b, $0C, 0
        
    SubTest $064, $29, 0
    SubTest $065, $29, 0
    SubTest $066, $29, 0
    SubTest $067, $29, 0
    SubTest $068, $29, 0
    SubTest $069, $29, 0
    SubTest $06a, $29, 0
    SubTest $06b, $29, 0
        
    SubTest $064, $38, 0
    SubTest $065, $38, 0
    SubTest $066, $38, 0
    SubTest $067, $38, 0
    SubTest $068, $38, 0
    SubTest $069, $38, 0
    SubTest $06a, $38, 0
    SubTest $06b, $38, 0
    
    ; Run the same tests again, with one extra NOP
    
    ; Sample is 4 cycles long
    
    SubTest $018, $9, 1
    SubTest $019, $9, 1
    SubTest $01a, $9, 1
    SubTest $01b, $9, 1
    SubTest $01c, $9, 1
    SubTest $01d, $9, 1
    SubTest $01e, $9, 1
    SubTest $01f, $9, 1
    
    ; Sample is 4 cycles long (expressed differently)
    
    SubTest $018, $18, 1
    SubTest $019, $18, 1
    SubTest $01a, $18, 1
    SubTest $01b, $18, 1
    SubTest $01c, $18, 1
    SubTest $01d, $18, 1
    SubTest $01e, $18, 1
    SubTest $01f, $18, 1
    
    ; Sample is 8 cycles long
    
    SubTest $030, $a, 1
    SubTest $031, $a, 1
    SubTest $032, $a, 1
    SubTest $033, $a, 1
    SubTest $034, $a, 1
    SubTest $035, $a, 1
    SubTest $036, $a, 1
    SubTest $037, $a, 1
    
    ; Sample is 8 cycles long (expressed differently)
    
    SubTest $030, $28, 1
    SubTest $031, $28, 1
    SubTest $032, $28, 1
    SubTest $033, $28, 1
    SubTest $034, $28, 1
    SubTest $035, $28, 1
    SubTest $036, $28, 1
    SubTest $037, $28, 1
    
    ; Sample is 12 cycles long
    
    SubTest $048, $0B, 1
    SubTest $049, $0B, 1
    SubTest $04a, $0B, 1
    SubTest $04b, $0B, 1
    SubTest $04c, $0B, 1
    SubTest $04d, $0B, 1
    SubTest $04e, $0B, 1
    SubTest $04f, $0B, 1
    
    ; Sample is 16 cycles long (Next 4 tests)
    
    SubTest $064, $1A, 0
    SubTest $065, $1A, 1
    SubTest $066, $1A, 1
    SubTest $067, $1A, 1
    SubTest $068, $1A, 1
    SubTest $069, $1A, 1
    SubTest $06a, $1A, 1
    SubTest $06b, $1A, 1
    
    SubTest $064, $0C, 1
    SubTest $065, $0C, 1
    SubTest $066, $0C, 1
    SubTest $067, $0C, 1
    SubTest $068, $0C, 1
    SubTest $069, $0C, 1
    SubTest $06a, $0C, 1
    SubTest $06b, $0C, 1
        
    SubTest $064, $29, 1
    SubTest $065, $29, 1
    SubTest $066, $29, 1
    SubTest $067, $29, 1
    SubTest $068, $29, 1
    SubTest $069, $29, 1
    SubTest $06a, $29, 1
    SubTest $06b, $29, 1
        
    SubTest $064, $38, 1
    SubTest $065, $38, 1
    SubTest $066, $38, 1
    SubTest $067, $38, 1
    SubTest $068, $38, 1
    SubTest $069, $38, 1
    SubTest $06a, $38, 1
    SubTest $06b, $38, 1

    ret


StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
