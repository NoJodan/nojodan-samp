// rol_data.pwn
// Datos y estructuras del sistema de rol.
// Define el esquema del personaje: nombre, historia, apariencia y estado de rol.
// Estos datos se guardan en disco y se cargan al conectar.

#if defined _rol_data_included
    #endinput
#endif
#define _rol_data_included

enum rolData {
    rNombre[32],        // Nombre del personaje en el server
    rSexo,              // Género del personaje (SEX_MALE / SEX_FEMALE)
    rEdad,              // Edad del personaje
    bool:rCreado,       // Indica si el personaje ha sido creado o es nuevo
}

new rInfo[MAX_PLAYERS][rolData];