enum {
	Tag = 0,
	Color
};

char g_sTags[][][] = {
    {"VIP", 		"\x06"},
    {"S-VIP", 		"\x04"},
    {"Oni", 		"\x06"},
    {"Runner", 		"\x06"},
    {"Fake-Admin", 	"\x06"},
    {"Banhammer", 	"\x06"},
    {"T-ADMIN", 	"\x04"},
    {"ADMIN", 		"\x07"},
    {"S-ADMIN", 	"\x07"},
    {"DEV", 		"\x02"}
};

public Action OpenTagsMenu(int client) {
	Menu menu = new Menu(TagMenuHandler);

	FormatMenuTitle(menu, "Tags");
	for(int i = 0; i < sizeof(g_sTags); i++) {
		if(StrEqual(g_sTags[i][0], "VIP", false) && player[client].rank != 1) {
			menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag], ITEMDRAW_DISABLED);
		}
        else if(StrEqual(g_sTags[i][0], "S-VIP", false) && player[client].rank != 2) {
			menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag], ITEMDRAW_DISABLED);
		}
		else if(StrEqual(g_sTags[i][0], "T-ADMIN", false) && !IsTADMIN(client)) {
			menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag], ITEMDRAW_DISABLED);
		}
		else if(StrEqual(g_sTags[i][0], "ADMIN", false) && !IsADMIN(client)) {
			menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag], ITEMDRAW_DISABLED);
		}
		else if(StrEqual(g_sTags[i][0], "S-ADMIN", false) && !IsSADMIN(client)) {
			menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag], ITEMDRAW_DISABLED);
		}
		else if(StrEqual(g_sTags[i][0], "DEV", false) && !IsOWNER(client)) {
			menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag], ITEMDRAW_DISABLED);
		}
		else menu.AddItem(g_sTags[i][Tag], g_sTags[i][Tag]);
    }
	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public int TagMenuHandler(Menu menu, MenuAction aAction, int client, int option)
{
    switch(aAction) {
        case MenuAction_Select: {
            player[client].tag = option;
            OP_Print(client, "\x08You changed your tag to \x0F%s", g_sTags[option][0]);
			
			OpenTagsMenu(client);
        }
		case MenuAction_Cancel:
		{
			if(option == MenuCancel_ExitBack) {
				OpenVIPMenu(client);
			}
		}
        case MenuAction_End: {
            delete menu;
        }
    }
    return 0;
}