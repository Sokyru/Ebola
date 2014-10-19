--[[ Chams ]]--

Ebola.Chams = {"CVAR", "VAR", "CC"};
Ebola.Chams.Name = "Chams";
Ebola.Chams.CVAR = { };
Ebola.Chams.VAR = { };
Ebola.Chams.CC = { };

Ebola.Chams.VAR.CurrentEntTypes = { };
Ebola.Chams.VAR.AllowedEntTypes = {
	"prop_physics",
	"prop_door_rotating",
	"func_door",
	"func_door_rotating",
	"spawned_shipment",
	"spawned_weapon",
	"prop_ragdoll",
	"prop_physics_multiplayer"};

Ebola.Chams.CVAR.EnableChams = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_Chams", "1", false, false);
Ebola.Chams.CVAR.EnableWire = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_Chams_Wireframe", "0", false, false);
Ebola.Chams.CVAR.ChamsType = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_Chams_mode", "3d");
Ebola.Chams.CVAR.ChamsBlend = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_Chams_blend", "0.5");

function Ebola.Chams._init()
	-- stuff
end

Ebola.Chams._init();

function Ebola.Chams.CC.FindEntTypes()
	for i, e in ipairs(ents.GetAll()) do
		if(!table.HasValue(Ebola.Chams.VAR.CurrentEntTypes, e:GetClass()) && !table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, e:GetClass())) then
			table.insert(Ebola.Chams.VAR.CurrentEntTypes, e:GetClass());
		end

		if(string.find(e:GetClass(), "weapon") && !table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, e:GetClass())) then
			table.insert(Ebola.Chams.VAR.AllowedEntTypes, e:GetClass());
			table.RemoveByValue(Ebola.Chams.VAR.CurrentEntTypes, e:GetClass());
		end

		if(string.find(e:GetClass(), "c_") && !table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, e:GetClass())) then
			table.insert(Ebola.Chams.VAR.AllowedEntTypes, e:GetClass());
			table.RemoveByValue(Ebola.Chams.VAR.CurrentEntTypes, e:GetClass());
		end
	end
	table.sort(Ebola.Chams.VAR.CurrentEntTypes);
	table.sort(Ebola.Chams.VAR.AllowedEntTypes);
end

Ebola.Chams.CC.FindEntTypes();

function Ebola.Chams.CC.ListEnts()
	MsgC(Ebola.Colors.Blue, "Currently allowed entities:\n");
	for i, e in ipairs(Ebola.Chams.VAR.AllowedEntTypes) do
		MsgC(Ebola.Colors.Green, e .. "\n");
	end
end

function Ebola.Chams.CC.AddEnt(ply, cmd, args, str)
	table.insert(Ebola.Chams.VAR.AllowedEntTypes, args[1]);
	MsgC(Ebola.Colors.Green, "\n" .. Ebola.Global.Properties.Prefix .. "[" .. Ebola.Chams.Name .. "] Entity \'" .. args[1] .. "\' added.\n");
	if(args[1] == nil) then
		-- yeah fuck you buddy
	end
end

function Ebola.Chams.CC.RemoveEnt(ply, cmd, args, str)
	if(table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, args[1])) then
		table.RemoveByValue(Ebola.Chams.VAR.AllowedEntTypes, args[1]);
		MsgC(Ebola.Colors.Green, "\n" .. Ebola.Global.Properties.Prefix .. "[" .. Ebola.Chams.Name .. "] Entity \'" .. args[1] .. "\' removed.\n");
	elseif(args[1] == nil) then
		-- yeah fuck you buddy
	else
		MsgC(Ebola.Colors.Orange, "\n" .. Ebola.Global.Properties.Prefix .. "[" .. Ebola.Chams.Name .. "] Entity \'" .. args[1] .. "\' either does not exist or is already disallowed.\n");
	end
end

