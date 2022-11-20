            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

segundos:    .byte 0x08, 0x04
minutos:     .byte 0x09, 0x00

            .section .text
            .global reset


reset:      LDR R6,=tabla
            MOVW R7,0xC350
            MOV R5,#1
            MOV R9,#0               //Registro para contar refrescos
            LDR R1,=segundos
            ADD R4,LR,#8
            BL refrescos            //Llama a Subrutina refrescos
            BL incrementar          //Llama a a subrutina para incrementar los segs
            LDR R1,=minutos
            BL incrementar          //Llama a a subrutina para incrementar los min
            BL conversion

stop:       B stop       

refrescos:  MOV R8,#0
            BL divisor              
            ADD R9,#1                 
            CMP R9,#100
            IT EQ
            BXEQ R4
            B refrescos

divisor:    ADD R8,#1
            CMP R8,R7
            IT EQ
            BXEQ LR
            B divisor


incrementar:    LDRB R2,[R1]        //Cargo en R2 el valor menos significativo
                LDRB R3,[R1,#1]     //Cargo en R3 el valor más significativo
                ADD R2,R5
                CMP R2,#10          
                ITT EQ              //Si la unidad llega a 10
                ADDEQ R3,#1         //Le sumo uno a la decena
                MOVEQ R2,#0         //Hago 0 la unidad
                CMP R3,#6           
                ITE EQ              //Si la decena llega a 6
                MOVEQ R3,#0         //Hago 0 la decena
                MOVNE R0,#0         //Seteo R0 en 0 si no se llega a 60 segs
                BX LR


conversion:     LDRB R0,[R6,R0]
                BX LR


            .pool
tabla:      .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F