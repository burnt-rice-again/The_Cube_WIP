


--- each seed will have some properties 
---     speed
---     yield 
---     growth speed 

--- as a component will use the green cube to plant flowers on surrounding tiles
--- tiles must have no foundations 
--- 
--- planted seeds will change into harvestable flowers after some time
--- 
--- no resource input?
--- 
--- 


local cc_crop_grow = Comp:RegisterComponent('cc_crop',{
    -- wait a set amount of time 
    -- grow the crop at the end 
    -- keep plant data. d
    name = "plant growth",
    desc = "Will grow the plant once the work completes",
    texture = "The_Cube_WIP/textures/phase_seed.png",
    
    next_frame = "fc_crop",
    base_id = "cc_crop",
    
    on_add = function(self, comp) comp:SetStateStartWork(100)  end,

	registers = {
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Growth Time</>\n\nHow many simulation ticks it will take the crop to grow\n\nDivide by 5 for seconds"},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Yield</>\n\nMultiplies the amount of items produced"},
    },
    -- will have extra_data.key to find planter
})

local function wake_up_planter(self, entity)
    -- get component 
    local comp = entity:FindComponent("cc_crop", true)
    if comp ~= nil and comp.has_extra_data and comp.extra_data.planter_key then
        -- drop yield if it has a drop property
        if self.drop then 
            Map.DropItemAt(entity.location, self.drop, ((1 * self.extra_data.yield) or 1), "f_dropped_resource")
            -- TODO drop seedling
        
        end



        -- get planter key from extra data
        local planter_frame = Map.GetEntityFromKey(comp.extra_data.planter_key)
        if planter_frame then
            -- retrieve planter componet
            local plant_comp = planter_frame:FindComponent("cc_planter", true)
            if plant_comp then 
                print("WAKE UP!")
                plant_comp:Activate()
            end
        end
    end
end

local fc_crop = Frame:RegisterFrame('fc_crop',{
    name = 'Planted Crop',
    desc = 'Budding Growth',
    size = 'Other',
    race = "alien",
	is_flower = true,
    minimap_color = { 0, 1, 0 },
    visual = "v_succulent_01",
    texture = "The_Cube_WIP/textures/phase_seed.png",

    drop = 'phase_leaf',
    next_frame = 'fc_crop_wire_plant',

    on_destroy = wake_up_planter,
    on_remove = wake_up_planter,
    
})

fc_crop:RegisterFrame('fc_crop_wire_seed0',{
    name = 'Wire Weed Seedling',
    desc = 'This weed grows hair made of conductive fibre\n it grows fast and without any fertilzer',
    drop = nil,
})




















--- PLANTER 

                -- Map.Defer( function()
                --     print('placing plant')
                --     local plant = Map.CreateEntity('world', 'fc_wire_plant')
                --     plant:Place(dx,dy)
                -- end)
-- wire seeds

local function is_pos_plantable(comp, x,y, range)
    local owner = comp.owner
    return owner:IsInRangeOf({x, y}, range) and Map.GetEntityAt(x,y, FF_OWNFACTION | FF_ENEMYFACTION | FF_NEUTRALFACTION | FF_ALLYFACTION, comp.faction ) == nil 
    -- todo check for frames as well?
end

local function find_plantable_position(self, comp)
    local owner = comp.owner
    local area = owner.area
    local x, y, w, h = area[1], area[2], area[3]-1, area[4]-1
    local range = self.range
    for dx = x-w-range, x+w+range, 1 do
        for dy = y-h-range, y+h+range, 1 do
            -- check in range and no foundation and 
            --print( is_pos_plantable(comp,dx,dy,range), dx, dy)
            if is_pos_plantable(comp,dx,dy,range) then 
                -- place see 
                return dx,dy
            end
        end
    end
    return nil, nil
end



