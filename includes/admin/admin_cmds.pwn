// admin_cmds.pwn
// Comandos de administrador.
// Contiene: /adminduty, /adminoffduty, /kick, /ban, /dararma, /limpiararmas

#if defined _admin_cmds_included
    #endinput
#endif
#define _admin_cmds_included


CMD:adminduty(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN] Ya estás en modo administrador.");

    SetAdminDuty(playerid, true);
    SaveUser_Data(playerid);

    new name[MAX_PLAYER_NAME], msg[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "[ADMIN] %s (ID:%d) ha entrado en servicio como administrador.", name, playerid);
    SendClientMessageToAll(COLOR_YELLOW, msg);
    return 1;
}

CMD:adminoffduty(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN] No estás en modo administrador.");

    SetAdminDuty(playerid, false);
    SaveUser_Data(playerid);

    new name[MAX_PLAYER_NAME], msg[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "[ADMIN] %s (ID:%d) ha salido del servicio de administrador.", name, playerid);
    SendClientMessageToAll(COLOR_YELLOW, msg);
    return 1;
}

CMD:kick(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /kick [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(targetid == playerid)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes kickearte a ti mismo.");

    // Si el target es admin con nivel mayor o igual, no se puede kickear
    if(pInfo[targetid][pAdmin] >= pInfo[playerid][pAdmin] && pInfo[playerid][pAdmin] < ADMIN_HEAD)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes kickear a un admin de igual o mayor nivel.");

    ShowKickReasonDialog(playerid, targetid);
    return 1;
}

CMD:ban(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /ban [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(targetid == playerid)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes banearte a ti mismo.");

    if(pInfo[targetid][pAdmin] >= pInfo[playerid][pAdmin] && pInfo[playerid][pAdmin] < ADMIN_HEAD)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes banear a un admin de igual o mayor nivel.");

    ShowBanReasonDialog(playerid, targetid);
    return 1;
}

CMD:dararma(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid, weaponid, ammo;
    if(sscanf(params, "udd", targetid, weaponid, ammo))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /dararma [id] [arma] [municion]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(weaponid < 1 || weaponid > 46)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] ID de arma inválido. Rango: 1-46.");

    if(ammo < 1 || ammo > 9999)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Munición inválida. Rango: 1-9999.");

    GivePlayerWeapon(targetid, WEAPON:weaponid, ammo);

    new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], msg[160];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    GetPlayerName(targetid, targetName, sizeof(targetName));

    format(msg, sizeof(msg), "[ADMIN] %s te ha dado el arma %d con %d municiones.", adminName, weaponid, ammo);
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Le diste el arma %d con %d municiones a %s (ID:%d).", weaponid, ammo, targetName, targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:limpiararmas(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /limpiararmas [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    ResetPlayerWeapons(targetid);

    new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], msg[160];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    GetPlayerName(targetid, targetName, sizeof(targetName));

    format(msg, sizeof(msg), "[ADMIN] %s ha limpiado tus armas.", adminName);
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Limpiaste las armas de %s (ID:%d).", targetName, targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:to(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /to [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(targetid == playerid)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes teleportarte a ti mismo.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(playerid, x + 1.0, y + 1.0, z);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    new targetName[MAX_PLAYER_NAME], msg[128];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(msg, sizeof(msg), "[ADMIN] Te teleportaste a %s (ID:%d).", targetName, targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:traer(playerid, params[]) {
    if(!pInfo[playerid][pLogged])
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");

    if(!IsOnDuty(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /traer [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(targetid == playerid)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes traerte a ti mismo.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(targetid, x + 1.0, y + 1.0, z);
    SetPlayerInterior(targetid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));

    new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], msg[128];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    GetPlayerName(targetid, targetName, sizeof(targetName));

    format(msg, sizeof(msg), "[ADMIN] El administrador %s te ha traído a su posición.", adminName);
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Trajiste a %s (ID:%d) a tu posición.", targetName, targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

