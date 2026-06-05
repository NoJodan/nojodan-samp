// auth_utils.pwn
// Funciones de lógica de autenticación.
// - Valida y procesa los datos de registro e inicio de sesión.
// - Controla intentos erróneos, bloqueos temporales y mensajes de error.
// - En el registro, crea el archivo de usuario, inicializa valores y hace spawn del jugador.
// - En el login, compara contraseñas, restaura el estado guardado y respawnea.

#if defined _auth_utils_included
    #endinput
#endif
#define _auth_utils_included

stock CreatePlayerFile(playerid) {
    new path[128];
    UserPath(playerid, path, sizeof(path));
    new INI:file = INI_Open(path);
    INI_SetTag(file, "playerData");
    INI_WriteString(file, "pPassword", pInfo[playerid][pPassword]);
    INI_WriteInt(file, "pAdmin", 0);
    INI_WriteBool(file, "pLogged", true);
    INI_WriteInt(file, "pMoney", 0);
    INI_WriteInt(file, "pOnDuty", 0);
    INI_WriteInt(file, "pSkin", pInfo[playerid][pSkin]);
    INI_WriteInt(file, "pSex", pInfo[playerid][pSex]);
    INI_WriteInt(file, "pAge", pInfo[playerid][pAge]);
    INI_WriteInt(file, "pHealth", 100);
    INI_WriteInt(file, "pArmour", 0);
    INI_WriteInt(file, "pLevel", 0);
    INI_WriteInt(file, "pFaction", 0);
    INI_WriteInt(file, "pRank", 0);
    INI_WriteInt(file, "pJob", 0);
    INI_WriteInt(file, "pWarns", 0);
    INI_WriteInt(file, "pVirtualWorld", 0);
    INI_WriteInt(file, "pInterior", 0);
    INI_WriteFloat(file, "pPosX", -2016.4399);
    INI_WriteFloat(file, "pPosY", -79.77140);
    INI_WriteFloat(file, "pPosZ", 35.3203);
    INI_WriteFloat(file, "pPosA", 0);
    INI_Close(file);

    SetSpawnInfo(playerid, 0, pInfo[playerid][pSkin], -2016.4399, -79.77140, 35.3203, 0, t_WEAPON:0, 0, t_WEAPON:0, 0, t_WEAPON:0, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerSkin(playerid, pInfo[playerid][pSkin]);
    GivePlayerMoney(playerid, 30000);
    pInfo[playerid][pLogged] = true;
    SpawnPlayer(playerid);

    return 1;
}

stock RegisterCase(playerid, const inputtext[]) {
    new lenPass = strlen(inputtext);

    if(lenPass < 4 || lenPass > 20) {
        if(pInfo[playerid][pTriesRegister] == 3) {
			SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] Demasiados intentos de registro. (kick)");
			pInfo[playerid][pTriesRegister] = 0;
			SetTimerEx("KickInTime", 200, false, "i", playerid);
            return 1;
		}

        SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] La contraseña no cumple los requisitos.");
        pInfo[playerid][pTriesRegister]++;
        return ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_PASSWORD, "Registrar", ""COLOR_RED_T"Has ingresado una contrasena invalida.\n"COLOR_WHITE_T"Escribe una contrasena valida para registrarse:", "Registrar", "Cancelar");
    }
    strcopy(pInfo[playerid][pPassword], inputtext);
    return ShowPlayerDialog(playerid, AgeDialog, DIALOG_STYLE_INPUT, "Edad", ""COLOR_RED_T"Bienvenido al servidor.\n"COLOR_WHITE_T"Antes de comenzar, por favor ingresa tu edad (mínimo 18 años):", "Confirmar", "");
}

stock AgeCase(playerid, const inputtext[]) {
    new age = strval(inputtext);
    if(age < 18 || age > 100) {
        SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] Edad inválida. Mínimo 18 años.");
        return ShowPlayerDialog(playerid, AgeDialog, DIALOG_STYLE_INPUT, "Edad", ""COLOR_RED_T"Edad inválida.\n"COLOR_WHITE_T"Ingresa tu edad (mínimo 18 años):", "Confirmar", "");
    }

    pInfo[playerid][pAge] = age;
    return ShowPlayerDialog(playerid, SexDialog, DIALOG_STYLE_LIST, "Sexo", ""COLOR_RED_T"Masculino\nFemenino", "Confirmar", "Cancelar");
}

stock SexCase(playerid, listitem) {
    pInfo[playerid][pSex] = (listitem == 0) ? SEX_MALE : SEX_FEMALE;
    pInfo[playerid][pSkin] = (pInfo[playerid][pSex] == SEX_MALE) ? 0 : 11;
    return CreatePlayerFile(playerid);
}

stock LoginCase(playerid, const inputtext[]) {

    if(strcmp(inputtext, pInfo[playerid][pPassword], true) == 0) {
        pInfo[playerid][pLogged] = true;
        SetPlayerVirtualWorld(playerid, pInfo[playerid][pVirtualWorld]);
        SetPlayerInterior(playerid, pInfo[playerid][pInterior]);
        SetPlayerSkin(playerid, pInfo[playerid][pSkin]);
        GivePlayerMoney(playerid, pInfo[playerid][pMoney]);
        SetPlayerHealth(playerid, pInfo[playerid][pHealth]);
        SetPlayerArmour(playerid, pInfo[playerid][pArmour]);
        SetSpawnInfo(playerid, 0, pInfo[playerid][pSkin], pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ], pInfo[playerid][pPosA], t_WEAPON:0, 0, t_WEAPON:0, 0, t_WEAPON:0, 0);
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

stock bool:CheckPlayerName(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    // Validar que el nombre no esté vacío y tenga entre 3 y 20 caracteres
    if(strlen(name) < 3 || strlen(name) > 20) {
        return false;
    }

    new underPos = strfind(name, "_");
    if(underPos == -1 || underPos == 0 || underPos == strlen(name) - 1) {
        return false; // No contiene guion bajo
    }

    if(strfind(name, " ") != -1) {
        return false; // Contiene espacios
    }

    if(name[0] < 'A' || name[0] > 'Z') {
        return false; // No comienza con mayúscula
    }

    for(new i = 0; i < strlen(name); i++) {
        if((!(name[i] >= 'a' && name[i] <= 'z') && !(name[i] >= 'A' && name[i] <= 'Z')) && name[i] != '_') {
            return false; // Contiene caracteres no permitidos
        }
    }

    return true;
}