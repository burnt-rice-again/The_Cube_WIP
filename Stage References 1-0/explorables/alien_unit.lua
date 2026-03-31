local alien_unit = {
	name = "Alien Unit",
	race = "robot",
}

function alien_unit:GetRelevancy(x, y, info)
	return info.blightness_delta > 0.05 and info.elevation < 0.1 and 1.0 or 0.0
end

function alien_unit:SpawnExplorable(x, y)
	local alien_frame = Map.CreateEntity(GetAlienFaction(), "f_alien_soldier")
	alien_frame:AddItem("blight_plasma", 20)
	alien_frame:Place(x, y)
end

data.explorables.alien_unit = alien_unit
