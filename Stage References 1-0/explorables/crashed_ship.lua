local crashed_ship = {
	name = "Crashed Ship",
}

function crashed_ship:GetRelevancy(x, y, info)
	return info.blightness_delta < 0 and info.elevation_delta < 0 and 0.02 or 0.0
end

function crashed_ship:SpawnExplorable(x, y)
	local visual = (Map.GetElevation(x, y) > -0.2 and "v_crashedship_2x2_moss" or "v_crashedship_2x2_desert")
	local crash_ship = Map.CreateEntity("world", "f_explorable", visual, true)
	crash_ship.extra_data.rewards = {}
	crash_ship.extra_data.difficulty = 3
	crash_ship.extra_data.hack_code = math.random(1000, 9999)
	local rewards = crash_ship.extra_data.rewards

	Explorable_AddRobotPuzzles(crash_ship)

	local fix = crash_ship:AddComponent("c_explorable_fix", "hidden")

	if math.random() < 0.5 then
		fix.extra_data.explorable_fix = "robot_datacube"
		crash_ship:SetRegister(FRAMEREG_SIGNAL, { id = "robot_datacube", num = 1 })
		crash_ship.extra_data.difficulty = 8
		local frame_loot = { "f_transport_bot", "f_bot_1s_as", "f_bot_1s_as", "f_bot_1s_adw", "f_bot_2m_as" }
		crash_ship.extra_data.reward_frame = frame_loot[math.random(#frame_loot)]
		if math.random() < 0.3 then
			rewards["c_resimulator_core"] = 1
		end
		-- mothership datakey
		local fix2 = crash_ship:AddComponent("c_explorable_fix_lvl2", "hidden")
		fix2.extra_data.explorable_fix = "datakey"
		rewards[GenerateRobotRewardComp(4)] = 1
	else
		fix.extra_data.explorable_fix = "circuit_board"
		crash_ship:SetRegister(FRAMEREG_SIGNAL, { id = "circuit_board", num = 1 })
		crash_ship.extra_data.difficulty = 5
	end


	rewards["datacube_matrix"] = math.random(1, 3)
	crash_ship:Place(x, y, math.random(4)-1)
end

data.explorables.crashed_ship = crashed_ship
