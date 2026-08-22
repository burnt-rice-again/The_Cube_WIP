local spawn_base_human = {
	name = "Spawn Base Human",
	player_only = true,
	singular = true,
	race = "robot",
}
data.explorables.spawn_base_human = spawn_base_human

function spawn_base_human:GetRelevancy(x, y, info)
	-- dont spawn if you havent unlocked humanity tree
	if not info.player_faction or not info.player_faction:IsUnlocked("t_human_industry1") then return 0.0 end

	-- don't spawn if it exists
	local save_spawn_base_human = info.save.spawn_base_human
	if save_spawn_base_human and save_spawn_base_human:ExistsOnFaction("human") then return 0.0 end

	-- check placement
	if info.elevation > 0.01 or info.blightness_delta > -0.025 then return 0.0 end

	return 5.0
end

function spawn_base_human:SpawnExplorable(x, y)
	local faction = GetHumanFaction()
	faction:Unlock("t_human_faction_npc")
	local entity
	if math.random(2) == 1 then
		entity = self:Spawn_Base(faction, x, y)
	else
		entity = self:Spawn_Base2(faction, x, y)
	end
	Map.GetSave().spawn_base_human = entity

	local autobase = entity:AddComponent("c_autobase")
	UploadBehavior(autobase, Tool.StringToTable("1Gu1Y2MPY0tTYyp09QBfw37SONl3HuPCQ4fRFUm1XO2tt04THCc0c90Qo3e6WNZ3pfaCP4c2Enp3AR4ZL3uAwoo3xIdYl4GTi8y29shvL1uA2060NJmUg27a4WR3qOMt53anV8s1xwa6I43YMQV0foH192wyILt0veeWe305pXq0re1i22p47Pn2zjJF54LX4qC17aFYT1i5NBg1xyHOe4Mv3ye4KDKQr2gfIee2Lf1fe1WN9z3245ckI00W3h93O8MdG4UH9sR3Xiwc92lm2Eb2vDanY3Y8JRM04toE31UHRNJ3037g30hEdn04TW5n13YSM0z3fbHkK3hh4vy0dpaEN2I8GTq36cHzu1WxQNL2FxiGz0hpmTN0RmDyu0BkNUX0eWI5Y0PWmYl1SAxvY0TF5iF1QhUCF2LWKnE1WUTdj2j5Q6z1bEGaF4LtqP20JTeun121jwz2Hr69T2m04vW426QuU2dOLua4QKSUf0CQr0v1f5C192cc5HK3Z0rDe20bXSy0OHs7v0wSDoq1s4V1s3sZymp4680qS2aZKdF1KoNW73nnuW21pvzTO2LXz2p1YiwBE1XSkrC3xMEY32pf3ba3AmrRF3NDOm115203I2kBvLu0Wy4gc13RcWg1F6O9s1pHcIS44rfjR2ONiYf4IyfpO3EczZI013P3d09d8kV0WxjwL4YQkZI1TlgO00FyYlt2pE2ZN2K5PmS2kmeSy38Y7qv0gP1AV0Tkt3f4ML2Tn0JtjUK0X6y1g4bzxNM0wOkk34gRhbm44kH9Y41iDFJ44NGaO05wsGI187ahE0fTjyt1fQ9QK3T5EY20hIf7q4NLHFC3QbKOe3FwPGL4PZk8a0lRySL3gKiDX2aI4Ww2ShlBb1pSbh61aYZ4532pIjO1xebip4Ompsl4IEBRy4OqoYa2lCrfs2lgAYj2jjTOh0Fceqr0QXxN21N1Mj93akh582d3wnR2xmuTm1OeaDL0wFJVV4SUqd33HkGFq0qnN1R0Db3dw3cydtSr"))
end

