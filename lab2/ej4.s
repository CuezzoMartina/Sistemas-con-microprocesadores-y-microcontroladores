                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

segundos:       .byte 0x09, 0x05

minutos:        .byte 0x04, 0x03

                .section .text
                .global reset

reset:          MOV R0,#1           
                LDR R1,=segundos
                BL incrementar      //Llamo a la subrutina para segundos
                LDR R1,=minutos     
                BL incrementar      //Llamo a la subrutina para minutos

stop:           B stop

incrementar:    LDRB R2,[R1]        //Cargo en R2 el valor menos significativo
                LDRB R3,[R1,#1]     //Cargo en R3 el valor más significativo
                CMP R0,#1
                IT EQ
                ADDEQ R2,#1
                CMP R2,#10          
                ITT EQ              //Si la unidad llega a 10
                ADDEQ R3,#1         //Le sumo uno a la decena
                MOVEQ R2,#0         //Hago 0 la unidad
                CMP R3,#6           
                ITE EQ              //Si la decena llega a 6
                MOVEQ R3,#0         //Hago 0 la decena
                MOVNE R0,#0         //Seteo R0 en 0 si no se llega a 60 segs
                BX LR