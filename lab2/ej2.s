            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

operando:   .word 0x81000304, 0x00200605

            .section .text
            .global reset

reset:      LDR R0,=operando        //dirección del nro de 64 bits en R0
            MOV R1,#0x0102          //operando de 32 bits en R1
            MOVT R1,#0XA056
            BL suma

stop:       B stop

suma:       LDR R2,[R0]             //cargo en R2 los 32 ult bits del numero
            ADDS R1,R2              //sumo 81000304+A0560102
            STR R1,[R0]             //guardo en M[r0] el resultado de la suma
            LDR R2,[R0,#4]          //cargo en R2 los 1eros 32b
            ADC R2,#0               //le sumo el carry del adds
            STR R2,[R0,#4]          //guardo el numero en memoria
            BX LR

