INCLUDE "config.inc"
INCLUDE "hardware.inc"

CGB_MODE: MACRO
SECTION "CGBFlag", ROM0[$143]
    db $80
ENDM

SGB_MODE: MACRO
SECTION "CGBFlag", ROM0[$146]
    db $03

SECTION "CGBLicensee", ROM0[$14B]
    db $33
ENDM

SECTION "NopSlide", ROMX,BANK[$1]
NopSlide:
    REPT $3FFF
    nop
    ENDR
    ret

MIN_SLIDE_LENGTH EQU ($4 + 6) ; Length of call and ret in NOPs
MAX_SLIDE_LENGTH EQU ($3fff + MIN_SLIDE_LENGTH)

SECTION "Home", ROM0[$150]

LCDOff::
    push af
    ldh a, [rLCDC]
    and $80
    jr z, .ret
.LCDOffLoop
    ldh a, [rLY]
    cp 144
    jr nz, .LCDOffLoop
    ldh a, [rLCDC]
    and $7F
    ldh [rLCDC], a
.ret
    pop af
    ret

LCDOn::
    push af
    ld a, [rLCDC]
    or $80
    ld [rLCDC], a
    pop af
    ret

LoadFont::
    ld c, 0
    ld de, $8010

    ld hl, HexDigits
    ; Regular
.loop
    ld a, [hli]
    ld [de], a
    inc de
    dec c
    jr nz, .loop

    ; Bold
.loop2
    ld a, [hli]
    ld [de], a
    inc de
    dec c
    jr nz, .loop2

    ; Right Aligned
    ld hl, HexDigits
.loop3
    ld a, [hli]
    srl a
    srl a
    ld [de], a
    inc de
    dec c
    jr nz, .loop3

    ; Inverted
    ld hl, $8000
.loop4
    ld a, [hli]
    cpl
    ld [de], a
    inc de
    ld a, $83
    cp h
    jr nz, .loop4
    ld a, $10
    cp l
    jr nz, .loop4
    ret


HexDigits::
    INCBIN "hexdigits.2bpp"

Palette:
    dw $7FFF, $5294, $294A, $0000
    dw $421F, $4214, $420A, $4200
    
LoadObjPalettes::
    ld c, $6A
    jr LoadPalettes

LoadBGPalettes::
    ld c, $68

LoadPalettes::
    ld a, $80
    or e
    ld [c], a
    inc c
.loop
    ld a, [hli]
    ld [c], a
    dec d
    jr nz, .loop
    ret

CommonInit::
    di
    ld a, %11100100
    ld [rBGP], a
    call LCDOff
    call LoadFont
    ld hl, Palette
    ld de, $1000
    call LoadBGPalettes
    ld hl, Palette
    ld de, $0800
    call LoadObjPalettes
    ret

nops: MACRO
    IF (\1) > MAX_SLIDE_LENGTH

    nops MAX_SLIDE_LENGTH
    nops (\1) - MAX_SLIDE_LENGTH

    ELSE

    IF (\1) < MIN_SLIDE_LENGTH
    REPT (\1)
    nop
    ENDR

    ELSE
    call NopSlide + MAX_SLIDE_LENGTH - (\1)
    ENDC
    ENDC
ENDM

wait_ly: MACRO
.loop\@:
    ldh a, [rLY]
    cp \1
    jr nz, .loop\@
ENDM

