// server.pwn
// Configuración inicial y callbacks de ciclo de vida del servidor.
// Aquí se inicializa el modo de juego, clima, hora y otras propiedades globales del servidor.
// También se gestionan eventos de desconexión y limpieza que deben ejecutarse siempre.
#if defined _server_included
    #endinput
#endif
#define _server_included

public OnGameModeInit() {
	SetGameModeText("Test Roleplay");
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	UsePlayerPedAnims();

	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	SaveUser_Data(playerid);
	return 1;
}