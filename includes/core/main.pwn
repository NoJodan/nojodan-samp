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