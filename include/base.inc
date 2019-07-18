SECTION "Reboot", ROM0[$FF]
reboot:
    ld [hl], a
SECTION "Header", ROM0[$100]

Start::
    nop
    jp _Start

MODEM_PARITY EQU $cfff
RESULT_CODE EQU $cffe
MODEM_TEMP EQU $cffd

INCLUDE "common.inc"

ModemSleep:
    xor a
    ldh [rTMA], a
    ldh [rDIV], a
    ldh [rTAC], a

    ld a, $80
    ldh [rTIMA], a
    ld a, 4
    ldh [rIE], a
    di
    ldh [rTAC], a

    xor a
    ldh [rIF], a
    halt
    nop
    ret

ModemFreq: MACRO
    dw $8000 | ($800 - $20000 / (\1))
ENDM

ModemFreqCh3: MACRO
    dw $8000 | ($800 - $20000 / ((\1) * 2))
ENDM


ModemCh1Freqs:
    dw $8000 | 1174 ; 149.97Hz
    dw $8000 | 1493 ; 236.17Hz
    dw $8000 | 1690 ; 366.12Hz
    dw $8000 | 1783 ; 494.61Hz
    dw $8000 | 1838 ; 624.15Hz
    dw $8000 | 1883 ; 794.38Hz
    dw $8000 | 1899 ; 879.68Hz
    dw $8000 | 1918 ; 1008.25Hz

ModemCh2Freqs:
    dw $8000 | 1933 ; 1139.76Hz
    dw $8000 | 1945 ; 1272.54Hz
    dw $8000 | 1957 ; 1440.35Hz
    dw $8000 | 1965 ; 1579.18Hz
    dw $8000 | 1971 ; 1702.23Hz
    dw $8000 | 1975 ; 1795.51Hz
    dw $8000 | 1980 ; 1927.53Hz
    dw $8000 | 1985 ; 2080.51Hz

ModemCh3Freqs:
    dw $8000 | 2024 ; 2730.67Hz
    dw $8000 | 2025 ; 2849.39Hz
    dw $8000 | 2026 ; 2978.91Hz
    dw $8000 | 2027 ; 3120.76Hz
    dw $8000 | 2032 ; 4096.00Hz
    dw $8000 | 2033 ; 4369.07Hz
    dw $8000 | 2034 ; 4681.14Hz
    dw $8000 | 2035 ; 5041.23Hz

ModemSendByte:
    push bc
    push de
    push hl
    ld b, a
    ld d, 0

    ld hl, ModemCh1Freqs
    ld a, b
    and $7
    ld e, a
    add hl, de
    add hl, de


    ld a, [hli]
    ldh [rNR13], a
    ld a, [hl]
    ldh [rNR14], a

    ld hl, ModemCh2Freqs
    ld a, b
    rra
    rra
    rra
    and $7
    ld e, a
    add hl, de
    add hl, de

    ld a, [hli]
    ldh [rNR23], a
    ld a, [hl]
    ldh [rNR24], a

    ld hl, ModemCh3Freqs
    ld a, b
    rra
    rra
    rra
    rra
    rra
    rra

    and $3
    ld e, a
    ld a, [MODEM_PARITY]
    xor 4
    ld [MODEM_PARITY], a
    add e
    ld e, a
    add hl, de
    add hl, de

    ld a, [hli]
    ldh [rNR33], a
    ld a, [hl]
    ldh [rNR34], a

    ld a, $77
    ldh [rNR51], a
    call ModemSleep

    xor a
    ldh [rNR51], a

    pop hl
    pop de
    pop bc
    ret

ModemStart:
    ld a, $80
    ldh [rNR52], a
    ldh [rNR30], a

    ld a, $77
    ldh [rNR50], a

    ld a, 4
    ld [MODEM_PARITY], a

    xor a
    ldh [rNR51], a
    ldh [rNR10], a


    ld a, $80
    ldh [rNR11], a
    ldh [rNR21], a

    ld a, $f0
    ldh [rNR12], a
    ldh [rNR22], a


    ld a, $20
    ldh [rNR32], a

    ld hl, $ff30

    xor a
REPT 8
    ld [hli], a
ENDR
    cpl
REPT 8
    ld [hli], a
