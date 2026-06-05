// rol.pwn
// Módulo central de rol.
// Orquesta el ciclo de vida del personaje: carga datos al conectar,
// muestra la creación de personaje si es nuevo, y limpia al desconectar.

#if defined _rol_included
    #endinput
#endif

#define _rol_included

#include <YSI_Coding\y_hooks>

hook OnPlayerText(playerid, text[]) {
    new msg[144];
    format(msg, sizeof(msg), "%s dice: %s", GetPlayerNameEx(playerid), text);
    ProxDetector(20.0, playerid, msg, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
    return 0;
}