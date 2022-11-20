            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

vector:     .byte 0x06,0x85,0x78,0xF8,0xE0,0x80

            .section .text
            .global reset

reset:      LDR R0,=vector

lazo:       LDRB R1,[R0]
            CMP R1,0X80
            BEQ stop
            TST R1,0X80         //si hay un bit en 1 entonces el nro es negativo
            ITTT NE
            EORNE R1,0x7F
            ADDNE R1,#1
            STRBNE R1,[R0]
            ADD R0,#1            //mueve el puntero
            B lazo

stop: B stop