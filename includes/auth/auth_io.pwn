#if defined _auth_io_included
    #endinput
#endif
#define _auth_io_included

#include <YSI_Storage\y_ini>

forward LoadUser_Data(playerid, name[], value[]);
public LoadUser_Data(playerid, name[], value[]) {
    INI_String("Password", pInfo[playerid][pPassword], 65);
    INI_Int("pAdmin", pInfo[playerid][pAdmin]);
    INI_Bool("pLogged", pInfo[playerid][pLogged]);
    INI_Int("pMoney", pInfo[playerid][pMoney]);
    INI_Int("pOnDuty", pInfo[playerid][pOnDuty]);
    INI_Int("pSkin", pInfo[playerid][pSkin]);
    INI_Int("pSex", pInfo[playerid][pSex]);
    INI_Int("pVirtualWorld", pInfo[playerid][pVirtualWorld]);
    INI_Int("pInterior", pInfo[playerid][pInterior]);
    INI_Float("pPosX", pInfo[playerid][pPosX]);
    INI_Float("pPosY", pInfo[playerid][pPosY]);
    INI_Float("pPosZ", pInfo[playerid][pPosZ]);
    INI_Float("pPosA", pInfo[playerid][pPosA]);
    return 1;
}

forward SaveUser_Data(playerid);
public SaveUser_Data(playerid) {
    new path[128];
    UserPath(playerid, path, sizeof(path));
    if(fexist(path)) {
        pInfo[playerid][pMoney] = GetPlayerMoney(playerid);
        pInfo[playerid][pSkin] = GetPlayerSkin(playerid);
        pInfo[playerid][pInterior] = GetPlayerInterior(playerid);
        pInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
        GetPlayerPos(playerid, pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, pInfo[playerid][pPosA]);

        new INI:file = INI_Open(path);
        INI_SetTag(file, "playerData");
        INI_WriteInt(file, "pAdmin", pInfo[playerid][pAdmin]);
        INI_WriteBool(file, "pLogged", pInfo[playerid][pLogged]);
        INI_WriteInt(file, "pMoney", pInfo[playerid][pMoney]);
        INI_WriteInt(file, "pOnDuty", pInfo[playerid][pOnDuty]);
        INI_WriteInt(file, "pSkin", pInfo[playerid][pSkin]);
        INI_WriteInt(file, "pSex", pInfo[playerid][pSex]);
        INI_WriteInt(file, "pVirtualWorld", pInfo[playerid][pVirtualWorld]);
        INI_WriteInt(file, "pInterior", pInfo[playerid][pInterior]);
        INI_WriteFloat(file, "pPosX", pInfo[playerid][pPosX]);
        INI_WriteFloat(file, "pPosY", pInfo[playerid][pPosY]);
        INI_WriteFloat(file, "pPosZ", pInfo[playerid][pPosZ]);
        INI_WriteFloat(file, "pPosA", pInfo[playerid][pPosA]);
        INI_Close(file);
    }
    return 1;
}

stock UserPath(playerid, dest[], size = sizeof(dest))
{
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    format(dest, size, User_Path, playername);
    return 1;
}