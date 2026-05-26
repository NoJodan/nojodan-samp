// rol_io.pwn
// Entrada/salida de datos de personaje.
// Carga y guarda el nombre, género, edad y estado de creación del personaje
// en un archivo INI separado por jugador, bajo la etiqueta "rolData".

#if defined _rol_io_included
    #endinput
#endif
#define _rol_io_included

#include <YSI_Storage\y_ini>

stock RolPath(playerid)
{
    new string[128], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    format(string, sizeof(string), "Users/Rol_%s.ini", playername);
    return string;
}

forward LoadRol_Data(playerid, name[], value[]);
public LoadRol_Data(playerid, name[], value[]) {
    INI_String("rNombre", rInfo[playerid][rNombre], 32);
    INI_Int("rSexo",      rInfo[playerid][rSexo]);
    INI_Int("rEdad",      rInfo[playerid][rEdad]);
    INI_Bool("rCreado",   rInfo[playerid][rCreado]);
    return 1;
}

forward SaveRol_Data(playerid);
public SaveRol_Data(playerid) {
    new INI:file = INI_Open(RolPath(playerid));
    INI_SetTag(file, "rolData");
    INI_WriteString(file, "rNombre", rInfo[playerid][rNombre]);
    INI_WriteInt(file,    "rSexo",   rInfo[playerid][rSexo]);
    INI_WriteInt(file,    "rEdad",   rInfo[playerid][rEdad]);
    INI_WriteBool(file,   "rCreado", rInfo[playerid][rCreado]);
    INI_Close(file);
    return 1;
}