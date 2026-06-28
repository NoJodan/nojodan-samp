// faction_cmds.pwn
// Comandos de gestión de facciones.

#if defined _faction_cmds_included
    #endinput
#endif
#define _faction_cmds_included

CMD:crearfacc(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new factionName[32];
    if(sscanf(params, "s[32]", factionName))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /crearfacc [Nombre_Faccion]");

    new slot = -1;
    for(new i = 0; i < MAX_FACTIONS; i++) {
        if(strlen(fInfo[i][fName]) == 0) {
            slot = i;
            break;
        }
    }

    if(slot == -1)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Se ha alcanzado el limite maximo de facciones.");

    new fid = GetNewFactionID();

    new path[128];
    format(path, sizeof(path), "Factions/%d.ini", fid);

    new INI:file = INI_Open(path);
    INI_SetTag(file, "factionData");
    INI_WriteInt(file, "fID", fid);
    INI_WriteString(file, "fName", factionName);
    INI_WriteString(file, "fLeader", "");
    INI_WriteInt(file, "fMembers", 0);

    for(new i = 0; i < 10; i++) {
        new rankKey[16];
        format(rankKey, sizeof(rankKey), "fRankName%d", i);
        INI_WriteString(file, rankKey, "");
    }

    INI_WriteInt(file, "fMoney", 0);
    INI_WriteInt(file, "fWarns", 0);
    INI_WriteInt(file, "fPayday", 0);
    INI_WriteInt(file, "fPickup", 1274);
    INI_WriteInt(file, "fPickupID", 0);
    INI_WriteInt(file, "fInteriorID", 18);
    INI_WriteFloat(file, "fExteriorX", 0.0);
    INI_WriteFloat(file, "fExteriorY", 0.0);
    INI_WriteFloat(file, "fExteriorZ", 0.0);
    INI_WriteFloat(file, "fInteriorX", 0.0);
    INI_WriteFloat(file, "fInteriorY", 0.0);
    INI_WriteFloat(file, "fInteriorZ", 0.0);
    INI_Close(file);

    INI_ParseFile(path, "LoadFaction_Data", .bExtra = true, .extra = slot);

    fInfo[slot][fPickupID] = CreatePickup(1274, 1, 0.0, 0.0, 0.0, 0);
    new string[128];
    format(string, sizeof(string), "Faccion (%d): %s", fid, factionName);
    fInfo[slot][fLabelID] = CreateDynamic3DTextLabel(string, COLOR_USUARIO, 0.0, 0.0, 0.0, 20.0, .testlos = true);

    new msg[128];
    format(msg, sizeof(msg), "[FACCION] Has creado la faccion \"%s\" (ID:%d) en el slot %d.", factionName, fid, slot);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:facciones(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");

    new list[512], line[64];
    for(new i = 0; i < MAX_FACTIONS; i++) {
        if(strlen(fInfo[i][fName]) == 0) continue;

        format(line, sizeof(line), "%d\t%s\t%d\n", fInfo[i][fID], fInfo[i][fName], fInfo[i][fMembers]);
        strcat(list, line, sizeof(list));
    }

    if(strlen(list) == 0)
        return SendClientMessage(playerid, COLOR_WHITE, "[INFO] No hay facciones creadas.");

    ShowPlayerDialog(playerid, KeyDialog, DIALOG_STYLE_TABLIST, "Facciones", list, "Cerrar", "");
    return 1;
}

CMD:darfacc(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new targetid, factionid;
    if(sscanf(params, "ud", targetid, factionid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /darfacc [id] [factionid]");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Jugador no encontrado.");

    new slot = GetFactionSlotByID(factionid);
    if(slot == -1)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Esa faccion no existe.");

    pInfo[targetid][pFaction] = slot;
    pInfo[targetid][pRank] = 0;

    SaveUser_Data(targetid);
    SaveFaction_Data(slot);

    new msg[128];
    format(msg, sizeof(msg), "[FACCION] Has asignado la faccion \"%s\" a %s (ID:%d).", fInfo[slot][fName], GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, COLOR_GREEN, msg);

    format(msg, sizeof(msg), "[FACCION] Has sido asignado a la faccion \"%s\".", fInfo[slot][fName]);
    SendClientMessage(targetid, COLOR_YELLOW, msg);
    return 1;
}

CMD:traerfacc(playerid, params[]) {
    if(!pInfo[playerid][pLogged])   return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes iniciar sesión primero.");
    if(!IsAdmin(playerid))          return SendClientMessage(playerid, COLOR_RED, "[ERROR] No tienes permisos de administrador.");
    if(!IsOnDuty(playerid))         return SendClientMessage(playerid, COLOR_RED, "[ERROR] Debes estar en modo /adminduty para usar comandos admin.");

    new factionid;
    if(sscanf(params, "d", factionid))
        return SendClientMessage(playerid, COLOR_WHITE, "USO: /traerfacc [factionid]");

    new slot = GetFactionSlotByID(factionid);
    if(slot == -1)
        return SendClientMessage(playerid, COLOR_RED, "[ERROR] Esa faccion no existe.");

    DestroyPickup(fInfo[slot][fPickupID]);
    DestroyDynamic3DTextLabel(fInfo[slot][fLabelID]);

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    fInfo[slot][fPickupID] = CreatePickup(fInfo[slot][fPickup], 1, x, y, z, 0);

    new string[128];
    format(string, sizeof(string), "Faccion (%d): %s", fInfo[slot][fID], fInfo[slot][fName]);
    fInfo[slot][fLabelID] = CreateDynamic3DTextLabel(string, COLOR_USUARIO, x, y, z + 1.0, 20.0, .testlos = true);

    fInfo[slot][fExterior][0] = x;
    fInfo[slot][fExterior][1] = y;
    fInfo[slot][fExterior][2] = z;

    SaveFaction_Data(slot);

    new msg[128];
    format(msg, sizeof(msg), "[FACCION] Has movido la base de \"%s\" a tu posicion.", fInfo[slot][fName]);
    SendClientMessage(playerid, COLOR_GREEN, msg);
    return 1;
}