local function RotateAndPlace(e, x, ofx, y, ofy, rotation, quarter_turns)
	local q = (quarter_turns % 4)
	x = x + ((q == 0 and ofx) or (q == 1 and  ofy) or (q == 2 and -ofx) or -ofy)
	y = y + ((q == 0 and ofy) or (q == 1 and -ofx) or (q == 2 and -ofy) or  ofx)
	rotation = (rotation + q) % 4
	if IsBuilding(e) then CreateFoundationsForEntity(e, x, y, rotation) end
	e:Place(x, y, rotation)
end

function spawn_base_human:Spawn_Base(f, x, y)
	local random_rot = math.random(0, 3)
	local e, slots
	local all_entities = { }
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -12, y, -4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, -13, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 1, y, -12, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, -12, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	RotateAndPlace(e, x, -2, y, -11, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, 0, y, -11, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[2]:SetItemAndStack('metalore', 20)
	slots[3]:SetItemAndStack('metalore', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -3, y, -10, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	RotateAndPlace(e, x, 6, y, -10, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 8, y, -10, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -8, y, -9, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -6, y, -9, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_barracks')
	RotateAndPlace(e, x, 2, y, -8, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 7, y, -8, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 10, y, -8, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 2)
	e.disconnected = false
	RotateAndPlace(e, x, -8, y, -7, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -1, y, -7, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_vehiclefactory')
	RotateAndPlace(e, x, -5, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -2, y, -6, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_barracks')
	RotateAndPlace(e, x, 1, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 11, y, -6, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -9, y, -5, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	e.disconnected = false
	RotateAndPlace(e, x, -7, y, -5, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 6, y, -5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -10, y, -4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_warehouse')
	RotateAndPlace(e, x, -8, y, -4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -4, y, -4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, 5, y, -4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_warehouse')
	RotateAndPlace(e, x, 8, y, -4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 11, y, -4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[2]:SetItemAndStack('metalore', 20)
	slots[3]:SetItemAndStack('metalore', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 13, y, -4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -5, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 3, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 5, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, 13, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -5, y, -2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, -2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, -2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_commandcenter')
	e:AddComponent('c_signpost')
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -2, y, -2, 2, random_rot)
	local base_home = e
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 3, y, -2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, -2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 5, y, -2, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 11, y, -2, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -10, y, -1, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -4, y, -1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 11, y, -1, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 5, y, 0, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, 6, y, 0, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	RotateAndPlace(e, x, 8, y, 0, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, 1, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -9, y, 2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -7, y, 2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_sciencelab')
	RotateAndPlace(e, x, -5, y, 2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_refinery')
	RotateAndPlace(e, x, 6, y, 2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 9, y, 2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	RotateAndPlace(e, x, -6, y, 3, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[2]:SetItemAndStack('metalore', 20)
	slots[3]:SetItemAndStack('metalore', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -3, y, 3, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, 2, y, 3, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_refinery')
	RotateAndPlace(e, x, 4, y, 3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -8, y, 4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 7, y, 4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 2, y, 5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, 6, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 4, y, 6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, 0, y, 7, 2, random_rot)
	--
	e = all_entities[1] -- f_human_adv_miner (x, -3, y, -10)
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[2] -- f_human_adv_miner (x, 6, y, -5)
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[3] -- f_human_adv_miner (x, 13, y, -4)
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[4] -- f_human_commandcenter (x, -2, y, -2)
	e:SetRegister(3, { id = 'c_signpost', num = 0 })
	e:SetRegister(5, { id = 'v_power_production', num = 1000 })
	--
	e = all_entities[5] -- f_human_adv_miner (x, -3, y, 3)
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	return base_home
end

function spawn_base_human:Spawn_Base2(f, x, y)
	local random_rot = math.random(0, 3)
	local e, slots
	local all_entities = { }
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 2)
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, -10, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 1, y, -10, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 3, y, -10, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -3, y, -9, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -1, y, -9, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 4, y, -9, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, -8, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 3, y, -8, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, -7, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 8, y, -7, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -8, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_warehouse')
	RotateAndPlace(e, x, -6, y, -6, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -1, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 1, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 2, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 3, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 8, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_vehiclefactory')
	RotateAndPlace(e, x, -3, y, -5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -1, y, -5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 5, y, -5, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, 0, y, -4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_barracks')
	RotateAndPlace(e, x, 2, y, -4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, 5, y, -4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 6, y, -4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, 8, y, -3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_commandcenter')
	e:AddComponent('c_signpost')
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -2, y, -2, 2, random_rot)
	local base_home = e
	--
	e = Map.CreateEntity(f, 'f_human_warehouse')
	RotateAndPlace(e, x, 5, y, -2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, -8, y, -1, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -5, y, -1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, 4, y, -1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_transport')
	slots = e.slots
	slots[1]:SetItemAndStack('smallreactor', 7)
	slots[2]:SetItemAndStack('ceramictiles', 20)
	slots[3]:SetItemAndStack('ceramictiles', 20)
	slots[4]:SetItemAndStack('ceramictiles', 20)
	slots[5]:SetItemAndStack('ceramictiles', 20)
	slots[6]:SetItemAndStack('ceramictiles', 20)
	slots[7]:SetItemAndStack('polymer', 20)
	slots[8]:SetItemAndStack('polymer', 15)
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, 0, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	slots = e.slots
	slots[1]:SetItemAndStack('ceramictiles', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -5, y, 1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -4, y, 1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_large_tankframe')
	e:AddComponent('c_human_missilelauncher')
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 3, y, 1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 7, y, 1, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -6, y, 2, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_sciencelab')
	RotateAndPlace(e, x, -3, y, 2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -5, y, 3, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, 3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[2]:SetItemAndStack('metalore', 20)
	slots[3]:SetItemAndStack('metalore', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, 5, y, 3, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_carrier')
	RotateAndPlace(e, x, -3, y, 4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tank')
	e:AddComponent('c_human_tank_turret')
	e.disconnected = false
	RotateAndPlace(e, x, -2, y, 4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_refinery')
	RotateAndPlace(e, x, 0, y, 4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -7, y, 5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, 5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_refinery')
	RotateAndPlace(e, x, 2, y, 5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, -5, y, 6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_infantrymech')
	e.disconnected = false
	RotateAndPlace(e, x, -2, y, 7, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_tankframe')
	e:AddComponent('c_human_tank_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('ceramictiles', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -1, y, 7, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_human_bunker')
	RotateAndPlace(e, x, 2, y, 8, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_heavy_bunker')
	RotateAndPlace(e, x, -2, y, 9, 2, random_rot)
	--
	e = all_entities[1] -- f_human_large_tankframe (x, 1, y, -10)
	e:SetRegister(2, { entity = Map.GetEntityAt(x + -3, y + 0) })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	--
	e = all_entities[2] -- f_human_adv_miner (x, 5, y, -5)
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[3] -- f_human_large_tankframe (x, 6, y, -4)
	e:SetRegister(2, { entity = Map.GetEntityAt(x + -3, y + 0) })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	--
	e = all_entities[4] -- f_human_commandcenter (x, -2, y, -2)
	e:SetRegister(3, { id = 'c_signpost', num = 0 })
	e:SetRegister(5, { id = 'v_power_production', num = 1000 })
	--
	e = all_entities[5] -- f_human_large_tankframe (x, -5, y, 1)
	e:SetRegister(2, { entity = Map.GetEntityAt(x + -3, y + 0) })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	--
	e = all_entities[6] -- f_human_large_tankframe (x, 3, y, 1)
	e:SetRegister(2, { entity = Map.GetEntityAt(x + -3, y + 0) })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	--
	e = all_entities[7] -- f_human_adv_miner (x, -5, y, 3)
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[8] -- f_human_adv_miner (x, 5, y, 3)
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[9] -- f_human_tankframe (x, -1, y, 7)
	e:SetRegister(2, { entity = Map.GetEntityAt(x + -3, y + 0) })
	e:SetRegister(5, { id = 'v_power_production', num = 100 })
	--
	return base_home
end
