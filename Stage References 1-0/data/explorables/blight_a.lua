local blight_a = {
	name = "Blight Peekaboo",
	tag = "hostile",
	player_only = true,
	singular = true,
	race = "robot",
}

function blight_a:GetRelevancy(x, y, info)
	-- only spawn for factions that haven't finished the mission
	if (info.faction_counters.m_blight_a or 0) >= 3 then return 0.0 end

	-- singleton style spawn, don't spawn if already spawned in the world somewhere
	local alien_soldier = info.save.blight_a
	if (alien_soldier and alien_soldier:ExistsOnFaction("world")) then return 0.0 end

	-- Along the perimeter only and avoid the water / ground too low
	local elevation = info.elevation
	if elevation < -0.3 or elevation > 0.15 then return 0.0 end

	if info.blightness_delta < -0.02 or info.blightness_delta > 0.05 then return 0.0 end

	if info.faction_level < 6 then return 0.0 end

	return 1.0
end

function blight_a:SpawnExplorable(x, y) -- Explorable_SpawnAt(x, y, discoverer, filter)
	local alien_soldier = Map.CreateEntity("world", "f_blight_peekaboo", "v_alien_soldier_shadow")
	alien_soldier:Place(x, y, math.random(4)-1)
	Map.GetSave().blight_a = alien_soldier
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

Frame:RegisterFrame("f_blight_peekaboo", {
	size = "Mission", race = "alien", index = 5999, name = "???",
	texture = "Main/textures/icons/alien/alienunit_soldier_a.png",
	health_points = 1,
	visibility_range = 10,
	minimap_color = { 0.9, 0.9, 0.8 },
	flags = "NonSelectable",
	resource = { 1, 3},
	components = {
		{ "c_blight_a_trigger", "hidden" },
	}
})

data.visuals.v_alien_soldier_shadow = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/AlienUnit_01/AlienUnit_Soldier_A.AlienUnit_Soldier_A'",
	light_color = { 0.0, 0.0, 0.0, 0.0 }, -- Shadow
	specular_scale = 0.1,
	light_radius = 1,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

local c_blight_a_trigger = Comp:RegisterComponent("c_blight_a_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 4,
	trigger_channels = "bot",
})

function c_blight_a_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	if other_faction.is_player_controlled then
		-- remove oneself from the scene
		comp.owner:RemoveHealth(1, other_entity, "full")
	end
end

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- From 0 to 3: Finding or attacking it
function c_blight_a_trigger:on_take_damage(comp, amount, damager)
	if amount <= 0 or not damager then return end
	local damager_faction = damager.faction -- nil if damager doesn't exist
	if not damager_faction or not damager_faction.is_player_controlled then return end

	local updated_count = FactionCount("m_blight_a", 3, damager_faction, 'increment_if_less')
	if not updated_count or updated_count < 3 then return end

	damager_faction:Unlock("c_anomaly_container_i")

	-- After the third time discovering the alien soldiers, spawn the reward
	local x, y = comp.owner:GetLocationXY()
	Map.Defer(function()
		Map.DropItemAt(x, y, "c_anomaly_container_i")
		Map.DropItemAt(x, y, "blight_plasma", math.random(10, 20))
		Map.DropItemAt(x, y, "anomaly_particle", math.random(10, 20))
	end)
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1
	{
		title = "It got away...",
		talkinghead = true,
		snd = "fx_518_elain",
		txt = [[There was something in the blight but it disappeared. It vanished as we approached. The electrical field in the blight has been disrupting our equipment making it difficult to enter. What could possibly move so quickly and freely within such a place?]],
		step_txt = "Let's hope we see it again.",
	},
	-- 2
	{
		title = "It got away again...",
		talkinghead = true,
		snd = "fx_522_elain",
		txt = [[Again, it vanished into the mist as we got near. Yet it was certainly a dark form that bore some similarity to the bizarre rock formations we have been seeing around the blight. We need to uncover the secrets of the blight and these forms that can move within it.]],
		step_txt = "Perhaps we will see it once again...",
	},
	-- 3
	{
		title = "It vanished but this time it left us something...",
		talkinghead = true,
		snd = "fx_526_elain",
		txt = [[It's gone again, disappeared in a flash. What has the ability to just de-materialize like that? It was certainly made of the same obsidian we see within the blight. It also glowed with energy similar to but unlike the blight, although maybe akin to it. Additional readings indicate it has left something behind.]],
		step_txt = "End of Mission! We couldn't seem to approach or catch it, the mystery remains unsolved. However, before it vanished it left us a parting gift!",
		-- final step of the mission, no goal
	}
}

data.codex.m_blight_a = {
	category = "Mission", index = 6, title = "A shadow in the mist!",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/values/anomaly.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_blight_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function()
		local e = Map.GetSave().blight_a
		return e and e:ExistsOnFaction("world") and e
	end,
	mission_location_text_exists = "Unknown Signal Detected at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Unknown Signal Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/values/anomaly.png",
	mission_start_notification_title = "Disturbance Detected",
	mission_start_notification_text = "Unknown Signal Detected at %d, %d",
	mission_lost_notification_title = "Unknown Signal Lost",
	mission_lost_notification_text = "Unknown Signal Disappeared at %d, %d",
}

data.explorables.blight_a = blight_a
