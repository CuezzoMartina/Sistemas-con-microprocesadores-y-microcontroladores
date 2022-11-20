                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

segundos:       .byte 0x08, 0x05

                .section .text
                .global reset

reset:          MOV R0,#1           
                LDR R1,=segundos
                PUSH {R0,R1}        //Paso parámetros por pila
                BL incrementar      //Llamo a la subrutina
                POP {R0}            //Recupero R0

stop:           B stop

incrementar:    POP {R0,R1}
                LDRB R2,[R1]        //Cargo en R2 el valor menos significativo
                LDRB R3,[R1,#1]     //Cargo en R3 el valor más significativo
                ADD R2,#1
                CMP R2,#10          
                ITT EQ              //Si la unidad llega a 10
                ADDEQ R3,#1         //Le sumo uno a la decena
                MOVEQ R2,#0         //Hago 0 la unidad
                CMP R2,#6           
                ITE EQ              //Si la decena llega a 6
                MOVEQ R3,#0         //Hago 0 la decena
                MOVNE R0,#0         //Seteo R0 en 0 si no se llega a 60 segs
                PUSH {R0}
                BX LR