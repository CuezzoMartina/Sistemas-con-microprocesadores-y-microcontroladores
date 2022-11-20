    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

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
    .equ DIG_3_BIT, 2
    .equ DIG_3_MASK, (1 << DIG_3_BIT)

// Recursos utilizados por el cuarto dígito
    .equ DIG_4_PORT, 1
    .equ DIG_4_PIN, 17
    .equ DIG_4_BIT, 3
    .equ DIG_4_MASK, (1 << DIG_4_BIT)

// Recursos utilizados por los digitos
    .equ DIG_GPIO, 0
    .equ DIG_OFFSET, ( DIG_GPIO << 2)
    .equ DIG_MASK, ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )

//Recusos utilizados por el punto del display
    .equ SEG_DP_PORT, 6
    .equ SEG_DP_PIN, 8
    .equ SEG_DP_BIT, 16
    .equ SEG_DP_MASK, (1 << SEG_DP_BIT)
    .equ SEG_DP_GPIO, 5
    .equ SEG_DP_OFFSET, ( SEG_DP_GPIO << 2)

//Recursos utilizados por el segmento a
    .equ SEG_A_PORT, 4
    .equ SEG_A_PIN, 0
    .equ SEG_A_BIT, 0
    .equ SEG_A_MASK, (1 << SEG_A_BIT)

//Recursos utilizados por el segmento b
    .equ SEG_B_PORT, 4
    .equ SEG_B_PIN, 1
    .equ SEG_B_BIT, 1
    .equ SEG_B_MASK, (1 << SEG_B_BIT)

//Recursos utilizados por el segmento c
    .equ SEG_C_PORT, 4
    .equ SEG_C_PIN, 2
    .equ SEG_C_BIT, 2
    .equ SEG_C_MASK, (1 << SEG_C_BIT)

//Recursos utilizados por el segmento d
    .equ SEG_D_PORT, 4
    .equ SEG_D_PIN, 3
    .equ SEG_D_BIT, 3
    .equ SEG_D_MASK, (1 << SEG_D_BIT)

//Recursos utilizados por el segmento e
    .equ SEG_E_PORT, 4
    .equ SEG_E_PIN, 4
    .equ SEG_E_BIT, 4
    .equ SEG_E_MASK, (1 << SEG_E_BIT)

//Recursos utilizados por el segmento f
    .equ SEG_F_PORT, 4
    .equ SEG_F_PIN, 5
    .equ SEG_F_BIT, 5
    .equ SEG_F_MASK, (1 << SEG_F_BIT)

//Recursos utilizados por el segmento g
    .equ SEG_G_PORT, 4
    .equ SEG_G_PIN, 6
    .equ SEG_G_BIT, 6
    .equ SEG_G_MASK, (1 << SEG_G_BIT)

// Recursos utilizados por los SEGMENTOS
    .equ SEG_GPIO, 2
    .equ SEG_OFFSET, ( SEG_GPIO << 2)
    .equ SEG_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )



//Vector de interrupciones
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
    .word   systick_isr+1   // 15: System tick service routine
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
    .word   handler+1       // 56: IRQ 40: GINT1 service routines

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .data
cont_refresco:  .byte 0      //Contador de refrescos
tiempo:         .byte 0,0,0,0,0,0

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)

