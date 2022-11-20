            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

dividendo:  .byte 0x0C

divisor:    .byte 0x05


            .section .text
            .global reset

reset:      LDR R0,=dividendo
            LDR R1,=divisor
            LDRB R2,[R0]
            LDRB R3,[R1]
            BL modulo


stop:       B stop

modulo:     CMP R2,R3
            IT MI
            BXMI LR
            SUB R2,R3
            B modulo