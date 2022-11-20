            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

divisores:  .space 25,0x00


            .section .text
            .global reset

reset:      MOV R0,#240
            LDR R1,=divisores
            MOV R3,#1               //contador auxiliar
            STRB R3,[R1],#1         //El 1 es divisor siempre               
            BL calc_div

stop:       B stop

calc_div:   CMP R3,#1
            ITT EQ              //Si es la primera vuelta
            PUSHEQ {LR}         //Guardo LR en la pila
            ADDEQ R2,R0,#0      //Copio r0 en r2 para poder usar r0

            ADD R5,R2,#0        //Copio R2 en R5
            ADD R3,#1           //Sumo uno al contador aux

            // Para salir de calc_div
            CMP R2,R3           
            ITTTT EQ             //Si R2 (num original) es igual al contador
            ADDEQ R0,#2
            SUBEQ R0,R2         //A R0 le resto el nro original ya que nunca seteo en 0
            STRBEQ R2,[R1]      //Guardo el nro original en el vector ya que es un divisor
            POPEQ {PC}          //Vuelvo al reset donde quedé

            //Si no sale
            BL modulo           //Calculo el mod del nro (usa R5)
            CMP R5,#0           
            ITT EQ              //Si mod==0
            ADDEQ R0,#1         //Cuenta un divisor
            STRBEQ R3,[R1],#1   //Guarda en el vector el divisor
            B calc_div          

modulo:     CMP R5,R3
            IT MI
            BXMI LR
            SUB R5,R3
            B modulo