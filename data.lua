local package = ...

-- files loaded when mod is initializing
package.includes = {
	"Cube_Utilities.lua",
	"Cube_Visuals.lua",
	
	"Cube_Items.lua",
	"Cube_Fabricator.lua",
	
	"Cube_Farming.lua",
	
	"Cube_Components.lua",
	"Cube_Converter.lua",
	"Cube_Pipes.lua",
	"Cube_Frames.lua",
	"Cube_Attack_Waves.lua",
	"Cube_Crystal_Power.lua",

	"Cube_Techs.lua",

	--"Cube_Land_Features.lua",
	"Cube_Explorables.lua",
	"Cube_Biomes.lua",
	
	
	--"Cube_Scenario.lua",
	'Cube_Instructions.lua',
	"Cube_DefinitionTooltip.lua",
	"Cube_Codex.lua",
	"Cube_UI_Box.lua"
}

-- called when mod is initializing
function package:init()


	local All_Mods = Game.GetModPackages("Main")

	for i,mod in ipairs(All_Mods) do 
		print(mod.id)
	end

end


-- fx descriptions ---------------------

-- fx_alien_liquid pink goo splash 
-- fx_reforming_pool good has small plasma and a whilwind above cube
-- fx_alien_teleporter - creates a ring but is in the air :(
-- fx_unit_teleport - good for a different purpose
-- fx_pulse - emp like pulse , fx_viral_pulse
-- fx_power_core - strong light 
-- fx_alien_core pink light 
--fx_deconstructor like bullets raining from the sky 
--fx_assembler - smaller fire
--fx_EMP - huge emp blast  
--fx_alien_miner for a cool effect around the centre
--fx_bug_attack for planter?
--fx_simulator - black debri like obsideon minning 