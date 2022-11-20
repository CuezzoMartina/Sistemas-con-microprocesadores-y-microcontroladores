                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

vector:         .hword 0x1,0x2,0x3,0x4,0x5,0x6,0x7

                .section .text
                .global reset

reset:          LDR R0,=vector
                MOV R3,#7               //Tamaño del vector
                MOV R4,#0               //Inicio del vector
                MOV R6,0X07             //Nro a buscar
                MOV R5,#2               //Para hacer el div
                BL busqueda

stop:           B stop

busqueda:       ADD R8,R3,R4            //Uso R8 para calcular mitad=(R3+R4)
                UDIV R8,R5              //R8=mitad=(R3+R4)/2
                ADD R10,R8,#0           //Guardo en R10 el valor de la posicion
                SUB R8,#1               //R8-1 para poder mover el puntero
                MUL R8,R5               //Porque son halfwords
                ADD R1,R0,R8            //R1 = vector[mitad]
                LDRH R1,[R1]            //Cargo en R1 el valor en la mitad
                CMP R6,R1   
                IT EQ                   //Si lo encuentro
                BXEQ LR                 //Salto
                ITE MI  
                SUBMI R3,R10,#1         //Si R6<vector[mitad] --> R3=mitad-1
                ADDPL R4,R10,#1         //Si R6>vector[mitad] --> R4=mitad+1
                B busqueda
                


       
