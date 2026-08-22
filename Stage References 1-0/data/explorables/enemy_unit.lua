local enemy_unit = {
	name = "Enemy Unit",
	tag = "hostile",
}

function enemy_unit:GetRelevancy(x, y, info)
	if info.peaceful < 1 then return 0.0 end

	if info.tutorial and math.abs(x) < 80 and math.abs(y) < 80 then
		return 0.0
	end

	return info.elevation_delta > 0.02 and info.blightness_delta < 0 and 20.0 or 0.0
end

function enemy_unit:SpawnExplorable(x, y, info)
	local bugs_faction = GetBugsFaction()
	local num_hives = math.random(2,4)
	for i=1,num_hives do
		if i==1 and math.random() > 0.3 then
			local hive = Map.CreateEntity(bugs_faction, "f_bug_hive_large", true)
			hive:Place(x+math.random(-4,4), y+math.random(-4,4))
		else
			local hive = Map.CreateEntity(bugs_faction, "f_bug_hive", true)
			hive:Place(x+math.random(-4,4), y+math.random(-4,4))
		end
	end

	--[[
	--- spawn some worms at high level
	local pl = info.faction_level
	if pl and pl > 50 then
		local num = math.min((pl - 40) // 10, 6)
		Map.CreateEntity(bugs_faction, "f_worm1", true):Place(x+math.random(-4,4), y+math.random(-4,4))
	end
	--]]

	local extra_num = math.random(3,6)+num_hives
	if extra_num > 0 then
		for i=1,extra_num do
			local newx = math.random(x-6, x+6)
			local newy = math.random(y-6, y+6)
			Map.CreateEntity(bugs_faction, "f_bug_hole", true):Place(newx, newy)
		end
	end
end

data.explorables.enemy_unit = enemy_unit
