local m_world_a = {
	name = "Big Daikon",
	player_only = true,
	singular = true,
	race = "robot",
}

function m_world_a:GetRelevancy(x, y, info)
	-- don't spawn too early
	if math.abs(x) + math.abs(y) < 200 then return 0.0 end

	-- don't spawn if it exists
	local save_big_daikon = info.save.big_daikon
	if (save_big_daikon and save_big_daikon:ExistsOnFaction("world")) then return 0.0 end

	-- don't spawn for factions that have finished the mission
	if not info.faction_counters.equipped_uplink then return 0.0 end
	if (info.faction_counters.m_world_a or 0) >= 3 then return 0.0 end

	-- don't spawn on certain map regions
	if info.elevation < -0.15 then return 0.0 end -- we want it on grass
	if info.elevation_delta > -0.02 then return 0.0 end
	if info.blightness_delta > 0 then return 0.0 end

	return 0.2
end

function m_world_a:SpawnExplorable(x, y)
	local silica_sand = Map.CreateEntity("world", "f_world_big_daikon", "v_big_daikon") -- Upscaled "SM_Grasslands_Tree_05_Large"
	silica_sand:Place(x, y, math.random(4)-1)

	-- just have some trilobytes below it, chilling out!
	local bugs_faction = GetBugsFaction()
	for i=1,math.random(4, 6) do
		local f_trilobyte1 = Map.CreateEntity(bugs_faction, "f_trilobyte1")
		f_trilobyte1:Place(x+math.random(-1, 1), y+math.random(-1, 1))
		f_trilobyte1:LookAt(x, y)
	end

	Map.GetSave().big_daikon = silica_sand
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

Frame:RegisterFrame("f_world_big_daikon", {
	name = "Super Silica Tree",
	texture = "Main/textures/icons/frame/gianttree.png",
	health_points = 100,
	visibility_range = 10,
	minimap_color = { 0.9, 0.9, 0.8 },
	size = "Mission",
	flags = "NonSelectable",
	prevent_goto = true,
	resource = { 1, 3},
	components = {
		{ "c_big_daikon_trigger", "hidden" },
	}
})

local c_big_daikon_trigger = Comp:RegisterComponent("c_big_daikon_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 12,
	trigger_channels = "bot",
})

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- To 1: Mission Start
function c_big_daikon_trigger:on_trigger(comp, other_entity)
	--print ("c_big_daikon_trigger:on_trigger")
	local other_faction = other_entity.faction
	if not other_faction.is_player_controlled then return end

	local halfhealth = comp.owner.max_health // 2
	FactionCount("m_world_a", (comp.owner.health <= halfhealth and 2 or 1), other_faction, 'set_if_less')
end

-- From 1 to 2: Damage Giant Tree
-- From 2 to 3: Clear the area of enemies and destroy the giant tree hive
function c_big_daikon_trigger:on_take_damage(comp, amount, damager)
	if amount <= 0 or not damager then return end
	local comp_owner, damager_faction = comp.owner, damager.faction

	-- first hit
	local comp_owner_health, halfhealth = comp_owner.health, comp_owner.max_health // 2
	if damager_faction.is_player_controlled and comp_owner_health > halfhealth and comp_owner_health - amount <= halfhealth then
		FactionCount("m_world_a", 2, damager_faction, 'set_if_less') -- you've disturbed the hive
		local x, y = comp_owner:GetLocationXY()
		local lx, ly = damager:GetLocationXY()
		Map.Defer(function()
			local bugs_faction = GetBugsFaction()
			for i=1,12 do
				local f_trilobyte1 = Map.CreateEntity(bugs_faction, "f_trilobyte1")
				f_trilobyte1:Place(x+math.random(-1, 1), y+math.random(-1, 1))
				f_trilobyte1:LookAt(lx, ly)
			end
		end)
	end

	-- final hit
	if damager_faction.is_player_controlled and comp_owner_health-amount <= 0 then
		FactionCount("m_world_a", 3, damager_faction, 'set_if_less') -- you did it

		local x, y = comp_owner:GetLocationXY()
		Map.Defer(function()
			for xx = -1,1 do
				for yy = -1,1 do
					if xx == 0 and yy == 0 then
						-- Max drop in the middle!
						Map.DropItemAt(x + xx, y + yy, "silica", 40, "f_dropped_resource", "v_silicascatter_node1")
					else
						Map.DropItemAt(x + xx, y + yy, "silica", math.random(5, 20), "f_dropped_resource", "v_silicascatter_node1")
					end
				end
			end
		end)
	end
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1
	{
		title = "So tall",
		talkinghead = true,
		txt = [[We are detecting some kind of anomaly in the world.

One the natural flora of the world is giving unusual readings. It appears mineable except scans indicate it has an extremely hard outer shell.

It's too strong to mine but perhaps there is some other way to acquire its resources.]],
		step_txt = "Destroy Giant Tree",
	},
	--- 2
	{
		title = "Disturbed the Hive!",
		talkinghead = true,
		txt = [[The tree acted as a giant hive. You'll need to eliminate all hostiles in the area before destroying it.]],
		step_txt = "Clear the area of enemies and destroy the giant tree hive",
		-- final step of the mission, no goal
	},
	--- 3
	{
		title = "Composition",
		talkinghead = true,
		txt = [[The trunk of the tree was made entirely of silica.

While this one had matured and hardened too much to be mined there appears to be smaller ones that we should be able to extract small amounts of silica.

This should help us set up our initial silicon production.]],
		step_txt = "End of Mission - Silica Resources Acquired",
		-- final step of the mission, no goal
	},
}

data.codex.m_world_a = {
	category = "Mission", index = 7, title = "That's a big tree!",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/frame/gianttree.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_world_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function()
		local e = Map.GetSave().big_daikon
		return e and e:ExistsOnFaction("world") and e
	end,
	mission_location_text_exists = "Big tree detected at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Tree was Destroyed", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/frame/gianttree.png",
	mission_start_notification_title = "Anomaly Detected",
	mission_start_notification_text = "Abnormal readings detected at %d, %d",
	mission_lost_notification_title = "Anomaly Disappeared",
	mission_lost_notification_text = "Abnormal readings Disappeared at %d, %d",
}

data.explorables.m_world_a = m_world_a
