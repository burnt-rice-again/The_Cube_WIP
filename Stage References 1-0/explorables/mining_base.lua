local mining_base = {
	name = "Mining Base",
	player_only = true,
	singular = true,
	race = "robot",
}

function mining_base:GetRelevancy(x, y, info)
	-- don't spawn too early
	if math.abs(x) + math.abs(y) < 200 then return 0.0 end

	-- don't spawn if it exists and is still owned by the world faction or the discoverer player's faction
	local save_mining_base, player_faction = info.save.mining_base, info.player_faction
	local base_faction = save_mining_base and save_mining_base ~= true and save_mining_base.exists and save_mining_base.faction
	if (base_faction and base_faction.is_world_faction) or base_faction == player_faction then return 0.0 end

	-- don't spawn for factions that have finished the mission
	local counters_m_bug_a = info.faction_counters.m_bug_a or 0
	if counters_m_bug_a >= 4 then return 0.0 end

	-- don't spawn on certain map regions
	if info.elevation_delta < 0.02 then return 0.0 end
	if info.blightness_delta >= 0.0 then return 0.0 end

	-- don't spawn if the faction still owns an unrepaired mining base (after another player faction caused another mining base to spawn)
	if counters_m_bug_a == 3 and player_faction:GetEntityWithId("f_mining_base") then return 0.0 end

	return 0.2
end

function mining_base:SpawnExplorable(x, y)
	local world_faction = Map.GetFaction("world")
	local silica_sand = Map.CreateEntity(world_faction, "f_resourcenode_silica", "v_silica_node") -- "v_silica_medium1"
	silica_sand:SetRegister(FRAMEREG_GOTO, { item = "silica", amount = 10000 + math.random(3999) })
	silica_sand:Place(x, y, math.random(4)-1)

	if not world_faction:CanPlace("f_resourcenode_silica", x, y, math.random(4)-1, "v_silica_node") then
		-- if the resource failed to spawn at the exact location update x, y to the new position
		x = silica_sand.location.x
		y = silica_sand.location.y
	end

	local base = Map.CreateEntity(world_faction, "f_mining_base")

	-- NE 1, -3, NW = -3, -3, SW -3, 1, SE 1, 1, N = 0, -3, S = 0, 1, E = 1, 0, W = -3, 0
	local ofx
	local ofy

	local checkpos_data
	-- favour random diagonal over random edge
	if math.random(2) == 1 then
		if math.random(2) == 1 then
			-- fixed size of 2d array x, y coords taking into account two 2x2 entities
			checkpos_data = { 1, -3, -3, -3, -3, 1, 1, 1, 0, -3, 0, 1, 1, 0, -3, 0 }
		else
			checkpos_data = { -3, -3, -3, 1, 1, 1, 1, -3, 0, 1, 1, 0, -3, 0, 0, -3 }
		end
	else
		if math.random(2) == 1 then
			checkpos_data = { -3, 1, 1, 1, 1, -3, -3, -3, 1, 0, -3, 0, 0, -3, 0, 1 }
		else
			checkpos_data = { 1, 1, 1, -3, -3, -3, -3, 1, -3, 0, 0, -3, 0, 1, 1, 0 }
		end
	end

	for _ii=1, 16, 2 do
		ofx = checkpos_data[_ii]
		ofy = checkpos_data[_ii + 1]

		if (world_faction:CanPlace("f_mining_base", x + ofx, y + ofy)) then
			break
		end
	end

	local function PlaceAndFaceMiningResource(base, res_x, res_y, base_x, base_y)
		-- Place and then face the resource so the mining effect doesn't pass through the building
		if base_x < res_x then
			if base_y < res_y then
				base:Place(base_x, base_y, 0) -- face NE
			else
				base:Place(base_x, base_y, 1) -- face SE
			end
		else
			if base_y > res_y then
				base:Place(base_x, base_y, 2) -- face NW
			else
				base:Place(base_x, base_y, 3) -- face SW
			end
		end
	end

	PlaceAndFaceMiningResource(base, x, y, x + ofx, y + ofy)

	base:AddComponent("c_wind_turbine")

	Map.GetSave().mining_base = base

	-- foundations for the mining building
	for _x=-1,2 do
		for _y=-1,2 do
			-- make the road not spawn in certain places
			if math.random(3) < 3 then
				Map.CreateEntity(world_faction, "f_foundation"):Place(x + ofx + _x, y + ofy + _y)
			end
		end
	end

	-- bug hives
	local bugs_faction = GetBugsFaction()
	for ii=1,math.random(3, 5) do
		local hive = Map.CreateEntity(bugs_faction, "f_bug_hive", true)
		ofx = math.random(-3, 3)
		ofy = math.random(-3, 3)
		hive:Place(x + ofx, y + ofy)
	end

	-- bug holes
	for ii=1,math.random(5, 8) do
		ofx = math.random(-4, 4)
		ofy = math.random(-4, 4)
		if (bugs_faction:CanPlace("f_bug_hole", x + ofx, y + ofy)) then
			local hole = Map.CreateEntity(bugs_faction, "f_bug_hole", true)
			hole:Place(x + ofx, y + ofy)
		end
	end

	-- trilobytes
	for i=1,math.random(1, 4) do
		local f_trilobyte1 = Map.CreateEntity(bugs_faction, "f_trilobyte1")
		f_trilobyte1:Place(x+math.random(-3, 3), y+math.random(-3, 3))
	end

	-- spawn the whole gang
	local gastarias1 = Map.CreateEntity(bugs_faction, "f_gastarias1")
	gastarias1:Place(x+math.random(-2, 2), y+math.random(-2, 2))

	local f_scaramar1 = Map.CreateEntity(bugs_faction, "f_scaramar1")
	f_scaramar1:Place(x+math.random(-2, 2), y+math.random(-3, 3))

	local f_scaramar2 = Map.CreateEntity(bugs_faction, "f_scaramar2")
	f_scaramar2:Place(x+math.random(-3, 3), y+math.random(-2, 2))

	local gastarid1 = Map.CreateEntity(bugs_faction, "f_gastarid1")
	gastarid1:Place(x+math.random(-2, 2), y+math.random(-2, 2))

	-- make sure they're tethered
	local newhome = Map.CreateEntity(bugs_faction, "f_bug_home", true)
	newhome:Place(x, y)
	gastarias1:SetRegisterEntity(FRAMEREG_GOTO, newhome)
	f_scaramar1:SetRegisterEntity(FRAMEREG_GOTO, newhome)
	f_scaramar2:SetRegisterEntity(FRAMEREG_GOTO, newhome)
	gastarid1:SetRegisterEntity(FRAMEREG_GOTO, newhome)
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