function Ebola.Chams.Chams()
	if(Ebola.Chams.CVAR.EnableChams:GetBool()) then
		cam.Start3D(EyePos(), EyeAngles());
		for k, v in ipairs(ents.GetAll()) do
			if(GetConVarString(Ebola.Global.Properties.CVARPref .. "_Chams_mode") == "3d") then
				if(v:IsPlayer() && v:Alive() && v:Team() != TEAM_SPECTATOR) then
					teamCol = team.GetColor(v:Team());
					render.SuppressEngineLighting(true);
					render.SetColorModulation((teamCol.r/255), (teamCol.g/255), (teamCol.b/255));
					v:SetMaterial("models/debug/debugwhite");
					render.MaterialOverride("models/debug/debugwhite");
					render.SetBlend(GetConVarNumber(Ebola.Global.Properties.CVARPref .. "_Chams_blend"));
					v:DrawModel();
					render.SuppressEngineLighting(false);
					render.SetColorModulation((teamCol.r/255), (teamCol.g/255), (teamCol.b/255));
					v:SetMaterial("models/debug/debugwhite");
					render.MaterialOverride("models/debug/debugwhite");
					v:DrawModel();
					if (IsValid(v:GetActiveWeapon())) then
						v:GetActiveWeapon():DrawModel();
					end
					v:SetMaterial();
				elseif(table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, v:GetClass())) then
					if(v:IsValid()) then
						propCol = Ebola.Colors.Red;
						render.SuppressEngineLighting(true);
						v:SetRenderMode(RENDERMODE_TRANSALPHA);
						render.SetBlend(GetConVarNumber(Ebola.Global.Properties.CVARPref .. "_Chams_blend"));
						render.SetColorModulation((propCol.r/255), (propCol.g/255), (propCol.b/255));
						v:DrawModel();
						render.SetBlend(1);
						render.SuppressEngineLighting(false);
						if(Ebola.Chams.CVAR.EnableWire:GetBool()) then
							v:SetMaterial("models/wireframe");
							render.MaterialOverride("models/wireframe");
							v:DrawModel();
						end
						v:SetMaterial();
					end
				end
			elseif(GetConVarString(Ebola.Global.Properties.CVARPref .. "_Chams_mode") == "2d") then
				if(v:IsPlayer() && v:Alive() && v:Team() != TEAM_SPECTATOR) then
					teamCol = team.GetColor(v:Team());
					render.SuppressEngineLighting(true);
					v:SetMaterial("models/debug/debugwhite");
					render.MaterialOverride("models/debug/debugwhite");
					if(string.find(GAMEMODE.Name, "Terror")) then
						if(v:IsTraitor()) then
							render.SetColorModulation( 1, 0, 0, 1 );
						end
					elseif(string.find(GAMEMODE.Name, "Terror") && table.HasValue(Ebola.ESP.VAR.Traitors, v)) then
						render.SetColorModulation( 1, 0, 0, 1 );
					elseif(string.find(GAMEMODE.Name, "Terror")) then
						if(v:IsActiveDetective()) then
							render.SetColorModulation( 0, 0, 1, 1 );
						end
					else
						render.SetColorModulation((teamCol.r/255), (teamCol.g/255), (teamCol.b/255));
					end
					v:DrawModel();
					if (IsValid(v:GetActiveWeapon())) then
						v:GetActiveWeapon():DrawModel();
					end
					render.SuppressEngineLighting(false);
					v:SetMaterial();
				elseif(table.HasValue(Ebola.Chams.VAR.AllowedEntTypes, v:GetClass())) then
					if(v:IsValid()) then
						defCol = Ebola.Colors.Red;
						render.SuppressEngineLighting(true);
						v:SetMaterial("models/debug/debugwhite");
						render.MaterialOverride("models/debug/debugwhite");
						render.SetBlend(GetConVarNumber(Ebola.Global.Properties.CVARPref .. "_Chams_blend"));
						render.SetColorModulation((defCol.r/255), (defCol.g/255), (defCol.b/255));
						v:DrawModel();
						render.SuppressEngineLighting(false);
						render.SetBlend(1);
						v:SetMaterial();
						if(Ebola.Chams.CVAR.EnableWire:GetBool()) then
							v:SetMaterial("models/wireframe");
							render.MaterialOverride("models/wireframe");
							v:DrawModel();
						end
						v:SetMaterial();
					end
				end
			end
		end
		cam.End3D();
	end
