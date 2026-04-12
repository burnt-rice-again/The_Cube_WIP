
local flower_png = "Main/textures/icons/values/flower.png"
local icon_seed = "<Image image=icon_small_seed color=ui_light margin_right=8/>"



local function plant_get_ui(self, comp)
	return UI.New([[<Box padding=4><Progress valign=center width=54 height=54 progress={progress} bg=progress_mask orientation=vertical color=virus bgcolor=ui_dark/></Box>]], {
		compicon = comp.def.texture,
		update = function(w)
			local growth = comp.extra_data.growth
			if growth then
				w.progress = growth / (self.growth_max + comp.extra_data.yield * 10)
				if w.tt then
					w.tt.text = L(("%s: %.0f/%.0f"), "Growth", growth, self.growth_max + comp.extra_data.yield * 10)
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
local function plant_on_add_extra_data(self, comp)
    --print("add comp plant", self, comp.extra_data)
    --if not comp.has_extra_data then comp.
    if (not comp.has_extra_data) or comp.extra_data.growth == nil then comp.extra_data = {growth = 0, growth_speed = 1, yield = 1} end
    -- if  then
    --     comp.extra_data = {growth = 0, growth_speed = 1, yield = 1}
    -- end 
    comp:SetRegisterNum(1, comp.extra_data.growth_speed)
    comp:SetRegisterNum(2, self.consume_amount)
    comp:SetRegisterId(2, self.consume_item)
    comp:SetRegisterId(3, self.future_yield ,comp.extra_data.yield)
    --print(comp.extra_data)
    comp:Activate()
    --comp:on_update(comp, cause)
end

local function calc_true_yield(self, comp)
    if self.base_prod_out then return self.base_prod_out
        -- local full_yield = self.base_prod_out
        -- --print(pairs(full_yield))
        -- for k,v in pairs(full_yield) do
        --     full_yield[k] = v * comp.extra_data.yield
        -- end
        -- return full_yield
    else 
        return {}
    end
end


-- occasionaly increases/decreases plant stats, will improve slightly more frequently
local function randomize_plant_stats(current)

    local increase_chance = 0.15
    local decrease_chance = 0.05
    local random = math.random()
    if random < decrease_chance and current > 1 then return -1
    elseif random < increase_chance then return 1 end
    return 0
end 
local function create_seed_copy(owner, e_data, seed_id)
    if math.random() > 0.9 or true then
        Map.Defer(function()
            owner:AddItem(seed_id,1,false,Tool.Copy(e_data))
        end) 
    end
end 

local function appl_reg_links(ent, tbl)
    for i,v in ipairs(tbl) do 
        ent:LinkRegisterFromRegister(v.index, v.source_index)
    end
end 
-- at this stage it consumes fertilizer to progress
local cc_plant_seed = Comp:RegisterComponent("cc_plant_seed", {
    name = "Phase Flower Bud",
	attachment_size = "Small",
	texture = "The_Cube_WIP/textures/phase_seed.png",
	desc = "",
	visual = "v_succulent_01",--"",v_phase_plant
	race = "virus",
	production_recipe = CreateProductionRecipeWithWaste({ ic_cube_green = 1,crystal_powder = 16, phase_leaf = 5 }, { cc_manifest = 30 },1, {ic_cube_green = 1}),
    --power_storage = 1,
    -- UI
    get_ui = plant_get_ui,
    activation = "OnAnyItemSlotChange",
    effect = "fx_greensplat_2",
    on_add = plant_on_add_extra_data,
    --on_placed = plant_on_add_comp,
    --plant stats 
    wait_ticks = 60,
    growth_max = 10,
    -- plant consumption
    consume_item = "crystal",
    consume_amount = 1,
    --plant output
    next_comp = "cc_plant_harvest",
    future_yield = "phase_leaf",
	--dumping_ground = true,
	registers = {
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Growth Effciency</>\n\nGrowth provided per input step\n\nReduces Amount of resources and time to grow the plant"},
        { read_only = true, ui_icon = "icon_small_seed", tip = "Plant Requires"},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Yield</>\n\nMultiplies the amount of items produced"},
	},
})

cc_plant_seed:RegisterComponent("cc_plant_harvest",{
    name = "PhaseFlower",
	attachment_size = "Small",
	texture = "Main/textures/icons/frame/powerflower_frame.png",
	desc = "Concentrated crystals push this flower to new vibrant colours",
	visual = "v_damage_plant",
    production_recipe = false,
    --plant stats 
    growth_max = 1,
    -- plant consumption
    consume_item = "ic_cube_green",
    consume_amount = 1,
    --plant output
    next_comp = "cc_plant_seed",
    cube_out = "ic_cube_green",
    base_prod_out = {["phase_leaf"] = 1},
})

----crystal leaf 
cc_plant_seed:RegisterComponent("cc_plant_seed2",{
    name = "Conductive Fibre Seed",
	texture = "The_Cube_WIP/textures/plant_seed_reed.png",
	desc = "Spins Souls Into Wire Perfect for Higher Though Processes",
	visual = "v_succulent_05_A",
    production_recipe = CreateProductionRecipeWithWaste({ ic_cube_green = 1,bug_carapace = 10, phase_leaf = 5 }, { cc_manifest = 30 },1, {ic_cube_green = 1}),
    --plant stats 
    growth_max = 90,
    -- plant consumption
    consume_item = "crystal",
    consume_amount = 1,
    --plant output
    next_comp = "cc_plant_harvest2",
    future_yield = "wire",
})

cc_plant_seed:RegisterComponent("cc_plant_harvest2",{
    name = "Neurotic Fibre Flower",
	attachment_size = "Small",
	texture = "Main/textures/icons/frame/powerflower_frame.png",
	desc = "The wailing has ceased",
	visual = "vc_sea_grass",
    production_recipe = false,
    --plant stats 
    growth_max = 1,
    -- plant consumption
    consume_item = "ic_cube_green",
    consume_amount = 1,
    --plant output
    next_comp = "cc_plant_seed2",
    cube_out = "ic_cube_green",
    base_prod_out = {["wire"] = 1},
    future_yield = "wire",
})

function cc_plant_seed:on_update(comp, cause)

	-- If still working from before but gotten activated again just continue work
	if cause & CC_FINISH_WORK == 0 and comp.is_working then
		return comp:SetStateContinueWork()
	end

	-- on_update is also called when work has finished, only refill stored power when actually on low power
    if comp.extra_data.growth == nil then plant_on_add_extra_data(self, comp) return end

	if comp.extra_data.growth >= self.growth_max + comp.extra_data.yield * 10 then  
        -- growth completed
        if comp.has_prepared_process then comp:FulfillProcess() end
        local random_range
        local owner = comp.owner
        -- randomize stats  
        comp.extra_data.growth_speed = comp.extra_data.growth_speed + randomize_plant_stats(comp.extra_data.growth_speed)
        comp.extra_data.yield = comp.extra_data.yield + randomize_plant_stats(comp.extra_data.yield)
        --print(comp.extra_data, math.max(comp.extra_data.growth_speed + math.random(3) - math.random(2), 1))
        
        Map.Defer(function() 
            local next_comp = self.next_comp
            local e_data = comp.extra_data
            local socket_num = comp.socket_index
            e_data.growth = 0 
            local links = comp.owner:GetRegisterLinks()
            if self.cube_out then 
                --create extra seed
                create_seed_copy(owner, e_data, next_comp)
            end
            --local seed_id = comp.id
            comp:Destroy()
            --print(e_data)
            -- go to next growth stage 
            owner:AddComponent(next_comp, socket_num, e_data) 
            appl_reg_links(owner,links)

            --Delay.Spawn_Crystal_Wave({yield = 30})
        end
        )

    end
    -- check if timer completed 
    if cause & CC_FINISH_WORK == 2 and comp.has_prepared_process then 
        -- complete process
        comp:FulfillProcess()
        comp.extra_data.growth = comp.extra_data.growth + comp.extra_data.growth_speed
        -- rebuild cube if necesary
        if self.cube_out then comp.owner:AddItem(self.cube_out, 1) end

        return 
    end 


    local can_make, flag_missing, flag_space = comp:PrepareProduceProcess({[self.consume_item] = self.consume_amount }, calc_true_yield(self, comp))
	if not can_make then
        if flag_missing then comp:FlagRegisterError(2) end
        if flag_space then comp:FlagRegisterError(3) end 
		return comp:SetStateSleep(25)
    else 
        comp:FlagRegisterError(2, false)
        comp:FlagRegisterError(3, false)
    end
	-- Start a 20 tick work until we can consume another crystal
	return comp:SetStateStartWork(self.wait_ticks)
end

function cc_plant_seed:get_reg_error(comp)
	--local reg1 = comp:GetRegister(1)
	local reg2 = comp:GetRegister(2)
    local reg3 = comp:GetRegister(3)
	-- if reg1.is_error then 
	-- 	return ""
	-- end 
    if reg2.is_error then 
		return "Missing Input"
	end
	if reg3.is_error then 
		return "No Space for More Output"
	end
end 

-- function Delay.Spawn_Crystal_Wave(arg) 

-- 	-- spawn bug 
-- 	-- local enemy = Map.CreateEntity("bugs","f_trilobyte1")
-- 	-- enemy:Place(arg.owner.location,arg.owner)

-- 	--spawn robot 
-- 	local enemy = Map.CreateEntity("anomaly","f_resourcenode_crystal")
-- 	enemy:Place(arg.owner.location,arg.owner)
-- 	enemy:PlayEffect("fx_digital_in")

-- 	if arg.yield > 5 then 
-- 		Map.Delay("Spawn_Time_Travel_Attack", 5, {owner = arg.owner, yield = arg.yield - 25})
-- 	end
-- end