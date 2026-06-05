// rol_utils.pwn
// Utilidades para el manejo de datos de personaje.

#if defined _rol_utils_included
    #endinput
#endif
#define _rol_utils_included

#include <strlib>
#include <YSI_Data\y_foreach>

stock GetPlayerNameEx(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    strreplace(name, "_", " "); // Reemplaza espacios por guiones bajos para evitar problemas de formato
    return name;
}

stock ProxDetector(Float:radi, playerid, str[], color1, color2, color3, color4) {
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new Float:r1 = radi * 0.10;
    new Float:r2 = radi * 0.25;
    new Float:r3 = radi * 0.50;
    new Float:r4 = radi * 0.75;

    foreach(new i : Player) {
        if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid)) continue;

        new Float:dist = GetPlayerDistanceFromPoint(i, px, py, pz);

        if(dist > radi) continue;

        if(dist <= r1) {
            SendClientMessage(i, color1, str);
        } else if(dist <= r2) {
            SendClientMessage(i, color2, str);
        } else if(dist <= r3) {
            SendClientMessage(i, color3, str);
        } else if(dist <= r4) {
            SendClientMessage(i, color4, str);
        }
    }
    return 1;
}