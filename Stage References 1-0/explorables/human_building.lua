local human_building = {
	name = "Human Building",
}

local building_visuals = {
	"v_explorable_building_4", -- 4 - power
	"v_explorable_building_2", -- 2 - storage
	"v_explorable_building_3", -- 3 - research
	"v_explorable_building_6", -- 6 - factory
}

function human_building:GetRelevancy(x, y, info)
	if math.abs(x) < 150 and math.abs(y) < 150 then return 0.0 end
	return info.blightness_delta < -0.1 and info.elevation > -0.1 and info.elevation < 0.1 and 0.2 or 0.0
end

function human_building:SpawnExplorable(x, y)
	for _x=x+1, x+2 do
		for _y=y-4, y+7 do
			if math.random(10) > 5 then
				Map.CreateEntity("world", "f_human_foundation_basic"):Place(_x, _y, math.random(4)-1)
			end
		end
	end

	for _x=x-4, x+7 do
		for _y=y+1, y+2 do
			if math.random(10) > 5 then
				Map.CreateEntity("world", "f_human_foundation_basic"):Place(_x, _y, math.random(4)-1)
			end
		end
	end

	local dir = {
		{1, 1},
		{-1, -1},
		{-1, 1},
		{1, -1},
	}

	for i=1,4 do --math.random(4)
		local buildingindex = i --math.random(4)
		local visual = building_visuals[buildingindex]
		local building_frame = Map.CreateEntity("world", "f_human_explorable", visual, true)
		building_frame.extra_data.rewards = {}
		local rewards = building_frame.extra_data.rewards
		building_frame:Place(x+(math.random(4)*dir[i][1]), y+(math.random(4)*dir[i][2]), math.random(4)-1)

		building_frame.extra_data.itemreward = i

		if i == 1 then -- power
			-- fix with transformer
			local fix = building_frame:AddComponent("c_explorable_fix", "hidden")
			fix.extra_data.explorable_fix = "transformer"
			building_frame:SetRegister(FRAMEREG_SIGNAL, { id = "transformer", num = 1 })
			rewards["human_datacube"] = 1
			rewards["smallreactor"] = 1
			building_frame:AddComponent("c_small_fusion_reactor", "hidden")
		elseif i == 2 then -- warehouse
			-- fix with small reactor
			local fix = building_frame:AddComponent("c_explorable_fix", "hidden")
			fix.extra_data.explorable_fix = "smallreactor"
			building_frame:SetRegister(FRAMEREG_SIGNAL, { id = "smallreactor", num = 1 })
			rewards["human_datacube"] = math.random(1,4)
			rewards["engine"] = 1
			building_frame:AddComponent("c_large_storage", "hidden")
		elseif i == 3 then -- research
			-- fix with microscope
			local fix = building_frame:AddComponent("c_explorable_fix", "hidden")
			fix.extra_data.explorable_fix = "microscope"
			building_frame:SetRegister(FRAMEREG_SIGNAL, { id = "microscope", num = 1 })
			rewards["human_datacube"] = math.random(2,4)

			-- mothership datakey
			--local fix2 = building_frame:AddComponent("c_explorable_fix_lvl2", "hidden")
			--fix2.extra_data.explorable_fix = "datakey"
			-- give a human vehilce on full solve
			local vehicle_rewards = { "f_human_miner", "f_human_tank", "f_human_flyer" }
			local vehicle = vehicle_rewards[math.random(1, #vehicle_rewards)]
			building_frame.extra_data.reward_frame = vehicle
			building_frame:AddComponent("c_human_science", "hidden")
		elseif i == 4 then -- factory
			-- factory
			local makeitem = { "human_datacube", "microscope", "ldframe", } -- "f_human_miner" -- removed unit for now because it would get built owned by the world faction

			local random_makeitem = Map.GetSave().human_explorable or 0
			random_makeitem = random_makeitem + 1
			if random_makeitem > #makeitem then random_makeitem = 1 end
			Map.GetSave().human_explorable = random_makeitem

			Map.GetFaction("world"):Unlock(makeitem[random_makeitem])
			--building_frame:AddComponent("c_human_factory"):SetRegister(1, { item = makeitem[random_makeitem], num = REG_INFINITE })

			local factory = building_frame:AddComponent("c_human_factory")
			building_frame:SetRegister(FRAMEREG_VISUAL, { item = makeitem[random_makeitem], num = 1 })
			factory:LinkRegisterFromRegister(1, FRAMEREG_VISUAL)

			-- fix with engine
			local fix = building_frame:AddComponent("c_explorable_fix", "hidden")
			fix.extra_data.explorable_fix = "engine"
			building_frame:SetRegister(FRAMEREG_SIGNAL, { id = "engine", num = 1 })

			rewards["human_datacube"] = math.random(2,4)
		end

		Explorable_AddHumanPuzzles(building_frame, i)
	end
end

data.explorables.human_building = human_building
