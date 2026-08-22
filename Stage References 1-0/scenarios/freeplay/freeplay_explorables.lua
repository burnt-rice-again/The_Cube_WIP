-- This is the rusted building in the desert
-- This is the remains of an alleged bot that was passing through or mining and got sniped destroyed and
-- then dropped all its items here. The perpetrators are still hanging around the scene of the crime!
local graveyard_drop = {
	name = 'GraveYard',
}

function graveyard_drop:GetRelevancy(x, y, info)
	return info.elevation_delta > 0.02 and info.blightness_delta < 0 and 0.2 or 0.0
end

function graveyard_drop:SpawnExplorable(x, y)
	local bugs_faction = GetBugsFaction()
	local gastarid1 = Map.CreateEntity(bugs_faction, "f_gastarid1")

	local randx = math.random(x-1, x+1)
	local randy = math.random(y-1, y+1)
	if randx == 0 and randy == 0 then
		-- spawn around the dropped items area
		randx = x-1
	end

	gastarid1:Place(randx, randy)

	-- Random buddy spawn
	local buddy_id

	randx = math.random(x-1, x+1)
	randy = math.random(y-1, y+1)
	if randx == 0 and randy == 0 then
		randx = x+1
	end

	local rand = math.random(4)

	if rand == 1 then
		buddy_id = "f_trilobyte1"
	elseif rand == 2 then
		buddy_id = "f_gastarias1"
	elseif rand == 3 then
		buddy_id = "f_scaramar1"
	else
		buddy_id = "f_scaramar2"
	end

	local buddy = Map.CreateEntity(bugs_faction, buddy_id)

	-- It's fine if spawn place is same as gastarid1, as it will auto position for us
	buddy:Place(randx, randy)

	-- tether bugs so they dont chase you across the map
	local newhome = Map.CreateEntity(bugs_faction, "f_bug_home", true)
	newhome:Place(randx, randy)
	gastarid1:SetRegisterEntity(FRAMEREG_GOTO, newhome)
	buddy:SetRegisterEntity(FRAMEREG_GOTO, newhome)

	-- item spawn location
	local location = { x, y }

	----- Internal drops
	-- Always give a capacitor
	Map.DropItemAt(location, "c_capacitor", 1, "f_dropped_resource")

	rand = math.random(4)

	local rewards = { "c_repairkit", "c_portable_radar", "c_capacitor" }
	Map.DropItemAt(location, rewards[math.random(1, #rewards)], 1, "f_dropped_resource")

	----------------------------------------------------
	----- Component drops (assuming this was maybe a twin bot so 2 components can drop)
	local s_comp = { "c_small_relay", "c_solar_cell", "c_small_battery", "c_portable_turret", "c_miner", "c_adv_miner", "c_adv_portable_turret"}
	local m_comp = { "c_laser_turret", "c_solar_panel", "c_turret", "c_power_relay", "c_power_transmitter", "c_wind_turbine" }

	local bot_type = math.random(4)
	if bot_type <=3 then
		Map.DropItemAt(location, s_comp[math.random(1, #s_comp)], 1, "f_dropped_resource") -- 1S
		if bot_type == 3 then
			Map.DropItemAt(location, s_comp[math.random(1, #s_comp)], 1, "f_dropped_resource") -- 2S
		end
	else
		Map.DropItemAt(location, m_comp[math.random(1, #m_comp)], 1, "f_dropped_resource") -- 1M
	end

	-- mimic that a fight took place
	gastarid1.health = gastarid1.max_health // 6
	buddy.health = buddy.max_health // 2
	----------------------------------------------------
	----- Inventory drops (assuming this was a stray miner bot or carrier bot for silica since it died on plateau)

	Map.DropItemAt(location, "silica", math.random(15, 40), "f_dropped_resource")

--	print ("graveyard placed at = " .. x .. " , " .. y)
end

data.explorables.graveyard_drop = graveyard_drop
