RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 16

include "base.inc"

; Part 2 of sweep_restart

CorrectResults:

db $f1, $f1, $f0, $f0, $f0, $f0, $f0, $f0
db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1



SubTest: MACRO
    ld [rDIV], a ; Reset DIV so we don't overflow too soon
    xor a
    ldh [rNR52], a
    cpl
    ldh [rNR52], a
    ld a, $10
    nops $800 ; Let DIV tick the APU once, so we know we're aligned to the APU start time
    ldh [rNR10], a
    ld a, $80
    ldh [rNR11], a
    ld a, $ff
    ldh [rNR13], a
    ld a, $80
    ldh [rNR12], a
    ld a, $83
    ldh [rNR14], a 
    ld a, $87
    ld [rDIV], a ; Reset DIV again to start counting from right after the DIV reset
    nops $0ffa + \2 ; Tick DIV
    ldh [rNR14], a ; Restart sound
    nops \1
    ld a, [hl]
    
    call StoreResult
    ENDM

RunTest:
    ld de, $c000
    ld hl, rNR52
    
    SubTest $0000, 0
    SubTest $0001, 0
    SubTest $0002, 0
    SubTest $0003, 0
    SubTest $0004, 0
    SubTest $0005, 0    
    SubTest $0006, 0    
    SubTest $0007, 0  
     
    SubTest $0008, 0
    SubTest $0009, 0
    SubTest $000a, 0
    SubTest $000b, 0
    SubTest $000c, 0
    SubTest $000d, 0    
    SubTest $000e, 0    
    SubTest $000f, 0   
    
    SubTest $0000, 1
    SubTest $0001, 1
    SubTest $0002, 1
    SubTest $0003, 1
    SubTest $0004, 1
    SubTest $0005, 1    
    SubTest $0006, 1    
    SubTest $0007, 1
    
    SubTest $0008, 1
    SubTest $0009, 1
    SubTest $000a, 1
    SubTest $000b, 1
    SubTest $000c, 1
    SubTest $000d, 1    
    SubTest $000e, 1    
    SubTest $000f, 1
    
    SubTest $0000, 2
    SubTest $0001, 2
    SubTest $0002, 2
    SubTest $0003, 2
    SubTest $0004, 2
    SubTest $0005, 2    
    SubTest $0006, 2    
    SubTest $0007, 2   
     
    SubTest $0008, 2
    SubTest $0009, 2
    SubTest $000a, 2
    SubTest $000b, 2
    SubTest $000c, 2
    SubTest $000d, 2    
    SubTest $000e, 2    
    SubTest $000f, 2  
      
    SubTest $0000, 3
    SubTest $0001, 3
    SubTest $0002, 3
    SubTest $0003, 3
    SubTest $0004, 3
    SubTest $0005, 3    
    SubTest $0006, 3    
    SubTest $0007, 3   
     
    SubTest $0008, 3
    SubTest $0009, 3
    SubTest $000a, 3
    SubTest $000b, 3
    SubTest $000c, 3
    SubTest $000d, 3    
    SubTest $000e, 3    
    SubTest $000f, 3  
      
    SubTest $0000, 4
    SubTest $0001, 4
    SubTest $0002, 4
    SubTest $0003, 4
    SubTest $0004, 4
    SubTest $0005, 4    
    SubTest $0006, 4    
    SubTest $0007, 4 
       
    SubTest $0008, 4
    SubTest $0009, 4
    SubTest $000a, 4
    SubTest $000b, 4
    SubTest $000c, 4
    SubTest $000d, 4    
    SubTest $000e, 4    
    SubTest $000f, 4  
      
    SubTest $0000, 5
    SubTest $0001, 5
    SubTest $0002, 5
    SubTest $0003, 5
    SubTest $0004, 5
    SubTest $0005, 5    
    SubTest $0006, 5    
    SubTest $0007, 5 
       
    SubTest $0008, 5
    SubTest $0009, 5
    SubTest $000a, 5
    SubTest $000b, 5
    SubTest $000c, 5
    SubTest $000d, 5    
    SubTest $000e, 5    
    SubTest $000f, 5 
       
    SubTest $0000, 6
    SubTest $0001, 6
    SubTest $0002, 6
    SubTest $0003, 6
    SubTest $0004, 6
    SubTest $0005, 6    
    SubTest $0006, 6    
    SubTest $0007, 6   
     
    SubTest $0008, 6
    SubTest $0009, 6
    SubTest $000a, 6
    SubTest $000b, 6
    SubTest $000c, 6
    SubTest $000d, 6    
    SubTest $000e, 6    
    SubTest $000f, 6  
      
    SubTest $0000, 7
    SubTest $0001, 7
    SubTest $0002, 7
    SubTest $0003, 7
    SubTest $0004, 7
    SubTest $0005, 7    
    SubTest $0006, 7    
    SubTest $0007, 7  
      
    SubTest $0008, 7
    SubTest $0009, 7
    SubTest $000a, 7
    SubTest $000b, 7
    SubTest $000c, 7
    SubTest $000d, 7    
    SubTest $000e, 7    
    SubTest $000f, 7    
    ret
    

StoreResult::
    ld [de], a
    inc de
    ret
    
    CGB_MODE
