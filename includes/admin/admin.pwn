// admin.pwn
// Módulo central de administración.
// Orquesta el sistema admin, inicializa permisos y enlaza los submódulos admin.

#if defined _admin_included
    #endinput
#endif
#define _admin_included

// Comprueba si un jugador tiene nivel admin suficiente
stock IsAdmin(playerid, level = ADMIN_MIN_LEVEL) {
    return (pInfo[playerid][pAdmin] >= level);
}

// Activa/desactiva el modo duty de un admin
stock SetAdminDuty(playerid, bool:duty) {
    pInfo[playerid][pOnDuty] = duty ? 1 : 0;
}

stock bool:IsOnDuty(playerid) {
    return bool:(pInfo[playerid][pOnDuty] == 1);
}

