



local  GetCoord, Set, BeginBlock = InstGetCoord, InstSet, InstBeginBlock



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
        if entity == nil then 
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
    func = function(comp, state, cause, out_result, out_no_result)

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

