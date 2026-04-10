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

data.components.c_fabricator.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 3}, {['c_fabricator'] = 50, c_assembler = 25},1 )

---lvl0
data.components.c_uplink.production_recipe = CreateProductionRecipe({["metalplate"]=20,["datakey_robot"]=10}, {["c_assembler"] = 150}, 1)
data.components.c_small_relay.production_recipe = CreateProductionRecipe({["metalplate"]=6,["crystal"]=4}, {["c_assembler"] = 40}, 1)
data.components.c_assembler.production_recipe = CreateProductionRecipe({["metalplate"] = 10, ["crystal"] = 5}, {['c_fabricator'] = 50, c_assembler = 25},1 )
data.components.c_behavior.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1}, {['c_assembler'] = 5},1 )
data.components.c_shared_storage.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1}, {['c_assembler'] = 5},1 )

data.components.c_signal_reader.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_portable_radar.production_recipe = CreateProductionRecipe({["datakey_robot"] = 2, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_scout_radar.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_signpost.production_recipe = CreateProductionRecipe({ ["datakey_robot"] = 1}, {['c_assembler'] = 5},1 )
data.components.c_deconstructor.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["datakey_robot"] = 2}, {['c_assembler'] = 5},1 )
data.components.c_portable_turret.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 4}, {['c_assembler'] = 25},1 )
data.components.c_robotics_factory.production_recipe = CreateProductionRecipe({["metalplate"] = 6, ["crystal"] = 4, ['datakey_robot']=1}, {['c_assembler'] = 25},1 )

