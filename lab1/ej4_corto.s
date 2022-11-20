            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

hora:       .space 6, 0x00

            .section .text
            .global reset


reset:      LDR R0,=hora
            MOV R8,#0
            LDRB R1,[R0]
            LDRB R2,[R0,#1]
            LDRB R3,[R0,#2]
            LDRB R4,[R0,#3]
            LDRB R5,[R0,#4]
            LDRB R6,[R0,#5]

divisor:    ADD R8,#1
            CMP R8,#1000
            BEQ seg
            B divisor

seg:        MOV R8,#0
            ADD R1,#1
            CMP R1,#10
            ITT EQ
            MOVEQ R1,#0
            ADDEQ R2,#1
            CMP R2,#6
            IT EQ
            MOVEQ R2,#0
            STRB R1,[R0]
            STRB R2,[R0,#1]
            BEQ min
            B divisor

min:        ADD R3,#1
            CMP R3,#10
            ITT EQ
            MOVEQ R3,#0
            ADDEQ R4,#1
            CMP R4,#6
            IT EQ
            MOVEQ R4,#0
            STRB R3,[R0,#2]
            STRB R4,[R0,#3]
            BEQ hora0
            B divisor


hora0:      ADD R5,#1
            CMP R5,#4
            BEQ hora1
            CMP R5,#10
            BEQ hora2
            STRB R5,[R0,#4]
            B divisor

hora1:      CMP R6,#2
            ITTT EQ
            MOVEQ R5,#0
            MOVEQ R6,#0
            STRBEQ R6,[R0,#5]
            STRB R5,[R0,#4]
            B divisor


hora2:      ADD R6,#1
            MOV R5,#0
            STRB R5,[R0,#4]
            STRB R6,[R0,#5]
            B divisor

stop: B stop