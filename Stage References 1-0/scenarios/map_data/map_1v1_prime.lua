data.map_data = data.map_data or {}
local md = {}
data.map_data.map_1v1_prime = md

---- (42, 42)Position A: START ZONE
---- (52, 29)Position B: [----------]
---- (47, 12)Position C: HIVE
---- (29, 19)Position D: HIVE
---- (23, 52)Position E: Droppod
---- (16, 48)Position F: SILICA SPOT
---- (1, 42)Position G: BIG METAL
---- (-6, 9)Position H: CRYSTAL, CRYSTAL, CRYSTAL
---- (-19, 29)Position I: MOTHIKA
---- (-45, 49)Position J: SUPER RICH METAL -- MAIN MINE 3 --
---- (-50, 33)Position K: SUPER HIVE
---- (-55, 12)Position L: MASS CRYSTAL
---- (-48, 3Position M: BLIGHT CRYSTAL
---- (-15, 6Position N: [----------]
---- (5, 5)Position O: CENTER SILICA

md.map_texture = "Main/scenarios/maps/map_1v1_prime.tga"
md.name = "1v1 Prime"
md.image = "Main/scenarios/maps/map_1v1_prime_image.tga"
md.init = function()
	data.visuals.v_metalrich2.scale = { 1.6, 1.6, 1.6 }
end

md.resource_array = {

	-- PLAYER 1

	---- (42, 42) Position A: START ZONE
	{ 'metalore', 34, 52, 3500, 5, 'v_metalrich1' }, -- MAIN MINE 1
	{ 'silica', 47, 48, 2000, 5, 'v_silica_node' },
	{ 'crystal', 37, 41, 500, 6, 'v_crystalmedium1b' }, { 'crystal', 37, 41, 500, 3, 'v_crystalmedium1b' },
	{ 'crystal', 37, 41, 500, 6, 'v_crystalmedium1a' }, { 'crystal', 37, 41, 500, 7, 'v_crystalmedium1a' },
	-- { 'metalore', 44, 44, 250, 3, 'v_metalmedium1a' }, { 'metalore', 46, 42, 250, 7, 'v_metalmedium1a' },

	{ 'crystal', 55, 34, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 55, 36, 200, 7, 'v_crystalmedium1a' },
	{ 'crystal', 55, 35, 200, 5, 'v_crystalmedium1a' }, { 'crystal', 55, 35, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 55, 36, 200, 8, 'v_crystalmedium1a' }, { 'crystal', 55, 37, 200, 3, 'v_crystalmedium1a' },
	{ 'crystal', 55, 38, 200, 2, 'v_crystalmedium1a' }, { 'crystal', 55, 38, 200, 2, 'v_crystalmedium1a' },

	{ 'crystal', 44, 55, 200, 2, 'v_crystalmedium1a' }, { 'crystal', 45, 55, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', 43, 55, 200, 2, 'v_crystalmedium1a' }, { 'crystal', 42, 56, 200, 2, 'v_crystalmedium1a' },

	---- (52, 29) Position B: [----------]


	---- (47, 12) Position C: -hive location
	-- { 'crystal', 47, 12, 3000, 2, 'v_crystal_rich1' },
	{ 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' },
	{ 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' },
	{ 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' },
	{ 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 47, 12, 200, 6, 'v_crystalmedium1a' },

	---- (29, 19)Position D: -hive location
	{ 'silica', 29, 19, 200, 1, 'v_silica_medium1' }, { 'silica', 30, 20, 200, 1, 'v_silica_medium1' },
	{ 'crystal', 32, 24, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 32, 24, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', 31, 25, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 31, 25, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', 31, 26, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 31, 26, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 31, 27, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 31, 27, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 31, 28, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 31, 28, 200, 1, 'v_crystalmedium1a' },

	---- (23, 52) Position E: Droppod
	-- { 'metalore', 23, 52, 350, 1, 'v_metalmedium1a' }, { 'metalore', 22, 52, 350, 2, 'v_metalmedium1a' },
	{ 'crystal', 23, 49, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 24, 48, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', 23, 47, 200, 5, 'v_crystalmedium1a' }, { 'crystal', 23, 46, 200, 7, 'v_crystalmedium1a' },
	{ 'crystal', 23, 45, 200, 1, 'v_crystalmedium1a' },

	---- (16, 48) Position F: SILICA SPOT
	{ 'silica', 16, 48, 200, 1, 'v_silica_medium1' }, { 'silica', 14, 49, 200, 1, 'v_silica_medium1' },
	{ 'silica', 15, 46, 200, 1, 'v_silica_medium1' }, { 'silica', 15, 46, 200, 1, 'v_silica_medium1' },
	{ 'silica', 15, 46, 200, 1, 'v_silica_medium1' }, { 'silica', 15, 46, 200, 1, 'v_silica_medium1' },
	{ 'silica', 15, 46, 200, 1, 'v_silica_medium1' }, { 'silica', 15, 46, 200, 1, 'v_silica_medium1' },
	{ 'crystal', 12, 41, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 12, 41, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 15, 40, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 16, 41, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 17, 41, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 18, 41, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 19, 40, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 20, 41, 200, 1, 'v_crystalmedium1a' },

	---- (1, 42) Position G: BIG METAL (1, 42)
	{ 'metalore', 1, 42, 5000, 2, 'v_metalrich2' }, -- MAIN MINE 2
	{ 'metalore', 0, 42, 250, 8, 'v_metalmedium1a' }, { 'metalore', -2, 43, 250, 8, 'v_metalmedium1a' },
	{ 'metalore', -1, 42, 30, 2, 'v_metalsmall1a' }, { 'metalore', -2, 43, 30, 4, 'v_metalsmall1a' }, { 'metalore', -3, 42, 30, 9, 'v_metalsmall1a' },

	---- (-6, 9) Position H: CRYSTAL, CRYSTAL, CRYSTAL
	{ 'crystal', -6, 9, 3500, 5, 'v_crystal_rich1' },
	{ 'crystal', -6, 11, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 4, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 11, 200, 2, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 3, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 11, 200, 3, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 7, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 11, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -6, 11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', -6, 15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -6, 15, 200, 4, 'v_crystalmedium1a' },

	---- (-19, 29) Position I: MOTHIKA
	{ 'crystal', -25, 33, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -25, 33, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -24, 33, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -23, 33, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -22, 33, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -21, 33, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -23, 34, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -23, 34, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -18, 36, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -18, 37, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -17, 36, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -17, 37, 200, 1, 'v_crystalmedium1a' },

	---- (-45, 49) Position J: SUPER RICH METAL -- MAIN MINE 3 --
	{ 'metalore', -44, 49, 9000, 9, 'v_metalrich2', },
	{ 'crystal', -50, 47, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -50, 47, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -50, 46, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -50, 46, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -50, 46, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -50, 46, 200, 1, 'v_crystalmedium1a' },
	{ 'silica', -53, 49, 3500, 0, 'v_silica_node' },

	---- (-50, 33) Position K: SUPER HIVE

	---- (-55, 12) Position L: MASS CRYSTAL
	{ 'crystal', -55, 12, 3500, 1, 'v_crystal_rich1' },
	{ 'crystal', -52, 17, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -52, 16, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -52, 17, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -52, 16, 200, 1, 'v_crystalmedium1a' },

	---- (-55, 12) (-48, 3)Position M: BLIGHT CRYSTAL
	{ 'blight_crystal', -50, 3, 500, 6, 'v_blightcrystal1a' }, { 'blight_crystal', -50, 3, 500, 6, 'v_blightcrystal1a' },
	{ 'blight_crystal', -50, 3, 500, 6, 'v_blightcrystal1a' }, { 'blight_crystal', -50, 3, 500, 6, 'v_blightcrystal1a' },
	{ 'blight_crystal', -50, 3, 500, 6, 'v_blightcrystal1a' }, { 'blight_crystal', -50, 3, 500, 6, 'v_blightcrystal1a' },


	---- (5, 5) Position O: CENTER SILICA
	{ 'silica', 5, 5, 5000, 0, 'v_silica_node' },

	-- PLAYER 2

	---- (-42, -42) Position A: START ZONE

	{ 'metalore', -34, -50, 3500, 5, 'v_metalrich1' }, -- MAIN MINE 1
	{ 'silica', -47, -48, 2000, 5, 'v_silica_node' },
	{ 'crystal', -37, -41, 500, 6, 'v_crystalmedium1b' }, { 'crystal', -37, -41, 500, 3, 'v_crystalmedium1b' },
	{ 'crystal', -37, -41, 500, 6, 'v_crystalmedium1a' }, { 'crystal', -37, -41, 500, 7, 'v_crystalmedium1a' },

	-- { 'metalore', -44, -44, 250, 3, 'v_metalmedium1a' }, { 'metalore', -46, -42, 250, 7, 'v_metalmedium1a' },

	{ 'crystal', -55, -34, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -55, -36, 200, 7, 'v_crystalmedium1a' },
	{ 'crystal', -55, -35, 200, 5, 'v_crystalmedium1a' }, { 'crystal', -55, -35, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -55, -36, 200, 8, 'v_crystalmedium1a' }, { 'crystal', -55, -37, 200, 3, 'v_crystalmedium1a' },
	{ 'crystal', -55, -38, 200, 2, 'v_crystalmedium1a' }, { 'crystal', -55, -38, 200, 2, 'v_crystalmedium1a' },

	{ 'crystal', -44, -55, 200, 2, 'v_crystalmedium1a' }, { 'crystal', -45, -55, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', -43, -55, 200, 2, 'v_crystalmedium1a' }, { 'crystal', -42, -56, 200, 2, 'v_crystalmedium1a' },

	---- (52, 29) Position B: [----------]

	-- ---- (-42, -42) Position A: START ZONE
	-- { 'metalore', -42, -42, 3500, 5, 'v_metalrich1' }, -- MAIN MINE 1
	-- { 'silica', -56, -39, 2000, 5, 'v_silica_node' },
	-- { 'metalore', -44, -44, 250, 3, 'v_metalmedium1a' }, { 'metalore', -46, -42, 250, 7, 'v_metalmedium1a' },
	-- { 'crystal', -49, -37, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -51, -36, 200, 7, 'v_crystalmedium1a' },
	-- { 'crystal', -51, -37, 200, 5, 'v_crystalmedium1a' }, { 'crystal', -50, -37, 200, 1, 'v_crystalmedium1a' },
	-- { 'crystal', -50, -36, 200, 8, 'v_crystalmedium1a' }, { 'crystal', -50, -38, 200, 3, 'v_crystalmedium1a' },
	-- { 'crystal', -50, -38, 200, 2, 'v_crystalmedium1a' }, { 'crystal', -51, -37, 200, 2, 'v_crystalmedium1a' },


	---- (52, 29) Position B: [----------]


	---- (47, 12) Position C: -hive location
	-- { 'crystal', 47, 12, 3000, 2, 'v_crystal_rich1' },
	{ 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' },
	{ 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' },
	{ 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' },
	{ 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -47, -12, 200, 6, 'v_crystalmedium1a' },

	---- (29, 19)Position D: -hive location
	{ 'silica', -29, -19, 200, 1, 'v_silica_medium1' }, { 'silica', -30, -20, 200, 1, 'v_silica_medium1' },
	{ 'crystal', -32, -24, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -32, -24, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', -31, -25, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -31, -25, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', -31, -26, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -31, -26, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -31, -27, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -31, -27, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -31, -28, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -31, -28, 200, 1, 'v_crystalmedium1a' },

	---- (23, 52) Position E: Droppod
	-- { 'metalore', 23, 52, 350, 1, 'v_metalmedium1a' }, { 'metalore', 22, 52, 350, 2, 'v_metalmedium1a' },
	{ 'crystal', -23, -49, 200, 6, 'v_crystalmedium1a' }, { 'crystal', -24, -48, 200, 2, 'v_crystalmedium1a' },
	{ 'crystal', -23, -47, 200, 5, 'v_crystalmedium1a' }, { 'crystal', -23, -46, 200, 7, 'v_crystalmedium1a' },
	{ 'crystal', -23, -45, 200, 1, 'v_crystalmedium1a' },

	---- (16, 48) Position F: SILICA SPOT
	{ 'silica', -16, -48, 200, 1, 'v_silica_medium1' }, { 'silica', -14, -49, 200, 1, 'v_silica_medium1' },
	{ 'silica', -15, -46, 200, 1, 'v_silica_medium1' }, { 'silica', -15, -46, 200, 1, 'v_silica_medium1' },
	{ 'silica', -15, -46, 200, 1, 'v_silica_medium1' }, { 'silica', -15, -46, 200, 1, 'v_silica_medium1' },
	{ 'silica', -15, -46, 200, 1, 'v_silica_medium1' }, { 'silica', -15, -46, 200, 1, 'v_silica_medium1' },
	{ 'crystal', -12, -41, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -12, -41, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -15, -40, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -16, -41, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -17, -41, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -18, -41, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', -19, -40, 200, 1, 'v_crystalmedium1a' }, { 'crystal', -20, -41, 200, 1, 'v_crystalmedium1a' },

	---- (1, 42) Position G: BIG METAL (1, 42)
	{ 'metalore', -1, -42, 5000, 2, 'v_metalrich2' }, -- MAIN MINE 2
	{ 'metalore', 0, -42, 250, 8, 'v_metalmedium1a' }, { 'metalore', 2, -43, 250, 8, 'v_metalmedium1a' },
	{ 'metalore', 1, -42, 30, 2, 'v_metalsmall1a' }, { 'metalore', 2, -43, 30, 4, 'v_metalsmall1a' }, { 'metalore', 3, -42, 30, 9, 'v_metalsmall1a' },

	---- (-6, 9) Position H: CRYSTAL, CRYSTAL, CRYSTAL
	{ 'crystal', 6, -9, 3500, 5, 'v_crystal_rich1' },
	{ 'crystal', 6, -11, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 4, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -11, 200, 2, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 3, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -11, 200, 3, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 7, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -11, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 6, -11, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 4, 'v_crystalmedium1a' },
	{ 'crystal', 6, -15, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 1, 'v_crystalmedium1a' }, { 'crystal', 6, -15, 200, 4, 'v_crystalmedium1a' },

	---- (-19, 29) Position I: MOTHIKA
	{ 'crystal', 25, -33, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 25, -33, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 24, -33, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 23, -33, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 22, -33, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 21, -33, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 23, -34, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 23, -34, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 18, -36, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 18, -37, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 17, -36, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 17, -37, 200, 1, 'v_crystalmedium1a' },

	---- (-45, 49) Position J: SUPER RICH METAL -- MAIN MINE 3
	{ 'metalore', 44, -49, 9000, 9, 'v_metalrich2', },
	{ 'crystal', 50, -47, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 50, -47, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 50, -46, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 50, -46, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 50, -46, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 50, -46, 200, 1, 'v_crystalmedium1a' },
	{ 'silica', 53, -49, 3500, 0, 'v_silica_node' },

	---- (-50, 33) Position K: SUPER HIVE

	---- (-55, 12) Position L: MASS CRYSTAL
	{ 'crystal', 55, -12, 3500, 1, 'v_crystal_rich1' },
	{ 'crystal', 52, -17, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 52, -16, 200, 1, 'v_crystalmedium1a' },
	{ 'crystal', 52, -17, 200, 6, 'v_crystalmedium1a' }, { 'crystal', 52, -16, 200, 1, 'v_crystalmedium1a' },

	---- (50, -3,) Position M: BLIGHT CRYSTAL
	{ 'blight_crystal', 50, -3, 500, 6, 'v_blightcrystal1a' }, { 'blight_crystal', 50, -3, 500, 6, 'v_blightcrystal1a' },
	{ 'blight_crystal', 50, -3, 500, 6, 'v_blightcrystal1a' }, { 'blight_crystal', 50, -3, 500, 6, 'v_blightcrystal1a' },
	{ 'blight_crystal', 50, -3, 500, 6, 'v_blightcrystal1a' }, { 'blight_crystal', 50, -3, 500, 6, 'v_blightcrystal1a' },

	---- (5, 5) Position O: CENTER SILICA
	{ 'silica', -5, -5, 5000, 0, 'v_silica_node' },
}

---- EXPLORABLE LOCATIONS
---- BUG HIVES

---- (42, 42)Position A: START ZONE
---- (52, 29)Position B: [----------]
---- (47, 12)Position C: HIVE
---- (29, 19)Position D: HIVE
---- (23, 52)Position E: Droppod
---- (16, 48)Position F: SILICA SPOT
---- (1, 42)Position G: BIG METAL
---- (-6, 9)Position H: CRYSTAL, CRYSTAL, CRYSTAL
---- (-19, 29)Position I: MOTHIKA
---- (-45, 49)Position J: SUPER RICH METAL--MAIN MINE 3 --
---- (-50, 33)Position K: SUPER HIVE
---- (-55, 12)Position L: MASS CRYSTAL
---- (-48, 3)Position M: [----------]
---- (-15, 6)Position N: [----------]
---- (5, 5)Position O: CENTER SILICA

md.bugs_array = {
	--------------------
	----- PLAYER 1 -----
	--------------------

	---- (42, 42)Position A: START ZONE
	--[[
	---- (52, 29)Position B: Human
	{ "f_bug_hole", 51, 29, 2, 6 }, { "f_bug_hole", 50, 30, 2, 6 }, { "f_bug_hole", 49, 29, 2, 9 },
	--]]

	---- (47, 12)Position C: HIVE
	{ "f_bug_hive", 43, 13, 2, 15 }, { "f_bug_hive", 52, 16, 2, 15 },
	-- { "f_bug_hive_large", 50, 15, 2, 20 },
	--{ "f_bug_hive", 48, 16, 2, 14 }, { "f_bug_hive", 48, 16, 2, 14 },
	--{ "f_bug_hole", 45, 14, 2, 9 }, { "f_bug_hole", 44, 14, 2, 9, }, { "f_bug_hole", 42, 14, 2, 9 }, { "f_bug_hole", 42, 14, 2, 9 },

	---- (29, 19)Position D: HIVE
	{ "f_bug_hive", 29, 17, 3, 16 }, { "f_bug_hive", 32, 14, 7, 14 }, -- { "f_bug_hive", 28, 23, 7, 20 },
	{ "f_bug_hole", 28, 21, 2, 7 }, { "f_bug_hole", 30, 20, 2, 7 }, { "f_bug_hole", 26, 21, 2, 7 }, { "f_bug_hole", 27, 16, 2, 7 },

	--[[
	---- (23, 52)Position E: Droppod
	{ "f_bug_hole", 25, 52, 2, 5 }, { "f_bug_hole", 26, 50, 2, 7 }, { "f_bug_hole", 26, 52, 2, 9 }, --{ "f_bug_hole", 26, 51, 2, 5 },
	--]]

	---- (10, 48)Position F: SILICA SPOT
	{ "f_bug_hive", 8, 50, 2, 16 }, { "f_bug_hive", 7, 50, 2, 16 }, { "f_bug_hive", 7, 50, 2, 16 }, --18/18/18
	{ "f_bug_hole", 9, 48, 2, 8 }, { "f_bug_hole", 10, 50, 2, 8 }, { "f_bug_hole", 8, 51, 2, 8 },
	{ "f_bug_hole", 2, 48, 2, 8 }, { "f_bug_hole", 3, 50, 2, 8 }, { "f_bug_hole", 4, 51, 2, 8 },

	---- (1, 42)Position G: BIG METAL
	---- (-6, 9)Position H: CRYSTAL, CRYSTAL, CRYSTAL
	---- (-19, 29)Position I: MOTHIKA


	---- (-45, 49) Position J: SUPER RICH METAL -- MAIN MINE 3 --
	---- (-50, 33) Position K: SUPER HIVE
	{ "f_bug_hive_large", -53, 30, 2, 18 }, { "f_bug_hive", -51, 33, 2, 16 }, { "f_bug_hive", -53, 33, 2, 14 }, --28/16/16

	---- (-55, 12) Position L: MASS CRYSTAL

	---- Position M: [----------]
	---- Position N: [----------]
	---- Position N: Droppod
	{ "f_bug_hive", 60, 2, 7, 20 }, { "f_bug_hive", 60, 0, 7, 20 }, --10/10


	---- (2, 4) Position O: CENTER SILICA
	{ "f_bug_hive_large", 2, 4, 2, 20 }, { "f_bug_hive", 2, 4, 7, 15 }, --25/15

	--------------------
	----- PLAYER 2 -----
	--------------------

	--[[
	---- (-52, -29)Position B: Human
	{ "f_bug_hole", -51, -29, 2, 6 }, { "f_bug_hole", -50, -30, 2, 6 }, { "f_bug_hole", -49, -29, 2, 9 },
	--]]

	---- (-47, -12)Position C: HIVE
	{ "f_bug_hive", -43, -13, 2, 15 }, { "f_bug_hive", -52, -16, 2, 15 },
	--{ "f_bug_hive_large", -50, -15, 2, 20 },
	--{ "f_bug_hive", -48, -16, 2, 14 }, { "f_bug_hive", -48, -16, 2, 14 },
	--{ "f_bug_hole", -45, -14, 2, 9 }, { "f_bug_hole", -44, -14, 2, 9, }, { "f_bug_hole", -42, -14, 2, 9 }, { "f_bug_hole", -42, -14, 2, 9 },

	---- (-29, -19)Position D: HIVE
	{ "f_bug_hive", -29, -17, 3, 16 }, { "f_bug_hive", -32, -14, 7, 14 }, -- { "f_bug_hive", 28, 23, 7, 20 },
	{ "f_bug_hole", -28, -21, 2, 7 }, { "f_bug_hole", -30, -20, 2, 7 }, { "f_bug_hole", -26, -21, 2, 7 }, { "f_bug_hole", -27, -16, 2, 7 },

	--[[
	---- (-23, -52)Position E: Droppod
	{ "f_bug_hole", -25, -52, 2, 5 }, { "f_bug_hole", -26, -50, 2, 7 }, { "f_bug_hole", -26, -52, 2, 9 }, --{ "f_bug_hole", -26, -51, 2, 5 },
	--]]

	---- (-10, -48)Position F: SILICA SPOT
	{ "f_bug_hive", -8, -50, 2, 16 }, { "f_bug_hive", -7, -50, 2, 16 }, { "f_bug_hive", -7, -50, 2, 16 },
	{ "f_bug_hole", -9, -48, 2, 8 }, { "f_bug_hole", -10, -50, 2, 8 }, { "f_bug_hole", -8, -51, 2, 8 },
	{ "f_bug_hole", -2, -48, 2, 8 }, { "f_bug_hole", -3, -50, 2, 8 }, { "f_bug_hole", -4, -51, 2, 8 },

	---- (-1, -42)Position G: BIG METAL
	---- (6, -9)Position H: CRYSTAL, CRYSTAL, CRYSTAL
	---- (19, -29)Position I: MOTHIKA


	---- (45, -49)Position J: SUPER RICH METALMAIN MINE 3 --
	---- (50, -33)Position K: SUPER HIVE
	{ "f_bug_hive_large", 53, -30, 2, 18 }, { "f_bug_hive", 51, -33, 2, 16 }, { "f_bug_hive", 53, -33, 2, 14 },

	---- (55, -12)Position L: MASS CRYSTAL

	---- Position M: [----------]
	---- Position N: [----------]
	---- Position N: Droppod
	{ "f_bug_hive", -60, -2, 7, 20 }, { "f_bug_hive", -60, 2, 7, 20 },

	---- (-2, -4)Position O: CENTER SILICA
	{ "f_bug_hive_large", -2, -4, 2, 20 }, { "f_bug_hive", -2, -4, 7, 15 },
}

md.creep_array = {

	-- ----- PLAYER 1 -----
	-- --------------------
	-- ---- Position D: Droppod
	-- { "f_trilobyte1", 24, 25, 7 }, { "f_trilobyte1", 23, 26, 2 }, { "f_trilobyte1", 21, 27, 2 },
	-- { "f_gastarias1", 23, 23, 4 },{ "f_gastarias1", 21, 26, 1 },

	-- ---- Position E: Droppod
	-- { "f_trilobyte1", 24, 49, 5 }, { "f_trilobyte1", 24, 49, 5 }, { "f_gastarias1", 23, 51, 9 },

	-- ---- Position F: Droppod
	-- { "f_gastarias1", 8, 49, 3 }, { "f_gastarias1", 9, 49, 1 }, { "f_gastarias1", 11, 51, 0 },

	---- Position I: Alien Explorable
	-- { "f_scaramar2", -18, 28, 9 },

	-- ---- Position J: Metal/Rich
	-- { "f_trilobyte1", -39, 48, 5 }, { "f_trilobyte1", -39, 47, 5 },

	-- ----- PLAYER 2 -----
	-- --------------------
	-- ---- Position D: Droppod
	-- { "f_trilobyte1", -24, -25, 7 }, { "f_trilobyte1", -23, -26, 2 }, { "f_trilobyte1", -21, -27, 2 },
	-- { "f_gastarias1", -23, -23, 4 },{ "f_gastarias1", -21, -26, 1 },

	-- ---- Position E: Droppod
	-- { "f_trilobyte1", -26, -49, 5 }, { "f_trilobyte1", -26, -49, 5 }, { "f_gastarias1", -25, -51, 9 },

	-- ---- Position F: Droppod
	-- { "f_gastarias1", -8, -49, 3 }, { "f_gastarias1", -9, -49, 1 }, { "f_gastarias1", -11, -51, 0 },

	-- ---- Position I: Alien Explorable
	-- { "f_scaramar2", 18, -28, 9 },

	-- ---- Position J: Metal/Rich
	-- { "f_trilobyte1", 39, -48, 5 }, { "f_trilobyte1", 39, -47, 5 },
}

md.spawn_explorables = function()

	---------- TEST ----------

	-- data.explorables.broken_ship:SpawnExplorable(50, 50)
	-- local exp = Map.GetEntityAt(50, 50)
	-- if exp then
	-- exp.extra_data.rewards = {
	-- c_repairkit = 2,
	-- circuit_board = 5
	-- }
	-- else
	-- print("can't spawn explorable at location specified", 50, 51)
	-- end

	---------- BROKEN DROP POD ----------

	----- PLAYER 1 -----
	--------------------


	---- Position B
	data.explorables.broken_ship:SpawnExplorable(51, 19)
	local exp = Map.GetEntityAt(51, 19)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 1,
			c_portable_turret_green = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", 51, 19)
	end


	---- Position D

	data.explorables.broken_ship:SpawnExplorable(30, 14)
	local exp = Map.GetEntityAt(30, 14)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 1,
			c_virus_bitlock = 1,
			c_power_relay = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", 30, 14)
	end

	--[[
	---- Position E
	data.explorables.broken_ship:SpawnExplorable(24, 50)
	local exp = Map.GetEntityAt(24, 50)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 1,
			c_adv_portable_turret = 1,
			circuit_board = 20,
			metalbar = 20,
			metalplate = 20,
			reinforced_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", 24, 50)
	end
	--]]

	-- ---- Position N
	data.explorables.broken_ship:SpawnExplorable(48, 1)
	local exp = Map.GetEntityAt(48, 1)
	if exp then
		exp.extra_data.rewards = {
			c_power_relay = 1,
			c_portable_turret_green = 1,
			c_portable_turret_red = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", 48, 1)
	end

	---- Position F
	data.explorables.broken_ship:SpawnExplorable(18, 50)
	local exp = Map.GetEntityAt(18, 50)
	if exp then
		exp.extra_data.rewards = {
			c_repairer_aoe = 1,
			c_virus_bitlock = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 18, 50)
	end

	---------------
	---------------
	---------------
	---------------
	---------------
	---------------

	----- PLAYER 2 -----
	--------------------

	---- Position B

	data.explorables.broken_ship:SpawnExplorable(-51, -19)
	local exp = Map.GetEntityAt(-51, -19)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 1,
			c_portable_turret_green = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", -51, -19)
	end

	---- Position D

	data.explorables.broken_ship:SpawnExplorable(-30, -14)
	local exp = Map.GetEntityAt(-30, -14)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 1,
			c_virus_bitlock = 1,
			c_power_relay = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", -30, -14)
	end

	--[[
	---- Position E
	data.explorables.broken_ship:SpawnExplorable(-24, -50)
	local exp = Map.GetEntityAt(-24, -50)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 1,
			c_adv_portable_turret = 1,
			circuit_board = 20,
			metalbar = 20,
			metalplate = 20,
			reinforced_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", -24, -50)
	end
	--]]

	-- ---- Position N
	data.explorables.broken_ship:SpawnExplorable(-48, 1)
	local exp = Map.GetEntityAt(-48, 1)
	if exp then
		exp.extra_data.rewards = {
			c_power_relay = 1,
			c_portable_turret_green = 1,
			c_portable_turret_red = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", -48, 1)
	end

	---- Position F
	data.explorables.broken_ship:SpawnExplorable(-18, -50)
	local exp = Map.GetEntityAt(-18, -50)
	if exp then
		exp.extra_data.rewards = {
			c_repairer_aoe = 1,
			c_virus_bitlock = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -18, -50)
	end

	-------- HUMAN EXPLORABLE --------

	---- Position C
	----- PLAYER 1 -----

	--[[
	local building = (math.random() < 0.5) and "v_explorable_building_4" or "v_explorable_building_2"
	local human_exp = Map.CreateEntity("world", "f_explorable", building, true) --"v_explorable_brokenship_1")
	human_exp:Place(52, 22, math.random(0,3))
	local fix = human_exp:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = 'circuit_board'
	human_exp:SetRegister(FRAMEREG_SIGNAL, { id = 'circuit_board', num = 1 })
	human_exp.extra_data.rewards = { c_virus_bitlock = 1 }
	--]]

	-- ---- Position C
	-- ----- PLAYER 2 -----
	--[[
	local building = (math.random() < 0.5) and "v_explorable_building_4" or "v_explorable_building_2"
	local human_exp = Map.CreateEntity("world", "f_explorable", building, true) --"v_explorable_brokenship_1")
	human_exp:Place(-52, -22, math.random(0,3))
	local fix = human_exp:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = 'circuit_board'
	human_exp:SetRegister(FRAMEREG_SIGNAL, { id = 'circuit_board', num = 1 })
	human_exp.extra_data.rewards = { c_virus_bitlock = 1 }
	--]]

	-------- ALIEN EXPLORABLE --------

	---- Position H?

	----- PLAYER 1 -----

	local building = (math.random() < 0.5) and "v_alien_feeder_dead" or "v_alien_extractor_dead"
	local alien_exp = Map.CreateEntity("world", "f_explorable", building, true) --"v_explorable_brokenship_1")
	alien_exp:Place(-19, 34, math.random(0,3))
	local fix = alien_exp:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = 'circuit_board'
	alien_exp:SetRegister(FRAMEREG_SIGNAL, { id = 'circuit_board', num = 1 })
	alien_exp.extra_data.rewards = { c_turret_powerflower = 1, c_portable_turret_red = 1 }

	---- Position N (new)

	local building = (math.random() < 0.5) and "v_alien_feeder_dead" or "v_alien_extractor_dead"
	local alien_exp = Map.CreateEntity("world", "f_explorable", building, true) --"v_explorable_brokenship_1")
	alien_exp:Place(55, -5, math.random(0,3))
	local fix = alien_exp:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = 'circuit_board'
	alien_exp:SetRegister(FRAMEREG_SIGNAL, { id = 'circuit_board', num = 1 })
	alien_exp.extra_data.rewards = { c_turret_powerflower = 1, c_portable_turret_red = 1 }

	-- ---- Position H?

	-- ----- PLAYER 2 -----

	local building = (math.random() < 0.5) and "v_alien_feeder_dead" or "v_alien_extractor_dead"
	local alien_exp = Map.CreateEntity("world", "f_explorable", building, true) --"v_explorable_brokenship_1")
	alien_exp:Place(19, -34, math.random(0,3))
	local fix = alien_exp:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = 'circuit_board'
	alien_exp:SetRegister(FRAMEREG_SIGNAL, { id = 'circuit_board', num = 1 })
	alien_exp.extra_data.rewards = { c_turret_powerflower = 1, c_portable_turret_red = 1 }

	---- Position N (new)

	local building = (math.random() < 0.5) and "v_alien_feeder_dead" or "v_alien_extractor_dead"
	local alien_exp = Map.CreateEntity("world", "f_explorable", building, true) --"v_explorable_brokenship_1")
	alien_exp:Place(-55, 5, math.random(0,3))
	local fix = alien_exp:AddComponent("c_explorable_fix", "hidden")
	fix.extra_data.explorable_fix = 'circuit_board'
	alien_exp:SetRegister(FRAMEREG_SIGNAL, { id = 'circuit_board', num = 1 })
	alien_exp.extra_data.rewards = { c_turret_powerflower = 1, c_portable_turret_red = 1 }
end

-- local loc = (faction.id == "faction_1") and { x=45, y=46 } or { x=-45, y=-46 }

md.faction_info = {
	{
		spawn_location = { x = 40, y = 45 },
	},
	{
		spawn_location = { x = -40, y = -45 },
	}
}