--miners 
data.components.c_miner.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 4, ['datakey_robot']=1}, {['c_assembler'] = 25},1 )
data.components.c_adv_miner.production_recipe = CreateProductionRecipe({ic_soul_angry = 1, reinforced_plate = 4, wire = 4, c_miner = 1}, {["c_assembler"] = 50}, 1)
data.components.c_extractor.production_recipe = CreateProductionRecipe({ic_soul_angry = 4, reinforced_plate = 9, phase_leaf = 4, c_adv_miner = 1, c_medium_capacitor = 1}, {["c_assembler"] = 70}, 1)
data.components.c_extractor.race = 'robot'
---non cube 
data.components.c_landing_pad.production_recipe = CreateProductionRecipe({["metalplate"]=40,["concreteslab"]=20,["c_portable_radar"]=1}, {["c_assembler"] = 150}, 1)
-- batteries and capacitors 
data.components.c_small_battery.production_recipe = CreateProductionRecipe({["metalplate"]=4,["crystal_powder"]=9}, {["c_assembler"] = 150}, 1)
data.components.c_battery.production_recipe = CreateProductionRecipe({["steelblock"]=9,["crystal_powder"]=9,["ic_soul_angry"]=1}, {["c_assembler"] = 150}, 1)
data.components.c_large_battery.production_recipe = CreateProductionRecipe({["reinforced_plate"]=16,["crystal_powder"]=16,["ic_time_crystal"]=2, ic_soul_happy = 2}, {["c_assembler"] = 150}, 1)
data.components.c_capacitor.production_recipe = CreateProductionRecipe({["metalplate"] = 4, ["crystal"] = 10}, {['c_assembler'] = 5},1 )
data.components.c_medium_capacitor.production_recipe = CreateProductionRecipe({["steelblock"]=9,["ic_soul_angry"]=4,["crystal_powder"]=4}, {["c_assembler"] = 150}, 1)
-- netowkring 
data.components.c_power_relay.production_recipe = CreateProductionRecipe({["steelblock"]=8,["metalplate"]=4,["crystal_powder"]=9}, {["c_assembler"] = 60}, 1)
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["crystal_powder"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_large_power_relay.production_recipe = CreateProductionRecipe({steelblock = 4, reinforced_plate = 16, crystal_powder = 9, ic_time_crystal = 1}, {["c_assembler"] = 50}, 1)
data.components.c_power_transmitter.production_recipe = CreateProductionRecipe({["steelblock"]=16,["wire"]=9, crystal_powder = 9}, {["c_assembler"] = 100}, 1)
data.components.c_power_transmitter.bandwidth = 5 * data.components.c_power_transmitter.bandwidth
data.components.c_large_power_transmitter.production_recipe = CreateProductionRecipe({["reinforced_plate"]=4,["wire"]=16, crystal_powder = 16, steelblock = 16, ic_time_crystal = 1}, {["c_assembler"] = 100}, 1)
data.components.c_large_power_transmitter.bandwidth = 5 * data.components.c_large_power_transmitter.bandwidth
data.components.c_internal_field.transfer_radius = 20
data.components.c_internal_field.get_ui = true
data.components.c_internal_field.race = "robot"
data.components.c_internal_field.texture = "Main/textures/icons/hidden/integrated_cell.png"

-- Weapons in order of unlock
data.components.c_repairkit.production_recipe = CreateProductionRecipe({["datakey_robot"]=1,["metalplate"]=1}, {["c_assembler"] = 30}, 1)
data.components.c_repairer.production_recipe = CreateProductionRecipe({["datakey_robot"]=1,["steelblock"]=2}, {["c_assembler"] = 30}, 1)
data.components.c_portable_turret_red.production_recipe = CreateProductionRecipe({["ic_soul_angry"]=1,["steelblock"]=4, wire = 2}, {["c_assembler"] = 50}, 1)
data.components.c_melee_pulse.production_recipe = CreateProductionRecipe({steelblock = 4, datakey_robot = 1, crystal = 4}, {['c_assembler'] = 25},1 )
data.components.c_adv_portable_turret.production_recipe = CreateProductionRecipe({steelblock = 4, datakey_robot = 1, crystal = 4}, {["c_assembler"] = 60}, 1)
data.components.c_pulselasers.production_recipe = CreateProductionRecipe({steelblock = 9, datakey_robot = 2, crystal_powder = 4}, {["c_assembler"] = 60}, 1)
data.components.c_pulse_disrupter.production_recipe = CreateProductionRecipe({steelblock = 9, datakey_robot = 2, crystal_powder = 4}, {["c_assembler"] = 60}, 1)
data.components.c_repairport.production_recipe = CreateProductionRecipe({steelblock = 16, datakey_robot = 6, crystal_powder = 1}, {["c_assembler"] = 60}, 1)
data.components.c_turret.production_recipe = CreateProductionRecipe({steelblock = 9, wire = 8, crystal_powder = 4}, {["c_assembler"] = 60}, 1)
data.components.c_repairer_small_aoe.production_recipe = CreateProductionRecipe({steelblock = 4, wire = 12, crystal_powder = 8}, {["c_assembler"] = 60}, 1)
data.components.c_twin_autocannons.production_recipe = CreateProductionRecipe({reinforced_plate = 4, wire = 8, datakey_robot = 2}, {["c_assembler"] = 60}, 1)
data.components.c_human_missilelauncher.production_recipe = CreateProductionRecipe({reinforced_plate = 16,wire = 6, crystal_powder = 6}, {["c_assembler"] = 60}, 1)
data.components.c_plasma_cannon.production_recipe = CreateProductionRecipe({reinforced_plate = 9, ic_soul_angry = 1, wire = 9}, {["c_assembler"] = 60}, 1)
data.components.c_plasma_turret.production_recipe = CreateProductionRecipe({reinforced_plate = 4, ic_soul_angry = 1, wire = 12}, {["c_assembler"] = 60}, 1)
data.components.c_railgun.production_recipe = CreateProductionRecipe({reinforced_plate = 16, ic_soul_angry = 9, ic_time_crystal = 4}, {["c_assembler"] = 60}, 1)
data.components.c_light_cannon.production_recipe = CreateProductionRecipe({reinforced_plate = 4, ic_soul_angry = 1, ic_time_crystal = 1}, {["c_assembler"] = 60}, 1)
data.components.c_laser_turret.production_recipe = CreateProductionRecipe({reinforced_plate = 9, ic_soul_angry = 4, ic_time_crystal = 4, ldframe = 1}, {["c_assembler"] = 60}, 1)
data.components.c_missile_turret.production_recipe = CreateProductionRecipe({reinforced_plate = 16, ic_soul_angry = 4, ic_time_crystal = 2, ldframe = 1}, {["c_assembler"] = 60}, 1)

data.components.c_portable_turret_green.production_recipe = CreateProductionRecipe({["phase_leaf"]=4,["steelblock"]=4, wire = 2}, {["c_assembler"] = 50}, 1)
-- storages 
data.components.c_internal_storage.production_recipe = CreateProductionRecipe({["metalplate"]=1, wire = 2}, {["c_assembler"] = 50}, 1)
data.components.c_small_storage.production_recipe = CreateProductionRecipe({["metalplate"]=4,["steelblock"]=4}, {["c_assembler"] = 50}, 1)
data.components.c_medium_storage.production_recipe = CreateProductionRecipe({steelblock = 9, reinforced_plate = 9, wire = 9}, {["c_assembler"] = 50}, 1)
data.components.c_large_storage.production_recipe = CreateProductionRecipe({ic_soul_happy = 1, reinforced_plate = 16, wire = 16}, {["c_assembler"] = 50}, 1)

-- Radar 
data.components.c_small_radar.production_recipe = CreateProductionRecipe({["metalplate"]=1,["crystal_powder"]=2,datakey_robot = 1, wire = 1}, {["c_assembler"] = 50}, 1)
data.components.c_radar.production_recipe = CreateProductionRecipe({["reinforced_plate"]=4,["wire"]=4,ic_soul_happy = 1}, {["c_assembler"] = 50}, 1)
-- Radios 
data.components.c_radio_transmitter.production_recipe = CreateProductionRecipe({["metalplate"]=1,["crystal_powder"]=2,datakey_robot = 1}, {["c_assembler"] = 50}, 1)
data.components.c_radio_receiver.production_recipe = CreateProductionRecipe({["metalplate"]=1,["crystal_powder"]=1,datakey_robot = 1}, {["c_assembler"] = 50}, 1)
-- drone ports 
data.components.c_drone_comp.production_recipe = CreateProductionRecipe({metalplate=9,c_portable_radar=1, wire = 1}, {["c_assembler"] = 150}, 1)
data.components.c_drone_comp.race = "robot"
data.components.c_drone_port.production_recipe = CreateProductionRecipe({reinforced_plate=16,c_portable_radar=2, wire = 2}, {["c_assembler"] = 150}, 1)
data.components.c_drone_launcher.production_recipe = CreateProductionRecipe({reinforced_plate=25,c_portable_radar=3, wire = 6}, {["c_assembler"] = 150}, 1)
data.components.c_drone_launcher.race = "robot"
-- shields  
data.components.c_shield_generator.production_recipe = CreateProductionRecipe({['crystal_powder'] = 4, ['wire'] = 4, metalplate = 4}, {c_assembler = 50})
data.components.c_shield_generator2.production_recipe = CreateProductionRecipe({['crystal_powder'] = 4, ['ic_soul_happy'] = 4, steelblock = 4, wire = 9}, {c_assembler = 50})
data.components.c_shield_generator3.production_recipe = CreateProductionRecipe({['crystal_powder'] = 4, ['wire'] = 16, reinforced_plate = 4, ldframe = 1, ic_soul_happy = 4}, {c_assembler = 50})

--cube 
data.components.c_advanced_refinery.name = "Soul Forge"
data.components.c_advanced_refinery.desc = "Melt Away Until Only The Essentials Remain"
data.components.c_advanced_refinery.slots = {anomaly = 1}
--light 
data.components.c_light.production_recipe = CreateProductionRecipe({metalplate=1,crystal=1}, {c_assembler = 50})
data.components.c_light_rgb.production_recipe = CreateProductionRecipe({metalplate=1,crystal=1}, {c_assembler = 50})

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

-------------------------------------------------------
----- Fueled Boost Modules -----------------------------------


----------------- Boots Effciency 
-- Modified to allow any component to modify a specific boost with greater control 
-- Rules Are:
-- Comps that have a .boost = amount 
-- Comps that have a .boost_id = boost type (component_boost or move_boost)
-- Comps that have extra_data.boost_active == true 

local function SumActiveModuleBoosts(owner, id, remove_comp)
	-- start at 100
	local sum = 100
	for i=1,owner.component_count do
		local boost_comp = owner:GetComponent(i)
		
		if boost_comp ~= nil -- has comp at that socket
		and boost_comp.def.boost_id == id -- check comp is a booster and is the correct boost type
		and boost_comp.extra_data.boost_active == true -- is comp active
		and boost_comp ~= remove_comp --not the comp being removed
		then
			sum = sum + boost_comp.def.boost
		end
	end
	-- hidden comps
	for i=1,100 do
		local boost_comp = owner:GetHiddenComponent(i)
		--print(i,boost_comp,boost_comp.def.boost_id,boost_comp.extra_data.boost_active,boost_comp ~= remove_comp )
		if boost_comp ~= nil then -- has comp at that socket

			if boost_comp.def.boost_id == id -- check comp is a booster and is the correct boost type
			and boost_comp.extra_data.boost_active == true -- is comp active
			and boost_comp ~= remove_comp --not the comp being removed
			then
				sum = sum + boost_comp.def.boost
			end
		else 
			break
		end
	end	
	return sum
end
-- on update/onremove/onadd should be the same for all the new boost modules
local cc_moduleefficiency = Comp:RegisterComponent("cc_moduleefficiency", {
	name = "Internal Time Distortion Module",
	desc = [[Time Distortion Increases Unit Effciency by 25%
Uses <img width="50" height="50" id="ic_time_crystal" style="bl"/> as Fuel"]],	
	attachment_size = "Internal", race = "robot", index = 1050,
	texture = data.components.c_moduleefficiency.texture,
	visual = "v_generic_i",
	production_recipe = CreateProductionRecipe({ reinforced_plate = 2, ic_time_crystal = 1, ic_soul_angry = 1 }, { c_assembler = 30, }),
	-- new items 
	activation = "OnAnyItemSlotChange",
	boost = 25,
	boost_id = "component_boost", -- or move_boost
	fuel = "ic_fuel",
	fuel_time = 1000, -- fuel_time / boost = working_time
	registers = {
		{ read_only = true, tip = "Requires",},
	}
})
function cc_moduleefficiency:update_boost(comp, remove)
	--print(self, comp, remove)
	local owner = comp.owner
	
	-- set remove when no nill 
	if remove == true then remove = comp end 
	owner[self.boost_id] = (owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, remove )
end
function cc_moduleefficiency:on_add(comp, cause)	
	comp.extra_data.boost_active = false
	comp:Activate()
end
function cc_moduleefficiency:on_remove(comp, cause)	
	comp.extra_data.boost_active = false
	self:update_boost(comp,true)
end
function cc_moduleefficiency:on_update(comp, cause)	
	
	-- check if installed on building for movement module
	if comp.owner.has_movement == false and self.boost_id == "move_boost" then 
		comp:FlagRegisterError(1)
		comp:SetStateSleep(2000) 
		return 
	end 

	if cause & CC_FINISH_WORK ~= 0 or comp.is_working == false then 
		-- start 
		-- request stack size of item
		local can_make, missing, no_space = comp:PrepareConsumeProcess({[self.fuel] = 1},3)
		--comp:OrderItem(self.fuel, 20)
		if can_make then 
			--consume next bit of fuel 
			comp:FulfillProcess()
			comp:SetStateStartWork(self.fuel_time/self.boost)
			comp.extra_data.boost_active = true 
			comp:SetRegister(1)

		else 
			-- wait until fuel arrives 
			comp:SetRegister(1,missing)
			comp:FlagRegisterError(1)
			comp:SetStateSleep(1000)
			comp.extra_data.boost_active = false
		end
		-- recalculate boosts
		self:update_boost(comp)
	else
		-- still consuming so go back to sleep 
		comp:SetStateContinueWork()
	end
end
function cc_moduleefficiency:get_reg_error(comp, cause)	
	if comp:RegisterIsError(1) then 
		if comp.owner.has_movement == false and self.boost_id == "move_boost" then 
			return "Unit cannot move"
		else 
			return "Missing Fuel To Operate"
		end
	end
end

cc_moduleefficiency:RegisterComponent("cc_moduleefficiency_s",{
	name = "Small Time Distortion Module",
	desc = [[Time Distortion Increases Unit Effciency by 50%
Uses <img width="50" height="50" id="ic_time_crystal"/> as Fuel"]],	
	attachment_size = "Small",
	texture = data.components.c_moduleefficiency_s.texture,
	visual = data.components.c_moduleefficiency_s.visual,
	production_recipe = CreateProductionRecipe({ reinforced_plate = 4, ic_time_crystal = 2, ic_soul_angry = 4 }, { c_assembler = 60, }),
	boost = 50,
})
cc_moduleefficiency:RegisterComponent("cc_moduleefficiency_m",{
	name = "Medium Time Distortion Module",
	desc = [[Time Distortion Increases Unit Effciency by 100%
Uses <img width="50" height="50" id="ic_time_crystal"/> as Fuel"]],	
	attachment_size = "Medium",
	texture = data.components.c_moduleefficiency_m.texture,
	visual = data.components.c_moduleefficiency_m.visual,
	production_recipe = CreateProductionRecipe({ reinforced_plate = 9, ic_time_crystal = 3, ic_soul_angry = 9 }, { c_assembler = 60, }),
	boost = 100,
})
cc_moduleefficiency:RegisterComponent("cc_moduleefficiency_l",{
	name = "Large Time Distortion Module",
	desc = [[Time Distortion Increases Unit Effciency by 150%
Uses <img width="50" height="50" id="ic_time_crystal"/> as Fuel"]],	
	attachment_size = "Large",
	texture = data.components.c_moduleefficiency_s.texture,
	visual = data.components.c_moduleefficiency_s.visual,
	production_recipe = CreateProductionRecipe({ reinforced_plate = 16, ic_time_crystal = 4, ic_soul_angry = 16 }, { c_assembler = 60, }),
	boost = 150,
})
--- Movement Boost 
cc_moduleefficiency:RegisterComponent("cc_modulespeed",{
	name = "Internal Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 25%
Uses <img width="50" height="50" id="ic_fuel"/> as Fuel"]],
	attachment_size = "Internal",
	texture = data.components.c_modulespeed.texture,
	production_recipe = CreateProductionRecipe({ engine = 2, steelblock = 4, datakey_robot = 1 }, { c_assembler = 60, }),
	boost = 25,
	boost_id = "move_boost", -- or move_boost
	fuel = "ic_fuel",
	index = 1052,
})
cc_moduleefficiency:RegisterComponent("cc_modulespeed_s",{
	name = "Small Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 50%
Uses <img width="50" height="50" id="ic_fuel"/> as Fuel"]],
	attachment_size = "Small",
	texture = data.components.c_modulespeed_s.texture,
	visual = data.components.c_modulespeed_s.visual,
	production_recipe = CreateProductionRecipe({ engine = 4, steelblock = 9, datakey_robot = 2 }, { c_assembler = 60, }),
	boost = 50,
	boost_id = "move_boost", -- or move_boost	
	fuel = "ic_fuel",
	index = 1052,
})
cc_moduleefficiency:RegisterComponent("cc_modulespeed_m",{
	name = "Medium Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 80%
Uses <img width="50" height="50" id="ic_fuel"/> as Fuel"]],
	attachment_size = "Medium",
	texture = data.components.c_modulespeed_m.texture,
	visual = data.components.c_modulespeed_m.visual,
	production_recipe = CreateProductionRecipe({ engine = 9, steelblock = 16, datakey_robot = 4 }, { c_assembler = 60, }),
	boost = 80,
	boost_id = "move_boost", -- or move_boost
	fuel = "ic_fuel",
	index = 1052,
})
cc_moduleefficiency:RegisterComponent("cc_modulespeed_l",{
	name = "Large Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 120%
Uses <img width="50" height="50" id="ic_fuel"/> as Fuel"]],
	attachment_size = "Large",
	texture = data.components.c_modulespeed_l.texture,
	visual = data.components.c_modulespeed_l.visual,
	production_recipe = CreateProductionRecipe({ engine = 16, steelblock = 25, datakey_robot = 8 }, { c_assembler = 60, }),
	boost = 120,
	boost_id = "move_boost", -- or move_boost
	fuel = "ic_fuel",
	index = 1052,
})
-------------------------------------------------------
----- Cube Pedestal -----------------------------------

local function update_cube_location(comp, item)

	if item == nil then return end 

	if comp.owner:CountItem(item) > 0 then 
		local faction = comp.faction
		faction.extra_data.cube_key = comp.owner.key
		faction.extra_data.cube_type = item
		faction.extra_data.cube_cord = comp.owner.location
	end
end
-- checks if both a Cube and Anti Cube are present in the same frame
local function check_for_anti_cube(comp) 
	local owner = comp.owner
	local slots = owner:GetSlotsByType("cube")
	if #slots >= 2 then
		-- could have anti cube and another cube 
		local check_anti, check_cube = false, false
		for i, val in ipairs(slots) do 
			if val.stack > 0 then 
				--contains cube 
				if val.id == "ic_cube_sphere" then check_anti = true 
				else check_cube = true end					
			end
		end 
		return check_anti and check_cube
	end
	return false
end
local function activate_other_comps(comp)
	local owner = comp.owner
	local find = owner:FindComponent("cc_crystal_power",true)
	-- activate cube power generators 
	if find ~= nil then find:Activate() end 
end

local replace_cube_with <const> = {
    ic_cube_blue = 'ic_cube_empty',
    ic_cube_green = 'ic_cube_red',
    ic_cube_empty = 'ic_cube_blue',
    ic_cube_red = 'ic_cube_green',
}
local blight_crystal_visuals <const> = { "v_blightcrystal_small1","v_blightcrystal1a", "v_blightcrystal1b" }
local function anti_cube_explosion(comp)

	if check_for_anti_cube(comp) ~= true then return end 
	-- EXPLOSION!
	local owner = comp.owner
	owner:PlayEffect("fx_EMP")
	local slots = owner:GetSlotsByType("cube")
	-- replace cube and destroy anti cube
	for i, val in ipairs(slots) do 
		if val.stack > 0 then 
			--contains cube 
			local id = val.id
			val:Clear()
			if id ~= "ic_cube_sphere" then 
				val:SetItemAndStack(replace_cube_with[id],1)
			end
		end
	end 
	local range = 10
	-- explosion 
	for _,frame in ipairs(Map.GetEntitiesInRange(owner.location, range, FF_OPERATING|FF_WALL|FF_GATE|FF_CONSTRUCTION)) do
		PlaceResourceNode(frame.location,"blight_crystal",100,"f_resourcenode_blightcrystal",blight_crystal_visuals[math.random(1,#blight_crystal_visuals)])
		frame:RemoveHealth(300, owner, "plasma_damage")
	end
	-- add time crystals 
	PlaceResourceNode(owner.location,"blight_crystal",10,"f_resourcenode_blightcrystal",blight_crystal_visuals[math.random(1,#blight_crystal_visuals)])
	-- add blight 
	local num = Map.StartTerraforming(owner, range, 10000)
	--does this need to be in a defer?
	Map.Defer(function()Map.StopTerraforming(num)end)
	-- notification
	-- need to add an on click method 
	Notification.Add("cube_explosion", "warning", "CUBE and ANTI-CUBE Annihilation", "The Cube and Anti-Cube where in contact\nThe Anti Cube Exploded leaving behind chrono crystal deposits")
end
local function Update_Cube_Effects(self, comp, cause)
	--print(comp,cause,comp.owner)
	--print(comp.CauseToString(comp,cause))
	--will have passed cube only if all change
	if cause & CC_CHANGED_ITEMSLOT_AMOUNT then-- traded cube 
		local owner = comp.owner
		--self.boost = -90
		--self:on_update_boosts(comp,{} ,self.boost)
		--BoostModuleOnAdd(self, comp.id)
		local boost_polarity = false
		if owner:CountItem("ic_cube_red") == 1 then
			comp:PlayEffect("fx_refinery","fx")
			comp.extra_data.boost_active = true
			self:update_boost(comp)
			update_cube_location(comp,"ic_cube_blue" )
			comp.extra_power = 401
			return 
			--comp.light_color = { 0.6,0.1,0,1 }
		elseif owner:CountItem("ic_cube_blue") == 1 then 
			update_cube_location(comp,"ic_cube_blue" )
		elseif owner:CountItem("ic_cube_empty") == 1 then 
			update_cube_location(comp,"ic_cube_empty" )
		elseif owner:CountItem("ic_cube_green") == 1 then 
			update_cube_location(comp,"ic_cube_green" )
			boost_polarity = true
		elseif owner:CountItem("ic_cube_sphere") == 1 then
			comp.light_color = { 1.0, 0.05, 0.0, 4.0}
			--comp:PlayEffect("fx_alien_liquid")
		else
			comp:StopEffects()
			comp.light_color = { 0,0,0,0 }
			comp.extra_power = 0
			comp.extra_data.boost_active = false
			self:update_boost(comp)
			if comp.faction.extra_data.cube_key == owner.key then 
				-- lost cube but key hasnt updated
				-- save cord encase it was thrown on the ground 
				comp.faction.extra_data.cube_key = nil
				comp.faction.extra_data.cube_cord = owner.location
			end
			return
		end
		-- when any cube has been added 
		comp.extra_power = 201
		comp.extra_data.boost_active = true
		self:update_boost(comp, boost_polarity)
		anti_cube_explosion(comp)
		activate_other_comps(comp)
	else
		comp:StopEffects() 
		print("stop effects")
		--self.boost = 0
		--print(self, comp, comp.id)
		--comp.extra_power = 0
		comp.extra_data.boost_active = false
		self:update_boost(comp)
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
	boost = -80,
	boost_id = "move_boost",
	power = -1,
	slots = { cube = 1, },
	production_recipe = CreateProductionRecipe({ steelblock = 16, metalplate = 4 }, { c_assembler = 20 }),
	activation = "OnComponentItemSlotChange",
	-- on_add = BoostModuleOnAdd,
	-- on_remove = BoostModuleOnRemove,
	on_update = Update_Cube_Effects,
	adjust_light_color = true,
})
function cc_cube_storage:update_boost(comp, reverse_polarity)
	--print(self, comp, remove)
	local owner = comp.owner
	-- set remove when no nill 
	if reverse_polarity == true then
		owner[self.boost_id] = math.max((owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id ) + self.boost * -2,0)
		return 
	end
	owner[self.boost_id] = math.max((owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, nil ),0)
end
function cc_cube_storage:on_remove(comp)
	local slot = comp:GetSlot(1)
	if slot.id == "ic_cube_sphere" then Place_Anti_Cube(comp.owner,true) end
end

-------------------------------------------------------
----- Boosting Tower Component -----------------------------------

local cc_temp_boost = Comp:RegisterComponent("cc_temp_boost", {
	desc = "Overclock Unit by 50%\n\nProvided By Boosting Tower",
	attachment_size = "Hidden", race = "human", index = 1050, name = "Chrono Boost From Tower",
	texture = data.components.c_moduleefficiency.texture,
	get_ui = true,
	-- new items 
	activation = "Manual",
	boost = 50,
	boost_id = "component_boost", -- or move_boost
	wait_ticks = 25,
})
function cc_temp_boost:update_boost(comp, remove)
	local owner = comp.owner
	-- set remove when not nil 
	if remove == true then remove = comp end  
	owner[self.boost_id] = (owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, remove )
	print(owner[self.boost_id],owner.def[self.boost_id])
end
function cc_temp_boost:on_add(comp, cause)
	comp.extra_data.boost_active = true
	self:update_boost(comp, false)
	comp:Activate()
end
function cc_temp_boost:on_remove(comp, cause)
	comp.extra_data.boost_active = false
	self:update_boost(comp,true)
end
function cc_temp_boost:on_update(comp, cause)
	if cause & CC_FINISH_WORK ~= 0 then 
		Map.Defer(function()comp:Destroy()end)
	else 
		comp:SetStateStartWork(self.wait_ticks*comp.owner[self.boost_id]/100)
	end
end

--- Boost Tower controller -------------------------------------
--- 
local cc_boost_tower = Comp:RegisterComponent("cc_boost_tower", {
	name = "Chrono Field Module",
	desc = "Dilates Time around the target unit\n\nRequires Advanced Fuel",
	texture = data.frames.f_beacon_l.texture,
	get_ui = true,
	power = -100,
	--visual = data.frames.f_beacon_l.visual,
	registers = {
		{ tip = "Chrono Field Target"},
		{ read_only = true, tip = "Requires",},
	},
	fuel = "ic_fuel",
	activation = "OnFirstRegisterChange|OnComponentItemSlotChange",
	wait_ticks = cc_temp_boost.wait_ticks,
	slots = {storage = 1},
	range = 20,
})

function cc_boost_tower:on_update(comp, cause)	
	-- Activated by item slot change or work finished or first register change 
	-- Flow:
		-- charge tower with fuel and power 
		-- boost unit with a tempoary buff 
			-- buff wears off on its own 
		-- Tower works on cooldown 
			-- recharging again
		-- is a hidden component so cant remove then re add 

	-- still on cooldown 
	if comp.is_working then 
		comp:SetStateContinueWork()
		return 
	end

	local target = comp:GetRegisterEntity(1)

	if target ~= nil then
		-- has a target 
		-- check in range 
		if target.faction.id ~= comp.faction.id or target:IsInRangeOf(comp.owner,self.range) == false then 
			comp:SetRegister(2)
			comp:FlagRegisterError(2)
			comp:SetStateSleep(50)
			comp:StopEffects()
			-- wait 10 seconds and try again
			return
		end
		-- check for fuel 
		-- if you relocate the tower you can probably skip the wait time.
		-- if they figure that out then good on them im not patching it
		local can_make, missing, no_space = comp:PrepareConsumeProcess({[self.fuel]=1},20)
		if can_make then
			comp:FulfillProcess()
			comp:SetRegister(2)
			comp:SetStateStartWork(self.wait_ticks)
			target:AddComponent("cc_temp_boost")
			comp:StopEffects()
			--comp:PlayEffect("fx_miner","fx",target)--fx_railgun
			comp:PlayEffect("fx_photon_beam","fx",target)
		else 
			comp:SetRegister(2,missing)
			comp:FlagRegisterError(2)
			comp:SetStateSleep(1000)
			comp:StopEffects()
		end
	else 
		comp:StopEffects()
	end
end
function cc_boost_tower:get_reg_error(comp, cause)	
	if comp:RegisterIsError(2) then 
		if comp:RegisterIsEmpty(2) then 
			return "Target Out Of Range or not valid"
		else 
			return "Missing Fuel To Operate"
		end
	elseif comp:RegisterIsError(1) then
		return "Target Out Of Range"
	end
end

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
		if not faction:IsUnlocked("tc_cube_green_2") then faction:Unlock("tc_cube_green_2") end
		Map.Defer(function ()
			comp.owner:AddItem("cc_planter_wire")
			local comp_puzzle = comp.owner:FindComponent ("c_explorable_netwalk")
			if comp_puzzle then comp_puzzle:Destroy() end
			comp:Destroy()
		end)
	end,
	on_remove = function(comp, cause)
		Map.DropItemAt(comp.owner.location, "cc_planter_wire",1, "f_dropped_resource")
		Map.DropItemAt(comp.owner.location, "wire",5, "f_dropped_resource")
	end
})

--Resource Rejeneration 
-- via green cube or anti-cube 

local c_blight_magnifier = data.components.c_blight_magnifier
c_blight_magnifier.name = "Cube Magnifier"
c_blight_magnifier.activation = "OnAnyItemSlotChange"
c_blight_magnifier.desc = "Regenerates nearby resources up to 1000\nRequires the Restless Cube"
c_blight_magnifier.registers = {{ read_only = true, tip = "Requires",},}
c_blight_magnifier.magnify_time = 25
c_blight_magnifier.get_ui = nil
c_blight_magnifier.power = -200
c_blight_magnifier.magnify_limit = 1000
c_blight_magnifier.production_recipe = CreateProductionRecipe(
{wire = 12, ic_soul_happy = 1, crystal_powder = 4},{c_assembler = 30})

function c_blight_magnifier:on_update(comp, cause)
	local owner = comp.owner
	-- local is_in_blight = Map.GetBlightnessDelta(owner, -1) >= 0 or Map.GetSave().dust_storm
	-- if not is_in_blight or owner.powered_down or not owner.is_placed then
	-- 	comp:SetRegisterId(1,"v_blight")
	-- 	comp:FlagRegisterError(1)
	-- 	comp:StopEffects()
	-- 	return comp:SetStateSleep(10000)
	-- end
	-- meets requirements 
	if comp.is_working == true then 
		comp:SetStateContinueWork() 
	end
	-- check if finished working 
	local is_finished_working = (cause & CC_FINISH_WORK == CC_FINISH_WORK)
	if is_finished_working then
		-- replace cube 
		comp:CancelProcess()
		--comp:AddItem("ic_cube_green")

		local check = Map.FindClosestEntity(owner, self.range, function(e)
			if AddResourceHarvestItemAmount(e, 100, self.magnify_limit) then
				e:SetRegisterNum(FRAMEREG_STORE, 1) -- mark as magnified (see c_miner:on_update)
			end
		end, FF_RESOURCE)
		if check == nil then 
			--no resources to regenerate 
			comp:SetRegister(1)
			comp:FlagRegisterError(1)
			comp:SetStateSleep(100)
			return
		end
	end
	local can_make, missing = comp:PrepareConsumeProcess({ic_cube_green = 1})
	if can_make == false then 
		comp:SetRegister(1,missing)
		comp:FlagRegisterError(1)
		comp:SetStateSleep(10000)
	else
		comp:PlayWorkEffect("fx_alien_liquid")
		comp:SetRegister(1)
		comp:FlagRegisterError(1,false)
		return comp:SetStateStartWork(self.magnify_time, false)
	end
end
function c_blight_magnifier:get_reg_error(comp)
	if comp:RegisterIsError(1) then
		if comp:RegisterIsEmpty(1) then 
			return "No Resources to Regnerate"
		elseif comp:GetRegisterId(1) == data.values.v_blight.id then 
			return "Not Inside the Blight"
		else	
			return "Missing The Cube"
		end
	end
end