
-- power calculations 
-- manifest is -1000 / tick 
--- cube log takes 25 ticks to craft 
--- 25 000 power needed per craft 
--- -- base 500 p/t from cube 
---  
--- Crystal power should be able to handle 1 craft 
--- so 500p/t for 25 s
--- 10000 

--- Red Power 
--- Should be able to take 50 crafts?
--- 500000




-------------------------------------------------------
----- Crystal Power with Cube -----------------------------------
-- local function battery_get_ui(self, comp)
-- 	return UI.New([[<Box padding=4><Progress valign=center width=54 height=54 progress={progress} bg=progress_mask orientation=vertical color={color} bgcolor=ui_dark/></Box>]], {
-- 		compicon = comp.def.texture,
-- 		update = function(w)
-- 			local comp_def, comp_details = comp.def, comp.power_details
-- 			if comp_details then
-- 				w.progress = comp_details.stored / comp_def.power_storage
-- 				if w.tt then
-- 					w.tt.text = L((comp_details.change ~= 0 and "%s: %.0f/%.0f (%+.0f)" or "%s: %.0f/%.0f"), "Stored", comp_details.stored, comp_def.power_storage, comp_details.change*TICKS_PER_SECOND)
-- 				end
--                 local target = comp:GetRegisterNum(1)
--                 if (target or 1) >= comp.stored_power / self.power_storage * 100 then
--                     -- below target
--                     w.color = "yellow"
--                     if w.tt then w.tt.text = w.tt.text .. "Battery Below Percentage: Requesting Recharge" end 
--                 else 
-- 					if comp.stored_power > self.power_storage / 2 then 
-- 						w.color = "ui_light"
-- 						if w.tt then w.tt.text = w.tt.text .. "Battery above 50% does not need to recharge" end
-- 					else 
-- 						w.color = "green"
-- 						if w.tt then w.tt.text = w.tt.text .. "Battery above target percentage but below 50%" end
-- 					end
--                 end
-- 			end
-- 		end,
-- 		tooltip = function(w)
-- 			w.tt = UI.New("<Box bg=popup_box_bg padding=12><Text/></Box>", { destruct = function() if w:IsValid() then w.tt = nil end end })[1]
-- 			w:update()
-- 			return w.tt.parent
-- 		end,
-- 	})  
-- end
local cc_crystal_power = Comp:RegisterComponent("cc_crystal_power", {
	name = "Crystal Power", --"Crystal Power Extractor",
	texture = "Main/textures/icons/components/component_crystalpower_01_s.png",
	desc = [[Produces a small amount of power with the cube and crystals
		<img width="50" height="50" image="Main/textures/icons/items/robot_research_cube.png"/><img width="50" height="50" image="Main/textures/icons/items/rawcrystal.png"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" image="Main/textures/icons/items/robot_research_cube.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
Will Recharge when target register is below units battery percentage
Power output is effected by component effciency boosts.]],
	attachment_size = "Small",
	visual = "v_crystalpower_01_s",
	race = "robot",
	production_recipe = CreateProductionRecipe({ metalplate = 5, crystal = 10 }, { c_assembler = 20 }),
	activation = "OnPowerStoredEmpty|OnComponentRegisterChange",
	--get_ui = battery_get_ui,
	adjust_light_color = true,
	consume_list = {ic_cube_blue = 1, crystal = 1},
	--output_list = {bug_carapace = 1},
	cube_out = "ic_cube_blue",
	charge_time = 120*5,--matches def tooltip
	drain_rate = 100,--matches def tooltip
	power = 0,
	rgb = {0,1,1},
	-- battery
	adjust_extra_power = true,
    registers = {{filter = "number", ui_icon = "icon_small_battery" , tip = "Battery Percentage to Request Recharge [ 0 - 100 ]"},
	{ read_only = true, tip = "Power Production" }}
}) -- "Main/skin/Icons/Common/32x32/Battery.png"
function cc_crystal_power:on_update(comp, cause)
	-- on_update is also called when work has finished, only refill stored power when actually on low power
	if comp.is_working then
		--print(1 - comp.ticker / comp.ticker_target)
		comp.light_color = {self.rgb[1],self.rgb[2],self.rgb[3], (1 - comp.ticker / comp.ticker_target) * 3}
		return comp:SetStateContinueWork()
	end
	comp.light_color = {self.rgb[1],self.rgb[2],self.rgb[3], 0}
    local target = comp:GetRegisterNum(1)
    if (target or 1) >= comp.owner.battery_percent or 0  then
        -- Perform Recharge
        local can_make, missing, no_space = comp:PrepareProduceProcess(self.consume_list,self.output_list,2)
        if not can_make then
			-- wait for materials 
            comp:FlagRegisterError(1)
            comp:SetStateSleep(50)
			comp.extra_power = 0
			comp:SetRegisterNum(2,0)
			--comp:StopEffects()
            return
        end
		-- recharge now
        comp:FlagRegisterError(1,false)
        comp:FulfillProcess()
        AddCubeThroughFixed(comp.owner,self.cube_out)
		comp.extra_power = math.floor(self.drain_rate * (comp.effective_boost/100))
		comp:SetRegister(2, { id = "v_power_production", num = comp.extra_power  * TICKS_PER_SECOND })

		comp.light_color = {self.rgb[1],self.rgb[2],self.rgb[3], 3}
        comp:SetStateStartWork(self.charge_time,5)
		-- check batteries are on frame // maybe just give it a small battery?
		if comp.owner.battery_total == 0 then 
			comp:FlagRegisterError(1)
		end
		--comp:PlayWorkEffect('fx_power_core')
	else
		-- go to sleep until it needs to charge
        comp:CancelProcess()
		comp:FlagRegisterError(1,false)
		comp:SetRegisterNum(2,0)
		-- check every 10 seconds if power is below target 
        comp:SetStateSleep(100)
		comp.extra_power = 0
		--comp:StopEffects()
    end
