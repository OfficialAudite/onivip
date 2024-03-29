public void SQL_SavePlayer_Callback(Database db, DBResultSet results, const char[] szError, int userid)
{
	if(db == null || results == null) {
		PrintToChatAll("[SQL] Update Query failure: %s", szError);
		return;
	}
	else {
		PrintToServer("UPDATED");
	}
}

public void SQL_DeletePlayer_Callback(Database db, DBResultSet results, const char[] szError, int userid)
{
	if(db == null || results == null) {
		PrintToChatAll("[SQL] Update Query failure: %s", szError);
		return;
	}
	else {
		PrintToServer("DELETED");
	}
}

public void SQL_GetPlayer_Callback(Database db, DBResultSet results, const char[] szError, int userid)
{	
	int client = GetClientOfUserId(userid); if(client == 0) return;
	
	if(db == null || results == null) {
		LogError("[SQL] Fetch Check Query failure: %s", szError);
		return;
	}
	else
	{
		if(IsValidClient(client)) {
			int rank, tag, activePerk, model, showTag, forumID, givenVips, trackGiveVipsTime;
				
			results.FieldNameToNum("showtag", showTag);
			results.FieldNameToNum("tag", tag);
			results.FieldNameToNum("rank", rank);
			results.FieldNameToNum("activeperk", activePerk);
			results.FieldNameToNum("forumid", forumID);
			results.FieldNameToNum("model", model);
			results.FieldNameToNum("givenvips", givenVips);
			results.FieldNameToNum("trackGiveVipsTime", trackGiveVipsTime);
			
			if(results.FetchRow())
			{
				int temp1 = results.FetchInt(showTag);
				player[client].showTag = temp1 ? true : false;
				player[client].tag = results.FetchInt(tag);
				player[client].rank = results.FetchInt(rank);
				player[client].activePerk = results.FetchInt(activePerk);
				player[client].forumID = results.FetchInt(forumID);
				player[client].model = results.FetchInt(model);
				player[client].givenVips = results.FetchInt(givenVips);
				player[client].trackGiveVipsTime = results.FetchInt(trackGiveVipsTime);
				
				
				CreateTimer(5.0, Timer_GivePerks, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

public Action Timer_GivePerks(Handle tmr, any data) {
	int client = GetClientOfUserId(data);
	if(IsValidClient(client)) {
		int rank = player[client].rank;
		OP_Print(client, "You have received your %s \x08perks!", g_sRanks[rank]);
	}
	return Plugin_Continue;
}