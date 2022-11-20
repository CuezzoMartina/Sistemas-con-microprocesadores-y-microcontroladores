            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

origen:     .byte 0x34,0x05,0x14,0xA2,0x0C

destino:    .space 1, 0x00

            .section .text
            .global reset

reset:      LDR R0, =origen
            LDR R1, =destino
            LDR R2, =tabla
            LDRB R3, [R0,#4]        //cargo el valor a mostrar

lazo:       CMP R3,#10              
            BMI final
            SUB R3,#10          //a R3 le resto 10 si R3>=10
            B lazo

final:      LDRB R4, [R2,R3]
            STRB R4, [R1]

stop:       B stop

            .pool
tabla:      .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F