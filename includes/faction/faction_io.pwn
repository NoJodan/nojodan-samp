// faction_io.pwn
// Funciones de entrada/salida de facciones.

#if defined _faction_io_included
    #endinput
#endif
#define _faction_io_included

#include <YSI_Storage\y_ini>

forward LoadFaction_Data(factionid, name[], value[]);
public LoadFaction_Data(factionid, name[], value[]) {
    INI_Int("fID", fInfo[factionid][fID]);
    INI_String("fName", fInfo[factionid][fName], 32);
    INI_String("fLeader", fInfo[factionid][fLeader], 32);
    INI_Int("fMembers", fInfo[factionid][fMembers]);
    INI_Int("fMoney", fInfo[factionid][fMoney]);
    
    // Cargar nombres de rangos individualmente (fRankName0 - fRankName9)
    for(new i = 0; i < 10; i++) {
        new rankKey[16];
        format(rankKey, sizeof(rankKey), "fRankName%d", i);
        if(strcmp(name, rankKey, true) == 0) {
            strcat(fInfo[factionid][fRankNames][i], value, 32);
            break;
        }
    }
    INI_Int("fWarns", fInfo[factionid][fWarns]);
    INI_Int("fPayday", fInfo[factionid][fPayday]);
    INI_Int("fPickup", fInfo[factionid][fPickup]);
    INI_Int("fPickupID", fInfo[factionid][fPickupID]);
    INI_Int("fInteriorID", fInfo[factionid][fInteriorID]);
    INI_Float("fExteriorX", fInfo[factionid][fExterior][0]);
    INI_Float("fExteriorY", fInfo[factionid][fExterior][1]);
    INI_Float("fExteriorZ", fInfo[factionid][fExterior][2]);
    INI_Float("fInteriorX", fInfo[factionid][fInterior][0]);
    INI_Float("fInteriorY", fInfo[factionid][fInterior][1]);
    INI_Float("fInteriorZ", fInfo[factionid][fInterior][2]);
    return 1;
}

stock FactionPath(factionid, dest[], size) {
    format(dest, size, "Factions/%d.ini", fInfo[factionid][fID]);
}

stock SaveFaction_Data(factionid) {
    new path[128];
    FactionPath(factionid, path, sizeof(path));

    new INI:file = INI_Open(path);
    INI_SetTag(file, "factionData");
    INI_WriteInt(file, "fID", fInfo[factionid][fID]);
    INI_WriteString(file, "fName", fInfo[factionid][fName]);
    INI_WriteString(file, "fLeader", fInfo[factionid][fLeader]);
    INI_WriteInt(file, "fMembers", fInfo[factionid][fMembers]);
    INI_WriteInt(file, "fMoney", fInfo[factionid][fMoney]);
    
    for(new i = 0; i < 10; i++) {
        new rankKey[16];
        format(rankKey, sizeof(rankKey), "fRankName%d", i);
        INI_WriteString(file, rankKey, fInfo[factionid][fRankNames][i]);
    }
    
    INI_WriteInt(file, "fWarns", fInfo[factionid][fWarns]);
    INI_WriteInt(file, "fPayday", fInfo[factionid][fPayday]);
    INI_WriteInt(file, "fPickup", fInfo[factionid][fPickup]);
    INI_WriteInt(file, "fPickupID", fInfo[factionid][fPickupID]);
    INI_WriteInt(file, "fInteriorID", fInfo[factionid][fInteriorID]);
    INI_WriteFloat(file, "fExteriorX", fInfo[factionid][fExterior][0]);
    INI_WriteFloat(file, "fExteriorY", fInfo[factionid][fExterior][1]);
    INI_WriteFloat(file, "fExteriorZ", fInfo[factionid][fExterior][2]);
    INI_WriteFloat(file, "fInteriorX", fInfo[factionid][fInterior][0]);
    INI_WriteFloat(file, "fInteriorY", fInfo[factionid][fInterior][1]);
    INI_WriteFloat(file, "fInteriorZ", fInfo[factionid][fInterior][2]);
    
    INI_Close(file);
}