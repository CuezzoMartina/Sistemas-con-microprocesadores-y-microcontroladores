                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

bloq_bin:       .byte 0x21,0xC3,0x06,0x21,0xC3,0x06,0x21,0xC3

resultado:      .space 4

                .section .text
                .global reset
               
reset:          LDR R4,=bloq_bin
                LDR R5,=resultado
                LDR R0,=cadena
                MOV R6,#8
                BL convertir

stop:           B stop

convertir:      PUSH {LR}
                CMP R6,#3
                IT MI                   //Si quedan menos de 3 bytes
                POPMI {PC}              //Vuelvo a reset
                MOV R3,#4               //nro   de caracteres a traducir por llamada a codificacion
                BL codificacion
                SUB R6,#3
                ADD R4,#3
                POP {LR}
                B convertir


codificacion:   CMP R3,#0               
                IT EQ                   //si R3 llega a 0
                BXEQ LR                 //Vuelvo al reset
                CMP R3,#4
                IT EQ                   //Si es la 1era vuelta
                LDREQ R1,[R4]           //Cargo el nro
                PUSH {R0}               //Guardo la direccion de la cadena
                AND R2,R1,0X3F          //Tomo los ultimos 6bits y hago 0 el resto
                ADD R0,R2               //Lugar donde está el caracter que necesito
                LDRB R2,[R0]            //Carga en R2 el valor del caracter
                STRB R2,[R5],#1         //Guardo el valor del caracter en 'resultado' y muevo el puntero
                LSR R1,#6               //Muevo 6 bits a la derecha
                SUB R3,#1
                POP {R0}                //Recupero la direccion de la cadena
                B codificacion


                .pool
cadena:         .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"