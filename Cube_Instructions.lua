



local Get, GetCoord, GetId, Set, BeginBlock = InstGet, InstGetCoord, InstGetId, InstSet, InstBeginBlock

-- from instructions file 
local function GetSeenEntityOrSelf(comp, state, ent)
	if not ent then return comp.owner end
	local reg = Get(comp, state, ent)
	if reg.is_empty then return nil end
	local entity = reg.entity
	return entity and comp.faction:IsSeen(entity) and entity or nil
end


----------- Extra Instructions for the CUBE 

data.instructions.get_foundation_at = {
    func = function(comp, state, cause, in_coord, out_result, out_no_result)
		local faction = comp.faction
		local coord = GetCoord(comp, state, in_coord)
		if not coord then
			Set(comp, state, out_result)
            state.counter = out_no_result
			return
		end

		local result = Map.GetFoundationEntityAt(coord.x, coord.y)
		if result and comp.faction:IsSeen(result) then
			Set(comp, state, out_result, { entity = result })
		else
			Set(comp, state, out_result)
            state.counter = out_no_result
		end
	end,
	args = {
		{ 'in', "Coordinate", "Coordinate to get Foundation from", 'coord' },
		{ 'out', "Result" },
        { 'exec', "No Foundation", "No Foundation Found or could not view coordinate" },
	},
	name = "Get Foundation At",
	desc = "Gets the Foundation at a coordinate",
	category = "Math",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Returns the Foundation located at a specific coordinate if visible.]],
}
-- there isnt an easy way to get stored battiers. even the Ui loops through them all.
-- data.instructions.grid_battery = {
--     func = function(comp, state, cause, entity, battery)

--         local ent = GetSeenEntityOrSelf(comp, state, in_target)

--         if ent ~= nil then 
--             local grid_index = ent.power_grid_index
--             if grid_index then 
--                 local grid = comp.faction:GetPowerGrid(grid_index)
--                 print(grid)
--             end
--         end

-- 	end,
-- 	args = {
-- 		{ 'in', "Unit", "Coordinate to get Foundation from", nil , true },
-- 		{ 'out', "Percentage", "Battery of grid [0 - 100]" },
-- 	},
-- 	name = "Get Grid Battery",
-- 	desc = "Returns the <hl>total battery percentage</> of the grid the unit is in",
-- 	category = "Math",
-- 	icon = "Main/skin/Icons/Common/32x32/Battery.png",
-- 	explain = [[Returns the <hl>total battery percentage</> of the grid the unit is in
-- Optionally retrun the grid target unit is in. 
-- Target entity must be visible

-- Returns a number between 0 - 100 inclusive]],
-- }
data.instructions.get_cube_type = {
    func = function(comp, state, cause, out_result)
		local faction = comp.faction
        
        if not faction.has_extra_data or faction.extra_data.cube_type == nil then 
            --no cube data
            Set(comp, state, out_result)
            return
        end
        local cube_id = faction.extra_data.cube_type
        -- check valid id 
        if data.items[cube_id] == nil then
            Set(comp, state, out_result)
            return 
        end
        -- successfully found id 
        Set(comp, state, out_result, {id = cube_id })
	end,
	args = {
		{ 'out', "Cube", "The Current Cube Type" },
	},
	name = "Get Cube Type",
	desc = "Gets the Cube's current type",
	category = "Global",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Returns the Cubes current type.]],
}

data.instructions.get_cube_entity = {
    func = function(comp, state, cause, out_result, out_no_result)
		local faction = comp.faction
        
        if not faction.has_extra_data or faction.extra_data.cube_type == nil then 
            --no cube data
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        local key = faction.extra_data.cube_key
        if key == nil then 
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        local entity = Map.GetEntityFromKey(key)
        if entity.location == nil then 
            -- entity could not be found 
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        -- check has cube 
        local cube_id = faction.extra_data.cube_type
        if entity:CountItem(cube_id) == 0 then
            -- not holding cube
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        -- successfully found id 
        Set(comp, state, out_result, {entity = entity })
	end,
	args = {
		{ 'out', "Unit", "Returns the Unit currently holding the Cube" },
        { 'exec', "No Unit", "No Unit is currently holding the Cube\nTry Get Cube Location Instead" },
	},
	name = "Get Cube Bearer",
	desc = "Returns the entity currently holding the Cube",
	category = "Global",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Returns the Entity Currently Holding The Cube]],
}