ENDR

    ret

ModemStop:
    xor a
    ldh [rNR52], a
    ret

ModemSendBuffer:
    ld a, [hli]
    call ModemSendByte
    dec c
    jr nz, ModemSendBuffer
    ret

_Start::
    call CommonInit
    call RunTest
    ld a, "P"
    ld [RESULT_CODE], a
    xor a
    ldh [rNR52], a
    ld [rIE], a
    call PrintResults
    call LCDOn
    
    IF MODEM_OUTPUT
    call ModemStart
    
    ld hl, RESULT_CODE
    ld c, 1
    call ModemSendBuffer
    
    ld a, [RESULT_CODE]
    cp "P"
    jr z, .skipResults
    
    ld a, RESULTS_N_ROWS * 8
    ld [MODEM_TEMP], a
    ld hl, MODEM_TEMP
    ld c, 1
    call ModemSendBuffer
    
    ld hl, RESULTS_START
    ld c, RESULTS_N_ROWS * 8
    call ModemSendBuffer
    
.skipResults
    
    call ModemStop
    ENDC
    IF EMS_REBOOT
    ; Wait for keypress
    ld a, $10
    ldh [rJOYP], a
    ld a, $10
    ldh [rIE], a
    xor a
    ldh [rIF], a
    di
    halt
    
    ; Restart EMS flash cart
    ld a, 1
    ld [$2000], a
    ld a, $a5
    ld [$1000], a
    xor a
    ld hl, $7000
    jp reboot
    ELSE
    xor a
    ldh [rIF], a
    ldh [rIE], a
    di

    wait_ly 144

    ld a, [RESULT_CODE]
    cp "P"
    jr nz, .failed

    ; Set registers to Fibonacci numbers on success
    ld b, 3
    ld c, 5
    ld d, 8
    ld e, 13
    ld h, 21
    ld l, 34 
    jr .sendSerial

.failed
    ; Set registers to $42 on failure
    ld b, $42
    ld c, b
    ld d, b
    ld e, b
    ld h, b
    ld l, b

.sendSerial
    ld a, b
    call SerialSendByte
    ld a, c
    call SerialSendByte
    ld a, d
    call SerialSendByte
    ld a, e
    call SerialSendByte
    ld a, h
    call SerialSendByte
    ld a, l
    call SerialSendByte

    ; Wait for another vblank to allow for invisible frame
    wait_ly 144
    xor a

    ; Software breakpoint for automated testing
    ld b, b
    halt
    ENDC
    

PrintResults::
    ld bc, RESULTS_START 
    ld de, CorrectResults
    ld hl, $9800
    
.yLoop
    ; Digit X000
    ld a, b
    srl a
    srl a
    srl a
    srl a
    add $11
    ld [hli], a

    ; Digit 0X00
    ld a, b
    and $F
    add $11
    ld [hli], a

    ; Digit 00X0
    ld a, c
    srl a
    srl a
    srl a
    srl a
    add $11
    ld [hli], a

    ; Digit 000X
    ld a, c
    and $F
    add $11
    ld [hli], a

.xLoop
    ld a, [bc]
    push hl
    push de
    pop hl
    cp [hl]
    ld h, 0
    jr z, .correct
    push af
    ld a, "F"
    ld [RESULT_CODE], a
    pop af
    ld h, $31
.correct
    swap a
    and $F
    add $21
    add h
    pop hl
    ld [hli], a

    ld a, [bc]
    push hl
    push de
    pop hl
    cp [hl]
    ld h, 0
    jr z, .correct2
    ld h, $31
.correct2
    and $F
    inc a
    add h
    pop hl
    ld [hli], a

    inc bc
    inc de
    ld a, l
    and $1f
    cp $14
    jr nz, .xLoop

    push de
    ld d, 0
    ld e, $c
    add hl, de
    pop de
    ld a, h
    cp $98 + RESULTS_N_ROWS / 8
    jr nz, .yLoop
    ld a, l
    cp (RESULTS_N_ROWS * 32) & $ff
    jr nz, .yLoop
    ret

SerialSendByte::
    ldh [rSB], a
    ld a, $81
    ldh [rSC],a 
.loop:
    ldh a, [rSC]
    bit 7, a
    jr nz, .loop
    ret
