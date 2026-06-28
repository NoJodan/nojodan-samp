// defines.pwn
// Definiciones globales del servidor y constantes de configuración.
// Contiene macros, rutas, claves y valores configurables que se usan en varios módulos.
// Aquí se centraliza la configuración que no es específica de una sola funcionalidad.

#if defined _defines_included
    #endinput
#endif
#define _defines_included

#pragma 				tabsize 					(0)

#define 				User_Path					"Users/%s.ini"

//Limites
#define					MAX_PING					(1500)
#define					MAX_FACTIONS				(20)

//Generos
#define                 SEX_MALE                     (0)
#define                 SEX_FEMALE                   (1)

// Niveles de administración
#define ADMIN_NONE      (0)
#define ADMIN_TRIAL     (1)   // Admin en prueba
#define ADMIN_MOD       (2)   // Moderador
#define ADMIN_ADMIN     (3)   // Administrador
#define ADMIN_HEAD      (4)   // Head Admin

// Niveles de rol (experiencia / nivel del personaje)
#define ROL_NIVEL_MAX   (100)

// Posición de spawn por defecto
#define SPAWN_POS_X     (-2016.4399)
#define SPAWN_POS_Y     (-79.77140)
#define SPAWN_POS_Z     (35.3203)