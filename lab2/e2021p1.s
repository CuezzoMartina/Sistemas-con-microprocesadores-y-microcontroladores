            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

fecha:      .byte 0x09, 0x08

            .section .text
            .global reset

reset:      LDR R0,=fecha
            LDR R1,=tabla
            LDRB R0,[R0]
            BL segmentos

stop:       B stop

segmentos:  LDRB R0,[R0,R1]
            BX LR


            .pool
tabla:      .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F