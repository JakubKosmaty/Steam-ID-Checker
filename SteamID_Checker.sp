#pragma semicolon 1

#define PLUGIN_AUTHOR "Master"
#define PLUGIN_VERSION "2.00"

#include <sourcemod>
#include <simple_colors>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Steam ID Checker", 
	author = PLUGIN_AUTHOR, 
	description = "Check your Steam ID", 
	version = PLUGIN_VERSION, 
	url = "http://cswild.pl/"
};

ConVar g_cChatTag;
char g_sTag[32] = "Steam ID";

ConVar g_cSteamIDType;
int g_iSteamIDType;

ConVar g_cMessage;
int g_iMessage;

public void OnPluginStart()
{
    g_cChatTag = CreateConVar("SteamID_chattag", "Steam ID", "Tag on chat", 0); g_cChatTag.AddChangeHook(OnCvarChange);
    g_cChatTag.GetString(g_sTag, sizeof(g_sTag));

    g_cSteamIDType = CreateConVar("SteamID_Type", "0", "Steam ID Type: 0 - STEAM_0:0:69130802, 1 - [U:1:138261604], 2 - 76561198098527332", 0); g_cSteamIDType.AddChangeHook(OnCvarChange);
    g_iSteamIDType = g_cSteamIDType.IntValue;

    g_cMessage = CreateConVar("SteamID_Type_Message", "0", "Message: 0 - Chat & Console, 1 - Chat, 2 - Console", 0); g_cMessage.AddChangeHook(OnCvarChange);
    g_iMessage = g_cMessage.IntValue;

    AutoExecConfig(true, "SteamID_Checker");

    RegConsoleCmd("sm_steamid", Cmd_SteamID, "Chceck player Steam ID");

    LoadTranslations("SteamID_Checker.phrases");
}

public void OnCvarChange(ConVar cvar, char[] oldValue, char[] newValue)
{
    if(cvar == g_cChatTag)
    {
        Format(g_sTag, sizeof(g_sTag), "%s", newValue);
    }
    else if(cvar == g_cSteamIDType)
    {
        g_iSteamIDType = g_cSteamIDType.IntValue;
    }
    else if(cvar == g_cMessage)
    {
        g_iMessage = g_cMessage.IntValue;
    }
}

public Action Cmd_SteamID(int client, int args)
{
    char sSteamID[64];

    GetClientAuthId(client, g_iSteamIDType == 0 ? AuthId_Steam2 : g_iSteamIDType == 1 ? AuthId_Steam3 : AuthId_SteamID64, sSteamID, sizeof(sSteamID));

    if(g_iMessage == 0)
    {
        S_PrintToChat(client, "%t", "chat_message", g_sTag, sSteamID);
        PrintToConsole(client, "%t", "console_message", g_sTag, sSteamID);
    }
    else if(g_iMessage == 1)
    {
        S_PrintToChat(client, "%t", "chat_message", g_sTag, sSteamID);
    }
    else
    {
        PrintToConsole(client, "%t", "console_message", g_sTag, sSteamID);
    }
}
