// admin_dialogs.pwn
// Diálogos de administrador.
// Maneja los diálogos de confirmación y razón para acciones administrativas.

#if defined _admin_dialogs_included
    #endinput
#endif
#define _admin_dialogs_included

#include <YSI_Coding\y_hooks>

// Muestra el diálogo para seleccionar razón de kick
stock ShowKickReasonDialog(adminid, targetid) {
    gAdminTarget[adminid] = targetid;
    // acción implícita: kick (antes se almacenaba en gAdminAction, ahora no se usa)

    new header[64];
    format(header, sizeof(header), "Kickear a %s", GetPlayerNameEx(targetid));

    ShowPlayerDialog(adminid, AdminKickDialog, DIALOG_STYLE_LIST,
        header,
        ADMIN_REASONS_LIST,
        "Confirmar", "Cancelar");
}

// Muestra el diálogo para seleccionar razón de ban
stock ShowBanReasonDialog(adminid, targetid) {
    gAdminTarget[adminid] = targetid;
    // acción implícita: ban (antes se almacenaba en gAdminAction, ahora no se usa)

    new header[64];
    format(header, sizeof(header), "Banear a %s", GetPlayerNameEx(targetid));

    ShowPlayerDialog(adminid, AdminBanDialog, DIALOG_STYLE_LIST,
        header,
        ADMIN_REASONS_LIST,
        "Confirmar", "Cancelar");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

    switch(dialogid) {
        case AdminKickDialog: {
            if(!response) {
                SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN] Acción de kick cancelada.");
                gAdminTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            new targetid = gAdminTarget[playerid];
            if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, COLOR_RED, "[ADMIN] El jugador ya no está conectado.");
                gAdminTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            new reasons[5][32] = {
                "Conducta inapropiada",
                "Trampas / Hacks",
                "Robo de cuenta",
                "Lenguaje ofensivo",
                "Otra razón"
            };

            new reason[32];
            if(listitem >= 0 && listitem < 5)
                format(reason, sizeof(reason), "%s", reasons[listitem]);
            else
                format(reason, sizeof(reason), "Sin razón especificada");

            new msg[160];
            format(msg, sizeof(msg), "[ADMIN] %s ha sido kickeado por %s. Razón: %s", GetPlayerNameEx(targetid), GetPlayerNameEx(playerid), reason);
            SendClientMessageToAll(COLOR_RED, msg);

            Kick(targetid);
            gAdminTarget[playerid] = INVALID_PLAYER_ID;
            return 1;
        }

        case AdminBanDialog: {
            if(!response) {
                SendClientMessage(playerid, COLOR_YELLOW, "[ADMIN] Acción de ban cancelada.");
                gAdminTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            new targetid = gAdminTarget[playerid];
            if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid)) {
                SendClientMessage(playerid, COLOR_RED, "[ADMIN] El jugador ya no está conectado.");
                gAdminTarget[playerid] = INVALID_PLAYER_ID;
                return 1;
            }

            new reasons[5][32] = {
                "Conducta inapropiada",
                "Trampas / Hacks",
                "Robo de cuenta",
                "Lenguaje ofensivo",
                "Otra razón"
            };

            new reason[32];
            if(listitem >= 0 && listitem < 5)
                format(reason, sizeof(reason), "%s", reasons[listitem]);
            else
                format(reason, sizeof(reason), "Sin razón especificada");

            new msg[160];
            format(msg, sizeof(msg), "[ADMIN] %s ha sido baneado por %s. Razón: %s", GetPlayerNameEx(targetid), GetPlayerNameEx(playerid), reason);
            SendClientMessageToAll(COLOR_RED, msg);

            Ban(targetid);
            gAdminTarget[playerid] = INVALID_PLAYER_ID;
            return 1;
        }

        default:
            return 0; // No es un diálogo admin, dejamos que otros hooks lo manejen
    }

    return 0;
}

