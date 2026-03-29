


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
local cc_crop_grow = Comp:RegisterComponent('cc_crop_grow',{
    -- wait a set amount of time 
    -- grow the crop at the end 
    -- keep plant data. d
})

local fc_crop = Frame:RegisterFrame('fc_crop',{
    name = 'Planted Crop',
    desc = 'Budding Growth',
    size = 'Other',
    race = "alien",
	is_flower = true,
    minimap_color = { 0, 1, 0 },
    visual = "v_damage_plant",
    texture = "Main/textures/icons/frame/powerflower_frame.png",
    drop = 'phase_leaf',
})




function fc_crop:on_destroy(entity, damager)
	if not damager or entity.faction.is_player_controlled then return end
	Map.DropItemAt(entity.location, fc_crop.drop, ((1 * fc_crop.extra_data.yield) or 1), "f_dropped_resource")
end

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
        local can_make, missing, has_slot = comp:PrepareConsumeProcess(self.ingriedents,1)
        -- start working 
        print( can_make, missing, has_slot)
        if can_make then 
            -- check for free space 
            local x, y = find_plantable_position(self, comp)
            if x == nil then 
                -- no space in range 
                comp:SetRegisterCoord(1, nil)
                comp:FlagRegisterError(1)
                comp:CancelProcess()
                comp:SetStateSleep(200)

            else 
                -- start working
                comp:SetStateStartWork(self.wait_ticks) 
                comp:SetRegisterCoord(1, {x = x, y = y})
                comp:SetRegister(2)
            end 
        else
            -- wait for items to arrive
            comp:SetRegister(2,missing)
            if has_slot ~= false then 
                comp:FlagRegisterError(2)
            else 
                comp:FlagRegisterError(2)
            end
            comp:SetStateSleep(50)
        end
    end
end





































----- planter not based on cc_crystal_power




--- entity:area and size 
--- entity:inRangeTo






