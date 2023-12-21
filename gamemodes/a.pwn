// includes //
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>
#include <DOF2>

// defines //
#define MAX_PASSWORD 20
#define MIN_PASSWORD 6
#define SERVER_NAME "Projeto SA-MP"

//mysql
#define 		  MYSQL_HOST 		"localhost"
#define 		MYSQL_PASSWORD 		""
#define			MYSQL_DATABASE 		"projeto"
#define 		MYSQL_USERNAME 		"root"

//enums
enum
{
	DIALOG_LOGIN,
	DIALOG_REGISTRO
};

new MySQL:DBConn;

enum PLAYER_DATA
{
	Nome[MAX_PLAYER_NAME],
	Senha[MAX_PASSWORD],
	Admin,
	Float:health,
	Float:armor,
	money,
	Skin,
	ORM:ormid,
	bool:Logado
};
new Player[MAX_PLAYERS][PLAYER_DATA];

//
main(){}//
//

public OnGameModeInit()
{
	SetGameModeText("Blank Script");
	DataBaseInit();
	return 1;
}

public OnGameModeExit()
{
	DOF2::Exit();
	mysql_close(DBConn);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	LoadPlayerData(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	orm_destroy(Player[playerid][ormid]);
	for(new PLAYER_DATA:i; i < PLAYER_DATA; i++)
		Player[playerid][i] = 0;

	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Player[playerid][Logado] == false)
	{
		SetPlayerData(playerid);
		Player[playerid][Logado] = true;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LOGIN:
		{
			if(!response)
				Kick(playerid);
			else
			{
				if(strlen(inputtext) < 1 || strcmp(Player[playerid][Senha], inputtext))
				{
					SendClientMessage(playerid, -1, "ERRO: Senha incorreta!");
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha para logar:", "Logar", "Sair");
				}
				else
				{
					SendClientMessage(playerid, -1, "Logado com sucesso!");
					SetSpawnInfo(playerid, 0, Player[playerid][Skin], 1156.1112,-1749.8468,13.5703,2.3737, 0,0,0,0,0,0);
					SpawnPlayer(playerid);
				}
			}
		}
		case DIALOG_REGISTRO:
		{
			if(!response)
				Kick(playerid);
			else
			{
				if(strlen(inputtext) < 1 || strlen(inputtext) > 16)
				{
					SendClientMessage(playerid, -1, "ERRO: Sua senha deve conter entre 1 e 16 caracteres!");
					ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "Entre com uma senha para se registrar:", "Registrar", "Sair");
				}
				else
				{
					SendClientMessage(playerid, -1, "Registrado com sucesso!");
					format(Player[playerid][Senha], MAX_PASSWORD, "%s", inputtext);
					orm_insert(Player[playerid][ormid]);
					Player[playerid][Logado] = true;
					SetSpawnInfo(playerid, NO_TEAM, 0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
			}
		}
	}

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}


stock OnPlayerLogin(playerid)
{
	orm_setkey(Player[playerid][ormid], "id");

	if(orm_errno(Player[playerid][ormid]) == ERROR_OK) // jogador ja existe na database
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha para logar:", "Logar", "Sair");
	else // jogador não encontrado na database
		ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", "Entre com uma senha para se registrar:", "Registrar", "Sair");
	return 1;
}

DataBaseInit()
{
	DBConn = mysql_connect(MYSQL_HOST, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE);
	if(mysql_errno() == 0)
	{
		printf("[MySQL] Database '%s' conectada com sucesso!", MYSQL_DATABASE);
		print("[MySQL] Verificando tabelas...");

		mysql_query(DBConn, "CREATE TABLE IF NOT EXISTS Player (\
		id int NOT NULL AUTO_INCREMENT,\
		nome varchar(25) NOT NULL,\
		senha varchar(255) NOT NULL,\
		admin int DEFAULT 0,\
		PRIMARY KEY(id));", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS health float DEFAULT 100;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS armor float DEFAULT 100;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS dinheiro int DEFAULT 10000;", false);
		mysql_query(DBConn, "ALTER TABLE Player ADD IF NOT EXISTS skin int DEFAULT 44;", false);

		print("[MySQL] Tabela 'Players' verificada com sucesso!");
	}
	else
	{
		printf("[MySQL] ERRO: Não foi possível se conectar a database '%s'!", MYSQL_DATABASE);
		SendRconCommand("exit");
	}

	return 1;
}

//--------------------- player functions ---------------------//

stock SavePlayerData(playerid)
{
    Player[playerid][armor] = GetPlayerArmourEx(playerid);
    Player[playerid][health] = GetPlayerHealthEx(playerid);
    Player[playerid][money] = GetPlayerMoney(playerid);
    Player[playerid][Skin] = GetPlayerSkin(playerid);

    orm_update(Player[playerid][ormid]);
}

stock SetPlayerData(playerid)
{
	SetPlayerSkin(playerid, Player[playerid][Skin]);
    SetPlayerHealth(playerid, Player[playerid][health]);
    SetPlayerArmour(playerid, Player[playerid][armor]);
    GivePlayerMoney(playerid, Player[playerid][money]);
}

stock LoadPlayerData(playerid)
{
	Player[playerid][Logado] = false;
	format(Player[playerid][Nome], MAX_PLAYER_NAME, "%s", PlayerName(playerid));

	Player[playerid][ormid] = orm_create("Player", DBConn);

	orm_addvar_string(Player[playerid][ormid], Player[playerid][Nome], MAX_PLAYER_NAME, "nome");
	orm_addvar_string(Player[playerid][ormid], Player[playerid][Senha], MAX_PASSWORD, "senha");
	orm_addvar_int(Player[playerid][ormid], Player[playerid][Admin], "admin");
	orm_addvar_int(Player[playerid][ormid], Player[playerid][Skin], "skin");
	orm_addvar_int(Player[playerid][ormid], Player[playerid][money], "money");
	orm_addvar_float(Player[playerid][ormid], Player[playerid][health], "health");
	orm_addvar_float(Player[playerid][ormid], Player[playerid][armor], "armor");

	orm_setkey(Player[playerid][ormid], "nome");
	orm_select(Player[playerid][ormid], "OnPlayerLogin", "d", playerid);
}

//------------------ player functions ----------------------//
stock PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}