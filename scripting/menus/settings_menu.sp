
public Action OpenSettingsMenu(int client)
{
	Menu menu = new Menu(SettingsMenuHandler);	
	FormatMenuTitle(menu, "Settings");
	
	menu.AddItem("tag", 		"Tag: Toggle");
	menu.AddItem("namecolor", 	"Namecolor: Reset");
	
	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

public int SettingsMenuHandler(Menu menu, MenuAction aAction, int client, int option)
{
    char sItem[64];
	menu.GetItem(option, sItem, sizeof(sItem));
	
    switch(aAction) {
        case MenuAction_Select: {
            if(StrEqual(sItem, "tag", false)) {
                player[client].showTag = !player[client].showTag;
				OP_Print(client, "Your Tag has been toggled %s", player[client].showTag ? "\x04On" : "\x0FOff");
				SetClientClanTag(client);
            }
			else if(StrEqual(sItem, "namecolor", false)) { 
                player[client].namecolor = -1;
            }
			OpenSettingsMenu(client);
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