end


function Ebola.Chams.CC.EntityMenu()
	Ebola.Chams.CC.FindEntTypes();
	table.sort(Ebola.Chams.VAR.AllowedEntTypes);

	local EntsMenu = vgui.Create("DFrame");
	EntsMenu:SetPos((ScrW() / 2) - 235, (ScrH() / 2) - 275);
	EntsMenu:SetSize( 470, 550 );
	EntsMenu:SetTitle("Ebola - Chams Entities");
	EntsMenu:SetVisible(true);
	EntsMenu:SetDraggable(true);
	EntsMenu:ShowCloseButton(true);
	EntsMenu:MakePopup();

	local CurrentEnts = vgui.Create("DListView", EntsMenu);
	CurrentEnts:SetPos((EntsMenu:GetWide() / 2) - 220, (EntsMenu:GetTall() / 2) - 240);
	CurrentEnts:SetSize(200, 500);
	CurrentEnts:AddColumn("Available Entities");
	for i, e in ipairs(Ebola.Chams.VAR.CurrentEntTypes) do
		CurrentEnts:AddLine(e);
	end

	local TrackedEnts = vgui.Create("DListView", EntsMenu);
	TrackedEnts:SetPos((EntsMenu:GetWide() / 2) + 20, (EntsMenu:GetTall() / 2) - 240);
	TrackedEnts:SetSize(200, 500);
	TrackedEnts:AddColumn("Tracked Entities");
	for ii, ee in ipairs(Ebola.Chams.VAR.AllowedEntTypes) do
		TrackedEnts:AddLine(ee);
	end

	local TrackEnt = vgui.Create("DButton", EntsMenu);
	TrackEnt:SetText("->");
	TrackEnt:SetPos((EntsMenu:GetWide() / 2), (EntsMenu:GetTall() / 2))
	TrackEnt:SetSize(20, 20);
	TrackEnt.DoClick = function()
		if(CurrentEnts:GetSelectedLine() != nil) then
			local lineID = CurrentEnts:GetSelectedLine();
			local lineContents = CurrentEnts:GetLine(lineID);
			local l2 = lineContents:GetValue(1);
			table.insert(Ebola.Chams.VAR.AllowedEntTypes, l2);
			table.RemoveByValue(Ebola.Chams.VAR.CurrentEntTypes, l2);
			TrackedEnts:AddLine(l2);
			CurrentEnts:RemoveLine(lineID);
		end
	end

	local UntrackEnt = vgui.Create("DButton", EntsMenu);
	UntrackEnt:SetText("<-");
	UntrackEnt:SetPos((EntsMenu:GetWide() / 2) - 20, (EntsMenu:GetTall() / 2))
	UntrackEnt:SetSize(20, 20);
	UntrackEnt.DoClick = function()
		if(TrackedEnts:GetSelectedLine() != nil) then
			local lineID = TrackedEnts:GetSelectedLine();
			local lineContents = TrackedEnts:GetLine(lineID);
			local l2 = lineContents:GetValue(1);
			table.insert(Ebola.Chams.VAR.CurrentEntTypes, l2);
			table.RemoveByValue(Ebola.Chams.VAR.AllowedEntTypes, l2);
			CurrentEnts:AddLine(l2);
			TrackedEnts:RemoveLine(lineID);
		end
	end
end

concommand.Add(Ebola.Global.Properties.CVARPref .. "_Chams_entMenu", Ebola.Chams.CC.EntityMenu);
concommand.Add(Ebola.Global.Properties.CVARPref .. "_Chams_listEnts", Ebola.Chams.CC.ListEnts);
concommand.Add(Ebola.Global.Properties.CVARPref .. "_Chams_addEnt", Ebola.Chams.CC.AddEnt);
concommand.Add(Ebola.Global.Properties.CVARPref .. "_Chams_removeEnt", Ebola.Chams.CC.RemoveEnt);

hook.Add("HUDPaint", "rce", Ebola.Chams.Chams);
cvars.AddChangeCallback(Ebola.Global.Properties.CVARPref .. "_Chams", Ebola.Chams.Chams);