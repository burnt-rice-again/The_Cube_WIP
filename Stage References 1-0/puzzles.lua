----- nineclicks --------------
data.update_mapping.c_nineclicks = "c_explorable_nineclicks"
Comp:RegisterComponent("c_explorable_nineclicks", {
	name = "Nine Clicks Minigame",
	texture = "Main/textures/icons/components/puz.png",
	type = "Puzzle",
	on_solved = function(comp, explorable_race, faction)
		AddRacePuzzleItem(comp.owner, explorable_race, faction)
	end,
	explorable_effect = "c_particle_birds",
	explorable_override = "infected_circuit_board",
	explorable_game = "ExplorableGameNineClicks",
	explorable_help = [[To complete the circuit, all lines need to be switched to the active state. Click a node to toggle the state of it and its neighbors.

Try selecting all corner pieces first, then center pieces, even if more corner pieces appear while doing so. Do this a couple times and the puzzle should be solved.]],
})

----- netwalk --------------
Comp:RegisterComponent("c_explorable_netwalk", {
	name = "Netwalk Minigame",
	texture = "Main/textures/icons/components/puz.png",
	type = "Puzzle",
	on_solved = function(comp, explorable_race, faction)
		AddRacePuzzleItem(comp.owner, explorable_race, faction)
	end,
	explorable_effect = "c_particle_leaves",
	explorable_override = "infected_circuit_board",
	explorable_game = "ExplorableGameNetWalk",
	explorable_help = "To complete the circuit, all lines need to be connected to the source node. Rotate any of the squares by clicking them to highlight all the nodes.",
})

----- slide --------------
Comp:RegisterComponent("c_explorable_slide", {
	name = "Slide Minigame",
	texture = "Main/textures/icons/components/puz.png",
	type = "Puzzle",
	on_solved = function(comp, explorable_race, faction)
		AddRacePuzzleItem(comp.owner, explorable_race, faction)
	end,
	explorable_effect = "c_particle_leaves",
	explorable_override = "infected_circuit_board",
	explorable_game = "ExplorableGameSlide",
	explorable_help = "slide numbers into numerical order",
})

----- balance --------------
Comp:RegisterComponent("c_explorable_balance", {
	name = "Balance Minigame",
	texture = "Main/textures/icons/components/puz.png",
	type = "Puzzle",
	on_solved = function(comp, explorable_race, faction)
		AddRacePuzzleItem(comp.owner, explorable_race, faction)
	end,
	explorable_effect = "c_particle_birds",
	explorable_override = "infected_circuit_board",
	explorable_game = "ExplorableGameBalance",
	explorable_help = "Pick the right combination of symbols by dragging them to the right column to complete the circuit. The bar underneath must be filled precisely in half.",
})

data.puzzles = {
	["robot"] = { "c_explorable_nineclicks", "c_explorable_netwalk" },
	["human"] = { "c_explorable_slide" },
	["alien"] = { "c_explorable_balance" },
}
