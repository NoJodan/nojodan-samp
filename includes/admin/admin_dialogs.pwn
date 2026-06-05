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
    gAdminAction[adminid] = 1; // 1 = kick

    new targetName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));

    new header[64];
    format(header, sizeof(header), "Kickear a %s", targetName);

    ShowPlayerDialog(adminid, AdminKickDialog, DIALOG_STYLE_LIST,
        header,
        ADMIN_REASONS_LIST,
        "Confirmar", "Cancelar");
}

// Muestra el diálogo para seleccionar razón de ban
stock ShowBanReasonDialog(adminid, targetid) {
    gAdminTarget[adminid] = targetid;
    gAdminAction[adminid] = 2; // 2 = ban

    new targetName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));

    new header[64];
    format(header, sizeof(header), "Banear a %s", targetName);

    ShowPlayerDialog(adminid, AdminBanDialog, DIALOG_STYLE_LIST,
        header,
        ADMIN_REASONS_LIST,
        "Confirmar", "Cancelar");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

    // --- Diálogo de Kick ---
    if(dialogid == AdminKickDialog) {
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

        new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, adminName, sizeof(adminName));
        GetPlayerName(targetid, targetName, sizeof(targetName));

        new msg[160];
        format(msg, sizeof(msg), "[ADMIN] %s ha sido kickeado por %s. Razón: %s", targetName, adminName, reason);
        SendClientMessageToAll(COLOR_RED, msg);

        Kick(targetid);
        gAdminTarget[playerid] = INVALID_PLAYER_ID;
        return 1;
    }

    // --- Diálogo de Ban ---
    if(dialogid == AdminBanDialog) {
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

        new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, adminName, sizeof(adminName));
        GetPlayerName(targetid, targetName, sizeof(targetName));

        new msg[160];
        format(msg, sizeof(msg), "[ADMIN] %s ha sido baneado por %s. Razón: %s", targetName, adminName, reason);
        SendClientMessageToAll(COLOR_RED, msg);

        Ban(targetid);
        gAdminTarget[playerid] = INVALID_PLAYER_ID;
        return 1;
    }

    return 0;
}

