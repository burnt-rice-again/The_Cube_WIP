--[[
data.components.samplecomponent = {
	name = "<NAME>",
	texture = "<PATH/TO/IMAGE.png>",

	-- Optional
	visual = "<VISUAL-ID>",
	slot_type = "storage|liquid|radioactive|...", -- default 'storage'
	attachment_size = "Hidden|Internal|Small|Medium|Large", -- default 'Hidden'
	activation = "None|Always|Manual|OnFirstRegisterChange|OnComponentRegisterChange|OnFirstItemSlotChange|OnComponentItemSlotChange|OnAnyItemSlotChange|OnLowPower|OnPowerStoredEmpty|OnTrustChange|OnOtherCompFinish", -- default 'None'
	-- note: OnAnyItemSlotChange can not be set with other change flags
	slots = { <SLOT_TYPE> = <NUM>, ... },
	registers = { ... },
	power = -0.1,
	power_storage = 1000,
	drain_rate = 1,
	charge_rate = 5,
	bandwidth = 2,
	transfer_radius = 10,
	adjust_extra_power = true,
	dumping_ground = true,
	effect = "fx_power_core", -- automatically spawned when this components visual is placed on the map
	effect_socket = "fx",
	trigger_radius = 8,
	trigger_channels = "bot|building|bug",
	production_recipe = CreateProductionRecipe(
		{ <INGREDIENT_ITEM_ID> = <INGREDIENT_NUM>, ... },
		{ <PRODUCTION_COMPONENT_ID> = <PRODUCTION_TICKS>, }
		-- Optional
		<AMOUNT_NUM>, --default: 1
	),
	on_add = function(self, comp) ... end,
	on_remove = function(self, comp) ... end,
	on_placed = function(self, comp) ... end,
	on_update = function(self, comp, cause) ... end,
	on_trigger = function(self, comp, other_entity) ... end,
	on_take_damage = function(self, comp, amount) ... end,
	on_faction_change = function(self, comp, old_faction) ... end,
	extra_stat = { { img, value, name } } -- for displaying extra stats for a component
}
]]

-- adjustements --------------------------------------


-- refinery 
-- for key,_ in pairs(data) do 
-- 	print(key)
-- end
-- data.components.c_refinery.name = "Cube Refinery"
-- data.components.c_refinery.power = -1000
-- data.components.c_refinery.production_recipe = CreateProductionRecipe({["steelblock"]=20,["concreteslab"]=20,["datakey_robot"]=2}, {["c_assembler"] = 150}, 1)
-------------------

data.components.c_fabricator.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 3}, {['c_fabricator'] = 50, c_assembler = 25},1 )

---lvl0
data.components.c_uplink.production_recipe = CreateProductionRecipe({["metalplate"]=20,["datakey_robot"]=10}, {["c_assembler"] = 150}, 1)
data.components.c_small_relay.production_recipe = CreateProductionRecipe({["metalplate"]=6,["crystal"]=4}, {["c_assembler"] = 40}, 1)
data.components.c_assembler.production_recipe = CreateProductionRecipe({["metalplate"] = 10, ["crystal"] = 5}, {['c_fabricator'] = 50, c_assembler = 25},1 )
data.components.c_behavior.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1}, {['c_assembler'] = 5},1 )
data.components.c_shared_storage.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1}, {['c_assembler'] = 5},1 )
data.components.c_capacitor.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 10}, {['c_assembler'] = 5},1 )

