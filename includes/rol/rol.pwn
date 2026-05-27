// rol.pwn
// Módulo central de rol.
// Orquesta el ciclo de vida del personaje: carga datos al conectar,
// muestra la creación de personaje si es nuevo, y limpia al desconectar.

#if defined _rol_included
    #endinput
#endif

#define _rol_included

#include <YSI_Coding\y_hooks>

