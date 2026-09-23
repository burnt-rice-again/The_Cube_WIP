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
data.components.c_portable_radar.production_recipe = CreateProductionRecipe({["datakey_robot"] = 1	, ["crystal"] = 2}, {['c_assembler'] = 5},1 )
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
data.components.c_medium_capacitor.production_recipe = CreateProductionRecipe({["steelblock"]=9,["ic_soul_angry"]=1,["crystal_powder"]=4}, {["c_assembler"] = 150}, 1)
-- netowkring 
data.components.c_power_relay.production_recipe = CreateProductionRecipe({["steelblock"]=8,["metalplate"]=4,["crystal_powder"]=9}, {["c_assembler"] = 60}, 1)
data.components.c_portable_relay.production_recipe = CreateProductionRecipe({["metalplate"]=4,["crystal_powder"]=2}, {["c_assembler"] = 50}, 1)
data.components.c_large_power_relay.production_recipe = CreateProductionRecipe({steelblock = 4, reinforced_plate = 16, crystal_powder = 9, ic_soul_angry = 1}, {["c_assembler"] = 50}, 1)
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

-- integrated power 
data.components.c_integrated_power_cell.power = 0
data.components.c_integrated_power_cell.range = 30


-- speed modules 


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


data.components.c_modulehealth.production_recipe = CreateProductionRecipe({ reinforced_plate = 2, wire = 1 }, { c_assembler = 30, })
data.components.c_modulehealth_s.production_recipe = CreateProductionRecipe({ reinforced_plate = 4, wire = 2 }, { c_assembler = 30, })
data.components.c_modulehealth_m.production_recipe = CreateProductionRecipe({ reinforced_plate = 9, wire = 4 }, { c_assembler = 30, })
data.components.c_modulehealth_l.production_recipe = CreateProductionRecipe({ reinforced_plate = 16, wire = 9 }, { c_assembler = 30, })

