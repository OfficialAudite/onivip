char g_sRanks[][] = {
	"",
	"\x04VIP",
	"\x09S-VIP",
	"\x07STAFF",
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
    	this.rank = -1;
    	this.tag = -1;
    	this.activePerk = -1;
    	this.model = -1;
    	this.showTag = true;
    	this.namecolor = -1;
    	this.givenVips = 0;
    	this.trackGiveVipsTime = GetTime();
    }
    
    void Get(){
    	if(IsValidClient(this.id)){
    		char sSQLQuery[512], sSteamID[64];
    		GetClientAuthId(this.id, AuthId_SteamID64, sSteamID, sizeof(sSteamID));
    		
    		g_hDatabase.Format(sSQLQuery, sizeof(sSQLQuery),
    		"SELECT rank, tag, activeperk, model, forumid, namecolor, givenvips, trackGiveVipsTime, showtag FROM `%s_vip` WHERE steamid='%s' ORDER BY rank DESC LIMIT 1;", DB_CONNECTION, sSteamID);
    		
    		g_hDatabase.Query(SQL_GetPlayer_Callback, sSQLQuery, GetClientUserId(this.id));
    	}
    }
    
    void Set(){
    	if(IsValidClient(this.id)){
    		char sSQLQuery[512], sSteamID[64];
    		GetClientAuthId(this.id, AuthId_SteamID64, sSteamID, sizeof(sSteamID));
    		int iClientForumID = Forum_GetClientID(this.id);
    		
			if(IsOWNER(this.id) && this.rank == -1){
				this.rank = 3;
				this.tag = 9;
			}else if(IsSADMIN(this.id) && this.rank == -1){
				this.rank = 3;
				this.tag = 8;
			}else if(IsADMIN(this.id) && this.rank == -1){
				this.rank = 3;
				this.tag = 7;
			}else if(IsTADMIN(this.id) && this.rank == -1){
				this.rank = 3;
				this.tag = 6;
			}else if(IsSVIP(this.id) && this.rank == -1){
				this.rank = 2;
				this.tag = 1;
			}else if(IsVIP(this.id) && this.rank == -1){
				this.rank = 1;
				this.tag = 0;
			}else if(!IsOWNER(this.id) && !IsSADMIN(this.id) && !IsADMIN(this.id) && !IsTADMIN(this.id) && !IsSVIP(this.id) && !IsVIP(this.id)){
				this.rank = -1;
				this.tag = -1;
			}

    		g_hDatabase.Format(sSQLQuery, sizeof(sSQLQuery),
    		"INSERT INTO `%s_vip` (steamid, rank, forumid, tag, activeperk, namecolor, model, showtag, givenvips, trackGiveVipsTime) VALUES ('%s', %d, %d, %d, %d, %d, %d, %d, %d, %d) ON DUPLICATE KEY UPDATE rank = %d, forumid = %d, tag = %d, activeperk = %d, namecolor = %d, model = %d, showtag = %d, givenvips = %d, trackGiveVipsTime = %d;", 
    		DB_CONNECTION, sSteamID, this.rank, iClientForumID, this.tag, this.activePerk, this.namecolor, this.model, this.showTag ? 1 : 0, this.givenVips, this.trackGiveVipsTime, this.rank, iClientForumID, this.tag, this.activePerk, this.namecolor, this.model, this.showTag ? 1 : 0, this.givenVips, this.trackGiveVipsTime);
    		
    		g_hDatabase.Query(SQL_SavePlayer_Callback, sSQLQuery, GetClientUserId(this.id));
    	}
    }

	void Delete(){
		if(IsValidClient(this.id)){
			char sSQLQuery[512], sSteamID[64];
			GetClientAuthId(this.id, AuthId_SteamID64, sSteamID, sizeof(sSteamID));
			
			g_hDatabase.Format(sSQLQuery, sizeof(sSQLQuery),
			"DELETE FROM `%s_vip` WHERE steamid='%s';", DB_CONNECTION, sSteamID);
			
			g_hDatabase.Query(SQL_DeletePlayer_Callback, sSQLQuery, GetClientUserId(this.id));
		}
	}
}
Player player[MAXPLAYERS+1];