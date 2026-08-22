local spawn_base_alien = {
	name = "Spawn Base Alien",
	player_only = true,
	singular = true,
	race = "robot",
}
data.explorables.spawn_base_alien = spawn_base_alien

function spawn_base_alien:GetRelevancy(x, y, info)
	if not info.player_faction or not info.player_faction:IsUnlocked("t_anomaly_technology") then return 0.0 end

	-- don't spawn if it exists
	local save_spawn_base_alien = info.save.spawn_base_alien
	if save_spawn_base_alien and save_spawn_base_alien:ExistsOnFaction("alien") then return 0.0 end

	-- check placement
	if info.blightness_delta < 0.1 then return 0.0 end

	return 5.0
end

function spawn_base_alien:SpawnExplorable(x, y)
	local faction = GetAlienFaction()
	faction:Unlock("t_alien_faction_npc")
	local entity
	if math.random(2) == 1 then
		entity = self:Spawn_Base(faction, x, y)
	else
		entity = self:Spawn_Base2(faction, x, y)
	end
	Map.GetSave().spawn_base_alien = entity

	local autobase = entity:AddComponent("c_autobase")
	UploadBehavior(autobase, Tool.StringToTable("1Jg1Y0A1I0tiinj21iMYG1Bu7HE1r4BxQ0I3MrV0aOHw23WYvky28Oso42DWJia1CdEyK3nY3Qj0pJtyZ1emFHR1urtp30H0Bvj4K7EdC2gh4xN3dSLTg27a4WN4bwSER0ZTsqN4Lar3S2Fd98t33ns6V3k7exx44cJVV04gwDK3mAGyb2vjoGJ2dVvbF2umBtm0uawuq3Ic61B28xdVr0fOknA46sFpR4VdlhT1UeSHB1Pc21T2KfXys4FeIox10BfV60mgnx93s9aff4K5SER2gKUqu19UVKH2Ynjhv2pdibC35LZ9f0ErYK21SGmjN4CE4kf2aMuEs1kYZUq1YKDFf2R4UyN0N8nDw1eW2Lj22ithA2KQG8o0TrYr50Dx0P42KZdKG2rrCwg1RhHpO3O5ONP35N3gx1bvlVc32V6iX3sqsxj4XIf732hH1we0juv0R2tn7xb44cADG4FHcYt1UUJKc28DqGR2tDXlt22yqVQ02WtbM0ToP9b2Pzlpx3vrhdl1pqtCG2eeE291ht2v63mKZUq2YLLWu2X2OMw1mCvUI0z7QZV2s0F2R02AdPo1QLgWu13naWz071nwP39voQi1FNpob47xTVR1GEoT230HSVn0A9qgn3YFT0u23Ma9U07UFLQ1MDsGH1bj3nz1tP07634jr8P0Zzl3Q02EakI05RdOS0jw7I70LAQ320S3fzr3MbB8o2iUXn021JRsG4BNiHW3IHA4w1pJYzZ1qkfYZ3V8nN73IqGUG3f4exc4IdNta1bUgsH332Aep08reF12mQBmr1LfdkN1fy5UX3LUzFN11frsl0HJaMP2Edj0b2pMRjR3bWEFp3WaFQG1d9Mym2KYh5e3hZcdF1stH4N1hn49v2BdU5F4Y7VK70kVK963diVG40Tm7iR0TUVHr3Nbc6U2hHPwR2Dnt2x02xEtI0uMhjn2luc2c38U7Fc1RgKpn320T4g253Z5E4Gg25Z1CVSLN3Y53IR451Z7y26Vs7502asoW3WcbyU3wlYLy3WJFSh4VCPvO3Zo7lk14ekRQ3OOvuV00YvJu1IusAqw"))
end

local function RotateAndPlace(e, x, ofx, y, ofy, rotation, quarter_turns)
	local q = (quarter_turns % 4)
	x = x + ((q == 0 and ofx) or (q == 1 and  ofy) or (q == 2 and -ofx) or -ofy)
	y = y + ((q == 0 and ofy) or (q == 1 and -ofx) or (q == 2 and -ofy) or  ofx)
	rotation = (rotation + q) % 4
	if IsBuilding(e) then CreateFoundationsForEntity(e, x, y, rotation) end
	e:Place(x, y, rotation)