.func main                  // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    CPSID I
    //Configuracion de digitos y segmentos
    BL config_dig
    BL config_seg
    //Configuracion del systick
    BL systick_init

    // Cuenta con clock interno
    LDR R1,=TIMER0_BASE
    MOV R0,#0x00
    STR R0,[R1,#CTCR]    //CTCR=0 clock interno

    // Prescaler de 9.500.000 para una frecuencia de 10 Hz
    LDR R0,=95000000
    STR R0,[R1,#PR]

    // El valor del semiperiodo para 1 Hz
    LDR R0,=86400
    STR R0,[R1,#MR3]    //Match provoca una interrupcion cada 5 llamadas del prescaler

    // El registro de match 3 provoca reset del contador
    MOV R0,#(MR3R | MR3I)   //Provoca reset e interrupcion que lleva a rutina
    STR R0,[R1,#MCR]

    // Limpieza del contador
    MOV R0,#CRST         //b1 del TCR pone en 0 el contador
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN         //b0 del TCR indica si arranca (CEN=1) o no la cuenta
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

main:
    B main

.pool       // Almacenar las constantes de código
.endfunc

tabla: .byte 0x3F,0x06,0x5b,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67

/****************************************************************************/
/* Rutina de servicio para la interrupcion del timer                        */
/****************************************************************************/
.func timer_isr
timer_isr:
    PUSH {LR}
    // Limpio el flag de interrupcion
    LDR R3,=TIMER0_BASE
    LDR R0,[R3,#IR]
    STR R0,[R3,#IR]
    //Llamo a rutina de actualización de reloj
    // Retorno
    POP {PC}
.pool                   // Almacenar las constantes de código
.endfunc

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
.func systick_isr
systick_isr:
    PUSH {LR}
    BL actualizar_reloj
    BL refresco
    POP {PC} // Se retorna al programa principal
.pool // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de actualizacion de reloj                                                 */
/************************************************************************************/
.func actualizar_reloj
actualizar_reloj:
    PUSH {LR}
    LDR R1,=TIMER0_BASE
    LDR R0,[R1,#TC]      //R0 = TIMER0_BASE + TC (Timer Counter), o sea valor del contador
    LDR R2,=tiempo 
    //Contador segundos 
    LDR R4,=60    
    PUSH {R0}
    ADD R3,R0,#0
    BL modulo
    POP {R0}
    BL dec_bcd
    STRB R3,[R2]
    STRB R5,[R2,#1]
    //Contador minutos
    LDR R4,=60
    ADD R3,R0,#0
    UDIV R3,R0,R4
    BL dec_bcd
    STRB R3,[R2,#2]
    STRB R5,[R2,#3]
    //Contador horas
    LDR R4,=3600
    UDIV R3,R0,R4
    BL dec_bcd
    STRB R3,[R2,#4]
    STRB R5,[R2,#5]   
    POP {PC}
.endfunc

/************************************************************************************/
.func modulo
modulo:
    CMP R3,R4                   
    IT MI           //Si r0 < r4
    BXMI LR         //vuelve 
    SUB R3,R4    
    ADD R5,#1               
    B modulo
.endfunc

/************************************************************************************/
.func dec_bcd
dec_bcd:
    PUSH {LR}
    MOV R4,#10
    MOV R5,#0
    BL modulo
    POP {PC}
.endfunc

/************************************************************************************/
.func refresco
refresco:
    PUSH {LR}
    LDR R0,=GPIO_CLR0
    LDR R1,=DIG_MASK
    STR R1,[R0,#DIG_OFFSET]
    LDR R1,=cont_refresco   //R1 = direccion contador refresco      
    LDRB R2,[R1]            //R2 = valor contador refresco
    ADD R2,#1               //R2 ++
    CMP R2,#5       
    IT EQ                   //Si R2 llega a 5
    MOVEQ R2,#1             //R2 vuelve a 1
    STRB R2,[R1]            //Guardo el contador de refrescos
    BL prender_segmento     //Rutina para prender el segmento
    BL prender_digito       //Rutina para prender el digito
    POP {PC}
.endfunc

/************************************************************************************/
.func prender_digito
prender_digito:
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las salidas
    LDR R0,=cont_refresco   //R0 = direccion contador de refrescos
    LDRB R1,[R0]            //R1 = valor cont_ref
    CMP R1,#1           
    IT EQ                   //Si refresco = 1
    MOVEQ R2,#DIG_1_MASK    //Se prende el digito 1 (guardo su mascara en R2)
    CMP R1,#2
    IT EQ                   //Si Refresco = 2
    MOVEQ R2,#DIG_2_MASK    //Se prende el digito 2 (guardo su mascara en R2)
    CMP R1,#3
    IT EQ
    MOVEQ R2,#DIG_3_MASK
    CMP R1,#4
    IT EQ
    MOVEQ R2,#DIG_4_MASK
    STR R2,[R4,#DIG_OFFSET] //Guardo mascara de digito en pin0+dig_offset
    BX LR
.endfunc

/************************************************************************************/
.func prender_segmento
prender_segmento:
    PUSH {LR}
    LDR R5,=GPIO_CLR0
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las salidas
    LDR R0,=cont_refresco
    LDRB R1,[R0]            //R1 = contador de refresco
    CMP R1,#1
    ITT EQ                  //Si refresco = 1
    LDREQ R0,=tiempo        
    LDRBEQ R0,[R0]          //R0 = segundo unidad
    CMP R1,#2               //Si refresco = 2
    ITT EQ
    LDREQ R0,=tiempo 
    LDRBEQ R0,[R0,#1]       //R0 = segundo decena
    CMP R1,#3               //Si refresco = 3
    ITT EQ
    LDREQ R0,=tiempo
    LDRBEQ R0,[R0,#2]
    //Para prender punto o apagar si no es el digito correspondiente
    ITTEE EQ
    MOVEQ R3,#SEG_DP_MASK
    STREQ R3,[R4,#SEG_DP_OFFSET]
    MOVNE R3,#SEG_DP_MASK
    STRNE R3,[R5,#SEG_DP_OFFSET]
    CMP R1,#4               //Si refresco = 4
    ITT EQ
    LDREQ R0,=tiempo
    LDRBEQ R0,[R0,#3]       //R0 = minuto decena
    BL bcd_7seg             //Convierto de BCD a 7 seg 
    STR R3,[R4,#SEG_OFFSET] //Guardo en pin0+seg_offset el nro en 7seg
    POP {PC}
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
.func config_dig
config_dig:
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]
    //Apaga los digitos
    LDR R0,=GPIO_CLR0
    LDR R1,=DIG_MASK
    STR R1,[R0,#DIG_OFFSET]
    //Configuro los digitos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK            //salida si DIR=1 y entrada si DIR=0 por eso OR
    STR R0,[R1,#DIG_OFFSET]
    BX LR        // Se retorna al programa principal
    .pool           // Se almacenan las constantes de codigo
.endfunc

/****************************************************************************/
.func bcd_7seg
bcd_7seg: 
    LDR R3,=tabla     
    LDRB R3,[R3,R0]             //Carga en R3 el digito en 7 seg
    BX LR
.endfunc


/************************************************************************************/
/* Rutina de inicializacion del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    // Se Configura prioridad de la interrupcion
    LDR R1,=SHPR3       // Se apunta al registro de prioridades
    LDR R0,[R1]         // Se cargan las prioridades actuales
    MOV R2,#2           // Se fija la prioridad en 2
    BFI R0,R2,#29,#3    // Se inserta el valor en el campo
    STR R0,[R1]         // Se actualizan las prioridades
    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]         // Se quita el bit ENABLE
    // Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(48000 - 1)
    STR R0,[R1]         // Se especifica el valor de RELOAD
    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]         // Se limpia COUNTER y flag COUNT
    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]         // Se fijan ENABLE, TICKINT y CLOCK_SRC
    BX LR               // Se retorna al programa principal
    .pool               // Se almacenan las constantes de codigo
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
.pool                       // Almacenar las constantes de codigo
.endfunc