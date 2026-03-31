local alien_building = {
	name = "Alien Building",
}

local building_frame_ids = {
	"f_alien_heart_shard",
	"f_alien_observer",
	"f_alien_console",
	"f_alien_monolith",
	"f_alien_time_egg",
}

function alien_building:GetRelevancy(x, y, info)
	return info.blightness_delta > 0.03 and 1.0 or 0.0
end

function alien_building:SpawnExplorable(x, y, force_frame_id)
	local building_id = Map.GetSave().alien_explorable or 0
	building_id = building_id + 1
	if building_id > #building_frame_ids then building_id = 1 end
	Map.GetSave().alien_explorable = building_id

	local building_frame_id = force_frame_id or building_frame_ids[building_id]

	local building_entity = Map.CreateEntity("world", building_frame_id, true)
	local rewards = {}
	building_entity.extra_data.rewards = rewards
	building_entity:Place(x, y, math.random(4)-1)

	local explorable_fix_item
	if building_frame_id == "f_alien_heart_shard" then -- "v_explorable_blightanomaly_01" , "Heart Shard"
		explorable_fix_item = "datakey_alien"
	elseif building_frame_id == "f_alien_observer" then -- "v_explorable_blightanomaly_02" , "Observer"
		explorable_fix_item = "datakey_alien"
	elseif building_frame_id == "f_alien_console" then -- "v_explorable_blightanomaly_03" , "Console"
		building_entity:AddComponent("c_explorable_admin_fix", "hidden")
		rewards["c_alien_key"] = 1
		rewards["alien_artifact"] = math.random(2) -- 1-2
	elseif building_frame_id == "f_alien_monolith" then -- "v_explorable_monolith_01" , "Monolith"
		building_entity:SetVisual("v_explorable_monolith_01", math.random(4)-1)
		local effect = building_entity:FindComponent("c_monolith_effect")
		if effect then effect:Destroy() end
		local effect = building_entity:FindComponent("c_monolith_lightning")
		if effect then effect:Destroy() end
		explorable_fix_item = "datakey_alien"
	elseif building_frame_id == "f_alien_time_egg" then -- "v_explorable_timeegg_01" , "Time Egg"
		rewards["virus_source_code"] = math.random(1,3)
		if math.random() > 0.5 then
			rewards["empty_databank"] = math.random(1,2)
		else
			rewards["fuel_rod"] = math.random(4,7)
		end
		explorable_fix_item = "datakey_virus"
	end

	if explorable_fix_item then
		local fix = building_entity:AddComponent("c_explorable_fix", "hidden")
		fix.extra_data.explorable_fix = explorable_fix_item
	end
	--building_frame:SetRegister(FRAMEREG_SIGNAL, { id = explorable_fix_item, num = 1 })

	Explorable_AddAlienPuzzles(building_entity, not explorable_fix_item)
	return building_entity -- for human_c
end

data.explorables.alien_building = alien_building
