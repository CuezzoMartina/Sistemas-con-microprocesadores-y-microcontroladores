    .cpu cortex-m4  // Indica el procesador de destino
    .syntax unified // Habilita las instrucciones Thumb-2
    .thumb          // Usar instrucciones Thumb y no ARM
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
    .equ SEG_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)

// Recursos utilizados por TECLA 1
    .equ TEC_1_PORT, 4
    .equ TEC_1_PIN, 8
    .equ TEC_1_BIT, 12
    .equ TEC_1_MASK, (1 << TEC_1_BIT)

// Recursos utilizados por TECLA 2
    .equ TEC_2_PORT, 4
    .equ TEC_2_PIN, 9
    .equ TEC_2_BIT, 13
    .equ TEC_2_MASK, (1 << TEC_2_BIT)

// Recursos utilizados por TECLA 3
    .equ TEC_3_PORT, 4
    .equ TEC_3_PIN, 10
    .equ TEC_3_BIT, 14
    .equ TEC_3_MASK, (1 << TEC_3_BIT)

// Recursos utilizados por TECLA 4
    .equ TEC_4_PORT, 6
    .equ TEC_4_PIN, 7
    .equ TEC_4_BIT, 15
    .equ TEC_4_MASK, (1 << TEC_4_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO, 5
    .equ TEC_OFFSET, ( TEC_GPIO << 2)
    .equ TEC_MASK, ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK )

/****************************************************************************/
/*              Vector de interrupciones                                    */
/****************************************************************************/
    .section .isr   // Define una seccion especial para el vector
    .word stack     // 0: Initial stack pointer value
    .word reset+1   // 1: Initial program counter value
    .word handler+1 // 2: Non mascarable interrupt service routine
    .word handler+1 // 3: Hard fault system trap service routine
    .word handler+1 // 4: Memory manager system trap service routine
    .word handler+1 // 5: Bus fault system trap service routine
    .word handler+1 // 6: Usage fault system tram service routine
    .word 0         // 7: Reserved entry
    .word 0         // 8: Reserved entry
    .word 0         // 9: Reserved entry
    .word 0         // 10: Reserved entry
    .word handler+1 // 11: System service call trap service routine
    .word 0         // 12: Reserved entry
    .word 0         // 13: Reserved entry
    .word handler+1 // 14: Pending service system trap service routine
    .word systick_isr+1 // 15: System tick service routine
    .word handler+1 // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data  // Define la seccion de variables (RAM)

espera:     .hword 100
bandera:    .byte 1     //Bandera para habilitar decremento de tiempo
cont_ref:   .byte 0     //Contador de refrescos
tmp_tec:    .hword 0    //Espera para que se tome en cuenta el apretado de la tecla
tiempo:     .byte 9,9


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset   // Define el punto de entrada del codigo
    .section .text  // Define la seccion de codigo (FLASH)
    .func main      // Inidica al depurador el inicio de una funcion

reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]
    // Llama a una subrutina para configurar los segmentos y digitos, y teclas
    BL config_dig   
    BL config_seg
    BL config_tec
    // Llama a una subrutina para configurar el systick
    BL systick_init

stop:   B stop

.endfunc

//Tabla de conversion BCD a 7seg
tabla: .byte 0x3F,0x06,0x5b,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
.func systick_isr
systick_isr:
    PUSH {LR}
    BL teclas
    BL actualizar_reloj
    BL refresco 
    POP {PC} // Se retorna al programa principal
.endfunc


