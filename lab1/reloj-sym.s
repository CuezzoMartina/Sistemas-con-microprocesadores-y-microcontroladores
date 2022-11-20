            .cpu cortex-m4
            .syntax unified
            .thumb

            .section .text
            .global reset

reset:      MOV R2,#0               //segundo unidad
            MOV R3,#0               //segundo decena
            MOV R4,#0               //minuto unidad
            MOV R5,#0               //minuto decena
            MOV R8,#0
            MOV R9,#0
            LDR R6,=35000
            LDR R10,=tabla


refresco:   ADD R9,#1
            CMP R9,#100
            IT EQ
            MOVEQ R9,#0
            BEQ seg
            BL seg0
            BL divisor
            BL seg1
            BL divisor
            BL min0
            BL divisor
            BL min1
            BL divisor
            B refresco

divisor:    ADD R8,#1
            CMP R8,R6
            ITT EQ
            MOVEQ R8,#0
            BXEQ LR
            B divisor

seg0:       PUSH {LR}
            PUSH {R2,R3,R4,R5}
            ADD R0,R2,#0
            MOV R1,0x01
            BL seg7 
            BL mostrar 
            POP {R2,R3,R4,R5}
            POP {PC}

seg1:       PUSH {LR}
            PUSH {R2,R3,R4,R5}
            ADD R0,R3,#0
            MOV R1,0x02
            BL seg7 
            BL mostrar 
            POP {R2,R3,R4,R5}
            POP {PC}

min0:       PUSH {LR}
            PUSH {R2,R3,R4,R5}
            ADD R0,R4,#0
            MOV R1,0x04
            BL seg7 
            BL mostrar 
            POP {R2,R3,R4,R5}
            POP {PC}

min1:       PUSH {LR}
            PUSH {R2,R3,R4,R5}
            ADD R0,R5,#0
            MOV R1,0x08
            BL seg7 
            BL mostrar
            POP {R2,R3,R4,R5} 
            POP {PC}

seg:        ADD R2,#1
            CMP R2,#10
            ITT EQ
            MOVEQ R2,#0
            ADDEQ R3,#1
            CMP R3,#6
            ITT EQ
            MOVEQ R3,#0
            BLEQ min
            B refresco

min:        ADD R4,#1
            CMP R4,#10
            ITT EQ
            MOVEQ R4,#0
            ADDEQ R5,#1
            CMP R5,#6
            IT EQ
            MOVEQ R5,#0
            B refresco


seg7:       LDRB R0,[R0,R10]             //Carga en R0 el digito en 7 seg
            BX LR

            .pool
tabla:      .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67


.include "lab2/funciones.s"