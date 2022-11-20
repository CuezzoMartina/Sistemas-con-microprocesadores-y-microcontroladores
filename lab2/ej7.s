                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data


cadena:         .asciz "martina"


                .section .text
                .global reset

reset:          LDR R0,=cadena
                LDR R1,=cadena
                BL puntero              //Subrutina para posicionar el puntero al final de la cadena
                BL invertir             //Subrutina para invertir la cadena

stop: B stop

puntero:        LDRB R2,[R1],#1         //Guardo un caracter en R2 
                CMP R2,0X00             //Comparo con 0x00 para saber si es el final del string
                ITT EQ                  //Si llega al final
                SUBEQ R1,#2             //Muevo R1 hacia el último caracter
                BXEQ LR                 
                B puntero

cambiar:        LDRB R2,[R0]            //Guarda en R2 el caracter al que apunta R0
                LDRB R3,[R1]            //Guarda en R3 el caracter al que apunta R1
                STRB R2,[R1]            //Guarda en M(R1) el caracter al que apuntaba R0
                STRB R3,[R0]            //Guarda en M(R0) el char al que apuntaba R1
                BX LR

invertir:       PUSH {LR}
                BL cambiar              //Llama a la subrutina para intercambiar caract
                ADD R0,#1               //Mueve el puntero R0 un lugar (hacia la der)
                CMP R0,R1               
                IT EQ                   //Si R0 y R1 apuntan a la misma dirección
                POPEQ {PC}              //Vuelvo a la rutina principal
                ADD R1,#-1              //Mueve el puntero R1 un lugar (hacia la izq)
                CMP R0,R1       
                IT EQ                   //Si R0 y R1 apuntan a la misma dirección
                POPEQ {PC}              //Vuelvo a la rutina principal
                POP {LR}                //Recupero el valor que tenía LR al hacer 'BL invertir' en la rutina principal
                B invertir              //Llamada recursiva