data.components.c_signal_reader.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_portable_radar.production_recipe = CreateProductionRecipe({["datakey_robot"] = 2, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_scout_radar.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_signpost.production_recipe = CreateProductionRecipe({ ["datakey_robot"] = 1}, {['c_assembler'] = 5},1 )
data.components.c_deconstructor.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["datakey_robot"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_capacitor.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 10}, {['c_assembler'] = 5},1 )
data.components.c_portable_turret.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 4}, {['c_assembler'] = 25},1 )
data.components.c_melee_pulse.production_recipe = CreateProductionRecipe({["steelblock"] = 6, ["crystal"] = 4}, {['c_assembler'] = 25},1 )
data.components.c_miner.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 4, ['datakey_robot']=1}, {['c_assembler'] = 25},1 )
data.components.c_robotics_factory.production_recipe = CreateProductionRecipe({["metalplate"] = 6, ["crystal"] = 4, ['datakey_robot']=1}, {['c_assembler'] = 25},1 )


---lvl1
---non cube 
data.components.c_power_relay.production_recipe = CreateProductionRecipe({["steelblock"]=8,["metalplate"]=4,["wire"]=9}, {["c_assembler"] = 60}, 1)
data.components.c_adv_portable_turret.production_recipe = CreateProductionRecipe({["steelblock"]=8,["wire"]=6,["crystal"]=4}, {["c_assembler"] = 60}, 1)
data.components.c_landing_pad.production_recipe = CreateProductionRecipe({["metalplate"]=40,["concreteslab"]=20,["c_portable_radar"]=1}, {["c_assembler"] = 150}, 1)
-- batteries and capacitors 
data.components.c_small_battery.production_recipe = CreateProductionRecipe({["metalplate"]=4,["crystal_powder"]=1,["crystal"]=10}, {["c_assembler"] = 150}, 1)
data.components.c_battery.production_recipe = CreateProductionRecipe({["steelblock"]=4,["crystal_powder"]=10,["ic_soul_angry"]=1}, {["c_assembler"] = 150}, 1)
data.components.c_large_battery.production_recipe = CreateProductionRecipe({["metalplate"]=4,["crystal_powder"]=1,["crystal"]=10}, {["c_assembler"] = 150}, 1)
data.components.c_medium_capacitor.production_recipe = CreateProductionRecipe({["steelblock"]=8,["ic_soul_angry"]=1,["crystal"]=10}, {["c_assembler"] = 150}, 1)


---lvl2
data.components.c_portable_turret_red.production_recipe = CreateProductionRecipe({["metalplate"]=8,["crystal_powder"]=4,["blight_plasma"]=1}, {["c_assembler"] = 150}, 1)
data.components.c_portable_turret_green.production_recipe = CreateProductionRecipe({["metalplate"]=8,["crystal_powder"]=4,["phase_leaf"]=1}, {["c_assembler"] = 150}, 1)
data.components.c_landing_pad.production_recipe = CreateProductionRecipe({["metalplate"]=40,["concreteslab"]=20,["c_portable_radar"]=1}, {["c_assembler"] = 150}, 1)
data.components.c_landing_pad.production_recipe = CreateProductionRecipe({["metalplate"]=40,["concreteslab"]=20,["c_portable_radar"]=1}, {["c_assembler"] = 150}, 1)
data.components.c_landing_pad.production_recipe = CreateProductionRecipe({["metalplate"]=40,["concreteslab"]=20,["c_portable_radar"]=1}, {["c_assembler"] = 150}, 1)

