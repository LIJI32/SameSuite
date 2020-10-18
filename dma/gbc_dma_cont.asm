NB_COPIED_TILES EQU 2
NB_EMPTY_TILES EQU 128 - NB_COPIED_TILES
TILE_SIZE EQU 16

TOTAL_BYTES equ (NB_COPIED_TILES + NB_EMPTY_TILES) * TILE_SIZE

RESULTS_START EQUS "vTestBuf"
RESULTS_N_ROWS EQU (NB_COPIED_TILES + 1) * 2

include "base.inc"

; Test what happens when partially initializing a new GDMA after the previous one ends normally

CorrectResults:
    REPT NB_COPIED_TILES * TILE_SIZE / 2
        dw SrcBuf + (@ - CorrectResults)
    ENDR
    ds TILE_SIZE, 0

RunTest:
    ; Note that this is jumped to with IME off, which is important for what follows
    ; The LCD is also off, so we can quickly clear VRAM, too

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

    ; Now, perform one tile-sized GDMA
    xor a
    ldh [rHDMA5], a
    ; And another one right after, which should continue right after the first one
    ldh [rHDMA5], a
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