local f_mining_base = Frame:RegisterFrame("f_mining_base", {
	texture = "Main/textures/icons/frame/building_2x2_F.png",
	name = "Miner Base (Abandoned)",
	race = "human",
	is_explorable = true,
	visibility_range = 10,
	minimap_color = { 0.9, 0.9, 0.8 },
	slots = { storage = 4 },
	construction_recipe = CreateConstructionRecipe({ energized_plate = 8, circuit_board = 4 }, 30),
	trigger_channels = "building",
	visual = "v_base2x2f_broken",
	size = "Mission",
	components = {
		{ "c_bug_mission_trigger", "hidden" }, -- range 22 trigger
		{ "c_bug_capture_trigger", "hidden" }, -- range 16 trigger
		{ "c_bug_a_repair", "hidden" }, -- repair comp
	}
})

-- first trigger for mining base mission
local c_bug_mission_trigger = Comp:RegisterComponent("c_bug_mission_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 22, -- detect range
	trigger_channels = "bot|building",
})

-- second mission trigger
local c_bug_capture_trigger = Comp:RegisterComponent("c_bug_capture_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 16,
	trigger_channels = "bot|building",
})

local c_bug_a_repair = data.components.c_mothership_repair:RegisterComponent("c_bug_a_repair", {
	attachment_size = "Hidden", race = "human", index = 3999, name = "Mining base repairs",
	texture = "Main/textures/icons/frame/building_2x2_F.png",
	on_add = function(self, comp)
		comp.extra_data.items = {
			["reinforced_plate"] = 0,
			["crystal"] = 0,
			["circuit_board"] = 0,
		}
		comp.extra_data.max_items = 10
		self:on_add_repair(comp)
	end,
})

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- To 1 - Mission Start
function c_bug_mission_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	if other_faction.is_player_controlled then
		FactionCount("m_bug_a", 1, other_faction, 'set_if_less')
	end
end

-- From 1 to 2 - Investigate the bug presence with a suitably armed force
function c_bug_capture_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	if not other_faction.is_player_controlled then return end
	if not FactionCount("m_bug_a", 2, other_faction, 'set_if_less') then return end

	-- trigger everyone in the area if its non passive mode
	if (Map.GetSettings().peaceful or 2) > 1 then
		Map.FindClosestEntity(comp.owner, 4, function(e)
			if e.faction.id ~= "bugs" then return end
			local trigger_comp = e:FindComponent("c_bug_spawn", true) or e:FindComponent("c_turret", true)
			if trigger_comp then
				trigger_comp.def:on_take_damage(trigger_comp, 0, other_entity)
			end
		end, FF_OPERATING)
	end
