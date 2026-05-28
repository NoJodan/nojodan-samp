// rol.pwn
// Módulo central de rol.
// Orquesta el ciclo de vida del personaje: carga datos al conectar,
// muestra la creación de personaje si es nuevo, y limpia al desconectar.

#if defined _rol_included
    #endinput
#endif

#define _rol_included

#include <YSI_Coding\y_hooks>

// Inicializa el personaje cuando el jugador hace spawn y está logueado
hook OnPlayerSpawn(playerid) {
    if(pInfo[playerid][pLogged]) {
        GetPlayerName(playerid, rInfo[playerid][rNombre], MAX_PLAYER_NAME);
        rInfo[playerid][rCreado] = true;
    }
    return 1;
}

// Limpia los datos del personaje al desconectarse
hook OnPlayerDisconnect(playerid, reason) {
    rInfo[playerid][rCreado] = false;
    strcopy(rInfo[playerid][rNombre], "", MAX_PLAYER_NAME);
    return 1;
}

// Función auxiliar: envía mensaje a jugadores cercanos
stock RolProxMsg(playerid, Float:dist, color, const msg[]) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(!IsPlayerConnected(i)) continue;
        if(IsPlayerInRangeOfPoint(i, dist, x, y, z)) {
            SendClientMessage(i, color, msg);
        }
    }
}