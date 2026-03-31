local ruined_component = {
	name = "Ruined Component",
}
function ruined_component:GetRelevancy(x, y, info)
	return (info.blightness_delta < 0 and info.elevation > -0.3 and info.elevation < 0.1 and 0.3) or 0.0
end

local ruined_comp_vis<const> = {
	"v_battery_01_l_ruined",
	"v_missile_launcher_m_ruined",
	"v_transporter_01_m_ruined",

	"v_2x2_a_ruined",
	"v_simulator_ruined",

	"v_crashedship_2x1_moss",
	"v_crashedship_2x1_desert",
}

local ruined_comp_fix<const> = {
	"metalbar",
	"metalplate",

	"circuit_board",
	"circuit_board",
	"circuit_board",

	"reinforced_plate",
	"hdframe"
}

local ruined_comp_reward<const> = {
	"circuit_board",
	"circuit_board",
	"circuit_board",

	"robot_datacube",
	"robot_datacube",

	"robot_datacube",
	"robot_datacube",
}

local ruined_component_rewards<const> = {
	"c_repairer_small_aoe", "c_advanced_assembler", "c_modulespeed", "c_modulehealth", "c_modulevisibility","c_shield_generator", "c_solar_panel",
	"c_battery", "c_photon_cannon", "c_power_transmitter",
}

local function dospawn_internal(x, y, rndnum)
	local visual = ruined_comp_vis[rndnum]
	if rndnum < 4 then
		for _x=x-1, x+1 do
			for _y=y+1, y+1 do
				if math.random(10) > 9 then
					Map.CreateEntity("world", "f_human_foundation_basic"):Place(_x, _y, math.random(4)-1)
				end
			end
		end
	end
	local ruin_comp = Map.CreateEntity("world", "f_explorable", visual, true)
	--if rndnum < 4 then
	--	ruin_comp:AddComponent("c_disappear_empty", "hidden")
	--end
	local rewards = {}
	ruin_comp.extra_data.rewards = rewards
	ruin_comp:Place(x, y, math.random(4)-1)
	Explorable_AddRobotPuzzles(ruin_comp)
	ruin_comp.extra_data.hack_code = math.random(1000, 9999)

	local fixitem = ruined_comp_fix[rndnum]
	if fixitem then
		local fix = ruin_comp:AddComponent("c_explorable_fix", "hidden")
		fix.extra_data.explorable_fix = fixitem
		ruin_comp:SetRegister(FRAMEREG_SIGNAL, { id = fixitem, num = 1 })
	end

	if (visual == "v_simulator_ruined" or visual == "v_2x2_a_ruined") and ruin_comp:FindComponent("c_explorable_netwalk") then
		local chance = math.random()
		if visual == "v_simulator_ruined" and chance < 0.7 then
			ruin_comp.extra_data.difficulty = 8
			local frame_loot = { "f_transport_bot", "f_bot_1s_as", "f_bot_1s_as", "f_bot_1s_adw" }
			ruin_comp.extra_data.reward_frame = frame_loot[math.random(#frame_loot)]
		elseif chance < 0.9 then
			ruin_comp.extra_data.difficulty = 7
			local frame_loot = { "f_bot_1m_a", "f_bot_2s", "f_bot_1s_a", "f_bot_1s_b" }
			ruin_comp.extra_data.reward_frame = frame_loot[math.random(#frame_loot)]
		else
			ruin_comp.extra_data.difficulty = 5
			rewards["c_deployer"] = 1
		end

		-- add foundations
		for _x=x-1, x+2 do
			for _y=y-1, y+2 do
				if math.random(10) > 4 then
					Map.CreateEntity("world", "f_human_foundation_basic"):Place(_x, _y, math.random(4)-1)
				end
			end
		end
	end

	rewards[ruined_comp_reward[rndnum]] = math.random(1, 5) -- always scrap a circuit board
	if rndnum < 4 then
		rewards[ruined_component_rewards[math.random(#ruined_component_rewards)]] = 1
	end
end

function ruined_component:SpawnExplorable(x, y)
	local spawned_index = {}
	local num_explore = math.random(1,2)

	for i=1,num_explore do
		local max = #ruined_comp_vis
		local rndnum = math.random(max)

		local already_spawned = false
		for _,v in ipairs(spawned_index) do
			if v == rndnum then
				already_spawned = true
				break
			end
		end

		if already_spawned then
			i=i-1
		else
			spawned_index[#spawned_index + 1] = rndnum
			dospawn_internal(x+math.random(-3, 3), y+math.random(-3, 3), rndnum)
		end
	end
end

data.explorables.ruined_component = ruined_component
