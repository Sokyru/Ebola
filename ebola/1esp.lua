
--[[ ESP ]]--

Ebola.ESP = {"CVAR", "VAR"};
Ebola.ESP.CVAR = { };
Ebola.ESP.VAR = { };

Ebola.ESP.VAR.Font = nil;
Ebola.ESP.VAR.Traitors = { };
Ebola.ESP.VAR.TraitorWeapons = { };

Ebola.ESP.CVAR.Enabled = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_ESP", "1", false, false);
Ebola.ESP.CVAR.ShowAllEnts = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_ESP_ShowAllEntities", "0", false, false);
Ebola.ESP.CVAR.TDetect = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_TraitorDetector", "1", false, false);

function Ebola.ESP._init()
	surface.CreateFont("ESPFont", { font = "Arial", size = 14, weight = 750, antialias = false, outline = true } ); -- Taken from bluebot
	surface.CreateFont("ESPFontLarge", { font = "Arial", size = 24, weight = 750, antialias = false, outline = true } ); -- Taken from bluebot
	for k,v in ipairs(player.GetAll()) do
		if(string.find(GAMEMODE.Name, "Terror")) then
			if(v:IsTraitor() && !table.HasValue(Ebola.ESP.VAR.Traitors, v)) then
				table.insert(Ebola.ESP.VAR.Traitors, v);
			end
		end
	end
end

Ebola.ESP._init();

function Ebola.ESP.ESP()
	if(Ebola.ESP.CVAR.Enabled:GetBool()) then
		for k,v in ipairs(ents.GetAll()) do
			if(v:IsValid()) then
				if(v:IsPlayer() && v:Alive() && v != LocalPlayer()) then -- v:Team() != TEAM_SPECTATOR
					local ESPL = (v:GetPos():ToScreen())

					if ( v:Health() <= 10 ) then color = Color( 255, 0, 0, 255 ); -- Bluebot
					elseif ( v:Health() <= 20 ) then color = Color( 255, 50, 50, 255 );
					elseif ( v:Health() <= 40 ) then color = Color( 250, 250, 50, 255 );
					elseif ( v:Health() <= 60 ) then color = Color( 150, 250, 50, 255 ); 
					elseif ( v:Health() <= 80 ) then color = Color( 100, 255, 50, 255 );
					else color = Color( 100, 255, 50, 255 ); end

					local w, h = surface.GetTextSize(tostring(v:Nick()));

					draw.DrawText("[" .. v:GetUserGroup() .. "]" .. v:Nick(), "ESPFont", ESPL.x, (ESPL.y - h / 2) + 7, color, 1);
					if(string.find(GAMEMODE.Name, "Terror") && table.HasValue(Ebola.ESP.VAR.Traitors, v)) then
						draw.DrawText("TRAITOR", "ESPFont", ESPL.x, ESPL.y + 13, Color(255, 0, 0), 1);
					elseif(string.find(GAMEMODE.Name, "Terror")) then
						if(v:IsTraitor()) then
							draw.DrawText("TRAITOR", "ESPFont", ESPL.x, ESPL.y + 13, Color(255, 0, 0), 1);
						elseif(v:IsActiveDetective()) then
							draw.DrawText("DETECTIVE", "ESPFont", ESPL.x, ESPL.y + 13, Color(0, 0, 255), 1);
						end
					end
					draw.DrawText("Health: " .. v:Health(), "ESPFont", ESPL.x, ESPL.y + 24, color, 1);
					if(v:GetActiveWeapon():IsValid()) then
						draw.DrawText(v:GetActiveWeapon():GetClass(), "ESPFont", ESPL.x, ESPL.y + 34, Color(255, 255, 255), 1);
					end
					if(string.find(GAMEMODE.Name, "Terror") && GetConVar("ttt_specdm_autoswitch") && v:Team() == TEAM_SPECTATOR) then
						draw.DrawText("Spectator Deathmatch", "ESPFont", ESPL.x, ESPL.y + 46, Color(255, 255, 0), 1);
					end
				elseif(v:GetClass() == "ttt_c4") then
					local ESPL = (v:GetPos():ToScreen());

					if(!v:GetArmed()) then
						draw.DrawText("C4 - Unarmed", "ESPFontLarge", ESPL.x, ESPL.y, Color( 255, 200, 200, 255 ), 1 );
					else
						draw.DrawText("C4 - "..string.FormattedTime(v:GetExplodeTime() - CurTime(), "%02i:%02i"), "ESPFontLarge", ESPL.x, ESPL.y, Color( 255, 200, 200, 255 ), 1 );
					end
				elseif(Ebola.ESP.CVAR.ShowAllEnts:GetBool() && table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, v:GetClass())) then
					local ESPL = (v:GetPos():ToScreen());

					draw.DrawText(v:GetClass(), "ESPFont", ESPL.x, ESPL.y, Ebola.Colors.Orange, 1);
				end
			end
		end
	end
end

function Ebola.ESP.TraitorDetector() --Credits completely to Blue Kirby, I will try to rewrite it for originality eventually.
	if(!Ebola.Global.Gamemode.TTT || LocalPlayer():IsTraitor()) then return end
	

	if(GetRoundState() == 2) then
		for _, w in ipairs(ents.GetAll()) do
			if(w:IsWeapon() && w.CanBuy && !table.HasValue(Ebola.ESP.VAR.TraitorWeapons, w:EntIndex())) then
				table.insert(Ebola.ESP.VAR.TraitorWeapons, w:EntIndex());
			end
		end
	end

	if(GetRoundState() != 3 && GetRoundState() != 2) then
		table.Empty(Ebola.ESP.VAR.Traitors);
		table.Empty(Ebola.ESP.VAR.TraitorWeapons);
		return;
	end

	for _, w in ipairs(ents.GetAll()) do
		if(w:IsWeapon() && w.CanBuy && IsValid(w:GetOwner()) && w:GetOwner():IsPlayer() && !table.HasValue(Ebola.ESP.VAR.TraitorWeapons, w:EntIndex())) then
			local ply = w:GetOwner();
			table.insert(Ebola.ESP.VAR.TraitorWeapons, w:EntIndex());

			if(!ply:IsDetective()) then
				if(!table.HasValue(Ebola.ESP.VAR.Traitors, ply)) then
					table.insert(Ebola.ESP.VAR.Traitors, ply);
				end

				if(ply != LocalPlayer() && !LocalPlayer():IsTraitor() && Ebola.ESP.CVAR.TDetect:GetBool()) then
					chat.AddText(Color(255, 50, 50), "Traitor", Color(255, 255, 255), " detected: ", Color(250, 180, 50), ply:Nick(), Color(255, 255, 255), " using ", Color(255, 255, 50), w:GetPrintName() or w:GetClass());
					chat.PlaySound("buttons/button10.wav");
				end
			end
		end
	end
end

hook.Add("HUDPaint", "EbolaESP", Ebola.ESP.ESP);
hook.Add("Think", "TraitorDetect", Ebola.ESP.TraitorDetector);