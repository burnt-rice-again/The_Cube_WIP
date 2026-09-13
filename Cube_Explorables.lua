local no_explorable = {
	GetRelevancy = function(self, x, y, info) return 0.6 end,
	SpawnExplorable = function(x, y) end,
}

data.explorables.ai_base = nil
data.explorables.alien_a = nil
data.explorables.alien_artifact = nil
data.explorables.alien_building = nil
data.explorables.alien_unit = nil
data.explorables.blight_a = nil
data.explorables.broken_ship = nil
data.explorables.crashed_ship = nil
data.explorables.human_a = nil
data.explorables.human_b = nil
data.explorables.human_building = nil
data.explorables.human_building_blight = nil
data.explorables.human_c = nil
data.explorables.mining_base = nil
data.explorables.ruined_component = nil
data.explorables.roaming_bot = nil
data.explorables.m_world_a = nil

------------------ Explorables 
local cc_explorable_fix_volcano = Comp:RegisterComponent("cc_explorable_fix_volcano", {
	name = "Repair Required",
	texture = "Main/textures/icons/components/int.png",
	--effect = "fx_leaves",
	activation = "OnAnyItemSlotChange",
	type = "Puzzle",
	on_solved = function(comp, explorable_race, faction)
		comp.owner:SetRegister(FRAMEREG_SIGNAL, nil)
		Map.Defer(function ()
			comp.owner.faction = faction.id--Map.GetPlayerFactions()[1]
			comp.owner:AddComponent("cc_cube_melter")
			comp.owner:AddItem(comp.extra_data.explorable_fix)
			local comp_puzzle = comp.owner:FindComponent ("c_explorable_netwalk")
			if comp_puzzle then comp_puzzle:Destroy() end
			if not faction:IsUnlocked("tc_cube_red_1") then faction:Unlock("tc_cube_red_1") end
			comp:Destroy()
		end)
	end,
	explorable_fix = "ic_cube_empty",
	slots = {cube = 1}
})
function cc_explorable_fix_volcano:on_update(comp, cause)
	local fix_item = comp.has_extra_data and comp.extra_data.explorable_fix or self.explorable_fix
	local slot = comp.owner:FindSlot(fix_item, 1)
	if slot then
		Map.Defer(function() if comp.exists and slot.exists and slot.unreserved_stack > 0 then FactionAction.ExplorableSolvePuzzle(comp.faction, { comp = comp, consume_slot = slot  }) end end)
	end
end

local cc_explorable_fix_wire_weed = Comp:RegisterComponent("cc_explorable_fix_wire_weed", {
	name = "Repair Required",
	texture = "Main/textures/icons/components/int.png",
	--effect = "fx_leaves",
	activation = "OnAnyItemSlotChange",
	type = "Puzzle",
	explorable_fix = "datakey_robot",
	on_solved = function(comp, explorable_race, faction)
		comp.owner:SetRegister(FRAMEREG_SIGNAL, nil)
		if not faction:IsUnlocked("tc_cube_green_1") then faction:Unlock("tc_cube_green_1") end
		Map.Defer(function ()
			comp.owner:AddItem("cc_planter_wire", 1, false, {
				yield = 1 + math.floor(math.random()*math.random() * 5 ),
				growth_time = 300 - math.random(-100, 100),
			})

			local comp_puzzle = comp.owner:FindComponent ("c_explorable_netwalk")
			if comp_puzzle then comp_puzzle:Destroy() end
			--comp:Destroy()
		end)
	end,
	on_update = function(self, comp, cause)
		local fix_item = comp.has_extra_data and comp.extra_data.explorable_fix or self.explorable_fix
		local slot = comp.owner:FindSlot(fix_item, 1)
		if slot then
			Map.Defer(function() if comp.exists and slot.exists and slot.unreserved_stack > 0 then FactionAction.ExplorableSolvePuzzle(comp.faction, { comp = comp, consume_slot = slot  }) end end)
		end
	end
})
table.insert(data.puzzles.robot, "cc_explorable_fix_volcano")
table.insert(data.puzzles.robot, "cc_explorable_fix_wire_weed")

local ec_volcano = {
    name = "volcano",
}

function ec_volcano:GetRelevancy(x, y, info)
    return info.blightness_delta > 0.03 and 1.0 or 0.0
end

local function add_volcano(x,y)
    local volcano = Map.CreateEntity("world", "fc_volcano",true)

	volcano.extra_data.rewards = {ic_cube_red = 1}

	local fix = volcano:AddComponent("cc_explorable_fix_volcano", "hidden")
	fix.extra_data.explorable_fix = "ic_cube_empty"
	volcano:SetRegister(FRAMEREG_SIGNAL, { id = "ic_cube_empty", num = 1 })
    volcano.extra_data.auto_destroy = true
	volcano:Place(x,y,math.random(4)-1)
