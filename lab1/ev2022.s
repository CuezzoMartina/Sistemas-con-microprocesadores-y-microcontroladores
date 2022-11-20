                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

base:           .word vector
                .space 2, 0x00

vector:         .byte 0x21,0xC3,0x16,0x02

                .section .text
                .global reset
    

reset:          MOV R0,#4           //cantidad de elementos del vector en R0
                LDR R1,=base        //puntero a base
                LDR R2,[R1]         //guardo en R2 la dirección del vector
                MOV R5,#0           //recorrer el vector sin modificar R0
                MOV R6,#0           //impares
        
impares:        LDRB R4,[R2],#1     //cargo en R4 los valores del vector
                CMP R5, R0
                BEQ final
                LSRS R4, #1         //tomo el último bit y guardo en carry
                IT HS
                ADDHS R6, #1        //Si c==1 cuento impar
                ADD R5,#1
                B impares

final:          STRB R6,[R1,#4]

stop:           B stop
