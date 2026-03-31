


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
--- extra data table inlcudes
---  
-- {
--     key = entity key
--     yield = comp.extra_data.yield or 1,
--     growth_time = comp.extra_data.growth_time or 100,
-- }




local cc_crop = Comp:RegisterComponent('cc_crop',{
    -- wait a set amount of time 
    -- grow the crop at the end 
    -- keep plant data. d
    name = "plant growth",
    desc = "Will grow the plant once the work completes",
    texture = "The_Cube_WIP/textures/wire_seed.png",
    activation = 'Manual',

    attachment_size = "Hidden",
    race = 'robot',
    --visual = "v_generic_i",

	registers = {
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Growth Time</>\n\nHow many simulation ticks it will take the crop to grow\n\nDivide by 5 for seconds"},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Yield</>\n\nMultiplies the amount of items produced"},
    },
    production_recipe = false,
    index = 9999,
    slots = {anomaly = 1},

    get_ui = true, -- needs this to show hidden components
    -- will have extra_data.key to find planter
})

function cc_crop:on_update(comp, cause) 

    -- set registers on placed
    if comp:RegisterIsEmpty(1) then 
        comp:SetRegister(1,{Id = comp.owner.def.drop, Num = comp.extra_data.yield or 1})
        comp:SetRegister(2,{ Num = comp.extra_data.growth_time or 100})
    end

    if cause & CC_FINISH_WORK ~= 0 then 
        -- finished growing 
        local owner = comp.owner
        local next_frame = owner.def.next_frame
        if next_frame == nil then return end 

        Map.Defer( function()
        local plant = Map.CreateEntity(comp.faction,next_frame )
        local crop = plant:AddComponent('cc_crop','hidden',comp.extra_data)
        local cord = owner.location
        owner:Unplace()
        owner:Destroy()
        plant:Place(cord,plant,false)
        end)

    elseif comp.is_working then 
        -- go back to sleep
        comp:SetStateContinueWork()
    elseif comp.owner.def.next_frame ~= nil then
        comp:SetStateStartWork(comp.extra_data.growth_time or 100)
    else 
        print("Stop growing")
    end
end

function cc_crop:on_add(comp)
    -- set extra data 
    if comp.has_extra_data == false then 
        comp.extra_data.yield = 1
        comp.extra_data.growth_time = 300
    end
    comp:SetRegister(1,comp.extra_data.growth_time)
    comp:SetRegisterNum(2, comp.extra_data.yield)
    comp:SetRegisterId(2,comp.owner.def.drop)
    -- start working
    comp:Activate()
end


local function wake_up_planter(self, entity)
    -- get component 
    print("attempt wake up")
    local comp = entity:FindComponent("cc_crop", true)
    if comp ~= nil and comp.has_extra_data and comp.extra_data.key then
        -- drop yield if it has a drop property
        if self.next_frame == nil then
            Map.DropItemAt(entity.location, self.drop, (comp.extra_data.yield or 1))
            -- TODO drop seedling
            if math.random() > 0.7 then 
                Map.DropItemAt(entity.location, 'cc_planter_' .. self.drop  , 1, comp.extra_data)
            end
        end

        -- need to wake up planter if its still exists
        -- get planter key from extra data
        local planter_frame = Map.GetEntityFromKey(comp.extra_data.key)
        print(planter_frame)
        if planter_frame then
            -- retrieve planter componet
            local plant_comp = planter_frame:FindComponent("cc_planter", true)
            print(plant_comp)
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
    minimap_color = { 0, 1, 0 },
    visual = "v_succulent_01",
    texture = "The_Cube_WIP/textures/phase_seed.png",
    --next_frame = 'fc_crop_wire_plant',

    drop = 'wire',
    --on_destroy = wake_up_planter,
    on_remove = wake_up_planter,
})

fc_crop:RegisterFrame('fc_crop_wire_seed0',{
    name = 'Wire Weed Seedling',
    desc = 'This weed grows hair made of conductive fibre\n it grows fast and without any fertilzer',
    visual = "vc_crop_wire_seed0",
    texture = "The_Cube_WIP/textures/wire_seed.png",
    next_frame = 'fc_crop_wire_plant',
    
})

fc_crop:RegisterFrame('fc_crop_wire_plant',{
    name = 'Wire Weed',
    desc = 'Conductive Reeds ready for winding onto a spool\nFilter by flower to find only harvestable crops',
    visual = 'vc_crop_wire',
    texture = "The_Cube_WIP/textures/wire_seed.png",
    is_flower = true,
})

