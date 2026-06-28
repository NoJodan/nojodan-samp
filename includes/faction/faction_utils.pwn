// faction_utils.pwn
// Funciones de carga/guardado masivo de facciones.

#if defined _faction_utils_included
    #endinput
#endif
#define _faction_utils_included

new gNextFactionID = 1;

stock LoadFaction_DataAll() {
    // Inicializar gNextFactionID desde nextid.txt
    new File:idfile = fopen("Factions/nextid.txt", io_read);
    if(idfile) {
        new str[8];
        new len = fread(idfile, str, sizeof(str));
        if(len > 0) {
            gNextFactionID = strval(str);
            if(gNextFactionID < 1) gNextFactionID = 1;
        }
        fclose(idfile);
    }
    printf("[FACCIONES] Proximo ID disponible: %d", gNextFactionID);

    new File:file = fopen("Factions/registry.ini", io_read);
    if(!file) {
        print("[FACCIONES] No se encontro Factions/registry.ini.");
        return 0;
    }

    new slotid = 0;
    new line[16];

    while(fread(file, line, sizeof(line)) && slotid < MAX_FACTIONS) {
        new len = strlen(line);
        while(len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }
        if(len == 0) continue;

        new fid = strval(line);
        if(fid <= 0) continue;

        new path[128];
        format(path, sizeof(path), "Factions/%d.ini", fid);

        if(fexist(path)) {
            INI_ParseFile(path, "LoadFaction_Data", .bExtra = true, .extra = slotid);
            fInfo[slotid][fPickupID] = CreatePickup(fInfo[slotid][fPickup], 1, fInfo[slotid][fExterior][0], fInfo[slotid][fExterior][1], fInfo[slotid][fExterior][2], 0);
            new string[128];
            format(string, sizeof(string), "Faccion (%d): %s", fid, fInfo[slotid][fName]);
            fInfo[slotid][fLabelID] = CreateDynamic3DTextLabel(string, COLOR_USUARIO, fInfo[slotid][fExterior][0], fInfo[slotid][fExterior][1], fInfo[slotid][fExterior][2] + 1.0, 20.0, .testlos = true);
            SaveFaction_Data(slotid);

            if(fInfo[slotid][fID] >= gNextFactionID) {
                gNextFactionID = fInfo[slotid][fID] + 1;
            }

            printf("[FACCIONES] Cargada: %s (fID:%d, slot:%d)", fInfo[slotid][fName], fid, slotid);
            slotid++;
        }
    }

    fclose(file);
    printf("[FACCIONES] %d faccion(es) cargada(s). Proximo ID: %d", slotid, gNextFactionID);
    return slotid;
}

stock SaveFaction_DataAll() {
    new File:file = fopen("Factions/registry.ini", io_write);
    if(!file) return 0;

    new count = 0;
    for(new i = 0; i < MAX_FACTIONS; i++) {
        if(strlen(fInfo[i][fName]) == 0) continue;

        SaveFaction_Data(i);

        new line[16];
        format(line, sizeof(line), "%d\r\n", fInfo[i][fID]);
        fwrite(file, line);
        count++;
    }

    fclose(file);
    printf("[FACCIONES] %d faccion(es) guardada(s).", count);
    return count;
}

stock GetFactionSlotByID(factionid) {
    for(new i = 0; i < MAX_FACTIONS; i++) {
        if(fInfo[i][fID] == factionid) {
            return i;
        }
    }
    return -1;
}

stock GetNewFactionID() {
    new id = gNextFactionID;
    gNextFactionID++;

    new File:file = fopen("Factions/nextid.txt", io_write);
    if(file) {
        new str[8];
        format(str, sizeof(str), "%d\r\n", gNextFactionID);
        fwrite(file, str);
        fclose(file);
    }
    return id;
}