end

-- From 2 to 3 - Destroy the bugs surrounding the miner base
function f_mining_base:on_interact(entity, interactor, is_retry)
	local interactor_faction = interactor.faction
	if is_retry or not interactor_faction.is_player_controlled or not entity.faction.is_world_faction then return end

	-- find hostiles in the area
	local enemy = Map.FindClosestEntity(entity, 8, function(e) return true end, FF_OPERATING|FF_ENEMYFACTION, interactor_faction)
	if enemy then return end -- notify interactor?

	local counters = interactor_faction.extra_data.counters
	if counters and ((counters.m_bug_a == 2 and FactionCount("m_bug_a", 1, interactor_faction)) or counters.m_bug_a == 3) then
		-- remove mission triggers, first person to interact wins
		entity.faction = interactor_faction
		local c = entity:FindComponent("c_bug_capture_trigger")
		if c then c:Destroy() end
		c = entity:FindComponent("c_bug_mission_trigger")
		if c then c:Destroy() end
	end
end

-- From 3 to 4 - Check the mining base for required materials to repair it
function c_bug_a_repair:on_complete(comp)
	local comp_faction, old_entity = comp.faction, comp.owner
	if comp_faction.is_player_controlled then
		FactionCount("m_bug_a", 4, comp_faction, 'set_if_less')
	end

	-- replace with real building
	Map.Defer(function()
		local newbase, loc, rot = Map.CreateEntity(comp_faction, "f_building2x2f"), old_entity.placed_location, old_entity.rotation
		for _,v in ipairs(old_entity.components) do -- pass non-hidden components
			local id, can_remove = v.id, not v.is_hidden and v:PrepareRemoval()
			local pass_extra = can_remove and v:Destroy() or nil
			if can_remove and not newbase:AddComponent(id, pass_extra) then old_entity:AddComponent(id, pass_extra) end
		end
		newbase:AddComponent("c_adv_miner")
		newbase:AddItem("c_deployer")
		comp_faction:RunUI("OnEntityRecreate", old_entity, newbase)
		old_entity:Destroy()
		newbase:Place(loc, rot)
	end)
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1
	{
		title = "Disturbance Detected",
		talkinghead = true,
		txt = [[The large amount of silica in this area seems to have attracted a strong bug presence. I'd suggest we check it out, but not until we have a strong enough force to deal with the hostiles.]],
		step_txt = "Investigate the bug presence with a suitably armed force",
	},
	-- 2
	{
		title = "Large Bug Force",
		talkinghead = true,
		txt = [[There seems to be an abandoned mining base right in the center of those hives. We need to directly access the building, however we'll first need to clear out any hostiles in the area.]],
		step_txt = "Destroy the bugs surrounding the miner base and then approach the building",
	},
	-- 3
	{
		title = "Mining Base Repair",
		talkinghead = true,
		txt = [[With the majority of the surrounding hostiles eliminated we are able to secure the facility. Initial scans reveal some minor damage that we should already have most of the supplies for.]],
		step_txt = "Check the mining base for required materials to repair it",
		-- final step of the mission, no goal
	},
	-- 4
	{
		title = "Mining Base Repaired",
		talkinghead = true,
		txt = [[Repairs have been completed, and with it we have a fully functional mining base. We could use it to collect the remaining silica if we can figure out how to bring it back to our main outpost.]],
		step_txt = "End of Mission",
		-- final step of the mission, no goal
	},
}

data.codex.m_bug_a = {
	category = "Mission", index = 4, title = "Silica Discovery",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/items/silica.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_bug_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function(faction)
		local e = Map.GetSave().mining_base
		local e_faction = e and e.exists and e.faction
		return e_faction and (e_faction == faction or e_faction.is_world_faction) and e
	end,
	mission_location_text_exists = "Bug signs Detected at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Bug signs Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/items/silica.png",
	mission_start_notification_title = "Disturbance Detected",
	mission_start_notification_text = "Bug signs Detected at %d, %d",
	mission_lost_notification_title = "Bug signs Lost",
	mission_lost_notification_text = "Bug Signs Disappeared at %d, %d",
}

data.explorables.mining_base = mining_base
