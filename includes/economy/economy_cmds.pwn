/*
    ECONOMY COMMANDS
    Contiene todos los comandos relacionados con el sistema económico.

    Ejemplos:
    - /pay
    - /balance
    - /deposit
    - /withdraw

    Este archivo solo maneja:
    - comandos
    - validaciones básicas
    - mensajes al jugador

    La lógica económica principal se encuentra
    en economy.pwn
*/
#if defined _economy_cmds_included
    #endinput
#endif
#define _economy_cmds_included