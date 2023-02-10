char g_sRanks[][] = {
	"",
	"\x04VIP",
	"\x09S-VIP",
};

enum struct Player{
    int id;
    int rank;
    int forumID;
    
    int tag;
    int activePerk;
    int model;
    bool showTag;
    int namecolor;
    
    // svip give out trial vips
    int givenVips;
    int trackGiveVipsTime;
    
    void Init(){
    	this.rank = 0;
    	this.tag = 0;
    	this.activePerk = 0;
    	this.model = 0;
    	this.showTag = true;
    	this.namecolor = -1;
    	this.givenVips = 0;
    	this.trackGiveVipsTime = GetTime();
    }
    
    void Get(){
    	if(IsValidClient(this.id)){
    		char sSQLQuery[512], sSteamID[64];
    		GetClientAuthId(this.id, AuthId_SteamID64, sSteamID, sizeof(sSteamID));
    		
    		int iClientForumID = Forum_GetClientID(this.id);
    		
    		g_hDatabase.Format(sSQLQuery, sizeof(sSQLQuery),
    		"SELECT rank, tag, activeperk, model, forumid, namecolor, showtag FROM `%s_vip` WHERE steamid='%s' ORDER BY rank DESC LIMIT 1;", DB_CONNECTION, sSteamID);
    		
    		g_hDatabase.Query(SQL_GetPlayer_Callback, sSQLQuery, GetClientUserId(this.id));
    	}
    }
    
    void Set(){
    	if(IsValidClient(this.id)){
    		char sSQLQuery[512], sSteamID[64];
    		GetClientAuthId(this.id, AuthId_SteamID64, sSteamID, sizeof(sSteamID));
    		
    		int iClientForumID = Forum_GetClientID(this.id);
    		
    		g_hDatabase.Format(sSQLQuery, sizeof(sSQLQuery),
    		"UPDATE `%s_vip` SET rank = %d, forumid = %d, tag = %d, activeperk = %d, namecolor = %d, model = %d, forumid = %d, showtag = %d WHERE steamid='%s';", 
    		DB_CONNECTION, this.rank, iClientForumID, this.tag, this.activePerk, this.namecolor, this.model, this.forumID, this.showTag ? 1 : 0, sSteamID);
    		
    		g_hDatabase.Query(SQL_SavePlayer_Callback, sSQLQuery);
    	}
    }
}
Player player[MAXPLAYERS+1];