                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

base:           .byte 0x23,0x03,0x07
                .space 10, 0x00

                .section .text
                .global reset

reset:          LDR R0,=base
                LDRB R1,[R0]        //cargo el 23 en r1
                MOV R4,#10

convbina:       AND R2,R1,0x0F     //guardo los ultimos 4 bits del numero 23 (el 3)
                AND R3,R1,0xF0     //guardo los penultimos 4 bits del 23 (el 2)
                LSR R3,#4          //muevo el 2 hacia el final
                MUL R3,R4          //multiplico el numero que iría en la decena por 10
                ADD R3,R2          //sumo la unidad
                STRB R3,[R0,#4]    //guardo el bin en base+4

convbinb:       LDRB R2,[R0,#1]
                LDRB R3,[R0,#2]
                MUL R2,R4
                ADD R3,R2
                STRB R3,[R0,#6]

suma:           LDRB R2,[R0,#4]
                LDRB R3,[R0,#6]
                ADD R3,R2
                STRB R3,[R0,#8]

stop:           B stop