end

function ec_volcano:SpawnExplorable(x, y)

    --- place surrounding volcanos 
    -- local num = Map.StartTerraforming(volcano, 6, 100 0)
    -- Map.Delay(Map.StopTerraforming,1)

    -- for i = 1,math.random(4),1 do 
    --     local extra = Map.CreateEntity("world", "f_wall","blight_set_0"..math.random(8))
    --     extra:Place(x+math.random(6)-math.random(6), y+math.random(6)-math.random(6),math.random(4)-1,true)
    -- end
    add_volcano(x, y)

end

data.explorables.ec_volcano = ec_volcano

local ec_wire_weed = {
    name = "Wire Weed",
}

function ec_wire_weed:GetRelevancy(x, y, info)
    --return (info.blightness_delta < 0 and info.elevation > -0.3 and info.elevation < 0.1 and 0.3) or 0.0
	if info.elevation < -0.15 then return 0.0 end -- we want it on grass
	if info.elevation_delta > -0.02 then return 0.0 end
	if info.blightness_delta > 0 then return 0.0 end

	return 0.2
end

function ec_wire_weed:SpawnExplorable(x, y)
    local weed = Map.CreateEntity("world", "fc_wire_weed", true)
    weed.extra_data.rewards = {crystal = 1}
    -- add fixx item lvl1 
    local fix = weed:AddComponent("cc_explorable_fix_wire_weed", "hidden")
    fix.extra_data.explorable_fix = "datakey_robot"
    weed:SetRegister(FRAMEREG_SIGNAL, { id = "datakey_robot", num = 1 })
    weed.extra_data.auto_destroy = true
    weed:Place(x, y, math.random(4)-1)
end

data.explorables.ec_wire_weed = ec_wire_weed

local ec_fort = {
    name = "Fort",
}

function ec_fort:GetRelevancy(x, y, info)
    --return (info.blightness_delta < 0 and info.elevation > -0.3 and info.elevation < 0.1 and 0.3) or 0.0
	if info.elevation < -0.15 then return 0.0 end -- we want it on grass
	if info.elevation_delta > -0.02 then return 0.0 end
	if info.blightness_delta > 0 then return 0.0 end

    -- dont place near spawn 
    if x < 200 and y < 200 then return 0 end 

	return 0.01
end

function ec_fort:SpawnExplorable(x, y)

    Place_enemy_fort(x,y,math.random(1,10))
    print("placing fort",x,y)
end
-- error in fort code remove temporarly 
--data.explorables.ec_fort = ec_fort





--------------  Ruined Cities 
---


-- local ruins_array = {"v_battery_01_l_ruined", "v_missile_launcher_m_ruined","v_transporter_01_m_ruined","v_explorable_glitchbuilding","v_simulator_ruined", "v_2x2_a_ruined","v_explorable_building_6","v_explorable_building_3" } 
-- local ruins_count = #ruins_array


-- local ec_city1 = {
--     name = "volcano",
-- }

-- local function PlaceRandomRuin(x,y)  
--     local visual = ruins_array[math.random(ruins_count)]
-- 	local new_entity = Map.CreateEntity("world", "f_resourcenode_metal", visual)
--     print(visual)
-- 	new_entity:SetRegister(FRAMEREG_GOTO, {id="metalore",num=math.random(1000, 25000)})
-- 	new_entity:Place(x, y, math.random(4))
-- end


-- function ec_city1:GetRelevancy(x, y, info)
--     local faction = Map.GetPlayerFactions()[0]
--     if faction then 
--         --faction exisits
--         if faction.home_entity and faction.home_entity:GetRangeTo(x,y) < 100 then return 0 end 
--     elseif x < 200 and y < 200 then 
--         --only on intial world load before faction spawned
--         return 0
--     end
--     return CheckFreeSpace(x,y) and 1 or 0
-- end

-- function ec_city1:SpawnExplorable(x, y)
--     local mug = Map.CreateEntity("world", "fc_mug")
--     local size = CheckFreeAreaFromCentre(x,y,10)
--     mug:Place(x,y)
--     --print(size)
--     if size < 3 then print("too small") return
        
--     elseif size > 3 then 
--         for k,v in pairs({{-2,-2},{2,-2},{-2,2},{2,2}}) do 
--             PlaceRandomRuin(v[1]+x,v[2]+y)
--         end
--         size = 4
--         CreateFoundationsFromCentre(x,y,size,size,"f_human_foundation_basic","world")
--     else
--         --CreateFoundationsFromCentre(x,y,size,size,"f_human_foundation_basic","world")
--     end
-- end

-- data.explorables.ec_city1 = ec_city1


--------------- Flower Explorables 
---
---


















