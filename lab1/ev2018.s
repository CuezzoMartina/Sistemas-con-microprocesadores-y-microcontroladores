        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data

base:   .byte 0x23,0x03,0x07
        .space 10, 0x00

        .section .text
        .global reset

reset:      LDR R0, =base       //apunta a la base
            LDRB R1, [R0]       //cargo contenido dirección de r0 en r1, o sea el 23
            LDRB R2, [R0,#1]    //guardo el 3
            LDRB R3, [R0,#2]    //guardo el 7

convbcd:    LSL R2,#4       //agrego los 0 al final y corro 4 lugares
            ADD R2,R3       //
            STRB R2, [R0,#4]    //guardo el numero convertido en memoria (base+4)

suma:       AND R4,R1,0X0F      //hago 0 los primeros 4 bits del 23 y guardo en r4 (3)
            AND R5,R2,0x0F      //hago 0 los primeros 4 bits del 37 y guardo en r5 (7)
            ADD R6, R1,R2       //sumo 23 y 37
            ADD R4,R5           //sumo r4 y r5 (7,3)
            CMP R4,#9           //si la suma de los ultimos digitos de los num da =>9 necesito sumar un 6
            IT PL
            ADDPL R6,#6         //sumo 6 si cmp r4,9 da positivo o cero
            STRB R6, [R0,#6]

convbin:    AND R7,R6,0x0F          //guardo en r7 los ultimos 4 bits
            AND R8,R6,0XF0          //guardo en r8 los penultimos 4 bits
            LSR R8,#4               //muevo los penultimos bits hacia el final
            MOV R4,#10              
            MUL R8,R4               //multiplico la "decena" por 10
            ADD R7,R8               //le sumo la unidad
            STRB R7,[R0,#8]


stop: B stop 