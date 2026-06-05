// admin_data.pwn
// Datos y estructuras de administración.
// Define variables globales, permisos, listas de admins, razones de ban y cualquier estado persistente del sistema administrativo.
// Aquí deben ir todas las constantes y datos usados por los comandos y diálogos admin.

#if defined _admin_data_included
    #endinput
#endif
#define _admin_data_included

// Nivel mínimo para usar comandos admin
#define ADMIN_MIN_LEVEL     ADMIN_TRIAL

// Variable temporal para guardar el target de un comando admin (usado en diálogos)
new gAdminTarget[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};

// Razones predefinidas para kick/ban mostradas en diálogo
#define ADMIN_REASONS_LIST  "Conducta inapropiada\nTrampas / Hacks\nRobo de cuenta\nLenguaje ofensivo\nOtra razón"




