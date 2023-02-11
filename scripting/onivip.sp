#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <cstrike>
#include <chat-processor>
#include <clientprefs>
#include <forum_api>
#pragma newdecls required
#pragma semicolon 1
#pragma tabsize 4

#define DB_CONNECTION "oniplay"
Database g_hDatabase = null;

// LIB
#include "lib/helper.sp"

// VIP
#include "vip/player.sp"

// SQL
#include "lib/sql.sp"

// MENUS
#include "menus/main_menu.sp"
#include "menus/tag_menu.sp"
#include "menus/settings_menu.sp"
#include "menus/name_color_menu.sp"

public Plugin myinfo =
{
	name = "onivip",
	author = "Audite",
	description = "VIP system for OniPlay.eu inspired by EFRAG & Klonken, some code ideas are gathered from EFRAG thanks to Zwolof!",
	version = "0.0.2",
	url = "https://oniplay.eu/"
};

public void OnPluginStart()
{
	// Registrate vip commands
	RegConsoleCmd("sm_vip", RCC_vip, "VIP commands");
	RegConsoleCmd("sm_gift", RCC_giftvip, "Gift VIP to a player");
	RegConsoleCmd("sm_viptest", RCC_vipTest, "VIP Test command", ADMFLAG_ROOT);

	// Hooks
	HookEvent("player_disconnect", Event_OnPlayerDisconnect, EventHookMode_Pre); 
	HookEvent("player_spawn", Event_OnPlayerSpawn, EventHookMode_Pre);

	// Connect to database
	Database.Connect(SQL_ConnectCallback, DB_CONNECTION);
}

public void SQL_ConnectCallback(Database db, const char[] error, any data)
{
	if(db == null) {
		LogError("T_Connect returned invalid Database Handle");
		return;
	}
	g_hDatabase = db;
}

public Action RCC_vip(int client, int args)
{
	if(player[client].rank == -1) {
		OP_Print(client, "You dont have permission to do that!");
		OP_Print(client, "To buy VIP go to https://oniplay.eu/store");
		return Plugin_Handled;
	}
	OpenVIPMenu(client);
	return Plugin_Handled;
}

public Action RCC_vipTest(int client, int args)
{
	char sSteamID[64];
	GetClientAuthId(client, AuthId_SteamID64, sSteamID, sizeof(sSteamID));
	
	int iClientForumID = Forum_GetClientID(client);

	OP_Print(client,"Player Tag: %d", player[client].tag);
	OP_Print(client,"Player ID: %d", player[client].id);
	OP_Print(client,"Player Rank %d", player[client].rank);
	OP_Print(client,"Player Active Perk: %d", player[client].activePerk);
	OP_Print(client,"Player Show Tag: %d", player[client].showTag);
	OP_Print(client,"Player AuthID64: %s", sSteamID);
	OP_Print(client,"Player ForumID: %d", iClientForumID);
	
	return Plugin_Handled;
}

public Action RCC_giftvip(int client, int args){
	if(player[client].rank >= 2){
		OP_Print(client, "Command is not ready yet!");
	}else{
		OP_Print(client, "You dont have permission to do that!");
		OP_Print(client, "Only S-VIP and above can gift vips to other players!");
		OP_Print(client, "To buy S-VIP go to https://oniplay.eu/store");
	}
	return Plugin_Handled;
}

public void OnClientPostAdminCheck(int client) {
	if(IsValidClient(client)) {
		player[client].id = client;
		player[client].Init();
        player[client].Get();
		SetClientClanTag(client);
	}
}

public void Event_OnPlayerDisconnect(Event event, const char[] sName, bool bDontBroadcast) {
    int client = GetClientOfUserId(event.GetInt("userid"));
    if(IsValidClient(client)) {
        player[client].Set();
    }
}

public void Event_OnPlayerSpawn(Event event, const char[] sName, bool bDontBroadcast) {
	int client = GetClientOfUserId(event.GetInt("userid"));
	CreateTimer(1.0, Timer_SetClanTag, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientSettingsChanged(int client) {
	if(IsValidClient(client)) {
		SetClientClanTag(client);
	}
}

public Action Timer_SetClanTag(Handle tmr, any data) {
	int client = GetClientOfUserId(data);
	if(IsValidClient(client)) {
		SetClientClanTag(client);
	}
	return Plugin_Continue;
}

public Action CP_OnChatMessage(int& author, ArrayList recipients, char[] flagstring, char[] name, char[] message, bool& processcolors, bool& removecolors)
{
	char sNewName[MAXLENGTH_NAME];
	
    if(player[author].rank != 0) {
        int nc = player[author].namecolor;
        int tag = player[author].tag;
        
        if(nc == -1) {
            if(!player[author].showTag) {
                Format(sNewName, MAXLENGTH_NAME, "\x03%s", name);
            }
            else Format(sNewName, MAXLENGTH_NAME, "\x01[%s%s\x01] \x03%s", g_sTags[tag][1], g_sTags[tag][0], name);
        }
        else if(nc != -1)
        {
            if(!player[author].showTag) {
                Format(sNewName, MAXLENGTH_NAME, "%s%s", g_sColors[nc][1], name);
            }
            else Format(sNewName, MAXLENGTH_NAME, "\x01[%s%s\x01] %s%s", g_sTags[tag][1], g_sTags[tag][0], g_sColors[nc][1], name);
        }
    }
	else Format(sNewName, MAXLENGTH_NAME, "\x03%s", name);
	
	static char sPassedName[MAXLENGTH_NAME];
	sPassedName = sNewName;
	
    //Update the name & message
	strcopy(name, MAXLENGTH_NAME, sPassedName);
	strcopy(message, MAXLENGTH_MESSAGE, message);

	processcolors = true;
	removecolors = false;

	return Plugin_Changed;
}