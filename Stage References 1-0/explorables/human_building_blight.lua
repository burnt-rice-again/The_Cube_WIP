local human_building_blight = {
	name = "Data Complex",
}

local building_visuals = {
	-- TODO maybe there are more blight only buildings later
	"v_human_explorable_5x5_a", -- 5x5 Data Complex
}

function human_building_blight:GetRelevancy(x, y, info)
	--if math.abs(x) < 150 and math.abs(y) < 150 then return 0.0 end

	return info.blightness_delta > 0.1 and info.elevation > -0.2 and info.elevation < 0.2 and 2.0 or 0.0
end

function human_building_blight:SpawnExplorable(x, y)
	local visual = building_visuals[1]
	local building_frame = Map.CreateEntity("world", "f_human_explorable", visual, true)
	building_frame.extra_data.rewards = {}
	local rewards = building_frame.extra_data.rewards
	building_frame:Place(x, y, math.random(4)-1)

	building_frame.extra_data.itemreward = 1

	local fix = building_frame:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = "microscope"
	building_frame:SetRegister(FRAMEREG_SIGNAL, { id = "microscope", num = 1 })
	rewards["datakey"] = math.random(3, 4)
	-- Move to when unlocking
	Map.GetFaction("world"):Unlock("datakey_blight")
	local factory = building_frame:AddComponent("c_human_factory")
	building_frame:SetRegister(FRAMEREG_VISUAL, { item = "datakey_blight", num = 1 })
	factory:LinkRegisterFromRegister(1, FRAMEREG_VISUAL)

	Explorable_AddHumanPuzzles(building_frame, 1)
end

data.explorables.human_building_blight = human_building_blight
