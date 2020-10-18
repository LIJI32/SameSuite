NB_COPIED_TILES EQU 1
NB_EMPTY_TILES EQU 128 - NB_COPIED_TILES
TILE_SIZE EQU 16

TOTAL_BYTES equ (NB_COPIED_TILES + NB_EMPTY_TILES) * TILE_SIZE

RESULTS_START EQUS "vTestBuf"
RESULTS_N_ROWS EQU (NB_COPIED_TILES + 1) * 2 + 1

include "base.inc"

; Test what happens when performing a HDMA with LCD off
; A single tile should get copied, and the count should decrement once

CorrectResults:
    REPT NB_COPIED_TILES * TILE_SIZE / 2
        dw SrcBuf + (@ - CorrectResults)
    ENDR

    ds TILE_SIZE, 0

    db $02, $80
    ds 6, 0

RunTest:
    ; Note that this is jumped to with IME off, which is important for what follows
    ; The LCD is also off, so we can quickly clear VRAM, too

    ; pop return address off of stack, as we are going to overwrite it...
    pop de

    ; Init the target area with a bunch of zeros
    ld hl, vTestBuf
    ; Also init the GDMA dest reg
    ld a, HIGH(hl)
    ldh [rHDMA3], a
    ld a, LOW(hl)
    ldh [rHDMA4], a
    ld bc, TOTAL_BYTES
    ; Otherwise the loop won't iterate the correct amount of times
    assert TOTAL_BYTES % 256 == 0
    xor a
.initTestBuf
    ld [hli], a
    dec c
    jr nz, .initTestBuf
    dec b
    jr nz, .initTestBuf

    ld hl, SrcBuf
    ld a, HIGH(hl)
    ldh [rHDMA1], a
    ld a, LOW(hl)
    ldh [rHDMA2], a
    ; Init WRAM with a fairly unique pattern
    ld bc, TOTAL_BYTES / 2
    ; Like the previous loop
    assert (TOTAL_BYTES / 2) % 256 == 0
.initSrcBuf
    ld a, l
    ld [hli], a
    ld a, h
    ld [hli], a
    dec c
    jr nz, .initSrcBuf
    dec b
    jr nz, .initSrcBuf

    ; Also set a pattern in HRAM, just in case
    ld c, LOW(_HRAM)
.initHRAM
    ld a, c
    ldh [c], a
    inc c
    jr nz, .initHRAM

    ; Now, start a HDMA
    ld c, LOW(rHDMA5)
    ld a, $83
    ldh [c], a
    ; Read the HDMA counter, and append it to the test results
    ld hl, RESULTS_START + RESULTS_N_ROWS * 8 - 8
    ldh a, [c]
    ld [hli], a
    ; Now, pause the transfer
    xor a
    ldh [c], a
    ldh a, [c]
    ld [hli], a

    ; Return to previously popped-off address
    push de
    ret

SECTION "STAT handler", ROM0[$48]
    reti

SECTION "Test buffer", VRAM[$8800]

vTestBuf:
    ds NB_COPIED_TILES * TILE_SIZE ; This is the normal result area...
    ds NB_EMPTY_TILES * TILE_SIZE ; ...but let's be safe, just in case.

SECTION "Source buffer", WRAM0,ALIGN[4]

SrcBuf: ; Like above
    ds NB_COPIED_TILES * TILE_SIZE
    ds NB_EMPTY_TILES * TILE_SIZE

    CGB_MODE
