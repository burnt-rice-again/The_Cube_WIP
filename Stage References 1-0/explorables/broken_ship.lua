-- This is the rusted building in the desert

local broken_ship = {
	name = "Broken Ship",
}

local explorable_comp<const> = {
	"cable", "wire", "reinforced_plate", "crystal_powder", "hdframe", "obsidian", "energized_plate",
}
local comp_reward<const> = {
	"c_portable_turret", "c_behavior", "c_small_radar", "c_scout_radar", "c_small_relay", "c_portable_relay",
	"c_repairkit", "c_repairer", "c_pulselasers", "c_wind_turbine",
}

function broken_ship:GetRelevancy(x, y, info)
	return info.blightness_delta < 0 and info.elevation < -0.2 and 5.0 or 0.0
end

function broken_ship:SpawnExplorable(x, y)
	local rnd_visuals = {
		"v_explorable_brokenship_1"
	}
	local visual =  rnd_visuals[math.random(1, #rnd_visuals)]
	local ship_frame = Map.CreateEntity("world", "f_explorable", visual, true)
	ship_frame:AddComponent("c_disappear_empty", "hidden")
	ship_frame:Place(x, y, math.random(4)-1)
	ship_frame.extra_data.rewards = {}
	local rewards = ship_frame.extra_data.rewards

	local GetRandomComposition = function(comptable)
		local selected = math.random(1, #comptable)
		local amount = math.random(4, 10)
		return comptable[selected], amount
	end

	--[[
	local GetRandomCompositionEarly = function(comptable)
		local selected = math.random(1, math.floor(#comptable/2))
		local amount = math.min(((#comptable - selected + 1)) + 1, 19)
		return comptable[selected], math.floor(amount/2)+1
	end
	--]]

	local t1, t2 = GetRandomComposition(explorable_comp)
	rewards[t1] = t2
	local t1, t2 = GetRandomComposition(explorable_comp)
	rewards[t1] = t2
	if math.random(2) == 1 then
		rewards[comp_reward[math.random(1, #comp_reward)]] = 1
	end
end

data.explorables.broken_ship = broken_ship
