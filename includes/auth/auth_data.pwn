// auth_data.pwn
// Estructuras y datos de autenticación.
// Define el esquema de información del jugador que se guarda en disco y carga en memoria.
// Incluye contraseña, estado de login, dinero, admin, posición y variables de sesión.

#if defined _auth_data_included
    #endinput
#endif
#define _auth_data_included

enum playerData {
    pPassword[65],
    pAdmin,
    bool:pLogged,
    pMoney,
    pOnDuty,
    pJob,
    pWarns,
    pSkin,
    pSex,
    pAge,
    pLevel,
    pFaction,
    pRank,
    pVirtualWorld,
    pInterior,
    pTriesLogin,
    pTriesRegister,
    Float:pPosX,
    Float:pPosY,    
    Float:pPosZ,
    Float:pPosA
}

new pInfo[MAX_PLAYERS][playerData];