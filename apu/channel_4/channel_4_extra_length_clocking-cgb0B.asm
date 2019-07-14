RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 3

include "base.inc"

; "Extra length clocking occurs when writing to NRx4 when the frame
; sequencer's next step is one that doesn't clock the length counter.
;
; In this case, if the length counter was PREVIOUSLY disabled
; and now enabled and the length counter is not zero, it
; is decremented.
;
; On revisions <= CPU CGB B, the length counter only has to have been
; disabled before; the current length enable state doesn't matter.
; This breaks at least one game (Prehistorik Man), and was fixed on
; CPU CGB C."
;
; Test written by Matt Currie.

CorrectResults:
db $F8, $F8, $F0, $F0, $F0, $F0, $F0, $F0
db $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8
db $F8, $F8, $F0, $F0, $F0, $F0, $F0, $F0


SubTest: MACRO
    ld hl, rNR52
    ld [rDIV], a
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a

    ld a, 64 - \2
    ldh [rNR41], a

    ld a, $F0
    ld [rNR42], a

    ld a, $80
    ldh [rNR44], a

    nops \1

    REPT \3

    ld a, $00
    ldh [rNR44], a

    ENDR

    ld a, [hl]
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    
    ld a, 1
    ldh [rKEY1], a
    stop
    
    ; Delay, Length Counter, Number of writes
    SubTest $FE2, 1, 1 
    SubTest $FE3, 1, 1 
    SubTest $FE4, 1, 1 
    SubTest $FE5, 1, 1 
    SubTest $FE6, 1, 1 
    SubTest $FE7, 1, 1 
    SubTest $FE8, 1, 1 
    SubTest $FE9, 1, 1 
           
    SubTest $FE2, 2, 1 
    SubTest $FE3, 2, 1 
    SubTest $FE4, 2, 1 
    SubTest $FE5, 2, 1 
    SubTest $FE6, 2, 1 
    SubTest $FE7, 2, 1 
    SubTest $FE8, 2, 1 
    SubTest $FE9, 2, 1 
           
    SubTest $FE2, 2, 2 
    SubTest $FE3, 2, 2 
    SubTest $FE4, 2, 2 
    SubTest $FE5, 2, 2 
    SubTest $FE6, 2, 2 
    SubTest $FE7, 2, 2 
    SubTest $FE8, 2, 2 
    SubTest $FE9, 2, 2 
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    