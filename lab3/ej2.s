    .cpu cortex-m4  // Indica el procesador de destino
    .syntax unified // Habilita las instrucciones Thumb-2
    .thumb          // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// CONFIGURACIÓN BOTONES DEL PONCHO

// Recursos utilizados por el primer boton
    .equ BTN_1_PORT, 4
    .equ BTN_1_PIN, 8
    .equ BTN_1_BIT, 12
    .equ BTN_1_MASK, (1 << BTN_1_BIT)

// Recursos utilizados por el segundo boton
    .equ BTN_2_PORT, 4
    .equ BTN_2_PIN, 9
    .equ BTN_2_BIT, 13
    .equ BTN_2_MASK, (1 << BTN_2_BIT)

// Recursos utilizados por el tercer boton
    .equ BTN_3_PORT, 4
    .equ BTN_3_PIN, 10
    .equ BTN_3_BIT, 14
    .equ BTN_3_MASK, (1 << BTN_3_BIT)

// Recursos utilizados por el cuarto boton
    .equ BTN_4_PORT, 6
    .equ BTN_4_PIN, 7
    .equ BTN_4_BIT, 15
    .equ BTN_4_MASK, (1 << BTN_4_BIT)

// Recursos utilizados por el teclado
    .equ BTN_GPIO, 5
    .equ BTN_OFFSET, ( BTN_GPIO << 2)
    .equ BTN_MASK, ( BTN_1_MASK | BTN_2_MASK | BTN_3_MASK | BTN_4_MASK )

//CONFIGURACIÓN DIGITOS PONCHO

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

//CONFIGURACION DE LOS SEGMENTOS

//Recursos utilizados por el segmento b
    .equ SEG_B_PORT, 4
    .equ SEG_B_PIN, 1
    .equ SEG_B_BIT, 1
    .equ SEG_B_MASK, (1 << SEG_B_BIT)

//Recursos utilizados por el segmento C
    .equ SEG_C_PORT, 4
    .equ SEG_C_PIN, 2
    .equ SEG_C_BIT, 2
    .equ SEG_C_MASK, (1 << SEG_C_BIT)

// Recursos utilizados por los SEGMENTOS
    .equ SEG_GPIO, 2
    .equ SEG_OFFSET, ( SEG_GPIO << 2)
    .equ SEG_MASK, ( SEG_B_MASK | SEG_C_MASK)


/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data // Define la seccion de variables (RAM)
espera:
    .zero 1 // Variable compartida con el tiempo de espera

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset   // Define el punto de entrada del codigo
    .section .text  // Define la seccion de codigo (FLASH)
    .func main      // Inidica al depurador el inicio de una funcion
reset:
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]

    // Se configuran los pines de los segmentos como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-UP
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS |SCU_MODE_FUNC4)
    STR R0,[R1,#(BTN_1_PORT << 7 | BTN_1_PIN << 2)]
    STR R0,[R1,#(BTN_2_PORT << 7 | BTN_2_PIN << 2)]
    STR R0,[R1,#(BTN_3_PORT << 7 | BTN_3_PIN << 2)]
    STR R0,[R1,#(BTN_4_PORT << 7 | BTN_4_PIN << 2)]

    // Apaga todos los bits gpio de los seg
    LDR R1,=GPIO_CLR0           //Apunto al registro de CLR0
    LDR R0,=SEG_MASK            //Cargo la máscara con 1 en bits que corresponden al seg y 0 en el resto
    STR R0,[R1,#SEG_OFFSET]     

    //Apaga los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    //Configuro los digitos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK            //salida si DIR=1 y entrada si DIR=0 por eso OR
    STR R0,[R1,#DIG_OFFSET]

    // Configura los SEG como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Configura los botones como entradas
    LDR R0,[R1,#BTN_OFFSET]
    BIC R0,#BTN_MASK
    STR R0,[R1,#BTN_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las entradas
    LDR R5,=GPIO_NOT0       //Registro que me permite hacer un toggle

    LDR R0,[R4,#SEG_OFFSET]
    ORR R0,SEG_MASK
    STR R0,[R4,#SEG_OFFSET]

refrescar:
    // Define el estado actual de los leds como todos apagados
    MOV R3,#0x00
    // Carga el estado actual de las teclas
    LDR R0,[R4,#BTN_OFFSET]

    // Verifica el estado del bit correspondiente a la tecla uno
    TST R0,#BTN_1_MASK
    // Si la tecla esta apretada
    IT NE
    // Enciende eL DIG1
    ORRNE R3,#DIG_1_MASK

    // Prende el dig 2 si el botón 2 está apretado
    TST R0,#BTN_2_MASK
    // Si el boton 2 esta apretado
    IT NE
    // Enciende eL DIG2
    ORRNE R3,#DIG_2_MASK

    // Prende el dig 3 si el botón 3 está apretado
    TST R0,#BTN_3_MASK
    // Si el boton 3 esta apretado
    IT NE
    // Enciende eL DIG3
    ORRNE R3,#DIG_3_MASK

    // Prende el dig 4 si el botón 4 está apretado
    TST R0,#BTN_4_MASK
    // Si el boton 4 esta apretado
    IT NE
    // Enciende eL DIG4
    ORRNE R3,#DIG_4_MASK
    
    // Actualiza las salidas con el estado definido para los leds
    STR R3,[R4,#DIG_OFFSET]
    // Repite el lazo de refresco indefinidamente
    B refrescar

stop:
    B stop

    .pool // Almacenar las constantes de codigo
.endfunc


/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/

.func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#DIG_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#DIG_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
.endfunc