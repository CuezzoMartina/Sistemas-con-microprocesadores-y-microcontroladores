                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

adc:            .hword 0x821,0x1C3,0x000,0x51A,0xA02
muestras:       .space 10

                .section .text
                .global reset

reset:          LDR R0,=adc
                LDR R1,=muestras
                MOV R2,#4
                BL ext_signo
                LDR R0,=muestras
                MOV R2,#4
                BL buscar0

stop:           B stop

ext_signo:      CMP R2,#0                   
                IT EQ                   //Si R2 llega a 0
                BXEQ LR                 //Sale de subrutina
                LDRH R3,[R0],#2         //Cargo el primer valor
                TST R3,0x800            //Hago TST para ver si es negativo
                IT NE                   //Si es neg (Z==1)
                ORRNE R3,0xF000         //Pongo en 1 los 4 primeros bits
                STRH R3,[R1],#2         //Guardo el valor con signo extendido en 'muestras'
                SUB R2,#1               
                B ext_signo

buscar0:        CMP R2,#0
                ITT EQ
                MOVEQ R1,#0
                BXEQ LR
                LDRH R3,[R0],#2         //Cargo el primer valor
                CMP R3,0X00
                ITT EQ
                ADDEQ R1,R0,#0
                BXEQ LR
                SUB R2,#1
                B buscar0