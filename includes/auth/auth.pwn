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