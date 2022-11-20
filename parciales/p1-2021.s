                .cpu cortex-m4
                .syntax unified
                .thumb


                .section .data

h:              .byte 0x03,0x04,0x01
x:              .byte 0x01,0x04,0x02,0x05
destino:        .space 10
y:              .space 10

                .section .text
                .global reset

reset:          LDR R0,=h
                MOV R2,#3               //m = cantidad de elementos en el filtro h
                ADD R1,R0,R2            
                SUB R1,#1               //apunto R1 al final del vector
                BL invertir             //Subrutina para invertir el vector
                MOV R3,#4               //n = tamaño del vector x
                SUB R2,#1               //m-1
                LDR R0,=x               //puntero al 1er elemento del vector x
                LDR R1,=destino         //puntero al vector destino
                BL copiar               //x a destino
                LDR R0,=destino         
                LDR R1,=h
                LDR R8,=y
                MOV R6,#6
                B convolucion   

convolucion:    CMP R6,#0
                IT EQ                   //Si recorrió todo
                BEQ stop                //Termina
                MOV R2,#3               //R2=m
                MOV R5,#0   
                PUSH {R0}               //Guardo la dirección a la que apunta R0
                BL calculo
                POP {R0}                //REcupero la dirección
                ADD R0,#1               //Muevo el puntero
                LDR R1,=h               //R1 apunta al filtro h
                STRB R5,[R8],#1         //Guardo el valor caculado en y
                SUB R6,#1
                B convolucion

stop:           B stop       


calculo:        CMP R2,#0
                IT EQ
                BXEQ LR
                LDRB R3,[R0],#1          //cargo el elemento de x en R3 y muevo el puntero
                LDRB R4,[R1],#1          //cargo el elem de h en R4 y muevo el puntero
                MUL R3,R4
                ADD R5,R3
                SUB R2,#1
                B calculo

copiar:         PUSH {LR}
                MOV R4,#2               //guardo un 2 para la multiplicación
                MLA R3,R2,R4,R3         //n+2*(m-1)
                MOV R4,0X00             //R4=0
                PUSH {R2}               //Guardo m-1
                CMP R2,#0
                IT NE                   //Si es la primera vuelta
                BLNE rellenar           //Le agrego (m-1) ceros en rellenar
                POP {R2}                //Recupero m-1 en R2
                BL copia                //Copia el vector despues de los (m-1) ceros
                POP {PC}

copia:          CMP R3,#1
                ITT EQ
                STRBEQ R4,[R1]          //Guarda un 0 al final
                BXEQ LR
                SUB R3,#1
                LDRB R5,[R0],#1         //Carga un valor de x en R5
                STRB R5,[R1],#1         //Guarda en destino a R5
                B copia


rellenar:       CMP R2,#0
                IT EQ
                BXEQ LR
                SUB R2,#1
                STRB R4,[R1],#1
                B rellenar

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

cambiar:        LDRB R2,[R0]            //Guarda en R2 el caracter al que apunta R0
                LDRB R3,[R1]            //Guarda en R3 el caracter al que apunta R1
                STRB R2,[R1]            //Guarda en M(R1) el caracter al que apuntaba R0
                STRB R3,[R0]            //Guarda en M(R0) el char al que apuntaba R1
                BX LR