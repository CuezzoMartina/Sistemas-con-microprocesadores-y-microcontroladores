    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .text
    .func decremento

decremento:
    PUSH {R4,R5}
    LDRB R4,[R1]        //seg[0]
    LDRB R5,[R1,#1]     //seg[1]

    decrementar:
    ADD R4,R0           //Aumentamos seg[0]-=1
    MOV R0,#0

    CMP R4,#0           //Vemos si desborda seg[0]
    BGE finalDecremento
    MOV R4,#9           //Si desborda, seteamos seg[0]=0
    SUB R5,#1           //y seg[1]+=1

    CMP R5,#0           //Vemos si desborda seg[1]
    BGE finalDecremento
    MOV R5,#9           //Si desborda, hacemos seg[1]=0
    MOV R0,#-1           //Guardamos el resultado de desborde

finalDecremento:

    STRB R4,[R1]        //Guardamos todos los nuevos valores
    STRB R5,[R1,#1]     //y reestablecemos la pila a su valor
    POP {R4,R5}         //previo a la llamada
    BX LR

    .align
    .pool
    .endfunc

    