// Cuezzo, Martina Constanza
                .cpu cortex-m4
                .syntax unified
                .thumb


                .section .data


numero:         .byte 0xD7
                .space 3

                .section .text
                .global reset

reset:          LDR R0,=numero
                LDR R1,=tabla
                BL conversion      //Separa la centena, decena y unidad y pasa a 7seg
                //LEDs
                B leds

leds:           PUSH {R0}
                LDRB R0,[R0,#1]
                MOV R1,0X04
                BL mostrar
                BL demora
                POP {R0}
                PUSH {R0}
                LDRB R0,[R0,#2]
                MOV R1,0X02
                BL mostrar
                BL demora
                POP {R0}
                PUSH {R0}
                LDRB R0,[R0,#3]
                MOV R1,0X01
                BL mostrar
                BL demora
                POP {R0}
                B leds


conversion:     PUSH {LR}
                LDRB R2,[R0]                //Cargo en R2 el nro
                MOV R3,#0                   //Uso R3 como contador para módulo
                MOV R4,#100                 //Uso R4 para hacer nro(mod)R4
                BL modulo
                BL segmentos                //BCD a 7seg
                STRB R3,[R0,#1]             //Guarda en M(R0+1) la centena en 7seg
                MOV R3,#0                   //Reseteo el contador
                MOV R4,#10                  //Ahora hago mod 10 para encontrar la decena y unidad
                BL modulo
                BL segmentos
                STRB R3,[R0,#2]             //Guardo el 7seg de la decena en M(R0+2)
                ADD R3,R2,#0                //Copio el valor de la unidad que estaba en R2 en R3
                BL segmentos                //Llamo a la subrutina con R3 siendo el nro a pasar a 7seg
                STRB R3,[R0,#3]             //Guardo el 7seg de la unidad en M(R0+3)
                POP {PC}
            
modulo:         CMP R2,R4                   
                IT MI                       //Si r2 < r4
                BXMI LR                     //vuelve a 'separar'
                SUB R2,R4                   
                ADD R3,#1                   //Cuenta el valor del primer dígito del nro
                B modulo


segmentos:      LDRB R3,[R3,R1]             //Carga en R3 el digito en 7 seg
                BX LR


                .pool
tabla:          .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67


.include "lab2/funciones.s"