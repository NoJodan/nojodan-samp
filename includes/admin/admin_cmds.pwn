// admin_cmds.pwn
// Comandos de administrador.
// Contiene: /adminduty, /adminoffduty, /kick, /ban, /dararma, /limpiararmas

#if defined _admin_cmds_included
    #endinput
#endif
#define _admin_cmds_included


CMD:adminduty(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(IsOnDuty(playerid))          return SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN] Ya estás en modo administrador.");

    SetAdminDuty(playerid, true);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s (ID:%d) ha entrado en servicio como administrador.", GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(COLOR_YELLOW, msg);
    return 1;
}

CMD:adminoffduty(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN] No estás en modo administrador.");

    SetAdminDuty(playerid, false);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s (ID:%d) ha salido del servicio de administrador.", GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(COLOR_YELLOW, msg);
    return 1;
}

CMD:kick(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

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
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

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
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

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

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s te ha dado el arma %d con %d municiones.", GetPlayerNameEx(playerid), weaponid, ammo);
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Le diste el arma %d con %d municiones a %s (ID:%d).", weaponid, ammo, GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:limpiararmas(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /limpiararmas [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    ResetPlayerWeapons(targetid);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s ha limpiado tus armas.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Limpiaste las armas de %s (ID:%d).", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:tp(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /tp [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(targetid == playerid)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No puedes teleportarte a ti mismo.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(playerid, x + 1.0, y + 1.0, z);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] Te teleportaste a %s (ID:%d).", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:traer(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

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

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] El administrador %s te ha traído a su posición.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Trajiste a %s (ID:%d) a tu posición.", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:mandarinterior(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid, interiorid;
    if(sscanf(params, "ud", targetid, interiorid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /mandarinterior [id] [interior_id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(interiorid < 0 || interiorid > 100) // Asumiendo que el rango de interiores es 0-100
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] ID de interior inválido.");

    SetPlayerInterior(targetid, interiorid);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] El administrador %s te ha mandado al interior %d.", GetPlayerNameEx(playerid), interiorid);
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Mandaste a %s (ID:%d) al interior %d.", GetPlayerNameEx(targetid), targetid, interiorid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:mandarvw(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid, vwid;
    if(sscanf(params, "ud", targetid, vwid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /mandarvw [id] [virtual_world_id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(vwid < 0 || vwid > 100) // Asumiendo que el rango de virtual worlds es 0-100
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] ID de virtual world inválido.");

    SetPlayerVirtualWorld(targetid, vwid);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] El administrador %s te ha mandado al virtual world %d.", GetPlayerNameEx(playerid), vwid);
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Mandaste a %s (ID:%d) al virtual world %d.", GetPlayerNameEx(targetid), targetid, vwid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:darvida(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /darvida [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    SetPlayerHealth(targetid, 100);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s te ha dado vida.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Le diste vida a %s (ID:%d).", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:darchaleco(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /darchaleco [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    SetPlayerArmour(targetid, 100);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s te ha dado un chaleco.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Le diste un chaleco a %s (ID:%d).", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:inmortal(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /inmortal [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    SetPlayerHealth(targetid, 1000);
    SetPlayerArmour(targetid, 1000);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s te ha toggled la inmortalidad.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Toggleste la inmortalidad de %s (ID:%d).", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:darskin(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid, skinid;
    if(sscanf(params, "ud", targetid, skinid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /darskin [id] [skin_id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    SetPlayerSkin(targetid, skinid); // Asumiendo que el skin 0 es un skin especial de admin

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] %s te ha dado un skin.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, msg);

    format(msg, sizeof(msg), "[ADMIN] Le diste un skin a %s (ID:%d).", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:verip(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /verip [id]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    if(pInfo[playerid][pAdmin] < ADMIN_HEAD)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tiene permisos para ver la IP de este jugador.");

    new ip[16];
    GetPlayerIp(targetid, ip, sizeof(ip));

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] La IP de %s (ID:%d) es: %s", GetPlayerNameEx(targetid), targetid, ip);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:setclima(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new climaid;
    if(sscanf(params, "d", climaid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /setclima [clima_id]");

    if(climaid < 0 || climaid > 20) // Asumiendo que el rango de climas es 0-20
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] ID de clima inválido.");

    if(pInfo[playerid][pAdmin] < ADMIN_HEAD)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos para cambiar el clima.");

    SetWeather(climaid);

    new msg[128];
    format(msg, sizeof(msg), "[ADMIN] Cambiaste el clima a %d.", climaid);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}