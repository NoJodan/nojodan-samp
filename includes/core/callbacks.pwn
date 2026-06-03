// callbacks.pwn
// Centro de definición de callbacks de SA-MP.
// Aquí se declaran los hooks de eventos globales como OnPlayerConnect, OnDialogResponse, OnPlayerCommandText, etc.
// El archivo debe mantenerse como punto de entrada para eventos del servidor, delegando lógica específica a otros módulos.

#if defined _callbacks_included
    #endinput
#endif
#define _callbacks_included

#include <YSI_Coding\y_hooks>
#include <strlib>

hook OnPlayerText(playerid, text[]) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    strreplace(name, "_", " "); // Reemplaza espacios por guiones bajos para evitar problemas de formato

    new msg[144];
    format(msg, sizeof(msg), "%s dice: %s", name, text);
    SendClientMessageToAll(-1, msg);
    return 0;
}