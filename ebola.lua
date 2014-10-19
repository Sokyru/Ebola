Ebola = {"CVAR", "bHop", "ESP", "Runlua", "Colors", "Extrafunctions", "Chams", "AntiScreenShot", "Menu", "Speedhack", "Global"};
Ebola.CVAR = { };
Ebola.Global = {"Properties", "Gamemode", "Misc"};
Ebola.Global.Properties = { };
Ebola.Global.Gamemode = { };
Ebola.Global.Misc = { };

Ebola.Global.Properties.Prefix = "[Ebola]";
Ebola.Global.Properties.CVARPref = "Ebola";

Ebola.Global.Gamemode.TTT = string.find(GAMEMODE.Name, "Terror");

concommand.Add(Ebola.Global.Properties.CVARPref .. "_reload", function()
	include("ebola.lua");
	MsgC(Color(0, 255, 0), "\n" .. Ebola.Global.Properties.Prefix .. " Reloading...");
end);

concommand.Add(Ebola.Global.Properties.CVARPref .. "_reloadModule", function(ply, cmd, args, str)
	if(args[1] != nil && file.Exists("lua/ebola/" .. args[1], "GAME")) then
		include("ebola/" .. args[1]);
		MsgC(Color(0, 0, 255), "\n" .. Ebola.Global.Properties.Prefix .. " Module reloaded: " .. args[1] .. "\n");
	elseif(args[1] == nil) then
		MsgC(Color(255, 150, 0), "\n" .. Ebola.Global.Properties.Prefix .. " Please enter a module name.\n");
	else
		MsgC(Color(255, 150, 0), "\n" .. Ebola.Global.Properties.Prefix .. " Module \'" .. args[1] .. "\' not found.\n");
	end
end);

-- local libfiles, libfolders = file.Find("lua/ebola/lib/*.lua", "GAME");
-- table.sort(libfiles);
-- PrintTable(libfiles);

local time = 0.25;
-- local libCheck = false;

-- for k,v in pairs(libfiles) do
-- 	timer.Simple(time * k, function()
-- 		include("ebola/lib/" .. v)
-- 		MsgC(Color(0, 255, 0), "\n" .. Ebola.Global.Properties.Prefix .. " Library loaded: " .. v .. "\n");
-- 	end);
-- 	libCheck = true;
-- end

local files, folders = file.Find("lua/ebola/*.lua", "GAME");
table.sort(files);
PrintTable(files);

--if(libCheck) then
	for a,b in pairs(files) do
		timer.Simple(time * a, function()
			include("ebola/" .. b)
			MsgC(Color(0, 0, 255), "\n" .. Ebola.Global.Properties.Prefix .. " Module loaded: " .. b .. "\n");
		end);
	end
--end

-- Below doesn't work in ebola/runlua.lua for some reason

function Ebola.Show()
	local EntsMenu = vgui.Create("DFrame");
	EntsMenu:SetPos((ScrW() / 2) - 175, (ScrH() / 2) - 100);
	EntsMenu:SetSize( 350, 100 );
	EntsMenu:SetTitle("Ebola - Run Lua");
	EntsMenu:SetVisible(true);
	EntsMenu:SetDraggable(true);
	EntsMenu:ShowCloseButton(true);
	EntsMenu:MakePopup();

	local LuaEntry = vgui.Create("DTextEntry", EntsMenu);
	LuaEntry:SetPos(EntsMenu:GetWide() / 14, EntsMenu:GetTall() / 3);
	LuaEntry:SetSize(300, 20);

	local RunLua = vgui.Create("DButton", EntsMenu);
	RunLua:SetText("Execute");
	RunLua:SetPos((EntsMenu:GetWide() / 2) - 25, (EntsMenu:GetTall() / 2) + 5)
	RunLua:SetSize(50, 25);
	RunLua.DoClick = function()
		RunString(tostring(LuaEntry:GetValue()));
	end
end

concommand.Add(Ebola.Global.Properties.CVARPref .. "_runLua", Ebola.Show);