-- Improved Weapons 1 
data.components.c_repairkit.production_recipe = CreateProductionRecipe({["datakey_robot"]=1,["metalplate"]=1}, {["c_assembler"] = 30}, 1)
data.components.c_repairer.production_recipe = CreateProductionRecipe({["datakey_robot"]=1,["steelblock"]=2}, {["c_assembler"] = 30}, 1)
data.components.c_portable_turret_red.production_recipe = CreateProductionRecipe({["ic_soul_angry"]=1,["steelblock"]=4, wire = 2}, {["c_assembler"] = 50}, 1)
data.components.c_portable_turret_green.production_recipe = CreateProductionRecipe({["phase_leaf"]=4,["steelblock"]=4, wire = 2}, {["c_assembler"] = 50}, 1)
-- storages 
data.components.c_internal_storage.production_recipe = CreateProductionRecipe({["metalplate"]=1, wire = 2}, {["c_assembler"] = 50}, 1)
data.components.c_small_storage.production_recipe = CreateProductionRecipe({["metalplate"]=4,["steelblock"]=4}, {["c_assembler"] = 50}, 1)
data.components.c_medium_storage.production_recipe = CreateProductionRecipe({["aluminiumrod"]=16, reinforced_plate = 16, wire = 4}, {["c_assembler"] = 50}, 1)
data.components.c_large_storage.production_recipe = CreateProductionRecipe({["reinforced_plate"]=40,["fused_electrodes"]=8, aluminiumrod = 12}, {["c_assembler"] = 50}, 1)
-- netowkring 
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_power_transmitter.production_recipe = CreateProductionRecipe({["steelblock"]=16,["wire"]=9, crystal_powder = 9}, {["c_assembler"] = 100}, 1)
data.components.c_power_transmitter.bandwidth = 5 * data.components.c_power_transmitter.bandwidth
data.components.c_large_power_transmitter.bandwidth = 5 * data.components.c_large_power_transmitter.bandwidth
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2}, {["c_assembler"] = 50}, 1)

-- Radios 
data.components.c_radio_transmitter.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2,datakey_robot = 1}, {["c_assembler"] = 50}, 1)
data.components.c_radio_receiver.production_recipe = CreateProductionRecipe({["metalplate"]=4,["wire"]=2,datakey_robot = 1}, {["c_assembler"] = 50}, 1)

-- shields  
data.components.c_shield_generator.production_recipe = CreateProductionRecipe({['phase_leaf'] = 10, ['wire'] = 4}, {c_assembler = 50})



--cube 
data.components.c_advanced_refinery.name = "Soul Forge"
data.components.c_advanced_refinery.desc = "Melt Away Until Only The Essentials Remain"
data.components.c_advanced_refinery.slots = {anomaly = 1}

--- Buff Batteries and capacitors
local battery_modifier <const> = 2
local battery = data.components.c_small_battery
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 
local battery = data.components.c_battery
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 
local battery = data.components.c_large_battery
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 
local battery = data.components.c_capacitor
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 
local battery = data.components.c_integrated_capacitor
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 
local battery = data.components.c_higrade_capacitor
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 
local battery = data.components.c_medium_capacitor
battery.power_storage = battery.power_storage * battery_modifier
battery.drain_rate = battery.drain_rate * battery_modifier
battery.charge_rate = battery.charge_rate * battery_modifier 



--data.components.c_terraformer.range = 2
-- define and register a custom component, the ID needs to be unique
local cc_adv_alien_factory = Comp:RegisterComponent("cc_adv_alien_factory", {
	name = "Advanced Alien Factory2",
	texture = "Main/textures/icons/components/Component_AdvancedAlienFactory_01_M.png",
	desc = "Alien and Robot technology, capable of producing Alien constructs and devices",
	attachment_size = "Large",
	race = "alien",
	visual = "vc_cube_blue",
	production_effect = "fx_assembler",
	power = -400,
	production_recipe = CreateProductionRecipe({  cpu = 10, energized_artifact = 10 }, { c_alien_factory_robots = 200 }),
	-- production_recipe = CreateProductionRecipe({ hdframe = 20, blight_plasma = 10, blight_bar = 10 }, { c_assembler = 150 }),
})

local function update_cube_location(comp, item)

	if item == nil then return end 

	if comp.owner:CountItem(item) > 0 then 
		local faction = comp.faction
		faction.extra_data.cube_key = comp.owner.key
		faction.extra_data.cube_type = item
		faction.extra_data.cube_cord = comp.owner.location
	end
end

