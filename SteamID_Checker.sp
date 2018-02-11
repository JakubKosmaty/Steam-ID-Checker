#pragma semicolon 1

#define PLUGIN_AUTHOR "Master"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <autoexecconfig>
#include <multicolors>

#pragma newdecls required


Handle g_ChatTag;
char g_Tag[32] = "Steam ID";

Handle g_SteamIDType;
int g_SteamID;

Handle g_Message;
int g_CMessage;

ConVar g_Commands;

public Plugin myinfo = 
{
	name = "Steam ID Checker", 
	author = PLUGIN_AUTHOR, 
	description = "Check your Steam ID", 
	version = PLUGIN_VERSION, 
	url = "http://cswild.pl/"
};

public void OnPluginStart()
{
	LoadTranslations("SteamID_Checker.phrases");
	
	AutoExecConfig_SetFile("SteamID_Checker");
	AutoExecConfig_SetCreateFile(true);
	
	g_ChatTag = AutoExecConfig_CreateConVar("SteamID_chattag", "Steam ID", "Tag on chat");
	g_SteamIDType = AutoExecConfig_CreateConVar("SteamID_Type", "0", "Steam ID Type: 0 - STEAM_0:0:69130802, 1 - [U:1:138261604], 2 - 76561198098527332");
	g_Message = AutoExecConfig_CreateConVar("SteamID_Type_Message", "0", "Message: 0 - Chat & Console, 1 - Chat, 2 - Console");
	
	g_Commands = AutoExecConfig_CreateConVar("SteamID_Commands", "steamid", "Set your custom chat commands (!steamid (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)");
	
	AutoExecConfig_CleanFile();
	AutoExecConfig_ExecuteFile();

	RegConsoleCmd("sm_steamid", Cmd_SteamID, "Chceck player Steam ID");
	
}

public void OnConfigsExecuted() 
{
	GetConVarString(g_ChatTag, g_Tag, sizeof(g_Tag));
	g_SteamID = GetConVarInt(g_SteamIDType);
	g_CMessage = GetConVarInt(g_Message);

	int iCount = 0;
	char sCommands[128], sCommandsL[12][32], sCommand[32];
	g_Commands.GetString(sCommands, sizeof(sCommands));
	ReplaceString(sCommands, sizeof(sCommands), " ","");
	iCount = ExplodeString(sCommands, ",", sCommandsL, sizeof(sCommandsL), sizeof(sCommandsL[]));
	for (int i = 0; i < iCount; i++)
	{
		Format(sCommand, sizeof(sCommand), "sm_%s", sCommandsL[i]);
		if (GetCommandFlags(sCommand) == INVALID_FCVAR_FLAGS)
			RegConsoleCmd(sCommand, Cmd_SteamID, "Chceck player Steam ID");
	}
}

public Action Cmd_SteamID(int client, int args)
{
	char steamId[64];
	if(g_SteamID == 0)
		GetClientAuthId(client, AuthId_Steam2, steamId, sizeof(steamId));
	else if(g_SteamID == 1)
		GetClientAuthId(client, AuthId_Steam3, steamId, sizeof(steamId));
	else
		GetClientAuthId(client, AuthId_SteamID64, steamId, sizeof(steamId));

	if(g_CMessage == 0)
	{
		CPrintToChat(client, "%t", "chat_message", g_Tag, steamId);
		PrintToConsole(client, "%t", "console_message", g_Tag, steamId);
	}
	else if(g_CMessage == 1)
		CPrintToChat(client, "%t", "chat_message", g_Tag, steamId);
	else
		PrintToConsole(client, "%t", "console_message", g_Tag, steamId);
}