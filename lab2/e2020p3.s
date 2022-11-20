            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

numero:     .byte 0XFF
maximo:     .space 1


            .section .text
            .global reset

reset:      LDR R1,=numero
            LDR R9,=maximo
            LDRB R4,[R1]            //Contador auxiliar para los 255 nros a testear               
            B div_max


div_max:    ADD R0,R4,#0            //Copio en R0 el num original
            MOV R3,#1               //Contador aux para calc_div
            BL calc_div         
            LDRB R8,[R9]            //Cargo en R8 la cantidad máxima de div
            CMP R0,R8               
            ITT PL                  //Si la cant de div del numero actual es mayor a la del anterior
            STRBPL R0,[R9]          //Store de divs
            STRBPL R4,[R1]          //Store del num
            SUB R4,#1               //Le resto 1 al registro contador aux
            CMP R4,#1
            BEQ stop                //Si R4 llega a 1 termina         
            B div_max               
            
stop:       B stop

calc_div:   CMP R3,#1
            ITT EQ              //Si es la primera vuelta
            PUSHEQ {LR}         //Guardo LR en la pila
            ADDEQ R2,R0,#0      //Copio r0 en r2 para poder usar r0

            ADD R5,R2,#0        //Copio R2 en R5
            ADD R3,#1           //Sumo uno al contador aux

            // Para salir de calc_div
            CMP R2,R3           
            ITTT EQ              //Si R2 (num original) es igual al contador
            SUBEQ R0,R2          //A R0 le resto el nro original ya que nunca seteo en 0
            ADDEQ R0,#2          //A R0 le sumo 2 ya que no contó al 1 y a si mismo como divs
            POPEQ {PC}           //Vuelvo al reset donde quedé

            //Si no sale
            BL modulo           //Calculo el mod del nro (usa R5)
            CMP R5,#0           
            IT EQ               //Si mod==0
            ADDEQ R0,#1         //Cuenta un divisor
            B calc_div          

modulo:     CMP R5,R3
            IT MI
            BXMI LR
            SUB R5,R3
            B modulo