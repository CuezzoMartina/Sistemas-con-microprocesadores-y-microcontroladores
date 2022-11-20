            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

fecha_act:  .byte 0x1D, 0x09

destino:    .space 4

            .section .text
            .global reset

reset:      LDR R0,=fecha_act
            LDR R1,=destino
            LDR R4,=tabla
            BL fecha

stop:       B stop

fecha:      PUSH {LR}              
            PUSH {R0}                   //Guardo el valor de R0 (dirección de fecha_act)
            //DÍA
            BL conversion               //Llamo a la subrutina que separa decena de unidad
            LDRB R0,[R1]                //Guardo en R0 (segmentos usa R0) el valor de la decena del día
            BL segmentos                //Llamo a la subrutina para pasar de BCD a 7seg
            STRB R0,[R1]                //Guardo el resultado en destino
            LDRB R0,[R1,#1]             //Cargo en R0 el valor de la unidad del día
            BL segmentos
            STRB R0,[R1,#1]             //Guardo el resultado en destino+1
            //MES
            POP {R0}                    //Recupero la dirección de fecha_act
            ADD R0,#1                   //Muevo R0 un lugar (para el mes)
            ADD R1,#2                   //Muevo R1 a destino+2
            BL conversion
            LDRB R0,[R1]                
            BL segmentos
            STRB R0,[R1]
            LDRB R0,[R1,#1]
            BL segmentos
            STRB R0,[R1,#1]

            POP {PC}                    //Vuelvo a la rutina principal

conversion: PUSH {LR}
            LDRB R2,[R0]                //Guarda en R2 lo que hay en M(R0)
            MOV R3,#0
            BL modulo
            STRB R3,[R1]                //Guardo la decena en R1
            STRB R2,[R1,#1]             //Guardo la unidad en R1+1
            POP {PC}
            
modulo:     CMP R2,#10                  
            IT MI                       //Si R2 < 10
            BXMI LR                     //Vuelvo a conversion
            SUB R2,#10                  //Si no, R2=R2-10
            ADD R3,#1                   //R3=R3+1 (en cada vuelta cuenta las decenas)
            B modulo

segmentos:  LDRB R0,[R0,R4]             //Guarda en R0 el digito en 7 seg
            BX LR


            .pool
tabla:      .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67