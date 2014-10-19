Ebola.Speedhack = {"CVAR", "VAR"};
Ebola.Speedhack.CVAR = { };
Ebola.Speedhack.VAR = { };

Ebola.Speedhack.VAR.ModuleName = "cocaine";
Ebola.Speedhack.VAR.CH = GetConVar("sv_cheats");
Ebola.Speedhack.VAR.FR = GetConVar("host_timescale");

function Ebola.Speedhack._init()
	require(Ebola.Speedhack.VAR.ModuleName);
end

Ebola.Speedhack._init();

function Ebola.Speedhack.On()
	Ebola.Speedhack.VAR.CH:SetValue(6);
	Ebola.Speedhack.VAR.FR:SetValue(5);
end

function Ebola.Speedhack.Off()
	Ebola.Speedhack.VAR.CH:SetValue(0);
	Ebola.Speedhack.VAR.FR:SetValue(1);
end

concommand.Add("+esh", Ebola.Speedhack.On);
concommand.Add("-esh", Ebola.Speedhack.Off);