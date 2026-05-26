// rol_dialogs.pwn
// Manejo del diálogo de creación de personaje.
// Captura el nombre que el jugador escribe, lo valida y lo guarda.

#if defined _rol_dialogs_included
    #endinput
#endif
#define _rol_dialogs_included

#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case RolNombreDialog: {
            if(!response) return Kick(playerid);

            new len = strlen(inputtext);
            if(len < 5 || len > 31) {
                return ShowPlayerDialog(playerid, RolNombreDialog,
                    DIALOG_STYLE_INPUT,
                    "Crear personaje",
                    ""COLOR_RED_T"Nombre inválido.\n"COLOR_WHITE_T"Escribe tu nombre de rol (ej: Juan_Perez):",
                    "Confirmar", "");
            }

            new underPos = strfind(inputtext, "_");
            if(underPos == -1 || underPos == 0 || underPos == len - 1) {
                return ShowPlayerDialog(playerid, RolNombreDialog,
                    DIALOG_STYLE_INPUT,
                    "Crear personaje",
                    ""COLOR_RED_T"Formato inválido.\n"COLOR_WHITE_T"Debes usar el formato: Nombre_Apellido (ej: Juan_Perez):",
                    "Confirmar", "");
            }

            if(strfind(inputtext, "_", false, underPos + 1) != -1) {
                return ShowPlayerDialog(playerid, RolNombreDialog,
                    DIALOG_STYLE_INPUT,
                    "Crear personaje",
                    ""COLOR_RED_T"Formato inválido.\n"COLOR_WHITE_T"Solo se permite un guión bajo entre nombre y apellido:",
                    "Confirmar", "");
            }

            if(underPos < 2 || (len - underPos - 1) < 2) {
                return ShowPlayerDialog(playerid, RolNombreDialog,
                    DIALOG_STYLE_INPUT,
                    "Crear personaje",
                    ""COLOR_RED_T"Nombre o apellido muy corto.\n"COLOR_WHITE_T"Cada parte debe tener mínimo 2 caracteres:",
                    "Confirmar", "");
            }

            strcopy(rInfo[playerid][rNombre], inputtext);
            rInfo[playerid][rCreado] = true;
            SaveRol_Data(playerid);

            new msg[64];
            format(msg, sizeof(msg), "Bienvenido, %s.", rInfo[playerid][rNombre]);
            SendClientMessage(playerid, COLOR_GREEN, msg);
            return 1;
        }
    }
    return 1;
}