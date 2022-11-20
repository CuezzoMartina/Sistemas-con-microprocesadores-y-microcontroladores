    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por tecla 1
    .equ TEC_1_PORT, 4
    .equ TEC_1_PIN, 8
    .equ TEC_1_BIT, 12
    .equ TEC_1_MASK, (1 << TEC_1_BIT)

// Recursos utilizados por tecla 2
    .equ TEC_2_PORT, 4
    .equ TEC_2_PIN, 9
    .equ TEC_2_BIT, 13
    .equ TEC_2_MASK, (1 << TEC_2_BIT)

// Recursos utilizados por tecla 3
    .equ TEC_3_PORT, 4
    .equ TEC_3_PIN, 10
    .equ TEC_3_BIT, 14
    .equ TEC_3_MASK, (1 << TEC_3_BIT)

// Recursos utilizados por tecla 4
    .equ TEC_4_PORT, 6
    .equ TEC_4_PIN, 7
    .equ TEC_4_BIT, 15
    .equ TEC_4_MASK, (1 << TEC_4_BIT)

//Recursos utilizador por la tecla aceptar
    .equ TEC_AC_PORT, 3
    .equ TEC_AC_PIN, 2
    .equ TEC_AC_BIT, 9
    .equ TEC_AC_MASK, (1 << TEC_AC_BIT)

// Recursos utilizados por tecla de cancelar
    .equ TEC_CN_PORT, 3
    .equ TEC_CN_PIN, 1
    .equ TEC_CN_BIT, 8
    .equ TEC_CN_MASK, (1 << TEC_CN_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO, 5
    .equ TEC_OFFSET, ( TEC_GPIO << 2)
    .equ TEC_MASK, ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK | TEC_AC_MASK | TEC_CN_MASK)

// Recursos utilizados por el primer dígito
    .equ DIG_1_PORT, 0
    .equ DIG_1_PIN, 0
    .equ DIG_1_BIT, 0
    .equ DIG_1_MASK, (1 << DIG_1_BIT)

// Recursos utilizados por el segundo dígito
    .equ DIG_2_PORT, 0
    .equ DIG_2_PIN, 1
    .equ DIG_2_BIT, 1
    .equ DIG_2_MASK, (1 << DIG_2_BIT)

// Recursos utilizados por el tercer dígito
    .equ DIG_3_PORT, 1
    .equ DIG_3_PIN, 15
    .equ DIG_3_MAT, 1
    .equ DIG_3_TMR, 0

// Recursos utilizados por el cuarto dígito
    .equ DIG_4_PORT, 1
    .equ DIG_4_PIN, 17
    .equ DIG_4_BIT, 3
    .equ DIG_4_MASK, (1 << DIG_4_BIT)

// Recursos utilizados por los digitos
    .equ DIG_GPIO, 0
    .equ DIG_OFFSET, ( DIG_GPIO << 2)
    .equ DIG_MASK, ( DIG_1_MASK | DIG_2_MASK | DIG_4_MASK )

//Recusos utilizados por el punto del display
    .equ SEG_DP_PORT, 6
    .equ SEG_DP_PIN, 8
    .equ SEG_DP_BIT, 16
    .equ SEG_DP_MASK, (1 << SEG_DP_BIT)
    .equ SEG_DP_GPIO, 5
    .equ SEG_DP_OFFSET, ( SEG_DP_GPIO << 2)

// Recursos utilizados por los SEGMENTOS
    .equ SEG_A_PORT, 4
    .equ SEG_A_PIN, 0
    .equ SEG_A_BIT, 0
    .equ SEG_A_MASK, (1 << SEG_A_BIT)

    .equ SEG_B_PORT, 4
    .equ SEG_B_PIN, 1
    .equ SEG_B_BIT, 1
    .equ SEG_B_MASK, (1 << SEG_B_BIT)

    .equ SEG_C_PORT, 4
    .equ SEG_C_PIN, 2
    .equ SEG_C_BIT, 2
    .equ SEG_C_MASK, (1 << SEG_C_BIT)

    .equ SEG_D_PORT, 4
    .equ SEG_D_PIN, 3
    .equ SEG_D_BIT, 3
    .equ SEG_D_MASK, (1 << SEG_D_BIT)

    .equ SEG_E_PORT, 4
    .equ SEG_E_PIN, 4
    .equ SEG_E_BIT, 4
    .equ SEG_E_MASK, (1 << SEG_E_BIT)

    .equ SEG_F_PORT, 4
    .equ SEG_F_PIN, 5
    .equ SEG_F_BIT, 5
    .equ SEG_F_MASK, (1 << SEG_F_BIT)

    .equ SEG_G_PORT, 4
    .equ SEG_G_PIN, 6
    .equ SEG_G_BIT, 6
    .equ SEG_G_MASK, (1 << SEG_G_BIT)

    .equ SEG_GPIO, 2
    .equ SEG_OFFSET, ( SEG_GPIO << 2)
    .equ SEG_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )

