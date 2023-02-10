char g_sColors[][][] = {
    {"White", 	"\x01"},
    {"Red", 	"\x02"},
    {"Purple", 	"\x03"},
    {"Green", 	"\x04"},
    {"Blue", 	"\x0B"},
    {"Gray", 	"\x08"},
    {"Orange", 	"\x10"},
    {"Yellow", 	"\x09"}
};

public Action OpenNamecolorMenu(int client) {
	Menu menu = new Menu(NamecolorMenuHandler);

	FormatMenuTitle(menu, "Namecolors");
	for(int i = 0; i < sizeof(g_sColors); i++) {
        menu.AddItem(g_sColors[i][Tag], g_sColors[i][Tag]);
    }
	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public int NamecolorMenuHandler(Menu menu, MenuAction aAction, int client, int option)
{
    switch(aAction) {
        case MenuAction_Select: {
            player[client].namecolor = option;
            OP_Print(client, "\x08You changed your namecolor to \x0F%s", g_sColors[option][0]);
			
			OpenNamecolorMenu(client);
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