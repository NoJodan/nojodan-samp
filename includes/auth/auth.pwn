#if defined _auth_included
    #endinput
#endif
#define _auth_included

#include <YSI_Storage\y_ini>
#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid) {
    SetPlayerColor(playerid, COLOR_USUARIO);
    
    new path[128];
    UserPath(playerid, path, sizeof(path));
    if(fexist(path)) {
        INI_ParseFile(path, "LoadUser_Data", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_PASSWORD, "Iniciar sesión", "Por favor, introduce tu contraseña:", "Ingresar", "Cancelar");
    } else {
        ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_PASSWORD, "Registrar", "Por favor, introduce tu contraseña:", "Registrar", "Cancelar");
    }

    return 1;
}

public OnPlayerSpawn(playerid)
{
    new path[128];
    UserPath(playerid, path, sizeof(path));
	INI_ParseFile(path, "LoadUser_Data", .bExtra = true, .extra = playerid);
	SetPlayerSkin(playerid, pInfo[playerid][pSkin]);
	SendClientMessage(playerid, COLOR_GREEN, "Iniciaste sesion.");
	GivePlayerMoney(playerid, pInfo[playerid][pMoney]);
    return 1;
}

stock RegisterCase(playerid, const inputtext[]) {
    if(!strlen(inputtext)) {
        if(pInfo[playerid][pTriesRegister] == 3) {
			SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] Demasiados intentos de registro. (kick)");
			pInfo[playerid][pTriesRegister] = 0;
			SetTimerEx("KickInTime", 200, false, "i", playerid);
            return 1;
		}

        SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] La contraseña no puede estar vacía.");
        pInfo[playerid][pTriesRegister]++;
        return ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_PASSWORD, "Registrar", ""COLOR_RED_T"Has ingresado una contrasena invalida.\n"COLOR_WHITE_T"Escribe una contrasena valida para registrarse:", "Registrar", "Cancelar");
    } else {
        new path[128];
        UserPath(playerid, path, sizeof(path));
        new INI:file = INI_Open(path);
        INI_SetTag(file, "playerData");
        INI_WriteString(file, "Password", inputtext);
        INI_WriteInt(file, "pAdmin", 0);
        INI_WriteBool(file, "pLogged", false);
        INI_WriteInt(file, "pMoney", 0);
        INI_WriteInt(file, "pOnDuty", 0);
        INI_WriteInt(file, "pSkin", 0);
        INI_WriteInt(file, "pSex", 0);
        INI_WriteInt(file, "pVirtualWorld", 0);
        INI_WriteInt(file, "pInterior", 0);
        INI_WriteFloat(file, "pPosX", -2016.4399);
        INI_WriteFloat(file, "pPosY", -79.77140);
        INI_WriteFloat(file, "pPosZ", 35.3203);
        INI_WriteFloat(file, "pPosA", 0);
        INI_Close(file);

        SetSpawnInfo(playerid, 0, 0, -2016.4399, -79.77140, 35.3203, 0, t_WEAPON:0, 0, t_WEAPON:0, 0, t_WEAPON:0, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerSkin(playerid, 0);
        GivePlayerMoney(playerid, 30000);
        SpawnPlayer(playerid);

        return 1;
    }
}

stock LoginCase(playerid, const inputtext[]) {
    if(strcmp(inputtext, pInfo[playerid][pPassword], true) == 0) {
        pInfo[playerid][pLogged] = true;
        SetPlayerVirtualWorld(playerid, pInfo[playerid][pVirtualWorld]);
        SetPlayerInterior(playerid, pInfo[playerid][pInterior]);
        SetPlayerSkin(playerid, pInfo[playerid][pSkin]);
        GivePlayerMoney(playerid, pInfo[playerid][pMoney]);
        SetSpawnInfo(playerid, 0, 0, pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ], pInfo[playerid][pPosA], t_WEAPON:0, 0, t_WEAPON:0, 0, t_WEAPON:0, 0);
        SpawnPlayer(playerid);
        return 1;
    } else {
        if(pInfo[playerid][pTriesLogin] == 3) {
            SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] Demasiados intentos de inicio de sesión. (kick)");
            pInfo[playerid][pTriesLogin] = 0;
            SetTimerEx("KickInTime", 200, false, "i", playerid);
            return 1;
        }

        SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] Contraseña incorrecta.");
        pInfo[playerid][pTriesLogin]++;
        return ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_PASSWORD, "Iniciar sesión", ""COLOR_RED_T"Has ingresado una contrasena incorrecta.\n"COLOR_WHITE_T"Escribe tu contrasena para iniciar sesion:", "Ingresar", "Cancelar");
    }
}