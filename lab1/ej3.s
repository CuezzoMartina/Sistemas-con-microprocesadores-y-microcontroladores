                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

base:           .word 0x06, 0x7A, 0x7B, 0x7C, 0x00

resultado:      .space 14, 0x00                          //espacio resultado                             

                .section .text
                .global reset

reset:          LDR R0, =base                           //apunto a la base            
                LDR R2, =resultado                      //apunto al primer elemento de resultado

lazo:           MOV R3, #0                              //cargo 0 en R3 para usarlo como contador
                MOV R4, #0                              //R4 tendra la cantidad de 1's
                LDR R1, [R0], #1                        //cargo el primer numero o sea 0x06 en R1 e incremento R0
                CMP R1, 0x00                            //while R1!=0x00. R1 ES EL NUMERO EN SI.
                BEQ final

rotacion:       CMP R3, #32                             //si es el bit 31 salta a par, tiene en R5 la cantidad de unos.
                BEQ par
                RORS R1, #1    
                IT HS                                   //mover un bit del numero
                ADDHS R4, #1                            //suma cantidad de unos cuando C=1
                ADD R3, #1    
                B rotacion


par:            LSRS R4, #1                             //pone el ultimo bit en el carry para ver si es par o impar.
                IT HS                            
                ADDHS R1, #128                          //suma uno al bit mas significativo si la cantidad de 1's es impar.
                STR R1, [R2], #1
                B lazo                                  //cargo R1 en el primer elemento del vector resultado e incremento el elemento

final:          STR R1, [R2]

stop:           B stop