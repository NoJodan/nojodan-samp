// rol_data.pwn
// Datos y estructuras del sistema de rol.
// Define el esquema del personaje: nombre, historia, apariencia y estado de rol.
// Estos datos se guardan en disco y se cargan al conectar.

#if defined _rol_data_included
    #endinput
#endif
#define _rol_data_included

#define ROL_CHAT_DIST   (15.0)

enum rolData {
    rNombre[MAX_PLAYER_NAME], // nombre del personaje
    bool:rCreado,             // si ya creó su personaje
}

new rInfo[MAX_PLAYERS][rolData];