data.components.c_modulevisibility.production_recipe = CreateProductionRecipe({ reinforced_plate = 1, ic_soul_happy = 1 }, { c_assembler = 30, })
data.components.c_modulevisibility_s.production_recipe = CreateProductionRecipe({ reinforced_plate = 2, ic_soul_happy = 2 }, { c_assembler = 30, })
data.components.c_modulevisibility_m.production_recipe = CreateProductionRecipe({ reinforced_plate = 3, ic_soul_happy = 4 }, { c_assembler = 30, })
data.components.c_modulevisibility_l.production_recipe = CreateProductionRecipe({ reinforced_plate = 4, ic_soul_happy = 9 }, { c_assembler = 30, })

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
			and (boost_comp.extra_data.boost_active == true or boost_comp.extra_data.boost_active == -1)-- is comp active
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
	desc = [[Time Distortion Increases Unit Effciency by 50%]],	
	attachment_size = "Internal", race = "robot", index = 1050,
	texture = data.components.c_moduleefficiency.texture,
	visual = "v_generic_i",
	production_recipe = CreateProductionRecipe({ reinforced_plate = 2, ic_time_crystal = 1, ic_soul_angry = 1 }, { c_assembler = 30, }),
	-- new items 
	activation = "OnAnyItemSlotChange",
	boost = 50,
	boost_id = "component_boost", -- or move_boost
	fuel = "ic_time_crystal",
	fuel_time = 1000*25, -- fuel_time / boost = working_time
	registers = {
		{ read_only = true, tip = "Requires",},
	},
})
function cc_moduleefficiency:update_boost(comp, remove)
	--print(self, comp, remove)
	local owner = comp.owner
	--print(comp.id, owner)
	-- set remove when no nill 
	if remove == true then remove = comp end 
	if owner[self.boost_id] == nil then return print("No Boost Id", self.boost_id) end
	owner[self.boost_id] = (owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, remove )
	--print("Updated Boost", self.boost_id, owner[self.boost_id], (owner.def[self.boost_id] or 0))
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
			comp.extra_data.boost_active = true 
			-- recalculate boost
			self:update_boost(comp)
			comp:SetStateStartWork(self.fuel_time*comp.effective_boost/100) 
			
			comp:SetRegister(1)

		else 
			-- wait until fuel arrives 
			comp:SetRegister(1,missing)
			comp:FlagRegisterError(1)
			comp:SetStateSleep(1000)
			comp.extra_data.boost_active = false
			self:update_boost(comp)
		end
		
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
	desc = [[Time Distortion Increases Unit Effciency by 100%
Uses <img width="50" height="50" id="ic_time_crystal" style="bl"/> as Fuel"]],	
	attachment_size = "Small",
	texture = data.components.c_moduleefficiency_s.texture,
	visual = data.components.c_moduleefficiency_s.visual,
	production_recipe = CreateProductionRecipe({ reinforced_plate = 4, ic_time_crystal = 2, ic_soul_angry = 4 }, { c_assembler = 60, }),
	boost = 100,
})
cc_moduleefficiency:RegisterComponent("cc_moduleefficiency_m",{
	name = "Medium Time Distortion Module",
	desc = [[Time Distortion Increases Unit Effciency by 150%
Uses <img width="50" height="50" id="ic_time_crystal" style="bl"/> as Fuel"]],	
	attachment_size = "Medium",
	texture = data.components.c_moduleefficiency_m.texture,
	visual = data.components.c_moduleefficiency_m.visual,
	production_recipe = CreateProductionRecipe({ reinforced_plate = 9, ic_time_crystal = 3, ic_soul_angry = 9 }, { c_assembler = 60, }),
	boost = 150,
})
cc_moduleefficiency:RegisterComponent("cc_moduleefficiency_l",{
	name = "Large Time Distortion Module",
	desc = [[Time Distortion Increases Unit Effciency by 200%
Uses <img width="50" height="50" id="ic_time_crystal" style="bl"/> as Fuel"]],	
	attachment_size = "Large",
	texture = data.components.c_moduleefficiency_s.texture,
	visual = data.components.c_moduleefficiency_s.visual,
	production_recipe = CreateProductionRecipe({ reinforced_plate = 16, ic_time_crystal = 4, ic_soul_angry = 16 }, { c_assembler = 60, }),
	boost = 200,
})
data.components.cc_moduleefficiency.fuel_time = math.ceil(data.components.cc_moduleefficiency.fuel_time / data.components.cc_moduleefficiency.boost)
cc_moduleefficiency.charge_time = cc_moduleefficiency.fuel_time
data.components.cc_moduleefficiency_s.fuel_time = math.ceil(data.components.cc_moduleefficiency_s.fuel_time / data.components.cc_moduleefficiency_s.boost)
data.components.cc_moduleefficiency_s.charge_time = data.components.cc_moduleefficiency_s.fuel_time
data.components.cc_moduleefficiency_m.fuel_time = math.ceil(data.components.cc_moduleefficiency_m.fuel_time / data.components.cc_moduleefficiency_m.boost)
data.components.cc_moduleefficiency_m.charge_time = data.components.cc_moduleefficiency_m.fuel_time
data.components.cc_moduleefficiency_l.fuel_time = math.ceil(data.components.cc_moduleefficiency_l.fuel_time / data.components.cc_moduleefficiency_l.boost)
data.components.cc_moduleefficiency_l.charge_time = data.components.cc_moduleefficiency_l.fuel_time
-- Movement Boost - removed fuel requirement
local cc_modulespeed = Comp:RegisterComponent("cc_modulespeed",{
	name = "Internal Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 25%]],
	attachment_size = "Internal",
	visual = "v_generic_i",
	texture = data.components.c_modulespeed.texture,
	production_recipe = CreateProductionRecipe({ engine = 2, steelblock = 4, datakey_robot = 1, ldframe = 1 }, { c_assembler = 60, }),
	boost = 30,
	boost_id = "move_boost", -- or move_boost
	fuel = false,
	index = 1052,
	race = "robot"
})
function cc_modulespeed:on_add(comp, cause)	
	comp.extra_data.boost_active = true
	self:update_boost(comp,false)
end
function cc_modulespeed:on_remove(comp, cause)	
	comp.extra_data.boost_active = false
	self:update_boost(comp,true)
end
function cc_modulespeed:update_boost(comp, remove)
	--print(self, comp, remove)
	local owner = comp.owner
	--print(comp.id, owner)
	-- set remove when no nill 
	if remove == true then remove = comp end 
	if owner[self.boost_id] == nil then return print("No Boost Id", self.boost_id) end
	owner[self.boost_id] = (owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, remove )
	--print("Updated Boost", self.boost_id, owner[self.boost_id], (owner.def[self.boost_id] or 0))
end
cc_modulespeed:RegisterComponent("cc_modulespeed_s",{
	name = "Small Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 50%]],
	attachment_size = "Small",
	texture = data.components.c_modulespeed_s.texture,
	visual = data.components.c_modulespeed_s.visual,
	production_recipe = CreateProductionRecipe({ engine = 4, steelblock = 9, datakey_robot = 2, ldframe = 2 }, { c_assembler = 60, }),
	boost = 50,
	boost_id = "move_boost", -- or move_boost	
	fuel = false,
	index = 1052,
})
cc_modulespeed:RegisterComponent("cc_modulespeed_m",{
	name = "Medium Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 80%]],
	attachment_size = "Medium",
	texture = data.components.c_modulespeed_m.texture,
	visual = data.components.c_modulespeed_m.visual,
	production_recipe = CreateProductionRecipe({ engine = 9, steelblock = 16, datakey_robot = 4, ldframe = 3 }, { c_assembler = 60, }),
	boost = 80,
	boost_id = "move_boost", -- or move_boost
	fuel = false,
	index = 1052,
})
cc_modulespeed:RegisterComponent("cc_modulespeed_l",{
	name = "Large Movement Speed Module",
	desc = [[Thrusters Increase Unit Speed by 120%]],
	attachment_size = "Large",
	texture = data.components.c_modulespeed_l.texture,
	visual = data.components.c_modulespeed_l.visual,
	production_recipe = CreateProductionRecipe({ engine = 16, steelblock = 25, datakey_robot = 8, ldframe = 4 }, { c_assembler = 60, }),
	boost = 120,
	boost_id = "move_boost", -- or move_boost
	fuel = false,
	index = 1052,
})
-------------------------------------------------------
----- Cube Pedestal -----------------------------------

local update_cube_location = Update_cube_location_global
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
	local i = 0
	while i < 5 do 
		i = i + 1
		local find = owner:FindComponent("cc_crystal_power",true, i)
		-- activate cube power generators 
		if find ~= nil then find:Activate() 
		else break end
	end
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
	if comp.faction:IsUnlocked("tc_cube_anti_0") == false then 
		comp.faction:Unlock("tc_cube_anti_0") end
	-- replace cube and destroy anti cube
	local anti_count = owner:CountItem("ic_cube_sphere") 
	for i, val in ipairs(slots) do 
		if val.stack > 0 then 
			--contains cube 
			local id = val.id
			val:CancelOrders()
			val:Clear()
			--val.RemoveStack(1,true)
			-- only replace cube if there was an odd number of spheres
			if id ~= "ic_cube_sphere"  then 
				if anti_count % 2 == 1 then 
					-- odd number of anti cubes
					val:SetItemAndStack(replace_cube_with[id],1)
				else 
					-- even number of anti cubes
					val:SetItemAndStack(id,1)
				end
			end
		end
	end
	local range = 4
	-- explosion 

	for _,frame in ipairs(Map.GetEntitiesInRange(owner.location, range, FF_OPERATING|FF_WALL|FF_GATE|FF_CONSTRUCTION)) do
		--PlaceResourceNode(frame.location,"blight_crystal",math.random(1,12),"f_resourcenode_blightcrystal",blight_crystal_visuals[math.random(1,#blight_crystal_visuals)])
		frame:RemoveHealth(300, owner, "plasma_damage")
		if frame.health > 0 then 
			-- activate miners
			local count = frame:CountComponents("c_miner",true)
			while count > 0 do 
				local miner = frame:FindComponent("c_miner",true,count) 
				if miner then 
					-- Map.Defer(function ()
					-- 	miner:Activate()
					-- end )
					--miner:SetRegister(1,miner:GetRegister(1))
					miner.extra_data = nil
				end 
				count = count - 1
			end
		end
	end
	-- add time crystals 
	while anti_count > 0 do 
		PlaceResourceNode(owner.location,"blight_crystal",math.random(9,64),"f_resourcenode_blightcrystal",blight_crystal_visuals[math.random(1,#blight_crystal_visuals)])
		anti_count = anti_count - 1
	end
	-- add blight 
	local num = Map.StartTerraforming(owner, range, 100)
	--does this need to be in a defer?
	Map.Defer(function()Map.StopTerraforming(num)end)
	-- notification
	-- need to add an on click method 
	--Notification.Add("cube_explosion", "warning", "CUBE and ANTI-CUBE Annihilation", "The Cube and Anti-Cube where in contact\nThe Anti Cube Exploded leaving behind chrono crystal deposits")
end
local function Update_Cube_Effects(self, comp, cause)
	--print(comp,cause,comp.owner)
	--print(comp.CauseToString(comp,cause))
	--will have passed cube only if all change
	-- TODO check alt recipe hasnt been requested in slot and change it if need be

	if cause & CC_CHANGED_ITEMSLOT_AMOUNT then-- traded cube 
		local owner = comp.owner
		local slot = comp.slots[1]
		local cube_id = slot.id
		--self.boost = -90
		--self:on_update_boosts(comp,{} ,self.boost)
		--BoostModuleOnAdd(self, comp.id)
		local boost_polarity, stop_effects = false, true
		if slot.stack == 0 then 
			-- no cube present 
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
			if comp.extra_data.locked_id ~= nil then
				slot:SetLockedItem(comp.extra_data.locked_id)
				comp.extra_data.locked_id = nil
			end
			return
		elseif cube_id == "ic_cube_red" then
			if self.attachment_size ~= "Hidden" then comp:PlayWorkEffect("fx_refinery","fx") end
			stop_effects = false
			update_cube_location(owner,"ic_cube_red" )
			--comp.light_color = { 0.6,0.1,0,1 }
		elseif  cube_id == "ic_cube_blue" then 
			update_cube_location(owner,"ic_cube_blue" )
		elseif cube_id == "ic_cube_empty" then 
			update_cube_location(owner,"ic_cube_empty" )
		elseif cube_id == "ic_cube_green" then 
			update_cube_location(owner,"ic_cube_green" )
			if self.attachment_size ~= "Hidden" and owner.has_movement then comp:PlayWorkEffect("fx_blight_shield","_entity") end
			boost_polarity = true
			stop_effects = false
		end
		if cube_id == "ic_cube_sphere" then
			comp.light_color = { 1.0, 0.05, 0.0, 4.0}
			--comp:PlayEffect("fx_alien_liquid")
		else 
			comp.extra_power = 201
		end
		-- when any cube has been added 
		comp.extra_data.boost_active = true
		self:update_boost(comp, boost_polarity)
		anti_cube_explosion(comp)
		activate_other_comps(comp)
		if stop_effects then comp:StopEffects() end
		--comp.slots[1].locked = false
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
	texture = "The_Cube_WIP/textures/Cube_Storage.png",
	desc = "Holds the <hl>CUBE</>but slows bots significantly <hl>-80%</>\n\nWill extract <hl>1000</> power while holding a CUBE",
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
	local owner = comp.owner
	-- set remove when no nill 
	if reverse_polarity == true then
		comp.extra_data.boost_active = -1
		owner[self.boost_id] = math.max((owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id ) + self.boost * -2,0)
		return 
	end
	owner[self.boost_id] = math.max((owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, nil ),0)
	--print("Updated Boost", self.boost_id, owner[self.boost_id], (owner.def[self.boost_id] or 0), owner)
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
	wait_ticks = 100,
})
function cc_temp_boost:update_boost(comp, remove)
	local owner = comp.owner
	-- set remove when not nil 
	if remove == true then remove = comp end  
	owner[self.boost_id] = (owner.def[self.boost_id] or 0) + SumActiveModuleBoosts(owner, self.boost_id, remove )
	--print(owner[self.boost_id],owner.def[self.boost_id])
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
		comp:SetStateStartWork(math.floor(self.wait_ticks*comp.owner[self.boost_id]/100))
		--print("temp module ", self.wait_ticks*comp.owner[self.boost_id]/100, comp.owner[self.boost_id])
	end
end

--- Boost Tower controller -------------------------------------
--- 
local cc_boost_tower = Comp:RegisterComponent("cc_boost_tower", {
	name = "Chrono Field Module",
	desc = "Dilates Time around the target unit\n\nRequires Phase Fuel",
	texture = "The_Cube_WIP/textures/chrono_tower_cropped.png",
	get_ui = true,
	power = -100,
	--visual = data.frames.f_beacon_l.visual,
	registers = {
		{ tip = "Chrono Field Target"},
		{ read_only = true, tip = "Requires",},
	},
	fuel = {"ic_time_crystal","ic_soul_plasma"},
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

	if target ~= nil  and target.has_component_list then
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
		local can_make, missing, no_space = comp:PrepareConsumeProcess({[self.fuel[1]]=1, [self.fuel[2]]=1},20)
		if can_make then
			comp:FulfillProcess()
			comp:SetRegister(2)
			comp:SetStateStartWork(self.wait_ticks)
			target:AddComponent("cc_temp_boost")
			comp:StopEffects()
			comp.owner:LookAt(target)
			--comp:PlayEffect("fx_miner","fx",target)--fx_railgun
			comp:PlayEffect("fx_photon_beam","fx",target,{speed=0.01})
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


--Resource Rejeneration 
-- via green cube or anti-cube 

local c_blight_magnifier = data.components.c_blight_magnifier
c_blight_magnifier.name = "Cube Magnifier"
c_blight_magnifier.activation = "OnAnyItemSlotChange"
c_blight_magnifier.desc = "Adds 1000 resources to nodes below 1000\nRequires the Restless Cube"
c_blight_magnifier.registers = {{ read_only = true, tip = "Requires",},{read_only = true, tip = "Target Resource", ui_icon = "icon_target"}}
c_blight_magnifier.magnify_time = 25
c_blight_magnifier.get_ui = nil
c_blight_magnifier.power = -1000
c_blight_magnifier.magnify_limit = 1000
c_blight_magnifier.production_recipe = CreateProductionRecipe(
{wire = 12, ic_soul_happy = 1, crystal_powder = 4},{c_assembler = 30})

c_blight_magnifier.on_update = function(self, comp, cause)

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
		return
	end
	
	local ent = comp:GetRegisterEntity(2)
	if cause & CC_FINISH_WORK > 0 and ent ~= nil then
		-- replace cube 
		comp:CancelProcess()
		ent:SetRegisterNum(FRAMEREG_GOTO,ent:GetRegisterNum(FRAMEREG_GOTO)+self.magnify_limit)
		ent:PlayEffect("fx_heal_unit")
		comp:SetRegister(2)
		comp:SetStateSleep(1)
		ent = nil
	end

	-- look for new resource
	if ent == nil then 
		ent = Map.FindClosestEntity(owner, self.range, function(e)
			if e:GetRegisterNum(FRAMEREG_GOTO) < self.magnify_limit then
				--e:SetRegisterNum(FRAMEREG_STORE, 1) -- mark as magnified (see c_miner:on_update)	
				return true 
			end
		end, FF_RESOURCE)
		if ent == nil then 
			comp:SetStateSleep(100)
			comp:SetRegister(2)
			comp:FlagRegisterError(2)
			comp:CancelProcess()
			return 
		end
	end
	-- check if finished working and regenerate

	-- get resource 

	-- request the cube 
	comp:SetRegisterEntity(2,ent)
	local can_make, missing = comp:PrepareConsumeProcess({ic_cube_green = 1})
	if can_make == false then 
		comp:SetRegister(1,missing)
		comp:FlagRegisterError(1)
		comp:SetStateSleep(10000)
	else
		comp:PlayWorkEffect("fx_alien_liquid")
		comp:SetRegister(1)
		comp:FlagRegisterError(1,false)
		comp:SetStateStartWork(self.magnify_time, false)
	end
end
function c_blight_magnifier:get_reg_error(comp)
	if comp:RegisterIsError(1) then
		return "Missing the Cube"
	elseif	comp:RegisterIsError(2) then 
		return "No Resource To Regenerate Nearby"
	end
end
function c_blight_magnifier:on_add(comp)
	comp:Activate()
end
	
--  attempt to make blight crystals dissapear over time but resource nodes dont update
local cc_unstable_resource = Comp:RegisterComponent("cc_unstable_resource",{
	name = "Unstable Resource",
	desc = "Reduces Resource over time",
	activation = "Manual",
	texture = data.items.blight_crystal.texture,
	wait_ticks = 10,
})
function cc_unstable_resource:on_add(comp,cause)
	comp:Activate()
end
function cc_unstable_resource:on_update(comp,cause)
	
	if comp.is_working then 
		comp:SetStateContinueWork()
	else
		local owner = comp.owner 
		local new_number = owner:GetRegisterNum(FRAMEREG_GOTO) - 1
		if new_number <= 0 then 
			owner:Destroy()
			return 
		end
		owner:SetRegisterNum(FRAMEREG_GOTO,new_number)
		comp:SetStateStartWork(self.wait_ticks)

	end
end


-- this is just to test research progression 
local cc_cheat_tech = Comp:RegisterComponent("cc_cheat_tech",{
	name = "Unstable Cheat",
	desc = "Reduces Resource over time",
	activation = "OnComponentRegisterChange",
	texture = data.items.blight_crystal.texture,
	get_ui = true,
	registers = {{ tip = "Research to cheat"}}
})

function cc_cheat_tech:on_update(comp, cause)
	local reg = comp:GetRegisterId(1)

	if reg then 
		comp.faction:Unlock(reg)
	end


end