/****************************************************************************/
/*                    Vector de interrupciones                              */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   handler+1       // 15: System tick service routine
    .word   handler+1       // 16: IRQ 0: DAC service routine
    .word   handler+1       // 17: IRQ 1: M0APP service routine
    .word   handler+1       // 18: IRQ 2: DMA service routine
    .word   0               // 19: Reserved entry
    .word   handler+1       // 20: IRQ 4: FLASHEEPROM service routine
    .word   handler+1       // 21: IRQ 5: ETHERNET service routine
    .word   handler+1       // 22: IRQ 6: SDIO service routine
    .word   handler+1       // 23: IRQ 7: LCD service routine
    .word   handler+1       // 24: IRQ 8: USB0 service routine
    .word   handler+1       // 25: IRQ 9: USB1 service routine
    .word   handler+1       // 26: IRQ 10: SCT service routine
    .word   handler+1       // 27: IRQ 11: RTIMER service routine
    .word   timer_isr+1     // 28: IRQ 12: TIMER0 service routine
    .word   handler+1       // 29: IRQ 13: TIMER1 service routine
    .word   handler+1       // 30: IRQ 14: TIMER2 service routine
    .word   handler+1       // 31: IRQ 15: TIMER3 service routine
    .word   handler+1       // 32: IRQ 16: MCPWM service routine
    .word   handler+1       // 33: IRQ 17: ADC0 service routine
    .word   handler+1       // 34: IRQ 18: I2C0 service routine
    .word   handler+1       // 35: IRQ 19: I2C1 service routine
    .word   handler+1       // 36: IRQ 20: SPI service routine
    .word   handler+1       // 37: IRQ 21: ADC1 service routine
    .word   handler+1       // 38: IRQ 22: SSP0 service routine
    .word   handler+1       // 39: IRQ 23: SSP1 service routine
    .word   handler+1       // 40: IRQ 24: USART0 service routine
    .word   handler+1       // 41: IRQ 25: UART1 service routine
    .word   handler+1       // 42: IRQ 26: USART2 service routine
    .word   handler+1       // 43: IRQ 27: USART3 service routine
    .word   handler+1       // 44: IRQ 28: I2S0 service routine
    .word   handler+1       // 45: IRQ 29: I2S1 service routine
    .word   handler+1       // 46: IRQ 30: SPIFI service routine
    .word   handler+1       // 47: IRQ 31: SGPIO service routine
    .word   handler+1       // 48: IRQ 32: PIN_INT0 service routine
    .word   handler+1       // 49: IRQ 33: PIN_INT1 service routine
    .word   handler+1       // 50: IRQ 34: PIN_INT2 service routine
    .word   handler+1       // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 56: IRQ 40: GINT1 service routine

    /****************************************************************************/
    /* Programa principal                                                       */
    /****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
display:    .byte 1
tec_actual: .word 0
tec_anterior:    .word 0

variables:
    .equ periodo,    0      // Variable compartida el valor del periodo del PWM
    .equ factor,     4      // Variable compartida con el factor de trabajo del PWM

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    BL config_tec
    BL config_seg
    BL config_dig

    //Configuracion digito3 como salida TMAT
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]

    // Inicialización de las variables con los tiempos del PWM
    LDR R1,=variables
    LDR R0,=#200
    STR R0,[R1,#periodo]
    LDR R2,=#20
    STR R2,[R1,#factor]

    // Cuenta con clock interno
    LDR R1,=TIMER0_BASE
    MOV R0,#0x00
    STR R0,[R1,#CTCR]

    // Prescaler de 9500 para una frecuencia de 10 KHz
    LDR R0,=9500
    STR R0,[R1,#PR]

    // La primera interupcion ocurre despues de un factor de trabajo
    STR R2,[R1,#MR1]

    // El registro de match provoca interrupcion
    MOV R0,#(MR1I)
    STR R0,[R1,#MCR]

    // Define el estado inicial y toggle on match del dig1
    MOV R0,#(3 << (4 + (2 * DIG_3_MAT)))
    STR R0,[R1,#EMR]

    // Limpieza del contador
    MOV R0,#CRST
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN
    STR R0,[R1,#TCR]

    // Limpieza del pedido pendiente en el NVIC
    LDR R1,=NVIC_ICPR0
    MOV R0,(1 << 12)
    STR R0,[R1]

    // Habilitacion del pedido de interrupcion en el NVIC
    LDR R1,=NVIC_ISER0
    MOV R0,(1 << 12)
    STR R0,[R1]

    CPSIE I     // Rehabilita interrupciones

    LDR R6,=GPIO_PIN0
main:        
    LDR R1,[R6,#TEC_OFFSET]     //R1 = estado de teclas
    LDR R0,=tec_actual
    LDR R2,=tec_anterior
    LDR R3,[R0]
    STR R3,[R2]                 //Guardo lo que habia en tecla actual en anterior
    TST R1,#TEC_1_MASK
    ITT NE 
    MOVNE R1,#TEC_1_MASK
    STRNE R1,[R0]
    TST R1,#TEC_2_MASK
    ITT NE 
    MOVNE R1,#TEC_2_MASK
    STRNE R1,[R0]
    TEQ R1,#0
    IT EQ
    STREQ R1,[R0]
    CMP R1,R3
    BEQ main
    TST R1,#TEC_1_MASK
    IT NE 
    BLNE tecla_s1
    TST R1,#TEC_2_MASK
    IT NE 
    BLNE tecla_s2
    B main

    .pool       // Almacenar las constantes de código
    .endfunc

/****************************************************************************/
    .func teclas
