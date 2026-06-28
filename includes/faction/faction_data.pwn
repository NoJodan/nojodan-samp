// faction_data.pwn
// Estructuras y datos de facciones.

#if defined _faction_data_included
    #endinput
#endif
#define _faction_data_included

enum factionData {
    fID,           // ID único y permanente (nunca se reutiliza)
    fName[32],
    fLeader[32],
    fMembers,
    fRankNames[10][32],
    fMoney,
    fWarns,
    fPayday,
    fPickup,
    fPickupID,
    fInteriorID,
    Float:fExterior[3],
    Float:fInterior[3],
    Text3D:fLabelID,
};

new fInfo[MAX_FACTIONS][factionData];