data.instructions.get_cube_location = {
    func = function(comp, state, cause, out_result)

        -- begins the same as get entity 
		local faction = comp.faction
        
        if not faction.has_extra_data or faction.extra_data.cube_type == nil then 
            --no cube data
            Set(comp, state, out_result,faction.extra_data.cube_cord )
            return 
        end
        local key = faction.extra_data.cube_key
        if key == nil then 
            Set(comp, state, out_result,faction.extra_data.cube_cord )
            return 
        end
        local entity = Map.GetEntityFromKey(key)
        if entity == nil then 
            -- entity could not be found 
            Set(comp, state, out_result,faction.extra_data.cube_cord )
            return 
        end
        -- check has cube 
        local cube_id = faction.extra_data.cube_type
        if entity:CountItem(cube_id) == 0 then
            -- not holding cube
            Set(comp, state, out_result,faction.extra_data.cube_cord )
            return 
        end
        -- successfully found id 
        Set(comp, state, out_result, {coord = entity.location })
	end,
	args = {
		{ 'out', "Coordinate", "The last known location of the Cube" },
	},
	name = "Get Cube Location",
	desc = "Returns the last known location of the Cube",
	category = "Global",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Returns the last known location of the Cube]],
}
data.instructions.is_cube_type = {
    func = function(comp, state, cause, in_id, out_not_cube)

        local id = GetId(comp, state, in_id)
        if id and data.items[id] and data.items[id].tag == "cube" then 
            return 
        end
        state.counter = out_not_cube
	end,
    exec_arg = { 2, "Cube", "This register is a Cube" },
	args = {
        { 'in', "Value", "Value to check if its Id is a Cube id" },
        { 'exec', "Non Cube", "This register is <hl>not</> a Cube" },
        
	},
	name = "is a Cube",
	desc = "Check if the input is a Cube",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Branches Execution based on the id of the input. 
Will check if the id is a valid Cube]],
}
local cube_ids <const> = {
    ic_cube_blue = 1,
    ic_cube_green = 2,
    ic_cube_empty = 3,
    ic_cube_red = 4,
    ic_cube_sphere = 5,
}
data.instructions.recipe_cube = {
    func = function(comp, state, cause, in_id, cube_in, cube_out, no_cube_req)

        local id = GetId(comp, state, in_id)
        if id == nil then state.counter = no_cube_req return  end
        local item = data.all[id]
        if item == nil or item.production_recipe == nil then 
            state.counter = no_cube_req
            return 
        end 
        local check = false 
        local recipe = item.production_recipe
        if recipe.ingredients ~= nil then
            for key,val in pairs(recipe.ingredients) do 
                if cube_ids[key] ~= nil then 
                    check = true 
                    Set(comp, state, cube_in, {id = key, num = val })
                    break
                end
            end
        end
        if recipe.byproduct ~= nil then 
            for key,val in pairs(recipe.byproduct) do 
                if cube_ids[key] ~= nil then 
                    check = true 
                    Set(comp, state, cube_out, {id = key, num = val })
                    break
                end
            end
        end
        if check == false then state.counter = no_cube_req return  end 

	end,
	args = {
        { 'in', "Recipe", "Item to check the recipe of" },
        { 'out', "Cube Input", "Cube Input" },
        { 'out', "Cube Output", "Cube Ouptut" },
        { 'exec', "No Cube Involved", "This item does not involve the Cube to craft" },
        
	},
	name = "Does Recipe Require Cube",
	desc = "Checks if a item requires the Cube to Craft",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Branches Execution based on the id of the input. 
Will check if the id is a valid Cube]],
}