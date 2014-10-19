Ebola.Extrafunctions = { };

function Ebola.Extrafunctions._init()
	-- stuff
end

Ebola.Extrafunctions._init();

function Ebola.Extrafunctions.TableContains(table, element)
	for _, v in ipairs(table) do
		if v == element then
			return true;
		end
	end
	return false;
end