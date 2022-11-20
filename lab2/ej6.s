                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

base:           .word  0x1A001D05, 0x1A005FC4, 0x1A002321, 0x01A05FC4, 0x01A07C3A

                .section .text
                .global reset

reset:          MOV R0,#2
                LDR R1,=base
                BL salto
                POP {PC}

stop:           B stop

salto:          MOV R3,#4
                MUL R2,R0,R3
                ADD R2,R1
                LDR R3,[R2]
                PUSH {R3}
                BX LR