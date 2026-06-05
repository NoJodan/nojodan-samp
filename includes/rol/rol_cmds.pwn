// rol_cmds.pwn
// Comandos del sistema de rol.
// Permite al jugador consultar la información de su personaje.

#if defined _rol_cmds_included
    #endinput
#endif
#define _rol_cmds_included

// /me [acción]
// Describe una acción que tu personaje realiza.
CMD:me(playerid, params[]) {
    if(!pInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "USO: /me [acción]");

    new msg[128];
    format(msg, sizeof(msg), "* %s %s.", GetPlayerNameEx(playerid), params);
    ProxDetector(15.0, playerid, msg, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
    return 1;
}

// /do [descripción]
// Describe contexto de la escena.
CMD:do(playerid, params[]) {
    if(!pInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "USO: /do [descripción]");

    new msg[128];
    format(msg, sizeof(msg), "* %s (( %s ))", params, GetPlayerNameEx(playerid));

    ProxDetector(20.0, playerid, msg, COLOR_CYAN, COLOR_CYAN, COLOR_CYAN, COLOR_CYAN);
    return 1;
}

// /e [entorno]
// Describe el entorno o ambiente de la escena.
CMD:e(playerid, params[]) {
    if(!pInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "USO: /e [entorno]");

    new msg[128];
    format(msg, sizeof(msg), "[Entorno]: %s (( %s ))", params, GetPlayerNameEx(playerid));
    ProxDetector(25.0, playerid, msg, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN);
    return 1;
}