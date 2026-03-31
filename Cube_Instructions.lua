



local Get, GetNum, GetCoord, GetId, GetEntity, Set, BeginBlock = InstGet, InstGetNum, InstGetCoord, InstGetId, InstGetEntity, InstSet, InstBeginBlock



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
            print("no extra data")
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        local key = faction.extra_data.cube_key
        if key == nil then 
            print("not valid key", key)
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        local entity = Map.GetEntityFromKey(key)
        if entity == nil then 
            -- entity could not be found 
            print("not valid entity", key)
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        -- check has cube 
        local cube_id = faction.extra_data.cube_type
        if entity:CountItem(cube_id) == 0 then
            -- not holding cube
            print("not holding cube")
            Set(comp, state, out_result)
            state.counter = out_no_result
            return 
        end
        -- successfully found id 
        print("return cube id", entity)
        Set(comp, state, out_result, {entity = entity })
	end,
	args = {
		{ 'out', "Unit", "Returns the Unit Currently Holding the Cube" },
	},
	name = "Get Cube Holder",
	desc = "Returns the entity currently holding the Cube",
	category = "Global",
	icon = "Main/skin/Icons/Common/56x56/Distance.png",
	explain = [[Returns the Entity Currently Holding The Cube]],
}