local cc_planter = Comp:RegisterComponent('cc_planter',{
    name = 'Seed Planter',
    texture = "The_Cube_WIP/textures/phase_seed.png",
    desc = "DO NOT SHOW",
    visual = "v_succulent_01",
    production_recipe = CreateProductionRecipeWithWaste({ ic_cube_blue = 1 }, { cc_manifest = 30 },1, {ic_cube_blue = 1}),
    range = 2,
    attachment_size = 'Small',
    activation = 'OnAnyItemSlotChange',
    wait_ticks = 100,
    --recipe
    ingriedents = { ic_cube_green = 1}, -- can add additional inputs here
    output = {}, -- can add additional outputs here
    output_cube = 'ic_cube_green',
    
    registers = {
		{ read_only = true, type = "Target", tip = "Planting seed at", ui_icon = "icon_target", },
		{ read_only = true, tip = "Requires",},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Growth Time</>\n\nHow many simulation ticks it will take the crop to grow\n\nDivide by 5 for seconds"},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Yield</>\n\nMultiplies the amount of items produced"},
	},
})

function cc_planter:on_add(comp)
    -- set extra data 
    if comp.has_extra_data == false then 
        comp.extra_data.yield = 1
    end
    -- start working 

    -- request green cube 

    comp:Activate()
end




function cc_planter:get_reg_error(comp)
   
    if comp:RegisterIsError(1) then 
        return "No Free Space In Range\nMust have no foundations to plant"
    elseif comp:RegisterIsError(2) then 
        if comp.owner:FindComponent("cc_cube_storage") == nil then 
            return "No CUBE pedastal"
        else
            return "Missing Items"
        end
    end
end 

local function clear_planter_position(comp) 
    comp:SetRegisterCoord(1, nil)
    comp:FlagRegisterError(1)
    comp:CancelProcess()
    comp:SetRegister(2)
end


function cc_planter:on_update(comp, cause)
    -- activated 
    --print(cause, cause & CC_FINISH_WORK == true)
    if cause & CC_FINISH_WORK > 0  then 
        local cord = comp:GetRegisterCoord(1)
        if not cord then 
            -- no coordinate
            
            return 
        end
        -- place crop 
        -- TODO change this 
        if is_pos_plantable(comp,cord.x ,cord.y ,self.range) then 
            -- Fufill Process 
            comp:FulfillProcess()
            comp.owner:AddItem(self.output_cube)
            

            --place crop 
            Map.Defer( function()
            --print('placing plant')
            local plant = Map.CreateEntity(comp.faction, 'fc_wire_plant')
            plant:Place(cord.x,cord.y)
                -- add turn and throw effect 
            end)
        else 
            comp:FlagRegisterError(2,"Can no longer Plant At Target")
            comp:CancelProcess()
            comp:Activate()

        end
    elseif comp.is_working == true then 
        -- continue working 
        --print("back to work")
        comp:SetStateContinueWork()
    else

        -- is a spot already choosen 
        local cord = comp:GetRegisterCoord(1)
        local check = false
        if cord == nil then
            local x, y = find_plantable_position(self, comp)
            
            if x == nil then 
                --- could not find pos
                clear_planter_position(comp)
                comp:SetStateSleep(2000)
                print("NO cord found")
                return
            else 
                cord = {x = x, y = y}
                comp:SetRegisterCoord(1, cord)
                check = true 
            end
        end
        local can_make, missing, has_slot = comp:PrepareConsumeProcess(self.ingriedents,1)
        -- start working 
        print( can_make, missing, has_slot)
        if can_make then 

            if check or is_pos_plantable(comp,cord.x ,cord.y ,self.range) then
            -- start working
                comp:SetStateStartWork(self.wait_ticks) 
                comp:SetRegisterCoord(1, cord)
                comp:SetRegister(2)
            else
                clear_planter_position(comp)
                comp:SetStateSleep()
            end
        else
            -- wait for items to arrive
            comp:SetRegister(2,missing)
            if has_slot ~= false then 
                comp:FlagRegisterError(2)
            else 
                comp:FlagRegisterError(2)
            end
            comp:SetStateSleep(500)
        end
    end
end





































----- planter not based on cc_crystal_power




--- entity:area and size 
--- entity:inRangeTo