/************************************************************************************/
.func teclas
teclas:
    PUSH {LR} 
    LDR R0,=GPIO_PIN0           
    LDR R1,[R0,#TEC_OFFSET]     //R1 = estado de teclas
    TST R1,#TEC_1_MASK
    IT NE                       //Si tecla apretada = tecla F1
    BLNE tecla_1                //Subrutina para teclaF1
    TST R1,#TEC_2_MASK
    IT NE                       //Si tecla apretada = tecla F2
    BLNE tecla_2                //Subrutina para teclaF2
    TST R1,#TEC_3_MASK
    IT NE                       //Si tecla apretada = tecla F3
    BLNE tecla_3                //Subrutina para teclaF3
    POP {PC} // Se retorna al programa principal
.endfunc


/************************************************************************************/
.func tecla_1
tecla_1:
    PUSH {LR}
    LDR R0,=tmp_tec     //R0 = direccion de tmp_tec
    LDRH R1,[R0]        //R1 = valor de tmp_tec
    ADD R1,#1           //tmp_tec +1
    CMP R1,#400
    ITE EQ              //Si tmp_tec = 0
    LDRHEQ R1,=0        //tmp_tec = 0       
    BNE fin_tecla_1     //Si no es 400, salgo
    LDR R2,=bandera     //R2 = direccion bandera
    LDRB R3,[R2]        //R3 = valor bandera (para comenzar a contar)
    EOR R3,#1           //invierto valor de bandera
    STRB R3,[R2]        //Guardo nuevo valor de bandera
fin_tecla_1:
    STRH R1,[R0]        //Guardo el valor de tmp_tec
    POP {PC}            // Se retorna al programa principal
.endfunc

/************************************************************************************/
.func tecla_2
tecla_2:
    LDR R0,=tmp_tec     //R0 = direccion de tmp_tec
    LDRH R1,[R0]        //R1 = valor de 
    ADD R1,#1           //tmp_tec +1
    CMP R1,#400
    ITE EQ              //Si tmp_tec = 0
    LDRHEQ R1,=0        //tmp_tec = 0       
    BNE fin_tecla_2     //Si no es 400, salgo
    LDR R2,=espera      //R2 = direccion espera
    LDRH R3,[R2]        //R3 = valor espera
    ADD R3,#200
    STRH R3,[R2]        //Guardo nuevo valor de espera
fin_tecla_2:
    STRH R1,[R0]        //Guardo el valor de tmp_tec
    BX LR            // Se retorna al programa principal
.endfunc

/************************************************************************************/
.func tecla_3
tecla_3:
    LDR R0,=tmp_tec     //R0 = direccion de tmp_tec
    LDRH R1,[R0]        //R1 = valor de 
    ADD R1,#1           //tmp_tec +1
    CMP R1,#400
    ITE EQ              //Si tmp_tec = 0
    LDRHEQ R1,=0        //tmp_tec = 0       
    BNE fin_tecla_2     //Si no es 400, salgo
    LDR R2,=espera      //R2 = direccion espera
    LDRH R3,[R2]        //R3 = valor espera
    ADD R3,#200
    STRH R3,[R2]        //Guardo nuevo valor de espera
fin_tecla_3:
    STRH R1,[R0]        //Guardo el valor de tmp_tec
    BX LR            // Se retorna al programa principal
.endfunc

/************************************************************************************/
/* Rutina de refresco de pantalla                                                   */
/************************************************************************************/
.func refresco
refresco:
    PUSH {LR}
    BL apagar_digitos
    LDR R1,=cont_ref        //R1 = direccion contador refresco      
    LDRB R2,[R1]            //R2 = valor contador refresco
    ADD R2,#1               //R2 ++
    CMP R2,#3       
    IT EQ                   //Si R2 llega a 5
    MOVEQ R2,#1             //R2 vuelve a 1
    STRB R2,[R1]            //Guardo el contador de refrescos
    BL prender_segmento     //Rutina para prender el segmento
    BL prender_digito       //Rutina para prender el digito
    POP {PC}
.endfunc


/************************************************************************************/
/* Rutina de apagado de digitos                                                     */
/************************************************************************************/
.func apagar_digitos
apagar_digitos:
    LDR R0,=GPIO_CLR0
    LDR R1,=DIG_MASK
    STR R1,[R0,#DIG_OFFSET]
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de prendido de digitos                                                    */
/************************************************************************************/
.func prender_digito
prender_digito:
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las salidas
    LDR R0,=cont_ref        //R0 = direccion contador de refrescos
    LDRB R1,[R0]             //R1 = valor cont_ref
    CMP R1,#1           
    IT EQ                   //Si refresco = 1
    MOVEQ R2,#DIG_1_MASK    //Se prende el digito 1 (guardo su mascara en R1)
    CMP R1,#2
    IT EQ                   //Si Refresco = 2
    MOVEQ R2,#DIG_2_MASK    //Se prende el digito 2 (guardo su mascara en R1)
    STR R2,[R4,#DIG_OFFSET] //Guardo mascara de digito en pin0+dig_offset
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de prendido de segmentos                                                  */
/************************************************************************************/
.func prender_segmento
prender_segmento:
    PUSH {LR}
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las salidas
    LDR R0,=cont_ref
    LDRB R1,[R0]            //R1 = contador de refresco
    LDR R0,=tiempo
    CMP R1,#1
    IT EQ                   //Si refresco = 1
    LDRBEQ R0,[R0]          //R0 = unidad
    CMP R1,#2
    IT EQ                   //Si refresco = 2
    LDRBEQ R0,[R0,#1]       //R0 = decena
    BL segmentos            //R3 = 7seg de R0 
    STR R3,[R4,#SEG_OFFSET] //Guardo en pin0+seg_offset el nro en 7seg
    POP {PC}
.endfunc

/************************************************************************************/
/* Rutina de actualizacion de reloj                                                 */
/************************************************************************************/
.func actualizar_reloj
actualizar_reloj:
    PUSH {LR}
    LDR R0,=espera
    LDRH R1,[R0]         //R1 = espera
    SUB R1,#1            //Espera -1
    CMP R1,#0
    ITE MI               //Si espera < 0
    LDRMI R1,=100        //Espera = 100
    BPL final            //Si espera >0 salgo
    LDR R2,=bandera
    LDRB R2,[R2]         //R2 = bandera
    TST R2,#1
    IT NE                //Si bandera = 1
    BLNE decremento      //Funcion decremento de 0,01s
final:
    STRH R1,[R0]
    POP {PC}
.endfunc

/************************************************************************************/
.func decremento
decremento:
    PUSH {R0,R1}
    LDR R0,=tiempo
    LDRB R1,[R0]           //R1 = unidad
    LDRB R2,[R0,#1]        //R2 = decena
    SUB R1,#1              //R1 -1
    CMP R1,#0               
    ITT MI                 //Si R1<0
    SUBMI R2,#1            //decena -1
    MOVMI R1,#9            //unidad = 9
    CMP R2,#0
    IT MI                  //Si decena <0
    MOVMI R2,#9            //decena = 0
    STRB R1,[R0]
    STRB R2,[R0,#1]
    POP {R0,R1}
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de inicializacion del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I             // Se deshabilitan globalmente las interrupciones
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
    CPSIE I             // Se habilitan globalmente las interrupciones
    BX LR               // Se retorna al programa principal
    .pool               // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de inicializacion de segmentos                                            */
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
    // Apaga todos los bits gpio de los seg
    LDR R1,=GPIO_CLR0           //Apunto al registro de CLR0
    LDR R0,=SEG_MASK            //Cargo la máscara con 1 en bits que corresponden al seg y 0 en el resto
    STR R0,[R1,#SEG_OFFSET] 
    // Configura los SEG como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    BX LR     // Se retorna al programa principal
    .pool     // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de inicializacion de DIGITOS                                              */
/************************************************************************************/
.func config_dig
config_dig:
    PUSH {LR}
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]
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
/* Rutina de inicializacion de botones                                              */
/************************************************************************************/
.func config_tec
config_tec:
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    // Configura los pines de las teclas como gpio con pull-UP
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS |SCU_MODE_FUNC4)
    STR R0,[R1,#(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
    STR R0,[R1,#(TEC_2_PORT << 7 | TEC_2_PIN << 2)]
    STR R0,[R1,#(TEC_3_PORT << 7 | TEC_3_PIN << 2)]
    STR R0,[R1,#(TEC_4_PORT << 7 | TEC_4_PIN << 2)]
    // Configura las teclas como entradas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK
    STR R0,[R1,#TEC_OFFSET]
    BX LR      // Se retorna al programa principal
    .pool      // Se almacenan las constantes de codigo
.endfunc


/************************************************************************************/
/* Rutina de conversion BCD a 7segmentos                                            */
/************************************************************************************/
.func segmentos
segmentos: 
    LDR R3,=tabla     
    LDRB R3,[R3,R0]             //Carga en R3 el digito en 7 seg
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/

.func handler
handler:
    LDR R1,=GPIO_SET0       // Se apunta a la base de registros SET
    MOV R0,#DIG_1_MASK      // Se carga la mascara para el LED 1
    STR R0,[R1,#DIG_OFFSET] // Se activa el bit GPIO del LED 1
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Se almacenan las constantes de codigo
.endfunc

