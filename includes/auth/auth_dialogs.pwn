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
    }
    return 1;
}