
-------------------------------------------------------
----- Crystal Power with Cube -----------------------------------
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
		<img width="50" height="50" image="Main/textures/icons/items/robot_research_cube.png"/><img width="50" height="50" image="Main/textures/icons/items/rawcrystal.png"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" image="Main/textures/icons/items/robot_research_cube.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
	]],
	attachment_size = "Small",
	visual = "v_crystalpower_01_s",
	race = "robot",
	production_recipe = CreateProductionRecipe({ metalplate = 5, crystal = 10 }, { c_assembler = 20 }),
	activation = "OnPowerStoredEmpty|OnComponentRegisterChange",
	get_ui = battery_get_ui,
	consume_item = "crystal",
	consume_amount = 1,
	cube_in = "ic_cube_blue",
	cube_out = "ic_cube_blue",
	wait_ticks = 30,
	-- battery
	power_storage = 10000,
	drain_rate = 400,
    registers = {{filter = "number", icon = "icon_number", tip = "Battery Percentage to Request Recharge [ 0 - 100 ]"}}
})

function cc_crystal_power:on_update(comp, cause)
	-- on_update is also called when work has finished, only refill stored power when actually on low power
	if comp.is_working then
		return comp:SetStateContinueWork()
	end
    local target = comp:GetRegisterNum(1)
    if (target or 1) >= comp.stored_power / self.power_storage * 100 then
        -- Perform Recharge
        local can_make = comp:PrepareConsumeProcess({[self.consume_item] = self.consume_amount, [self.cube_in] = 1}, 2)
        if not can_make then
            comp:FlagRegisterError(1)
            comp:SetStateSleep(50)
            return
        end
        comp:FlagRegisterError(1,false)
        comp:FulfillProcess()
        comp.owner:AddItem(self.cube_out)
        comp.stored_power = self.power_storage
        comp:SetStateStartWork(self.wait_ticks)
	elseif comp.has_prepared_process == true then 
        comp:CancelProcess()
        comp:SetStateSleep(50)
    end 
end
function cc_crystal_power:get_reg_error(comp)
    return "Missing Inputs to produce power"
end


-- cc_crystal_power:RegisterComponent("cc_crystal_power_red",{
-- 	name = "Fury Cube Power Engine", --"Crystal Power Extractor",
-- 	texture = "Main/textures/icons/components/component_blightcrystalpower_01_m.png",
-- 	desc = [[Requires extreme heat to vaporize crystal powders
-- <img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="crystal_powder"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>]],
-- 	visual = 'v_blightcrystalpower_01_m',
-- 	power_storage = 500000,
-- 	drain_rate = 2000,
-- 	consume_item = "crystal_powder",
-- 	consume_amount = 10,
-- 	cube_in = "ic_cube_red",
-- 	attachment_size = "Small",
-- 	wait_ticks = 100,
-- 	production_recipe = CreateProductionRecipe({reinforced_plate = 20, concreteslab = 20, wire = 6 },{c_assembler = 60})
-- })
-- data.components.c_crystal_power:RegisterComponent("cc_power_souls",{
-- 	name = "Soul Consumption", --"Crystal Power Extractor",
-- 	texture = 'Main/textures/icons/components/Component_PowerCell_01_S.png',
-- 	desc = [[Consumes Soul Plasma for energy 
-- <img width="50" height="50" id="ic_soul_plasma"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
-- Requires drastically less Cube time compared to crystal power]],
-- 	visual = "v_power_cell_01_s",
-- 	power_storage = 5000,
-- 	drain_rate = 50,
-- 	consume_item = "ic_soul_plasma",
-- 	wait_ticks = 11,
-- 	production_recipe = CreateProductionRecipe({wire = 4, crystal_powder = 8, steelblock = 4},{c_assembler = 60}, 1)
-- })
-- data.components.c_crystal_power:RegisterComponent("cc_power_phase",{
-- 	name = "Phase Fuel Generator", --"Crystal Power Extractor",
-- 	texture = 'Main/textures/icons/components/Component_PowerCell_01_S.png',
-- 	desc = [[Consumes Phase Fuel for energy 
-- <img width="50" height="50" id="ic_fuel"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>
-- Less effcient but very portable]],
-- 	visual = "v_power_cell_01_s",
-- 	power_storage = 50000,
-- 	drain_rate = 200,
-- 	consume_item = "ic_fuel",
-- 	wait_ticks = 11,
-- 	production_recipe = CreateProductionRecipe({wire = 4, crystal_powder = 8, steelblock = 4},{c_assembler = 60}, 1)
-- })