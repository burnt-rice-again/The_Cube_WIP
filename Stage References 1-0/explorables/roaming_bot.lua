local roaming_bot = {
	name = "Roaming Bot",
	tag = "hostile",
}

function roaming_bot:GetRelevancy(x, y, info)
	if info.tutorial and math.abs(x) < 100 and math.abs(y) < 100 then
		return 0.0
	end
	return info.blightness_delta < 0 and info.elevation_delta > 0 and 10.0 or 0.0
end

function roaming_bot:SpawnExplorable(x, y)
	local botvisual = math.random(2) == 1 and "v_explorable_bot2" or "v_explorable_bot"

	local bot = Map.CreateEntity("world", "f_exploreable_bot_glitch", botvisual)
	bot:Place(x, y)
	bot:AddComponent("c_virus", "hidden")
	bot:AddItem("infected_circuit_board", math.random(1,3))
	bot.health = 2
	--print(x, y)

	Explorable_AddHumanPuzzles(bot, 0)
end

data.explorables.roaming_bot = roaming_bot
