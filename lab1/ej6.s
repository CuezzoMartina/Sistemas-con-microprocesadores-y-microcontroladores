            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

base:       .byte 0xA1, 0x07, 0xBB, 0x7C

            .section .text
            .global reset

reset:      MOV R0, #4
            MOV R3, #4
     
            LDR R1, =base

lazo:       LDRB R2, [R1], #1
            CMP R3, #0
            BEQ final
            UADD R4, R4, R2
            SUB R3, #1
            B lazo

final:      STRB R4, [R1, #4]

stop:       B stop