end

function spawn_base_alien:Spawn_Base(f, x, y)
	local random_rot = math.random(0, 3)
	local e, slots
	local all_entities = { }
	--
	e = Map.CreateEntity(f, 'f_alien_smallframe')
	e:AddComponent('c_particle_ripper')
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, -9, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_smallframe')
	e:AddComponent('c_particle_ripper')
	e.disconnected = false
	RotateAndPlace(e, x, -1, y, -8, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_smallframe')
	e:AddComponent('c_particle_ripper')
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, -8, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_smallframe')
	e:AddComponent('c_particle_ripper')
	e.disconnected = false
	RotateAndPlace(e, x, 1, y, -8, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_worker')
	RotateAndPlace(e, x, 4, y, -8, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_smallframe')
	e:AddComponent('c_particle_ripper')
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, -7, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_producer')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 3, y, -7, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pylon')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 7, y, -7, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -4, y, -6, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -1, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 1, y, -6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_monolith')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 12, y, -6, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -8, y, -5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -6, y, -5, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_producer')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 6, y, -5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_monolith')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -11, y, -4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_worker')
	RotateAndPlace(e, x, -9, y, -4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_powergenerator')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -7, y, -4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_feeder')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 20)
	slots[2]:SetItemAndStack('blight_plasma', 20)
	slots[3]:SetItemAndStack('blight_plasma', 20)
	slots[4]:SetItemAndStack('blight_plasma', 20)
	RotateAndPlace(e, x, -4, y, -4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 10, y, -4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 11, y, -3, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 15, y, -3, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_extractor')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -7, y, -2, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -1, y, -2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_worker')
	RotateAndPlace(e, x, 1, y, -2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	e.disconnected = false
	RotateAndPlace(e, x, 10, y, -2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_worker')
	RotateAndPlace(e, x, -11, y, -1, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_heart_shard')
	e:AddComponent('c_signpost')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -1, y, -1, 0, random_rot)
	local base_home = e
	--
	e = Map.CreateEntity(f, 'f_alien_scout_probe')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 3, y, -1, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	slots[3]:SetItemAndStack('blight_crystal', 20)
	slots[4]:SetItemAndStack('blight_crystal', 20)
	slots[5]:SetItemAndStack('blight_crystal', 20)
	slots[6]:SetItemAndStack('anomaly_particle', 20)
	RotateAndPlace(e, x, 13, y, -1, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_extractor')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -6, y, 0, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	slots[2]:SetItemAndStack('obsidian', 20)
	slots[3]:SetItemAndStack('obsidian', 20)
	slots[4]:SetItemAndStack('obsidian', 20)
	slots[5]:SetItemAndStack('obsidian', 20)
	RotateAndPlace(e, x, -3, y, 0, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 2, y, 0, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 3, y, 0, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_worker')
	RotateAndPlace(e, x, 4, y, 0, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 7, y, 0, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_worker')
	RotateAndPlace(e, x, 9, y, 0, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 2, y, 1, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 4, y, 1, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_scout_probe')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 6, y, 1, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 8, y, 1, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -2, y, 2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_reformingpool')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 5, y, 2, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pylon')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -7, y, 3, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, -1, y, 3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pylon')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 9, y, 3, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, -1, y, 4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	slots[2]:SetItemAndStack('obsidian', 20)
	slots[3]:SetItemAndStack('obsidian', 20)
	slots[4]:SetItemAndStack('obsidian', 20)
	slots[5]:SetItemAndStack('obsidian', 20)
	RotateAndPlace(e, x, 0, y, 4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_researcher')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 1, y, 4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 4, y, 4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_powergenerator')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 6, y, 5, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 7, y, 5, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -3, y, 6, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 7, y, 6, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -7, y, 7, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -5, y, 8, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_monolith')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, 3, y, 9, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_scout_probe')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 1)
	RotateAndPlace(e, x, -12, y, 12, 1, random_rot)
	--
	e = all_entities[1] -- f_alien_heart_shard (x, -1, y, -1)
	e:SetRegister(3, { id = 'c_signpost', num = 0 })
	return base_home
end

function spawn_base_alien:Spawn_Base2(f, x, y)
	local random_rot = math.random(0, 3)
	local e, slots
	local all_entities = { }
	--
	e = Map.CreateEntity(f, 'f_alien_scout_probe')
	e.disconnected = false
	RotateAndPlace(e, x, -8, y, -12, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pylon')
	RotateAndPlace(e, x, -5, y, -9, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	RotateAndPlace(e, x, 3, y, -9, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_monolith')
	RotateAndPlace(e, x, -2, y, -7, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 0, y, -7, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pincer')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, -6, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, -5, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 3, y, -5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, -4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_extractor')
	RotateAndPlace(e, x, -1, y, -4, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 2, y, -4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 6, y, -4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, -3, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pincer')
	e.disconnected = false
	RotateAndPlace(e, x, 8, y, -3, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	RotateAndPlace(e, x, 9, y, -3, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_researcher')
	RotateAndPlace(e, x, 3, y, -2, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	RotateAndPlace(e, x, -9, y, -1, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_heart_shard')
	e:AddComponent('c_signpost')
	table.insert(all_entities, e)
	RotateAndPlace(e, x, -1, y, -1, 0, random_rot)
	local base_home = e
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	e.disconnected = false
	RotateAndPlace(e, x, 5, y, -1, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, -5, y, 0, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, 0, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_feeder')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 20)
	slots[2]:SetItemAndStack('blight_plasma', 20)
	slots[3]:SetItemAndStack('blight_plasma', 20)
	slots[4]:SetItemAndStack('blight_plasma', 20)
	RotateAndPlace(e, x, 2, y, 0, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 6)
	e.disconnected = false
	RotateAndPlace(e, x, 7, y, 0, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('obsidian', 20)
	slots[2]:SetItemAndStack('obsidian', 20)
	slots[3]:SetItemAndStack('obsidian', 12)
	slots[4]:SetItemAndStack('blight_crystal', 20)
	slots[5]:SetItemAndStack('blight_crystal', 20)
	slots[6]:SetItemAndStack('anomaly_particle', 9)
	RotateAndPlace(e, x, -4, y, 1, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_turret')
	RotateAndPlace(e, x, -2, y, 1, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_producer')
	RotateAndPlace(e, x, -8, y, 2, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 20)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	slots[3]:SetItemAndStack('blight_crystal', 20)
	slots[4]:SetItemAndStack('blight_crystal', 20)
	slots[5]:SetItemAndStack('blight_crystal', 20)
	slots[6]:SetItemAndStack('anomaly_particle', 20)
	RotateAndPlace(e, x, -3, y, 2, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	slots = e.slots
	slots[3]:SetItemAndStack('anomaly_particle', 20)
	e.disconnected = false
	RotateAndPlace(e, x, -4, y, 3, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 4, y, 3, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	e.disconnected = false
	RotateAndPlace(e, x, 6, y, 3, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, 4, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_monolith')
	RotateAndPlace(e, x, -1, y, 4, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 5, y, 4, 2, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pylon')
	slots = e.slots
	slots[5]:SetItemAndStack('anomaly_particle', 2)
	RotateAndPlace(e, x, -8, y, 5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	e.disconnected = false
	RotateAndPlace(e, x, -3, y, 5, 3, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_hvy_soldier')
	e.disconnected = false
	RotateAndPlace(e, x, 1, y, 5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_reformingpool')
	RotateAndPlace(e, x, 3, y, 5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_tankframe')
	e:AddComponent('c_alien_ion_lance')
	e.disconnected = false
	RotateAndPlace(e, x, 7, y, 5, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pylon')
	RotateAndPlace(e, x, 10, y, 5, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_pincer')
	e.disconnected = false
	RotateAndPlace(e, x, -2, y, 6, 1, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_scout_probe')
	e.disconnected = false
	RotateAndPlace(e, x, -2, y, 12, 0, random_rot)
	--
	e = Map.CreateEntity(f, 'f_alien_scout_probe')
	e.disconnected = false
	RotateAndPlace(e, x, 10, y, 14, 0, random_rot)
	--
	e = all_entities[1] -- f_alien_heart_shard (x, -1, y, -1)
	e:SetRegister(3, { id = 'c_signpost', num = 0 })
	return base_home
end