local function BoostModuleOnAdd(self, comp) self:on_update_boosts(comp, nil, 0) end
local function BoostModuleOnRemove(self, comp) self:on_update_boosts(comp, comp, 0) end
local function Update_Cube_Effects(self, comp, cause)
	--print(comp,cause,comp.owner)
	--print(comp.CauseToString(comp,cause))




	
	--will have passed cube only if all change
	if cause & CC_CHANGED_ITEMSLOT_AMOUNT then-- traded cube 

		local owner = comp.owner

		



		--self.boost = -90
		--self:on_update_boosts(comp,{} ,self.boost)
		--BoostModuleOnAdd(self, comp.id)

		if owner:CountItem("ic_cube_red") == 1 then
			comp:PlayEffect("fx_refinery","fx")
			self:on_update_boosts(comp,{} ,self.boost)
			update_cube_location(comp,"ic_cube_blue" )
			comp.extra_power = 400
			return 
			--comp.light_color = { 0.6,0.1,0,1 }
		elseif owner:CountItem("ic_cube_blue") == 1 then 
			update_cube_location(comp,"ic_cube_blue" )
		elseif owner:CountItem("ic_cube_empty") == 1 then 
			update_cube_location(comp,"ic_cube_empty" )
		elseif owner:CountItem("ic_cube_green") == 1 then 
			update_cube_location(comp,"ic_cube_green" )
		elseif owner:CountItem("ic_cube_sphere") == 1 then
			comp.light_color = { 1.0, 0.05, 0.0, 4.0}
			--comp:PlayEffect("fx_alien_liquid")
			update_cube_location(comp,"ic_cube_sphere" )
		else
			comp:StopEffects()
			comp.light_color = { 0,0,1,0 }
			comp.extra_power = 0
			self:on_update_boosts(comp,{} ,0)
			if comp.faction.extra_data.cube_key == owner.key then 
				-- lost cube but key hasnt updated
				-- save cord encase it was thrown on the ground 
				comp.faction.extra_data.cube_key = nil
				comp.faction.extra_data.cube_cord = owner.location
			end
			return
			
		end
		comp.extra_power = 200
		self:on_update_boosts(comp,{} ,self.boost)


		-- fx_reforming_pool good has small plasma and a whilwind above cube
		-- fx_alien_teleporter - creates a ring but is in the air :(
		-- fx_unit_teleport - good for a different purpose
		-- fx_pulse - emp like pulse , fx_viral_pulse
		-- fx_power_core - strong light 
		-- fx_alien_core pink light 
		--fx_deconstructor like bullets raining from the sky 
		--fx_assembler - smaller fire
		--fx_EMP - huge emp blast  
	else
		comp:StopEffects() 
		print("stop effects")

		--self.boost = 0
		--print(self, comp, comp.id)
		--comp.extra_power = 0
		self:on_update_boosts(comp,{} ,0)
		--comp.light_color = { 0,0,0,0 }
	end
	--if cause == 3073 -- cube left 

end
-- Storage Comp for Cube 
local cc_cube_storage = Comp:RegisterComponent("cc_cube_storage", {
	name = "Cube Pedastal",
	attachment_size = "Medium",
	texture = "Main/textures/icons/components/Component_Storage_01_S.png",
	desc = "Holds the <hl>CUBE</>but slows bots significantly <hl>-90%</>\n\nWill extract <hl>500</> power while holding a CUBE",
	visual = "vc_cube_storage",
	race = "robot",
	boost = -90,
	power = -1,
	slots = { cube = 1, },
	production_recipe = CreateProductionRecipe({ steelblock = 16, metalplate = 4 }, { c_assembler = 20 }),
	activation = "OnComponentItemSlotChange",
	-- on_add = BoostModuleOnAdd,
	-- on_remove = BoostModuleOnRemove,
	on_update = Update_Cube_Effects,
	adjust_light_color = true,
	--effect = "cube_floating_blue",
	--dumping_ground = true,
})


function cc_cube_storage:on_update_boosts(comp, remove_comp, holding_cube)
	local owner = comp.owner
	
	if holding_cube == 0 then comp.extra_power = 0 else comp.extra_power = 101 end

	--self.PlayEffect("cube_floating_blue")
	owner.move_boost = 100 + SumModuleBoosts(owner, "c_modulespeed", remove_comp) + holding_cube
end

local function battery_get_ui(self, comp)
	return UI.New([[<Box padding=4><Progress valign=center width=54 height=54 progress={progress} bg=progress_mask orientation=vertical color=ui_light bgcolor=ui_dark/></Box>]], {
		compicon = comp.def.texture,
		update = function(w)
			local comp_def, comp_details = comp.def, comp.power_details
			if comp_details then
				w.progress = comp_details.stored / comp_def.power_storage
				if w.tt then
					w.tt.text = L((comp_details.change ~= 0 and "%s: %.0f/%.0f (%+.0f)" or "%s: %.0f/%.0f"), "Stored", comp_details.stored, comp_def.power_storage, comp_details.change*TICKS_PER_SECOND)
				end
			end
		end,
		tooltip = function(w)
			w.tt = UI.New("<Box bg=popup_box_bg padding=12><Text/></Box>", { destruct = function() if w:IsValid() then w.tt = nil end end })[1]
			w:update()
			return w.tt.parent
		end,
	})
end

local cc_crystal_power = Comp:RegisterComponent("cc_crystal_power", {
	name = "Crystal Power", --"Crystal Power Extractor",
	texture = "Main/textures/icons/components/component_crystalpower_01_s.png",
	desc = [[Produces a small amount of power with the cube and crystals
		<img width="50" height="50" image="Main/textures/icons/items/robot_research_cube.png"/><img width="50" height="50" image="Main/textures/icons/items/rawcrystal.png"/>x20 --><img width="50" height="50" image="Main/textures/icons/items/robot_research_cube.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
	]],
	attachment_size = "Small",
	visual = "v_crystalpower_01_s",
	race = "robot",
	production_recipe = CreateProductionRecipe({ metalplate = 5, crystal = 10 }, { c_assembler = 20 }),
	activation = "OnPowerStoredEmpty",
	get_ui = battery_get_ui,
	consume_item = "crystal",
	consume_amount = 1,
	cube_in = "ic_cube_blue",
	cube_out = "ic_cube_blue",
	wait_ticks = 30,
	-- battery
	power_storage = 10000,
	drain_rate = 400,
})

function cc_crystal_power:on_update(comp, cause)
	-- on_update is also called when work has finished, only refill stored power when actually on low power
	if comp.stored_power > 0.5 * self.power_storage then
		if comp.has_prepared_process then
			-- keep 1 ordered/reserved for once power runs out
			--comp:PrepareConsumeProcess({[self.consume_item] = self.consume_amount}, 1)
			--comp:FulfillProcess()
			--comp.owner:AddItem(self.cube_out)
			return comp:SetStateSleep()
		end
		return
	end

	-- If still working from before but gotten activated again just continue work
	if cause & CC_FINISH_WORK == 0 and comp.is_working then
		return comp:SetStateContinueWork()
	end

	-- reserve or order 2 crystal so 1 can be consumed immediately and 1 is kept reserved
	local can_make = comp:PrepareConsumeProcess({[self.consume_item] = self.consume_amount, [self.cube_in] = 1}, 2)
	if not can_make then
		return comp:SetStateSleep()
	end

	comp:FulfillProcess()
	comp.owner:AddItem(self.cube_out)

	-- refill stored power
	if self.requires_blight and Map.GetBlightnessDelta(comp.owner, -1) < 0 then
		comp.stored_power = self.power_storage // 3
	else
		comp.stored_power = self.power_storage
	end

	-- Start a 20 tick work until we can consume another crystal
	return comp:SetStateStartWork(self.wait_ticks)
end

cc_crystal_power:RegisterComponent("cc_crystal_power_red",{
	name = "Fury Cube Power Engine", --"Crystal Power Extractor",
	texture = "Main/textures/icons/components/component_blightcrystalpower_01_m.png",
	desc = [[Requires extreme heat to vaporize crystal powders
		<img width="50" height="50" image="Main/textures/icons/items/alien_datacube.png"/><img width="50" height="50" image="Main/textures/icons/items/crystalpowder.png"/>x100 --><img width="50" height="50" image="The_Cube_WIP/textures/cube_blue_drained.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
	]],
	visual = 'v_blightcrystalpower_01_m',
	power_storage = 500000,
	drain_rate = 2000,
	consume_item = "phase_leaf",
	consume_amount = 100,
	cube_in = "ic_cube_red",
	attachment_size = "Small",
	wait_ticks = 100,
	production_recipe = CreateProductionRecipe({reinforced_plate = 20, concreteslab = 20, wire = 6 },{c_assembler = 60})
})

data.components.c_crystal_power:RegisterComponent("cc_power_souls",{
	name = "Soul Consumption", --"Crystal Power Extractor",
	texture = 'Main/textures/icons/components/Component_PowerCell_01_S.png',
	desc = [[Consumes Soul Plasma for energy 
		<img width="50" height="50" image="Main/textures/icons/items/anomaly_particle.png"/>x1 --><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
		Requires drastically less Cube time compared to crystal power 
	]],
	visual = "v_power_cell_01_s",
	power_storage = 5000,
	drain_rate = 50,
	consume_item = "ic_soul_plasma",
	wait_ticks = 11,
	production_recipe = CreateProductionRecipe({wire = 4, crystal_powder = 8, steelblock = 4},{c_assembler = 60}, 1)
})

------------------ Explorables 
local cc_explorable_fix = Comp:RegisterComponent("cc_explorable_fix_volcano", {
	name = "Repair Required",
	texture = "Main/textures/icons/components/int.png",
	--effect = "fx_leaves",
	activation = "OnAnyItemSlotChange",
	type = "Puzzle",
	on_solved = function(comp, explorable_race, faction)
		comp.owner:SetRegister(FRAMEREG_SIGNAL, nil)
		Map.Defer(function ()
			comp.owner.faction = faction.id--Map.GetPlayerFactions()[1]
			comp.owner:AddItem(comp.extra_data.explorable_fix)
			comp.owner:AddComponent("cc_cube_melter")
			local comp_puzzle = comp.owner:FindComponent ("c_explorable_netwalk")
			if comp_puzzle then comp_puzzle:Destroy() end
			if not faction:IsUnlocked("tc_cube_red_refining") then faction:Unlock("tc_cube_red_refining") end
			comp:Destroy()
		end)
	end,
	explorable_fix = "ic_cube_empty",
})
function cc_explorable_fix:on_update(comp, cause)
	local fix_item = comp.has_extra_data and comp.extra_data.explorable_fix or self.explorable_fix
	local slot = comp.owner:FindSlot(fix_item, 1)
	if slot then
		Map.Defer(function() if comp.exists and slot.exists and slot.unreserved_stack > 0 then FactionAction.ExplorableSolvePuzzle(comp.faction, { comp = comp, consume_slot = slot  }) end end)
	end
end

cc_explorable_fix:RegisterComponent("cc_explorable_fix_wire_weed", {
	explorable_fix = "datakey_robot",
	on_solved = function(comp, explorable_race, faction)
		comp.owner:SetRegister(FRAMEREG_SIGNAL, nil)
		Map.Defer(function ()
			comp.owner:AddItem("cc_planter_wire")
			local comp_puzzle = comp.owner:FindComponent ("c_explorable_netwalk")
			if comp_puzzle then comp_puzzle:Destroy() end
			if not faction:IsUnlocked("tc_cube_green_discovery") then faction:Unlock("tc_cube_green_discovery") end
			comp:Destroy()
		end)
	end,
})