end
function cc_crystal_power:on_add(comp)
    if comp:RegisterIsEmpty(1) == true then 
		comp:SetRegisterNum(1,50) 
	end
end
function cc_crystal_power:get_reg_error(comp)
	if comp.owner.battery_total == 0 then 
		return "Building has no battery storage\nTherefore will not stop producing"
	else
    	return "Missing Inputs to produce power\nor no space for output"
	end
end
cc_crystal_power:RegisterComponent("cc_crystal_power_red",{
	name = "Fury Cube Power Engine", --"Crystal Power Extractor",
	texture = "Main/textures/icons/components/component_blightcrystalpower_01_m.png",
	desc = [[Requires extreme heat to vaporize crystal powders
<img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="crystal_powder"/><img width="50" height="50" id="ic_soul_plasma"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" id="ic_soul_angry"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
Will Recharge when input register is below units battery %
Power output is effected by component effciency boosts.]],
	visual = 'v_blightcrystalpower_01_m',
	production_recipe = CreateProductionRecipe({reinforced_plate = 20, concreteslab = 20, wire = 6 },{c_assembler = 60}),
	rgb = {1, 0.3, 0},
	consume_list = {crystal_powder = 4,ic_soul_plasma = 10, ic_cube_red = 1},
	output_list = {ic_soul_angry = 1},
	cube_out = "ic_cube_empty",
	charge_time = 300*5,
	drain_rate = 2000,
})

-----------------------------------------------------------------------------
-- these ones dont need the cube so are just a copy of crystal power base game
data.components.c_crystal_power:RegisterComponent("cc_power_souls",{
	name = "Soul Consumption", --"Crystal Power Extractor",
	texture = 'Main/textures/icons/components/Component_PowerCell_01_S.png',
	desc = [[Consumes Soul Plasma for energy 
<img width="50" height="50" id="ic_soul_plasma"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
Requires drastically less Cube time compared to crystal power]],
	visual = "v_power_cell_01_s",
	power_storage = 10000,
	drain_rate = 500,
	consume_item = "ic_soul_plasma",
	wait_ticks = 25,
	production_recipe = CreateProductionRecipe({wire = 4, crystal_powder = 8, steelblock = 4},{c_assembler = 60}, 1)
})
data.components.c_crystal_power:RegisterComponent("cc_power_phase",{
	name = "Phase Fuel Generator", --"Crystal Power Extractor",
	texture = 'Main/textures/icons/components/Component_PowerCell_01_S.png',
	desc = [[Consumes Phase Fuel for energy 
<img width="50" height="50" id="ic_fuel"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
Less effcient but very portable]],
	visual = "v_power_cell_01_s",
	power_storage = 50000,
	drain_rate = 1000,
	consume_item = "ic_fuel",
	wait_ticks = 20,
	production_recipe = CreateProductionRecipe({wire = 4, crystal_powder = 8, steelblock = 4},{c_assembler = 60}, 1)
})