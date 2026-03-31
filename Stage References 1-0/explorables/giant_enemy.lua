local giant_enemy = {
	name = "Giant Enemy",
	player_only = true
}

function giant_enemy:GetRelevancy(x, y, info)
	if info.peaceful < 1 then return 0.0 end
	if info.faction_level < 10 then return 0.0 end
	return info.elevation_delta > 0.2 and info.blightness_delta > 0 and 10.0 or 0.0
end

function giant_enemy:SpawnExplorable(x, y)
	local bugs_faction = GetBugsFaction()
	local hive = Map.CreateEntity(bugs_faction, "f_giant_home", true)
	hive:Place(x, y)

	local giant = Map.CreateEntity(bugs_faction, "f_charcharosaurus1", true)
	giant:Place(x, y)
	giant:SetRegister(FRAMEREG_GOTO, { entity = hive })
end

data.explorables.giant_enemy = giant_enemy
