Ebola.bHop = {"CVAR"};
Ebola.bHop.CVAR = { };

Ebola.bHop.CVAR.Enabled = CreateClientConVar(Ebola.Global.Properties.CVARPref .. "_bhop", "1", false, false);

function Ebola.bHop._init()
	-- stuff
end

Ebola.bHop._init();

function Ebola.bHop.bHop()
	if(Ebola.bHop.CVAR.Enabled:GetBool()) then
		if(input.IsKeyDown(KEY_SPACE)) then
			if(LocalPlayer():IsOnGround() || LocalPlayer():WaterLevel() > 0) then
				if(LocalPlayer():IsTyping()) then return end;
				RunConsoleCommand("+jump");
				timer.Create("DisableJump", 0.01, 0, function()
					RunConsoleCommand("-jump");
				end)
			end
		end
	end
end

hook.Add("Think", "bHop", Ebola.bHop.bHop);