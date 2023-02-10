char g_sMenuList[][][] = {
    {"select_tag", 	    	"Select Tag",           "enabled"},
    {"select_namecolor", 	"Select Name Color",    "enabled"},
    {"select_votes", 		"Create Vote",          "disabled"},
    {"select_models", 		"Select Model",         "disabled"},
    {"select_settings", 	"Settings",         	"enabled"},
};

public Action OpenVIPMenu(int client){
    Menu menu = new Menu(OpenVIPMenu_Handler);
    FormatMenuTitle(menu, "Main Menu");

    for (int i = 0; i < sizeof(g_sMenuList); i++)
    {
        if(StrEqual(g_sMenuList[i][2], "enabled", false))
            menu.AddItem(g_sMenuList[i][0], g_sMenuList[i][1]);
        else
            menu.AddItem(g_sMenuList[i][0], g_sMenuList[i][1], ITEMDRAW_DISABLED);
    }

    menu.ExitButton = true;
	menu.ExitBackButton = false;
    menu.Display(client, MENU_TIME_FOREVER);

    return Plugin_Handled;
}

public int OpenVIPMenu_Handler(Menu menu, MenuAction maction, int client, int option)
{
    char sItem[64];
	menu.GetItem(option, sItem, sizeof(sItem));

    switch(maction) {
        case MenuAction_Select: {
            if(StrEqual(sItem, "select_tag", false)) {
                OpenTagsMenu(client);
            }
            else if(StrEqual(sItem, "select_namecolor", false)) {
               	OpenNamecolorMenu(client);
            }
            else if(StrEqual(sItem, "select_votes", false)) {
                //OpenVoteMenu(client);
            }
            else if(StrEqual(sItem, "select_models", false)) {
                //OpenModelMenu(client);
            }
            else if(StrEqual(sItem, "select_settings", false)) {
                OpenSettingsMenu(client);
            }
        }
        case MenuAction_End: {
            delete menu;
            return 0;
        }
    }
    
    return 0;
}