



local Get, GetNum, GetCoord, GetId, GetEntity, Set, BeginBlock = InstGet, InstGetNum, InstGetCoord, InstGetId, InstGetEntity, InstSet, InstBeginBlock



----------- Extra Instructions for the CUBE 

data.instructions.get_foundation_at = {
    func = function(comp, state, cause, in_coord, out_result, out_no_result)
		local faction = comp.faction
		local coord = GetCoord(comp, state, in_coord)
		if not coord then
			Set(comp, state, out_no_result)
			return
		end

		local result = Map.GetFoundationEntityAt(coord.x, coord.y)
		if result and comp.faction:IsSeen(result) then
			Set(comp, state, out_result, { entity = result })
		else
			Set(comp, state, out_no_result)
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





