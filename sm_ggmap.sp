#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "SM GGMap",
    author      = "rdbo",
    description = "Map Changer for Gun Game",
    version     = "1.0",
    url         = ""
};

ConVar g_cvEnabled;
ConVar g_cvMaxFrags;
ConVar g_cvMapVote;

public void OnPluginStart()
{
    g_cvEnabled = CreateConVar("sm_ggmap_enabled", "1", "Enable Plugin");
    g_cvMaxFrags = CreateConVar("sm_ggmap_frags", "24", "Max Frags to Change Map");
    g_cvMapVote = CreateConVar("sm_ggmap_cmd", "sm_umc_mapvote 0", "MapVote Command");
    HookEvent("player_death", Event_PlayerDeath);
}
 
public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvEnabled.BoolValue)
        return Plugin_Continue;
    
    int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
    
    if (IsClientInGame(attacker))
    {
        int frags = GetClientFrags(attacker);
        
        if (frags >= g_cvMaxFrags.IntValue)
        {
            char cmd[256];
            g_cvMapVote.GetString(cmd, sizeof(cmd));
            ServerCommand(cmd);
        }
    }
    
    return Plugin_Continue;
}
