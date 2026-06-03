// rol_io.pwn
// Entrada/salida de datos de personaje.
// Carga y guarda el nombre, género, edad y estado de creación del personaje
// en un archivo INI separado por jugador, bajo la etiqueta "rolData".

#if defined _rol_io_included
    #endinput
#endif
#define _rol_io_included

#include <YSI_Storage\y_ini>