tecla_s1:
    LDR R12,=variables
    LDR R2,[R12,#factor]
    ADD R2,#20
    CMP R2,#200
    IT EQ
    LDREQ R2,=20
    B fin_teclas

tecla_s2:
    LDR R12,=variables
    LDR R2,[R12,#factor]
    SUB R2,#20
    CMP R2,#0
    IT EQ
    LDREQ R2,=180

fin_teclas:
    STR R2,[R12,#factor]
    LDR R0,=display
    LDR R1,=20
    UDIV R2,R2,R1
    STRB R2,[R0]
    BX LR

    .pool
    .endfunc

/****************************************************************************/
/* Rutina de servicio para la interrupcion del timer                        */
/****************************************************************************/
    .func timer_isr
timer_isr:
    PUSH {LR}
    // Limpio el flag de interrupcion
    LDR R1,=TIMER0_BASE
    LDR R0,[R1,#IR]
    STR R0,[R1,#IR]

    // Cargo el factor de trabajo
    LDR R12,=variables
    LDR R2,[R12,#factor]
    
    // Determino si el punto esta encendido o apagado
    LDR R0,[R1,#EMR]
    TST R0,#(1 << 1)

    ITTE EQ
    // Si esta apagado se utiliza periodo menos el factor de trabajo
    LDREQ R3,[R12,#periodo]
    SUBEQ R3,R2
    // Si esta encendido se utiliza el factor de trabajo
    MOVNE R3,R2

    // Se actualiza el valor de match para la siguiente interrupcion
    LDR R0,[R1,#MR1]
    ADD R0,R3
    STR R0,[R1,#MR1]

    LDR R1,=display
    LDRB R0,[R1]
    BL bcd_7seg
    LDR R0,=GPIO_PIN0
    STR R3,[R0,#SEG_OFFSET] //Guardo en pin0+seg_offset el nro en 7seg
    // Retorno
    POP {PC}

    .pool                   // Almacenar las constantes de código
    .endfunc

/************************************************************************************/
.func config_seg
config_seg:
        // Se configuran los pines de los segmentos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]
    //Punto tiene diferente funcion
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]
    // Apaga todos los bits gpio de los seg
    LDR R1,=GPIO_CLR0           //Apunto al registro de CLR0
    LDR R0,=SEG_MASK            //Cargo la máscara 
    STR R0,[R1,#SEG_OFFSET] 
    LDR R0,=SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]
    // Configura los SEG como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    LDR R0,[R1,#SEG_DP_OFFSET]
    ORR R0,#SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]
    BX LR     // Se retorna al programa principal
    .pool     // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
.func config_tec
config_tec:
    PUSH {LR}
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    // Configura los pines de las teclas como gpio con pull-UP
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS |SCU_MODE_FUNC4)
    STR R0,[R1,#(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
    STR R0,[R1,#(TEC_2_PORT << 7 | TEC_2_PIN << 2)]
    STR R0,[R1,#(TEC_3_PORT << 7 | TEC_3_PIN << 2)]
    STR R0,[R1,#(TEC_4_PORT << 7 | TEC_4_PIN << 2)]
    STR R0,[R1,#(TEC_AC_PORT << 7 | TEC_AC_PIN << 2)]
    STR R0,[R1,#(TEC_CN_PORT << 7 | TEC_CN_PIN << 2)]
    // Configura las teclas como entradas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK
    STR R0,[R1,#TEC_OFFSET]
    POP {PC}        // Se retorna al programa principal
    .pool           // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
.func config_dig
config_dig:
    PUSH {LR}
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]
    //Apaga los digitos
    BL apagar_digitos
    //Configuro los digitos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK            //salida si DIR=1 y entrada si DIR=0 por eso OR
    STR R0,[R1,#DIG_OFFSET]
    POP {PC}        // Se retorna al programa principal
    .pool           // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
.func bcd_7seg
bcd_7seg: 
    LDR R3,=tabla     
    LDRB R3,[R3,R0]             //Carga en R3 el digito en 7 seg
    BX LR
.endfunc

/************************************************************************************/
.func apagar_digitos
apagar_digitos:
    LDR R0,=GPIO_CLR0
    LDR R1,=DIG_MASK
    STR R1,[R0,#DIG_OFFSET]
    BX LR
.endfunc

/****************************************************************************/
/* Rutina de servicio generica para excepciones                             */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.  */
/* Se declara como una medida de seguridad para evitar que el procesador    */
/* se pierda cuando hay una excepcion no prevista por el programador        */
/****************************************************************************/
    .func handler
handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo
    .endfunc

tabla:          .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67