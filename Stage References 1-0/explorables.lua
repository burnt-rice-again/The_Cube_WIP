local RANDOMSEED_DECIDE<const>  = 1000
local RANDOMSEED_SPAWN<const>   = 1001
local RANDOMSEED_SOLVE<const>   = 1002
local RANDOMSEED_REWARDS<const> = 1003

local no_explorable = {
	GetRelevancy = function(self, x, y, info) return 0.6 end,
}

data.explorables = { no_explorable = no_explorable }
local unique_spawns = {}

function Explorable_SpawnAt(x, y, discoverer, filter)
	-- select relevant explorable
	local tile = Map.GetTileData(x, y)
	local discoverer_faction = discoverer and discoverer.faction
	local player_faction = discoverer_faction and discoverer_faction.is_player_controlled and discoverer_faction
	local player_faction_data = player_faction and player_faction.extra_data
	--print(string.format("LOC %d,%d - b: %f, e: %f, r: %f, v: %f", x, y, tile.blightness, tile.elevation, tile.richness, tile.variation))

	-- Collect information commonly used by GetRelevancy function
	local settings, blightness, elevation = Map.GetSettings(), tile.blightness, tile.elevation
	local info =
	{
		blightness = blightness, elevation = elevation,
		blightness_delta = blightness - settings.blight_threshold,
		elevation_delta = elevation - settings.plateau_level,
		peaceful = settings.peaceful or 2,
		tutorial = settings.tutorial,
		save = Map.GetSave(),
		player_faction = player_faction,
		faction_counters = player_faction and (player_faction_data.counters or {}),
		faction_level = player_faction and GetPlayerFactionLevel(player_faction),
	}

	-- get all relevancy and choose randomly
	local relevancies, total = {}, 0.0
	for k,v in pairs(data.explorables) do
		if (v == no_explorable or v.tag == filter) and (not v.player_only or player_faction) and (not v.race or v.race == (player_faction and player_faction_data.race or "robot")) then
			local rel = not unique_spawns[v.name] and v:GetRelevancy(x, y, info)
			if rel and rel > 0.0 then
				relevancies[#relevancies + 1] = rel
				relevancies[#relevancies + 1] = v
				total = total + rel
			end
		end
	end

	-- seed the random used here and in the SpawnExplorable callback so the explorable to spawn here on this map seed is always the same
	math.randomseed(x, y, RANDOMSEED_DECIDE)
	local rndnum = math.random() * total
	local selected_explorable

	-- go through until you hit rndnum
	for i=1,#relevancies,2 do
		rndnum = rndnum - relevancies[i]
		if rndnum <= 0.0 then
			selected_explorable = relevancies[i + 1]
			break
		end
	end

	-- if found none, just destroy it and end (selected_explorable can be nil if data.explorables has been cleared)
	if selected_explorable == no_explorable or not selected_explorable then return end

	if selected_explorable.SpawnDecided ~= nil then
		selected_explorable:SpawnDecided(x, y, info)
	end

	if selected_explorable.singular then
		unique_spawns[selected_explorable.name] = true
	end

	local skip_if_close = player_faction_data and player_faction_data.started == Map.GetTick() and player_faction
	Map.Defer(function()
		--print("[Explorable] ", selected_explorable.name, " at Location: " .. x .. "," .. y)
		if skip_if_close then
			-- Skip spawning if close to the home of a newly spawned faction (need to be done deferred because before the home is not yet set or placed)
			local faction_home = skip_if_close.home_entity
			if faction_home and faction_home:GetRangeSquaredTo(x, y) < 100 then return end
		end
		math.randomseed(x, y, RANDOMSEED_SPAWN)
		selected_explorable:SpawnExplorable(x, y)
		if selected_explorable.singular then
			unique_spawns[selected_explorable.name] = nil
		end
	end)
end

function Explorable_AddMinigame(explorable, game)
	game = game or data.puzzles.robot[math.random(#data.puzzles.robot)]
	explorable:AddComponent(game, "hidden")
	local comp = data.components[game]
	if comp and comp.explorable_effect then
		explorable:AddComponent(comp.explorable_effect, "hidden")
	end
end

function Explorable_AddAlienPuzzles(explorable, skip_lock)
	local puzzle = math.random(#data.puzzles.alien)
	Explorable_AddMinigame(explorable, data.puzzles.alien[puzzle])

	-- requires scanning and blight_plasma
	explorable:AddComponent("c_explorable_scannable", "hidden")
	if not skip_lock then
		explorable:AddComponent("c_alien_lock", "hidden")
	end
--	local fix = explorable:AddComponent("c_explorable_fix", "hidden")
--	fix.extra_data.explorable_fix = "blight_plasma"
end

function Explorable_AddHumanPuzzles(explorable, num)
	local lnum = num or 1

	-- always have a minigame
	local puzzle = math.random(#data.puzzles.human)
	Explorable_AddMinigame(explorable, data.puzzles.human[puzzle])

	-- requires scanning
	local scannable_comp = explorable:AddComponent("c_explorable_scannable", "hidden")
end

function Explorable_AddRobotPuzzles(explorable)
	local puzzle = math.random(#data.puzzles.robot)
	Explorable_AddMinigame(explorable, data.puzzles.robot[puzzle])
end

local function Explorable_SetSolved(entity, solved_faction)
	local entity_extra_data = entity.extra_data
	entity_extra_data.solved = true
	entity.lootable = true

	Map.Run("OnSolvedExplorable", solved_faction, entity.visual_def.explorable_name)

	-- remove effects
	for _,v in ipairs(entity.components or {}) do
		if v.def.type == "Effect" then
			v:Destroy()
		end
	end

	-- item rewards
	local rewards = entity_extra_data.rewards
	if rewards then
		-- seed the random used below so the rewards given here on this map seed are always the same
		math.randomseed(entity.location, RANDOMSEED_REWARDS)
		for k,v in SortedPairs(rewards) do
			local slot = entity:AddItem(k, v)
			if slot then
				if k == "c_deployer" then
					local deployrewards = {
						"f_bot_1s_as", -- Scout
						"f_bot_2s", -- Twinbot
						"f_bot_1m_a", -- Cub
						"f_building2x2b", -- 2x2 (3M)
						"f_building2x2f", -- 2x2 (2M) 8 storage
						"f_building1x1b", -- 1x1 (1L)
						"f_building1x1g", -- Storage block (16)
						"f_building2x1a", -- 2x1 (2M)
					}
					slot.extra_data = { bp = { frame = deployrewards[math.random(1, #deployrewards)] }, onetime = true, }
				end
			end
		end
		entity_extra_data.rewards = nil
	end

	-- frame rewards
	local reward_frame = entity_extra_data.reward_frame
	if reward_frame then
		if solved_faction then
			local slot = entity:AddItem("c_deployer", 1)
			if slot then
				slot.extra_data = { onetime = true, bp = { frame = entity_extra_data.reward_frame } }
			else
				local rewardentity = Map.CreateEntity(solved_faction, reward_frame)
				rewardentity:Place(entity.location.x, entity.location.y)
				solved_faction:RunUI(function () View.PlayEffect("fx_ping", rewardentity) end)
			end
		end
		entity_extra_data.reward_frame = nil
	end

	local explorable_race = entity.visual_def.explorable_race
	if explorable_race and solved_faction then
		FactionCount("solved_explorable_" .. explorable_race, 1, solved_faction)
	end

	-- set signal register
	local hasscannable = entity:FindComponent("c_explorable_scannable")
	entity:SetRegister(FRAMEREG_SIGNAL, { entity = entity, num = hasscannable and hasscannable.extra_data.hack_code })
end

--------------------------------------------------------------------------------------------------------------------------

function FactionAction.ExplorableSolvePuzzle(faction, arg)
	local comp, consume_slot, interactor = arg.comp, arg.consume_slot, arg.interactor
	if not comp or not comp.exists then return end
	local comp_owner, comp_extra_data, comp_def = comp.owner, comp.extra_data, comp.def
	if comp_extra_data.ok then return end
	if comp_def.type ~= "Puzzle" then print("ExplorableSolvePuzzle called for non Puzzle component: ", comp) end
	local is_alien_interactor = interactor and interactor.faction == faction and interactor.def.race == "alien"

	-- Check if an alien unit is using the special override on an alien explorable
	if is_alien_interactor and comp_owner.visual_def.explorable_race == "alien" and not comp_owner.def.immortal then
		-- Consume item, fully solve explorable then switch faction ownership
		if not consume_slot or not consume_slot.exists or consume_slot.owner.faction ~= faction then return end -- invalid slot
		if consume_slot.unreserved_stack == 0 or consume_slot.id ~= "energized_artifact" then return end -- invalid item
		consume_slot:RemoveStack(1)
		for _,v in ipairs(comp_owner.components or {}) do
			if v.def.type == "Puzzle" and v.extra_data.ok ~= true then
				FactionAction.ExplorableSolvePuzzle(faction, { comp = v })
			end
		end
		Map.Defer(function()
			if not comp_owner.exists or comp_owner.faction.is_player_controlled then return end
			data.components.c_hacking_tool:switch_faction(comp_owner, faction)
			comp_owner:SetRegister(FRAMEREG_SIGNAL, nil)
			faction:RunUI("OnEntityRecreate", interactor, comp_owner)
		end)
		return
	end

	if consume_slot then
		if not consume_slot.exists or consume_slot.owner.faction ~= faction or consume_slot.unreserved_stack == 0 then
			Action.RunUI(function() Notification.Error("Item no longer available") end)
			return
		end
		local fix_item = comp_extra_data.explorable_fix or comp_def.explorable_fix or comp_extra_data.explorable_override or comp_def.explorable_override
		if is_alien_interactor then fix_item = "crystalized_obsidian" end
		if consume_slot.id ~= fix_item then
			Action.RunUI(function() Notification.Error("Item not accepted") end)
			return
		end
		consume_slot:RemoveStack(1)
		if fix_item == "infected_circuit_board" then
			if comp_def.id == "c_explorable_balance" and comp_owner.visual_def.explorable_race == "alien" and comp_owner.def.construction_recipe then
				StabilityAdd(faction, "infect_alien_explorable")
			else
				StabilityAdd(faction, "infect_explorable")
			end
			faction:UnlockAchievement("PUZZLE_ME")
		elseif fix_item == "crystalized_obsidian" and comp_owner.visual_def.explorable_race == "human" then
			-- aliens unlocked human stuff unlocks transformers
			faction:Unlock("transformer")
		end
	elseif comp_def.id == "c_explorable_balance" and comp_owner.visual_def.explorable_race == "alien" and comp_owner.def.construction_recipe then
		StabilityAdd(faction, "solve_alien_explorable")
	end

	comp_owner.lootable = true
	comp_extra_data.ok = true

	-- check if all puzzles on this explorable have been solved
	local allsolved = true
	for _,v in ipairs(comp_owner.components or {}) do
		if v.def.type == "Puzzle" and v.extra_data.ok ~= true then
			allsolved = false
			break
		end
	end

	-- Map.Defer isn't needed in normal actions but this function can also be called via data.instructions.solve which needs the defer for spawning reward entities.
	-- And because Map.Defer doesn't actually defer the function unless needed this doesn't incur much of a performance penalty for the regular faction action use.
	if comp_def.on_solved then
		Map.Defer(function()
			if not comp.exists then return end
			-- seed the random used in the on_solved callback so the rewards given here on this map seed are always the same
			math.randomseed(comp_owner.location, RANDOMSEED_SOLVE, comp)
			comp_def.on_solved(comp, comp_owner.visual_def.explorable_race, faction)
		end)
	end
	if allsolved then
		Map.Defer(function()
			if comp_owner.exists then Explorable_SetSolved(comp_owner, faction) end
		end)
	end
end

function FactionAction.ExplorableSetSolved(faction, arg)
	local entity = arg.entity
	if not entity or not entity.exists then return end
	if entity.extra_data.solved then
		error("ExplorableSetSolved called on explorable already solved")
	end

	-- this action is only valid on an explorable without puzzles
	for _,v in ipairs(entity.components or {}) do
		if v.def.type == "Puzzle" and not v.extra_data.ok then
			error("ExplorableSetSolved called on explorable with unsolved puzzles")
		end
	end

	-- See FactionAction.ExplorableSolvePuzzle why we need to wrap this in Map.Defer
	Map.Defer(function() if entity.exists then Explorable_SetSolved(entity, faction) end end)
end

function MapMsg.OnFactionCount(faction, counter_name, old_value, new_value)
	-- If there is a mission codex entry with an id that matches the counter name, unlock that codex now (if it isn't already) and show a talking head
	local counter_codex_def = data.codex[counter_name]
	if not counter_codex_def or type(new_value) ~= "number" then return end
	faction:Unlock(counter_name)
	faction:RunUI(function() RefreshGoals(nil, counter_name) end)
end
