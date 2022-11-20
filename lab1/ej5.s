            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

base:       .space 1
            .byte 0x03, 0x3A, 0xAA, 0xF2

            .section .text
            .global reset

reset:      LDR R0, =base            //apunta a base0
            LDRB R1, [R0, #1]        //carga 0x03 en R1
            LDRB R2, [R0, #2]        //carga el primer numero en r2 3A
            MOV R4, #1
            LDRB R3, [R0, #3]        //carga en R3 el siguiente numero
            MOV R5, #3

lazo:       CMP R1, R4
            BEQ stop
            CMP R2, R3
            ITE MI
            STRBMI R3, [R0]
            STRBPL R2, [R0]
            LDRB R2, [R0, R5]
            ADD R5, #1
            LDRB R3, [R0, R5]
            ADD R4, #1
            B lazo

stop:       B stop