RESULTS_START  EQU $c000
RESULTS_N_ROWS EQU 2

include "base.inc"

; This test verifies how SGB command MLT_REQ works

SgbPacket: MACRO
    push hl
    ld hl, \1
    call SendSgbPacket
    pop hl
    ENDM

CorrectResults:
db $FF, $FE, $FF, $FF, $FF, $FF, $FE, $FD
db $FC, $FE, $FF, $FE, $FF, $00, $00, $00

RunTest:
    ld de, $c000

; Initial value always reads out as controller 1
    SgbPacket MLT_REQ_1
    ldh a, [rP1]
	call StoreResult

; Check that incrementing works as expected
	call Increment

    ldh a, [rP1]
	call StoreResult

; Test to see if the controller value is reset by going back to 1 player
    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_1
    ldh a, [rP1]
	call StoreResult

; Test to see the controller value in unsupported MLT_REQ 2
    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_2
    ldh a, [rP1]
	call StoreResult

	call Increment
    ldh a, [rP1]
	call StoreResult

; Test to see the controller order in MLT_REQ 3
    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_3
    ldh a, [rP1]
	call StoreResult

	call Increment
    ldh a, [rP1]
	call StoreResult

	call Increment
    ldh a, [rP1]
	call StoreResult

	call Increment
    ldh a, [rP1]
	call StoreResult

; Test if switching from 3 to 1 retains any state
    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_3

    SgbPacket MLT_REQ_1
    ldh a, [rP1]
	call StoreResult

    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_3
	call Increment

    SgbPacket MLT_REQ_1
    ldh a, [rP1]
	call StoreResult

    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_3
	call Increment
	call Increment

    SgbPacket MLT_REQ_1
    ldh a, [rP1]
	call StoreResult

    SgbPacket MLT_REQ_0
    SgbPacket MLT_REQ_3
	call Increment
	call Increment
	call Increment

    SgbPacket MLT_REQ_1
    ldh a, [rP1]
	call StoreResult

	xor a
	call StoreResult
	call StoreResult
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

Increment:
    ld a, $10
    ldh [rP1], a
    ld a, $30
    ldh [rP1], a
	ret

StoreResult::
    ld [de], a
    inc de
    ret

MLT_REQ_0:
    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
MLT_REQ_1:
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
MLT_REQ_2:
    db $89, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
MLT_REQ_3:
    db $89, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	SGB_MODE
