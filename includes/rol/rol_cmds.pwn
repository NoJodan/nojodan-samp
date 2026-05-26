// rol_cmds.pwn
// Comandos del sistema de rol.
// Permite al jugador consultar la información de su personaje.

#if defined _rol_cmds_included
    #endinput
#endif

#define _rol_cmds_included

CMD:stats(playerid, params[]) {
    
    if(!pInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!rInfo[playerid][rCreado]) return SendClientMessage(playerid, COLOR_RED, "[ERROR] Aún no tienes un personaje creado.");

    new sexo[10];
    if(pInfo[playerid][pSex] == SEX_MALE) sexo = "Masculino";
    else sexo = "Femenino";

    new msg[128];

    SendClientMessage(playerid, COLOR_WHITE, "══════════════════════════");
    format(msg, sizeof(msg), "Personaje: %s", rInfo[playerid][rNombre]);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "Sexo: %s | Edad: %d", sexo, pInfo[playerid][pAge]);
    SendClientMessage(playerid, COLOR_WHITE, msg);
    format(msg, sizeof(msg), "Nivel: %d | Dinero: $%d", pInfo[playerid][pLevel], GetPlayerMoney(playerid));
    SendClientMessage(playerid, COLOR_WHITE, msg);
    SendClientMessage(playerid, COLOR_WHITE, "══════════════════════════");
    return 1;
}