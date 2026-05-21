// callbacks.pwn
// Centro de definición de callbacks de SA-MP.
// Aquí se declaran los hooks de eventos globales como OnPlayerConnect, OnDialogResponse, OnPlayerCommandText, etc.
// El archivo debe mantenerse como punto de entrada para eventos del servidor, delegando lógica específica a otros módulos.

#if defined _callbacks_included
    #endinput
#endif
#define _callbacks_included