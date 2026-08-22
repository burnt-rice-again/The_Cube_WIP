local alien_artifact = {
	name = "Alien Artifact",
	race = "robot",
}

function alien_artifact:GetRelevancy(x, y, info)
	if info.tutorial and math.abs(x) < 200 and math.abs(y) < 200 then
		return 0.0
	end
	return info.blightness_delta < 0 and info.blightness_delta > -0.1 and 7.0 or 0.0
end

function alien_artifact:SpawnExplorable(x, y)
	local building = (math.random() < 0.5) and "v_alien_feeder_dead" or "v_alien_extractor_dead"
	local ship_frame = Map.CreateEntity("world", "f_alien_explorable", building, true) --"v_explorable_brokenship_1")
	ship_frame:Place(x, y, math.random(0,3))

	Explorable_AddAlienPuzzles(ship_frame)

	local peaceful = Map.GetSettings().peaceful or 2
	if peaceful < 1 then return end

	-- spawn a bug alongside the alien building
	local bughole = Map.CreateEntity(GetBugsFaction(), "f_bug_hole", true)
	bughole:Place(math.random(x-2, x+2), math.random(y-2, y+2))
end

data.explorables.alien_artifact = alien_artifact
