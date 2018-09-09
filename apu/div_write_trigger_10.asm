RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; This test verifies that starting the APU while bit 4
; of the DIV register is set causes the APU to skip the
; first DIV-APU event

CorrectResults:

db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F1, $F1, $F0, $F0, $F0, $F0, $F0, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F1, $F1, $F1, $F1, $F0, $F0, $F0, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F1, $F1, $F1, $F1, $F1, $F1, $F0, $F0
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0
db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F1, $F1, $F0, $F0, $F0, $F0, $F0, $F0
db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F1, $F1, $F1, $F1, $F0, $F0, $F0, $F0
db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1
db $F1, $F1, $F1, $F1, $F1, $F1, $F0, $F0



TriggerAPU:
    call WaitDIV10
    ld [hl], a
    ret

WaitDIV10:
    ld a, $10
.waitDIV 
    cp [hl]
    jr nz, .waitDIV
    ret

SubTest: MACRO
    ld hl, rDIV
    ld [hl], a
    call WaitDIV10

    ld c, rNR52 & $FF
    xor a
    ld [c], a
    cpl
    ld [c], a    
    ldh [rNR13], a
    ld a, $BF - \1
    ldh [rNR11], a
    ldh [rNR12], a


    ld a, $C1
    ldh [rNR14], a
REPT \2
    call TriggerAPU
ENDR
    ld a, [c]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000

    SubTest 0, $0
    SubTest 0, $1
    SubTest 0, $2
    SubTest 0, $3
    SubTest 0, $4
    SubTest 0, $5
    SubTest 0, $6
    SubTest 0, $7
    SubTest 0, $8
    SubTest 0, $9
    SubTest 0, $A
    SubTest 0, $B
    SubTest 0, $C
    SubTest 0, $D
    SubTest 0, $E
    SubTest 0, $F
    
    
    SubTest 1, $0
    SubTest 1, $1
    SubTest 1, $2
    SubTest 1, $3
    SubTest 1, $4
    SubTest 1, $5
    SubTest 1, $6
    SubTest 1, $7
    SubTest 1, $8
    SubTest 1, $9
    SubTest 1, $A
    SubTest 1, $B
    SubTest 1, $C
    SubTest 1, $D
    SubTest 1, $E
    SubTest 1, $F
    
    
    SubTest 2, $0
    SubTest 2, $1
    SubTest 2, $2
    SubTest 2, $3
    SubTest 2, $4
    SubTest 2, $5
    SubTest 2, $6
    SubTest 2, $7
    SubTest 2, $8
    SubTest 2, $9
    SubTest 2, $A
    SubTest 2, $B
    SubTest 2, $C
    SubTest 2, $D
    SubTest 2, $E
    SubTest 2, $F
    
    
    SubTest 3, $0
    SubTest 3, $1
    SubTest 3, $2
    SubTest 3, $3
    SubTest 3, $4
    SubTest 3, $5
    SubTest 3, $6
    SubTest 3, $7
    SubTest 3, $8
    SubTest 3, $9
    SubTest 3, $A
    SubTest 3, $B
    SubTest 3, $C
    SubTest 3, $D
    SubTest 3, $E
    SubTest 3, $F
    
    
    SubTest 4, $0
    SubTest 4, $1
    SubTest 4, $2
    SubTest 4, $3
    SubTest 4, $4
    SubTest 4, $5
    SubTest 4, $6
    SubTest 4, $7
    SubTest 4, $8
    SubTest 4, $9
    SubTest 4, $A
    SubTest 4, $B
    SubTest 4, $C
    SubTest 4, $D
    SubTest 4, $E
    SubTest 4, $F
    
    
    SubTest 5, $0
    SubTest 5, $1
    SubTest 5, $2
    SubTest 5, $3
    SubTest 5, $4
    SubTest 5, $5
    SubTest 5, $6
    SubTest 5, $7
    SubTest 5, $8
    SubTest 5, $9
    SubTest 5, $A
    SubTest 5, $B
    SubTest 5, $C
    SubTest 5, $D
    SubTest 5, $E
    SubTest 5, $F
    
    
    SubTest 6, $0
    SubTest 6, $1
    SubTest 6, $2
    SubTest 6, $3
    SubTest 6, $4
    SubTest 6, $5
    SubTest 6, $6
    SubTest 6, $7
    SubTest 6, $8
    SubTest 6, $9
    SubTest 6, $A
    SubTest 6, $B
    SubTest 6, $C
    SubTest 6, $D
    SubTest 6, $E
    SubTest 6, $F
    
    
    SubTest 7, $0
    SubTest 7, $1
    SubTest 7, $2
    SubTest 7, $3
    SubTest 7, $4
    SubTest 7, $5
    SubTest 7, $6
    SubTest 7, $7
    SubTest 7, $8
    SubTest 7, $9
    SubTest 7, $A
    SubTest 7, $B
    SubTest 7, $C
    SubTest 7, $D
    SubTest 7, $E
    SubTest 7, $F

    ret


StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
