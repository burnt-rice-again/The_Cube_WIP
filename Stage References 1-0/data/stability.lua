data.stability = {
	kill_enemy                = { amount =     1, limit =  3000, desc = "Enemy terminated" },
	blight_extract            = { amount =    -1, limit =  3000, desc = "Blight resource extracted" },
	hack_unit                 = { amount =   -50, limit =  9000, desc = "Hack engaged" },
	infect_explorable         = { amount =  -100, limit =  3000, desc = "Explorable infected" },
	spawn_bug_wave            = { amount =  -100, limit =  3000, desc = "Spawn bug wave" },
	duplicate_resource        = { amount =  -200, limit =  6000, desc = "Duplicate resource" },
	destabilize               = { amount =  -500, limit =  6000, desc = "Destabilize object" },
	research_virus            = { amount =  -500, limit =  9000, desc = "Virus research advancement" },
	research_blight           = { amount =   500, limit =  9000, desc = "Blight research advancement" },
	solve_alien_explorable    = { amount =  1000, limit = 10000, desc = "Alien explorable solved" },
	infect_alien_explorable   = { amount = -1000, limit = 10000, desc = "Alien explorable infected" },
	kill_boss                 = { amount =  3000, limit =  9000, desc = "Elevated bug terminated" },
	core_blight               = { amount =  3000, limit =  6000, desc = "Blight core integrated" },
	core_virus                = { amount = -3000, limit =  6000, desc = "Virus core integrated" },
}

data.stability_info = {
	{ min_range = -10000, max_range = -10000, desc = "<bl>Critical instability</>\nSimulation collapse imminent" },
	{ min_range =  -9999, max_range =  -6001, desc = "<bl>Severe instability</>\nWidespread bug activity" },
	{ min_range =  -6000, max_range =  -3001, desc = "<bl>Moderate instability</>\nElevated bug presence" },
	{ min_range =  -3000, max_range =   -101, desc = "<bl>Minor instability</>\nIncreased anomaly count" },
	{ min_range =   -100, max_range =    100, desc = "<bl>System stability</>\nWithin normal operating range" },
	{ min_range =    101, max_range =   3000, desc = "<bl>Initial stability</>\nMinor blight processes detected" },
	{ min_range =   3001, max_range =   6000, desc = "<bl>Moderate stability</>\nBlight activity intensifying" },
	{ min_range =   6001, max_range =   9999, desc = "<bl>Strong Stability</>\nPersistent blight clusters active" },
	{ min_range =   9999, max_range =  10000, desc = "<bl>Simulation threshold</>\nGateway channels now accessible" },
}
function StabilityGet(_is_modify)
	local save = Map.GetSave()
	local stability = save.stability
	if stability then return stability end

	-- convert old table
	local old_stability_data = save.stability_data
	if not old_stability_data then return 0 end
	local sum = 0
	for k,v in pairs(old_stability_data) do sum = sum + v end
	sum = old_stability_data.total or math.max(-9000, math.min(9000, sum))
	if _is_modify then save.stability, save.stability_data = sum, nil end
	return sum
end

local function stability_modify(faction, event_name, add)
	local _save = Map.GetSave()
	local unlocked_ending = _save.stability_locked == true
	if unlocked_ending and not faction:IsUnlocked("t_simulator_robots") then return end -- dont modify if the simulation is in a locked state
	local def = data.stability[event_name]
	if not def then print("Invalid stability event:", event_name) return end
	local watermark = _save.stability_watermark or 0
	local oval = StabilityGet(true)
	local nval = oval + (def.amount * (add and 1 or -1))
	local limit = math.max(def.limit, watermark)

	FactionCount("stability_" .. event_name, true, faction)

	if nval > oval then
		if oval >= limit then return end -- was already above positive limit
		if nval > limit then nval = limit end
	else
		if oval <= -limit then return end -- was already below negative limit
		if nval < -limit then nval = -limit end
	end

	_save.stability = nval
	_save.stability_watermark = math.max(math.abs(nval), watermark)
	UI.Run("OnStabilityChanged")

	local stability_events = _save.stability_events or {}
	stability_events[event_name] = (stability_events[event_name] or 0) + 1
	if not _save.stability_events then _save.stability_events = stability_events end
	--print(stability_events, nval)
end

function StabilityAdd(faction, event_name)
	stability_modify(faction, event_name, true)
end

function StabilitySub(faction, event_name)
	stability_modify(faction, event_name, false)
end
