            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

lista:      .byte 0xA0, 0x83, 0x1B, 0x85, 0xF3
espacio:    .space 2

            .section .text
            .global reset

reset:      LDR R0,=lista
            MOV R1,#5
            ADD R5,R1,#0               //Uso otro registro como contador para no cambiar R1
            BL ordenar

stop:       B stop

ordenar:    PUSH {LR}
            CMP R5,#1                  
            IT EQ                      //Si R5 llega a 1 (ya comparó con todo el vector)
            POPEQ {PC}                 //Vuelvo a la rutina principal
            LDRB R2,[R0]               //Cargo el valor al que apunta R0
            ADD R8,R2,#0               //Copio el mismo valor en r8
            PUSH {R0}                  //Guardo a lo que apuntaba R0 para poder usar el puntero luego
            MOV R4,#0                  //Contador auxiliar
            MOV R6,#0                  //Aux para intercambiar valores de regs
            BL menor
            POP {R0}                   //Recupero la direccion
            STRB R8,[R0,R6]            //Guardo en R0+R6 el valor con el que estaba comparando el resto de nros
            STRB R2,[R0],#1            //Guardo en R0 el menor valor
            SUB R5,#1                  
            POP {LR}                   //Recupero el LR por recursividad
            B ordenar


menor:      CMP R4,R5               
            IT EQ                       //Si R4=R5
            BXEQ LR                     //Vuelvo a ordenar
            LDRB R3,[R0],#1             //Cargo el valor al que apunta R0 y muevo el puntero
            CMP R3,R2
            ITT MI                      //Si R3<R2
            ADDMI R6,R4,#0              //Guardo posicion donde estaba el menor
            ADDMI R2,R3,#0              //Guardo en R2 el menor nro
            ADD R4,#1
            B menor

