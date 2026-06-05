// admin_utils.pwn
// - Funciones relacionadas con el modo administrador, como crear el archivo del jugador, registrar casos, etc.
// - Estas funciones se utilizan en los comandos de administrador y en la lógica de autenticación.

#if defined _admin_utils_included
    #endinput
#endif
#define _admin_utils_included

// Comprueba si un jugador tiene nivel admin suficiente
stock IsAdmin(playerid, level = ADMIN_MIN_LEVEL) {
    return (pInfo[playerid][pAdmin] >= level);
}

// Activa/desactiva el modo duty de un admin
stock SetAdminDuty(playerid, bool:duty) {
    pInfo[playerid][pOnDuty] = duty ? 1 : 0;
    if(duty) {
        GetPlayerHealth(playerid, pInfo[playerid][pHealth]);
        GetPlayerArmour(playerid, pInfo[playerid][pArmour]);
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 100);
        switch(pInfo[playerid][pAdmin]) {
            case ADMIN_TRIAL: SetPlayerColor(playerid, COLOR_TRIAL); break;
            case ADMIN_MOD:   SetPlayerColor(playerid, COLOR_MOD); break;
            case ADMIN_ADMIN: SetPlayerColor(playerid, COLOR_ADMIN); break;
            case ADMIN_HEAD:  SetPlayerColor(playerid, COLOR_HEAD); break;
        }
    } else {
        SetPlayerHealth(playerid, pInfo[playerid][pHealth]);
        SetPlayerArmour(playerid, pInfo[playerid][pArmour]);
        SetPlayerColor(playerid, COLOR_USUARIO);
    }
}

stock bool:IsOnDuty(playerid) {
    return bool:(pInfo[playerid][pOnDuty] == 1);
}