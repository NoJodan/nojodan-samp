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
    pSkin,
    pSex,
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