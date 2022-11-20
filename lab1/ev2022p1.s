        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data

base:       .byte 0x21,0xC3,0x16,0x02
            .space 2, 0x00

            .section .text
            .global reset
    
reset:      MOV R0,#4           //cantidad de elementos del vector en R0
            LDR R1,=base        //puntero a base
            MOV R3,#0           //registro para recorrer el vector y no modificar R0
            MOV R4,#0           //impares

impares:    LDRB R2,[R1],#1     //cargo en R2 los valores del vector
            CMP R3, R0
            BEQ final
            LSRS R2, #1         //tomo el último bit y guardo en carry
            IT HS
            ADDHS R4, #1        //Si c==1 cuento impar
            ADD R3,#1
            B impares

final:  STRB R4,[R1,#-1]

stop: B stop
