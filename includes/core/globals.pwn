// globals.pwn
// Definiciones de variables globales usadas en varios módulos.
// Aquí se declaran arrays y estados compartidos entre auth, admin y otros subsistemas.
// Mantiene la visibilidad centralizada de datos que necesitan existir en memoria durante toda la sesión.
#if defined _globals_included
    #endinput
#endif
#define _globals_included