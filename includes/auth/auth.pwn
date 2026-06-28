// auth.pwn
// Módulo de autenticación.
// Controla el ciclo de registro e inicio de sesión de jugadores.
// - Detecta nuevos jugadores y muestra el diálogo adecuado.
// - Carga datos de usuario y aplica el estado al spawn.
// - Coordina hooks y llamadas básicas de auth.

#if defined _auth_included
    #endinput
#endif
#define _auth_included

#include <YSI_Storage\y_ini>
#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid) {
    SetPlayerColor(playerid, COLOR_USUARIO);
    
    new bool:rolName = CheckPlayerName(playerid);
    if(!rolName) {
        SendClientMessage(playerid, COLOR_RED, "Tu nombre de jugador no es válido. Por favor, cámbialo para continuar.");
        Kick(playerid);
        return 0;
    }

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

hook OnPlayerDisconnect(playerid, reason) {
    if(pInfo[playerid][pLogged]) {
        pInfo[playerid][pLogged] = false;
        SaveUser_Data(playerid);
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "Iniciaste sesion.");
    return 1;
}