fc_crop:RegisterFrame('fc_crop_phase_seed0',{
    name = 'Wire Weed Seedling',
    desc = 'This weed grows hair made of conductive fibre\n it grows fast and without any fertilzer',
    visual = "vc_crop_wire_seed0",
    texture = "The_Cube_WIP/textures/phase_seed.png",
    next_frame = 'fc_crop_phase_plant',
    drop = 'phase_leaf',
    
})

fc_crop:RegisterFrame('fc_crop_phase_plant',{
    name = 'Wire Weed',
    desc = 'Conductive Reeds ready for winding onto a spool\nFilter by flower to find only harvestable crops',
    visual = 'vc_crop_wire',
    texture = "The_Cube_WIP/textures/phase_seed.png",
    is_flower = true,
    drop = 'phase_leaf',
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
    return (owner:IsInRangeOf({x, y}, range) 
    and Map.GetEntityAt(x,y, FF_OWNFACTION | FF_ENEMYFACTION | FF_NEUTRALFACTION | FF_ALLYFACTION, comp.faction ) == nil 
    and Map.GetEntityAt(x,y,FF_RESOURCE) == nil
    -- todo check for frames as well?)
    )
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



local cc_planter = Comp:RegisterComponent('cc_planter_wire',{
    name = 'Wire Weed Planter',
    texture = "The_Cube_WIP/textures/phase_seed.png",
    desc = "DO NOT SHOW",
    visual = "v_succulent_01",
    production_recipe = CreateProductionRecipeWithWaste({ ic_cube_blue = 1 }, { cc_manifest = 30 },1, {ic_cube_blue = 1}),
    range = 2,
    attachment_size = 'Small',
    activation = 'OnAnyItemSlotChange',
    wait_ticks = 15,
    power = -100,
    --recipe
    ingriedents = { ic_cube_green = 1}, -- can add additional inputs here
    output = {}, -- can add additional outputs here
    output_cube = 'ic_cube_green', -- replace cube with
    
    registers = {
		{ read_only = true, type = "Target", tip = "Planting seed at", ui_icon = "icon_target", },
		{ read_only = true, tip = "Requires",},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Growth Time</>\n\nHow many simulation ticks it will take the crop to grow\n\nDivide by 5 for seconds"},
        { read_only = true, ui_icon = "icon_small_seed", tip = "<header>Plant Yield</>\n\nMultiplies the amount of items produced"},
	},

    -- change these with each new plant
    seed_id = "fc_crop_wire_seed0",
    default_grow_time = 300,
    drop = 'wire',
})
cc_planter.base_id = 'cc_planter'

cc_planter:RegisterComponent('cc_planter_phase_leaf',{
    name = 'Phase Flower Planter',
    desc = 'Plants the contained phase flower leaf',
    seed_id = 'fc_crop_phase_seed0',
    drop = 'phase_leaf',
    default_grow_time = 1000,
})


function cc_planter:on_add(comp)
    -- set extra data 
    if comp.has_extra_data == false then 
        comp.extra_data.yield = 1
        comp.extra_data.growth_time = self.default_grow_time
    end
    print(comp.def.base_id)
    comp:SetRegister(3,comp.extra_data.growth_time)
    comp:SetRegisterNum(4, comp.extra_data.yield)
    comp:SetRegisterId(4,self.drop)
    -- start working
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
            local plant = Map.CreateEntity(comp.faction, self.seed_id)
            local crop = plant:AddComponent('cc_crop','hidden',{
                key = comp.owner.key,
                yield = math.max((comp.extra_data.yield or 1) + math.random(-1,1), 1),
                growth_time =  math.max((comp.extra_data.growth_time or 100) + math.random(-5,5), 5),
            })
            -- if crop then 
            --     crop.extra_data.key = comp.owner.key
            --     crop.extra_data.yield = math.max((comp.extra_data.yield or 1) + math.random(-1,1), 1)
            --     crop.extra_data.growth_time =  math.max((comp.extra_data.growth_time or 100) + math.random(-5,5), 5)
            --     print(crop.extra_data)
            -- else print("co crop comp") end

            plant:Place(cord,comp.owner,false)
            comp:SetRegisterCoord(1, nil)
        -- TODO add turn and throw effect 
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
        --print( can_make, missing, has_slot)
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






