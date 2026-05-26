// rol.pwn
// Módulo central de rol.
// Orquesta el ciclo de vida del personaje: carga datos al conectar,
// muestra la creación de personaje si es nuevo, y limpia al desconectar.

#if defined _rol_included
    #endinput
#endif

#define _rol_included

#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid) {
    rInfo[playerid][rNombre]  = '\0';
    rInfo[playerid][rSexo]    = SEX_MALE;
    rInfo[playerid][rEdad]    = 0;
    rInfo[playerid][rCreado]  = false;

    if(fexist(UserPath(playerid))) {
        INI_ParseFile(UserPath(playerid), "LoadRol_%s", .bExtra = true, .extra = playerid);
    }
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if(pInfo[playerid][pLogged] && !rInfo[playerid][rCreado]) {
        ShowPlayerDialog(playerid, RolNombreDialog,
            DIALOG_STYLE_INPUT,
            "Crear personaje",
            ""COLOR_WHITE_T"Bienvenido al servidor.\nEscribe tu nombre de rol (ej: Juan_Perez):",
            "Confirmar", "");
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    rInfo[playerid][rNombre]  = '\0';
    rInfo[playerid][rSexo]    = 0;
    rInfo[playerid][rEdad]    = 0;
    rInfo[playerid][rCreado]  = false;
    return 1;
}