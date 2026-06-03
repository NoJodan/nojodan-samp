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


// /me [acción]
// Describe una acción que tu personaje realiza.
CMD:me(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!rInfo[playerid][rCreado])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Aún no tienes un personaje creado.");
    if(isnull(params))
        return SendClientMessage(playerid, COLOR_RED, "USO: /me [acción]");

    new msg[144];
    format(msg, sizeof(msg), "* %s %s.", rInfo[playerid][rNombre], params);

    // Enviar solo a jugadores cercanos
    RolProxMsg(playerid, ROL_CHAT_DIST, COLOR_PURPLE, msg);
    return 1;
}

// /do [descripción]
// Describe algo que ocurre en la escena.
CMD:do(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!rInfo[playerid][rCreado])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Aún no tienes un personaje creado.");
    if(isnull(params))
        return SendClientMessage(playerid, COLOR_RED, "USO: /do [descripción]");

    new msg[160];
    format(msg, sizeof(msg), "* %s (( %s ))", params, rInfo[playerid][rNombre]);

    RolProxMsg(playerid, ROL_CHAT_DIST, COLOR_PURPLE, msg);
    return 1;
}