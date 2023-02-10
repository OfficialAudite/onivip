public void FormatMenuTitle(Menu menu, char[] sITitle, any ...){
    char sTitle[192];
	FormatEx(sTitle, sizeof(sTitle), " ONIPLAY VIP\n  ⊳ %s      \n▬▬▬▬▬▬▬▬▬▬▬▬", sITitle);
	menu.SetTitle(sTitle);
}

stock void OP_Print(int client, char[] szMessage, any ...)
{
	if(client && IsClientInGame(client) && !IsFakeClient(client))
	{
		char szBuffer[PLATFORM_MAX_PATH], szNewMessage[PLATFORM_MAX_PATH];
        Format(szBuffer, sizeof(szBuffer), " \x01\x04\x01[\x0FONIPLAY\x01] \x08%s", szMessage);
        VFormat(szNewMessage, sizeof(szNewMessage), szBuffer, 3);

		Handle hBf = StartMessageOne("SayText2", client, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS);
		if(hBf != null)
		{
			if(GetUserMessageType() == UM_Protobuf)
			{
				Protobuf hProtoBuffer = UserMessageToProtobuf(hBf);
				hProtoBuffer.SetInt("ent_idx", client);
				hProtoBuffer.SetBool("chat", true);
				hProtoBuffer.SetString("msg_name", szNewMessage);
				hProtoBuffer.AddString("params", "");
				hProtoBuffer.AddString("params", "");
				hProtoBuffer.AddString("params", "");
				hProtoBuffer.AddString("params", "");
			}
			else
			{
				BfWrite hBfBuffer = UserMessageToBfWrite(hBf);
				hBfBuffer.WriteByte(client);
				hBfBuffer.WriteByte(true);
				hBfBuffer.WriteString(szNewMessage);
			}
		}
		EndMessage();
	}
}

stock void OP_PrintAll(char[] szMessage, any ...)
{
	for(int client = 1; client <= MaxClients; client++) {
		if(client && IsClientInGame(client) && !IsFakeClient(client))
		{
			char szBuffer[PLATFORM_MAX_PATH], szNewMessage[PLATFORM_MAX_PATH];
			Format(szBuffer, sizeof(szBuffer), " \x01\x04\x01[\x0FONIPLAY\x01] \x08%s", szMessage);
			VFormat(szNewMessage, sizeof(szNewMessage), szBuffer, 3);

			Handle hBf = StartMessageOne("SayText2", client, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS);
			if(hBf != null)
			{
				if(GetUserMessageType() == UM_Protobuf)
				{
					Protobuf hProtoBuffer = UserMessageToProtobuf(hBf);
					hProtoBuffer.SetInt("ent_idx", client);
					hProtoBuffer.SetBool("chat", true);
					hProtoBuffer.SetString("msg_name", szNewMessage);
					hProtoBuffer.AddString("params", "");
					hProtoBuffer.AddString("params", "");
					hProtoBuffer.AddString("params", "");
					hProtoBuffer.AddString("params", "");
				}
				else
				{
					BfWrite hBfBuffer = UserMessageToBfWrite(hBf);
					hBfBuffer.WriteByte(client);
					hBfBuffer.WriteByte(true);
					hBfBuffer.WriteString(szNewMessage);
				}
			}
			EndMessage();
		}
	}
}

stock bool IsValidClient(int client) {
    return ((1 <= client <= MaxClients) && IsClientInGame(client) && !IsFakeClient(client));
}

stock bool IsVIP(int iClient) {
    return CheckCommandAccess(iClient, "", ADMFLAG_RESERVATION);
}

stock bool IsSVIP(int iClient) {
    return CheckCommandAccess(iClient, "", ADMFLAG_CUSTOM1);
}

stock bool IsTADMIN(int iClient) {
    return CheckCommandAccess(iClient, "", ADMFLAG_CUSTOM2);
}

stock bool IsADMIN(int iClient) {
    return CheckCommandAccess(iClient, "", ADMFLAG_GENERIC);
}

stock bool IsSADMIN(int iClient) {
    return CheckCommandAccess(iClient, "", ADMFLAG_RCON);
}

stock bool IsOWNER(int iClient) {
    return CheckCommandAccess(iClient, "", ADMFLAG_ROOT);
}