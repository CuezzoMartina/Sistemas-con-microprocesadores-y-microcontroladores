            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

numero:      .byte 0x2A
resultado:   .space 2

            .section .text
            .global reset

reset:      LDR R0,=numero
            LDR R1,=resultado
            BL conversion

stop:       B stop

conversion: PUSH {LR}
            LDRB R2,[R0]
            MOV R3,#0
            BL modulo
            STRB R3,[R1]
            STRB R2,[R1,#1]
            POP {PC}
            
modulo:     CMP R2,#10
            IT MI
            BXMI LR
            SUB R2,#10
            ADD R3,#1
            B modulo