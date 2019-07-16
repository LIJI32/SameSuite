RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 4

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
; On CPU CGB, CH3 requires ONE write to disable the channel when 
; the length counter is 1.
;
; On CPU CGB B, CH3 requires TWO writes to disable the channel when
; the length counter is 1.
;
; Test written by Matt Currie.

CorrectResults:
db $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4
db $F4, $F4, $F0, $F0, $F0, $F0, $F0, $F0
db $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4
db $F4, $F4, $F0, $F0, $F0, $F0, $F0, $F0


SubTest: MACRO
    ld hl, rNR52
    ld [rDIV], a
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a

    ld a, $80
    ldh [rNR30], a

    ld a, 256 - \2
    ldh [rNR31], a

    ld a, $80
    ldh [rNR34], a

    nops \1

    REPT \3

    ld a, $03
    ldh [rNR34], a

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

    SubTest $FE2, 1, 2 
    SubTest $FE3, 1, 2 
    SubTest $FE4, 1, 2 
    SubTest $FE5, 1, 2 
    SubTest $FE6, 1, 2 
    SubTest $FE7, 1, 2 
    SubTest $FE8, 1, 2 
    SubTest $FE9, 1, 2 
           
    SubTest $FE2, 2, 2 
    SubTest $FE3, 2, 2 
    SubTest $FE4, 2, 2 
    SubTest $FE5, 2, 2 
    SubTest $FE6, 2, 2 
    SubTest $FE7, 2, 2 
    SubTest $FE8, 2, 2 
    SubTest $FE9, 2, 2 

    SubTest $FE2, 2, 3 
    SubTest $FE3, 2, 3 
    SubTest $FE4, 2, 3 
    SubTest $FE5, 2, 3 
    SubTest $FE6, 2, 3 
    SubTest $FE7, 2, 3 
    SubTest $FE8, 2, 3 
    SubTest $FE9, 2, 3 
     
        
    ret
    
    
StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
    