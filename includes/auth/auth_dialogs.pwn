// auth_dialogs.pwn
// Manejo de los diálogos de registro e inicio de sesión.
// - Captura las respuestas del jugador cuando aparece el formulario.
// - Redirige a las funciones de registro o login según el diálogo.
// - Debe contener la lógica de interacción con UI para auth.

#if defined _auth_dialogs_included
    #endinput
#endif
#define _auth_dialogs_included

#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case RegisterDialog: {
            if(!response) return Kick(playerid);
            return RegisterCase(playerid, inputtext);
        }
        case LoginDialog: {
            if(!response) return Kick(playerid);
            return LoginCase(playerid, inputtext);
        }

        case AgeDialog: {
    
            new age = strval(inputtext);
            if(age < 18 || age > 100) {
                SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] Edad inválida. Mínimo 18 años.");
                return ShowPlayerDialog(playerid, AgeDialog, DIALOG_STYLE_INPUT, "Edad", ""COLOR_RED_T"Edad inválida.\n"COLOR_WHITE_T"Ingresa tu edad (mínimo 18 años):", "Confirmar", "");
            }
            pInfo[playerid][pAge] = age;

            // Guardar la edad en el archivo
            new path[128];
            UserPath(playerid, path, sizeof(path));
            new INI:file = INI_Open(path);
            INI_SetTag(file, "playerData");
            INI_WriteInt(file, "pAge", pInfo[playerid][pAge]);
            INI_Close(file);
            return 1;
        }
    }
    return 1;
}