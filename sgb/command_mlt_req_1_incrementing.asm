RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 1

include "base.inc"

; This test verifies which patters incrememnt MLT_REQ 01

SgbPacket: MACRO
    push hl
    ld hl, \1
    call SendSgbPacket
    pop hl
    ENDM

CorrectResults:
db $FE, $FE, $FF, $FF, $FE, $FF, $FE, $FF

RunTest:
    ld de, $c000
    SgbPacket MLT_REQ_1
; Test to see if the controller value increments from only one bit lowering
    ld a, $10
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Increments

    ldh a, [rP1]
	call StoreResult

    ld a, $20
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Does not increment

    ldh a, [rP1]
	call StoreResult

    ld a, $10
    ldh [rP1], a
    ld a, $20
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Increments

    ldh a, [rP1]
    call StoreResult

    ld a, $10
    ldh [rP1], a
    ld a, $20
    ldh [rP1], a
    ld a, $10
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Does not increment

    ldh a, [rP1]
    call StoreResult

    ld a, $10
    ldh [rP1], a
    ld a, $10
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Increments

    ldh a, [rP1]
    call StoreResult

    xor a
    ldh [rP1], a
    ld a, $10
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Increments

    ldh a, [rP1]
    call StoreResult

    ld a, $10
    ldh [rP1], a
    xor a
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Increments

    ldh a, [rP1]
    call StoreResult

    xor a
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a ; Increments

    ldh a, [rP1]
    call StoreResult
	ret

SendSgbPacket:
    push bc
    push de
    ld d, 16
; Reset packet buffer
    xor a
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a

.sgbByte:
    ld a, [hl+] ; Load next byte
    ld c, 8
    ld b, a
.sgbByteLoop:
    ld a, $10
    bit 0, b
    jr nz, .sgbBit
    sla a
.sgbBit:
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a
    srl b
    dec c
    jr nz, .sgbByteLoop
    dec d
    jr nz, .sgbByte

; Terminate packet
    ld a, $20
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a

    pop de
    pop bc

SgbWait:
    push de
    ld de, 7000
.waitloop:
    nop
    nop
    nop
    dec de
    ld a, e
    or d
    jr nz, .waitloop

    pop de
    ret

StoreResult::
    ld [de], a
    inc de
    ret

MLT_REQ_0:
    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
MLT_REQ_1:
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	SGB_MODE
