data.map_data = data.map_data or {}
local md = {}
data.map_data.map_2v2_planetside = md

md.map_texture = "Main/scenarios/maps/map_2v2_planetside.tga"
md.name = "2v2 Planetside"
md.image = "Main/scenarios/maps/map_2v2_planetside_image.tga"

md.resource_array = {

	---- Co-ordinates ( 63, 93 )Position (A)
	---- Co-ordinates ( 43, 92 )Position (B)
	---- Co-ordinates ( 55, 65 )Position (C)
	---- Co-ordinates ( 15, 90 )Position (D)
	---- Co-ordinates ( 3, 87 )Position (E)
	---- Co-ordinates ( 7, 57 )Position (F)
	---- Co-ordinates ( 45, 45 )Position (G)
	---- Co-ordinates ( 70, 40 )Position (H)
	---- Co-ordinates ( 82, 15 )Position (I)
	---- Co-ordinates ( 50, 20 )Position (J)
	---- Co-ordinates ( 14, 30 )Position (K)
	---- Co-ordinates ( 11, 8 )Position (L)

	----------------------------------------------------------------------------------
	-- TEAM 1: PLAYERS 1 & 2
	----------------------------------------------------------------------------------

	----------------------------
	--------- PLAYER 1 ---------
	----------------------------

	-- A ---- START -- Co-ordinates ( 63, 93 )Position (A)

	{ 'metalore', 66, 91, 5000, 9, 'v_metalrich1' },
	{ 'crystal', 77, 84, 2000, 2, 'v_crystal_rich1' },
	{ 'silica', 67, 75, 2000, 2, 'v_silica_node' },

	{ 'crystal', 82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 72, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, 82, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 80, 90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 80, 90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 80, 90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 80, 90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 80, 90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 80, 90, 350, 7, 'v_crystalmedium1a' },

	-- B ---- Co-ordinates ( 43, 92 )Position (B)

	{ 'crystal', 39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, 85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, 85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, 85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, 85, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', 35, 95, 500, 0, 'v_silica_node' }, { 'silica', 35, 95, 500, 0, 'v_silica_node' },
	-- { 'silica', 28, 86, 110, 0, 'v_silica_medium1' }, { 'silica', 28, 86, 110, 0, 'v_silica_medium1' }, { 'silica', 28, 86, 110, 0, 'v_silica_medium1' },

	-- C ---- Co-ordinates ( 55, 65 )Position (C)METAL / Crystal / Silica

	{ 'crystal', 58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, 62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, 62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, 62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, 62, 350, 7, 'v_crystalmedium1a' },

	-- D ---- Co-ordinates ( 15, 90 Position (D)Silica
	---- Co-ordinates ( 20, 98 )Position D: METAL / Crystal

	{ 'metalore', 10, 94, 4000, 5, 'v_metalrich1' },
	-- { 'metalore', 12, 92, 230, 3, 'v_metalmedium1a' }, { 'metalore', 12, 93, 230, 3, 'v_metalmedium1a' }, { 'metalore', 12, 93, 230, 3, 'v_metalmedium1a' },
	{ 'crystal', 20, 98, 2000, 2, 'v_crystal_rich1' },
	{ 'crystal', 18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, 92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, 92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, 92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, 92, 350, 7, 'v_crystalmedium1a' },

	-- E ---- Co-ordinates 3, 87 )Position (E)

	{ 'silica', 1, 85, 3500, 0, 'v_silica_node' },

	-- F ---- Co-ordinates 7, 57 )Position (F)
	{ 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' },
	{ 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' },
	--{ 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, 55, 200, 0, 'v_silica_medium1' },
	{ 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' },
	{ 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' },
	--{ 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' },
	--{ 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, 55, 200, 0, 'v_silica_medium1' },

	-- F ---- Co-ordinates ( 13, 58 )Position F: METAL / Crystal
	{ 'metalore', 10, 44, 5000, 5, 'v_metalrich1' },
	{ 'crystal', 13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, 58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, 58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, 58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, 58, 350, 7, 'v_crystalmedium1a' },


	-- G ---- Co-ordinates ( 45, 45 )Position (G)
	{ 'crystal', 37, 49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 37, 49, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 37, 49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 37, 49, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 38, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 38, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, 51, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, 51, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 40, 52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 40, 52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 40, 52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 40, 52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 40, 52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 40, 52, 350, 7, 'v_crystalmedium1a' },


	-- H ---- Co-ordinates ( 70, 40 )Position (H)
	-- H ---- Co-ordinates ( 100, 45 )
	{ 'metalore', 100, 45, 5000, 5, 'v_metalrich1' },
	-- { 'crystal', 83, 48, 4520, 2, 'v_crystal_rich1' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, 50, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', 81, 61, 2000, 0, 'v_silica_node' },
	{ 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' },
	{ 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, {'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' },
	{ 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, 61, 200, 0, 'v_silica_medium1' },

	-- I ---- Co-ordinates ( 82, 15 )Position (I)

	-- J ---- Co-ordinates ( 50, 20 )Position (J)
	{ 'crystal', 57, 7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', 57, 7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', 57, 7, 850, 7, 'v_crystalmedium1a' },
	{ 'crystal', 57, 7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', 57, 7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', 57, 7, 850, 7, 'v_crystalmedium1a' },
	{ 'silica', 70, 23, 3000, 0, 'v_silica_node' },
	{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', 70, 23, 200, 0, 'v_silica_medium1' },

	-- K ---- Co-ordinates ( 14, 30 )Position (K)
	{ 'crystal', 12, 28, 5000, 2, 'v_crystal_rich1' },
	{ 'crystal', 12, 28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 12, 28, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 12, 28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 12, 28, 350, 7, 'v_crystalmedium1a' },

	-- L ---- Co-ordinates ( 11,8 )Position (L)
	{ 'metalore', 17, 9, 6000, 3, 'v_metalrich1' },

	----------------------------
	--------- PLAYER 2 ---------
	----------------------------


	-- A ---- START -- Co-ordinates ( 63, 93 )Position (A)

	{ 'metalore', -69, 91, 5000, 9, 'v_metalrich1' },
	{ 'crystal', -77, 84, 2000, 2, 'v_crystal_rich1' },
	{ 'silica', -67, 75, 2000, 2, 'v_silica_node' },

	{ 'crystal', -82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 72, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, 82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, 82, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -80, 90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -80, 90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -80, 90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -80, 90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -80, 90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -80, 90, 350, 7, 'v_crystalmedium1a' },

	-- B ---- Co-ordinates ( 43, 92 )Position (B)

	{ 'crystal', -39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, 85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, 85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, 85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, 85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, 85, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', -35, 95, 500, 0, 'v_silica_node' }, { 'silica', -35, 95, 500, 0, 'v_silica_node' },
	-- { 'silica', -28, 86, 110, 0, 'v_silica_medium1' }, { 'silica', -28, 86, 110, 0, 'v_silica_medium1' }, { 'silica', -28, 86, 110, 0, 'v_silica_medium1' },

	-- C ---- Co-ordinates ( 55, 65 )Position (C)METAL / Crystal / Silica

	{ 'crystal', -58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, 62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, 62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, 62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -58, 62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, 62, 350, 7, 'v_crystalmedium1a' },

	-- D ---- Co-ordinates ( 15, 90 )Position (D)Silica
	---- Co-ordinates ( 20, 98 )Position D: METAL / Crystal

	{ 'metalore', -10, 94, 4000, 5, 'v_metalrich1' },
	-- { 'metalore', -12, 92, 230, 3, 'v_metalmedium1a' }, { 'metalore', -12, 93, 230, 3, 'v_metalmedium1a' }, { 'metalore', -12, 93, 230, 3, 'v_metalmedium1a' },
	{ 'crystal', -20, 98, 2000, 2, 'v_crystal_rich1' },
	{ 'crystal', -18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, 92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, 92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, 92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -18, 92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, 92, 350, 7, 'v_crystalmedium1a' },

	-- E ---- Co-ordinates (3, 87 )Position (E)

	{ 'silica', -1, 85, 3500, 0, 'v_silica_node' },

	-- F ---- Co-ordinates (7, 57 )Position (F)
	{ 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' },
	{ 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' },
	--{ 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, 55, 200, 0, 'v_silica_medium1' },
	{ 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' },
	{ 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' },
	--{ 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' },
	--{ 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, 55, 200, 0, 'v_silica_medium1' },

	-- F ---- Co-ordinates ( 13, 58 )Position F: METAL / Crystal
	{ 'metalore', -10, 44, 5000, 5, 'v_metalrich1' },
	{ 'crystal', -13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, 58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, 58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, 58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -13, 58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, 58, 350, 7, 'v_crystalmedium1a' },


	-- G ---- Co-ordinates ( 45, 45 )Position (G)
	{ 'crystal', -37, 49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -37, 49, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -37, 49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -37, 49, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -38, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -38, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, 51, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, 51, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -40, 52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -40, 52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -40, 52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -40, 52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -40, 52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -40, 52, 350, 7, 'v_crystalmedium1a' },


	-- H ---- Co-ordinates ( 70, 40 )Position (H)
	-- H ---- Co-ordinates ( 100, 45 )
	{ 'metalore', -100, 45, 5000, 5, 'v_metalrich1' },
	-- { 'crystal', -83, 48, 4520, 2, 'v_crystal_rich1' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, 50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, 50, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', -81, 61, 2000, 0, 'v_silica_node' },
	{ 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' },
	{ 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' },
	{ 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, 61, 200, 0, 'v_silica_medium1' },

	-- I ---- Co-ordinates ( 82, 15 )Position (I)

	-- J ---- Co-ordinates ( 50, 20 Position (J)
	{ 'crystal', -57, 7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', -57, 7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', -57, 7, 850, 7, 'v_crystalmedium1a' },
	{ 'crystal', -57, 7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', -57, 7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', -57, 7, 850, 7, 'v_crystalmedium1a' },
	{ 'silica', -70, 23, 3000, 0, 'v_silica_node' },
	{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },{ 'silica', -70, 23, 200, 0, 'v_silica_medium1' },

	-- K ---- Co-ordinates ( 14, 30 )Position (K)
	{ 'crystal', -12, 28, 5000, 2, 'v_crystal_rich1' },
	{ 'crystal', -12, 28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -12, 28, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -12, 28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -12, 28, 350, 7, 'v_crystalmedium1a' },

	-- L ---- Co-ordinates ( 11,8 )Position (L)
	{ 'metalore', -17, 9, 6000, 3, 'v_metalrich1' },

	----------------------------------------------------------------------------------
	-- TEAM 2 - PLAYERs 3 & 4
	----------------------------------------------------------------------------------

	----------------------------
	--------- PLAYER 3 ---------
	----------------------------

	-- A ---- START -- Co-ordinates ( 63, 93 )Position (A)

	{ 'metalore', 66, -91, 5000, 9, 'v_metalrich1' },
	{ 'crystal', 77, -84, 2000, 2, 'v_crystal_rich1' },
	{ 'silica', 67, -75, 2000, 2, 'v_silica_node' },

	{ 'crystal', 82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -72, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 82, -82, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 80, -90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 80, -90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 80, -90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 80, -90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 80, -90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 80, -90, 350, 7, 'v_crystalmedium1a' },

	-- B ---- Co-ordinates ( 43, 92 )Position (B)

	{ 'crystal', 39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, -85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, -85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, -85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, -85, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', 35, -95, 500, 0, 'v_silica_node' }, { 'silica', 35, -95, 500, 0, 'v_silica_node' },
	-- { 'silica', 28, -86, 110, 0, 'v_silica_medium1' }, { 'silica', 28, -86, 110, 0, 'v_silica_medium1' }, { 'silica', 28, 86, 110, 0, 'v_silica_medium1' },

	-- C ---- Co-ordinates ( 55, 65 )Position (C)METAL / Crystal / Silica

	{ 'crystal', 58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, -62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, -62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, -62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 58, -62, 350, 7, 'v_crystalmedium1a' },

	-- D ---- Co-ordinates ( 15, 90 )Position (D)Silica
	---- Co-ordinates ( 20, 98 Position D: METAL / Crystal

	{ 'metalore', 10, -94, 4000, 5, 'v_metalrich1' },
	-- { 'metalore', 12, 92, 230, 3, 'v_metalmedium1a' }, { 'metalore', 12, 93, 230, 3, 'v_metalmedium1a' }, { 'metalore', 12, 93, 230, 3, 'v_metalmedium1a' },
	{ 'crystal', 20, -98, 2000, 2, 'v_crystal_rich1' },
	{ 'crystal', 18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, -92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, -92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, -92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 18, -92, 350, 7, 'v_crystalmedium1a' },

	-- E ---- Co-ordinates (3, 87 Position (E)

	{ 'silica', 1, -85, 3500, 0, 'v_silica_node' },

	-- F ---- Co-ordinates (7, 57 )Position (F)
	{ 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' },
	{ 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' },
	-- { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 1, -55, 200, 0, 'v_silica_medium1' },
	{ 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' },
	{ 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' },
	-- { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' },
	-- { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', 3, -55, 200, 0, 'v_silica_medium1' },

	-- F ---- Co-ordinates ( 13, 58 )Position F: METAL / Crystal
	{ 'metalore', 10, -44, 5000, 5, 'v_metalrich1' },
	{ 'crystal', 13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, -58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, -58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, -58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 13, -58, 350, 7, 'v_crystalmedium1a' },

	-- G ---- Co-ordinates ( 45, 45 )Position (G)
	{ 'crystal', 37, -49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 37, -49, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 37, -49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 37, -49, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 38, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 38, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 39, -51, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 39, -51, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', 40, -52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 40, -52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 40, -52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 40, -52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 40, -52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 40, -52, 350, 7, 'v_crystalmedium1a' },

	-- H ---- Co-ordinates ( 70, 40 )Position (H)
	-- H ---- Co-ordinates ( 100, 45 )
	{ 'metalore', 100, -45, 5000, 5, 'v_metalrich1' },
	-- { 'crystal', 83, 48, 4520, 2, 'v_crystal_rich1' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 83, -50, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', 81, -61, 2000, 0, 'v_silica_node' },
	{ 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' },{ 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' },
	{ 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' },{ 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' },
	{ 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' },{ 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', 81, -61, 200, 0, 'v_silica_medium1' },

	-- I ---- Co-ordinates ( 82, 15 )Position (I)

	-- J ---- Co-ordinates ( 50, 20 )Position (J)
	{ 'crystal', 57, -7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', 57, -7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', 57, -7, 850, 7, 'v_crystalmedium1a' },
	{ 'crystal', 57, -7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', 57, -7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', 57, -7, 850, 7, 'v_crystalmedium1a' },
	{ 'silica', 70, -23, 3000, 0, 'v_silica_node' },
	{ 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', 70, -23, 200, 0, 'v_silica_medium1' },

	-- K ---- Co-ordinates ( 14, 30 )Position (K)
	{ 'crystal', 12, -28, 5000, 2, 'v_crystal_rich1' },
	{ 'crystal', 12, -28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 12, -28, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', 12, -28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', 12, -28, 350, 7, 'v_crystalmedium1a' },

	-- L ---- Co-ordinates ( 11 8 )Position (L)
	{ 'metalore', 17, -9, 6000, 3, 'v_metalrich1' },

	----------------------------
	--------- PLAYER 4 ---------
	----------------------------

	-- A ---- START -- Co-ordinates ( 63, 93 Position (A)

	{ 'metalore', -66, -91, 5000, 9, 'v_metalrich1' },
	{ 'crystal', -77, -84, 2000, 2, 'v_crystal_rich1' },
	{ 'silica', -67, -75, 2000, 2, 'v_silica_node' },

	{ 'crystal', -82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -72, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -72, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -72, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -82, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -82, -82, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -82, -82, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -80, -90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -80, -90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -80, -90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -80, -90, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -80, -90, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -80, -90, 350, 7, 'v_crystalmedium1a' },

	-- B ---- Co-ordinates ( 43, 92 )Position (B)

	{ 'crystal', -39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, -85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, -85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, -85, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, -85, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, -85, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', -35, -95, 500, 0, 'v_silica_node' }, { 'silica', -35, -95, 500, 0, 'v_silica_node' },
	-- { 'silica', -28, -86, 110, 0, 'v_silica_medium1' }, { 'silica', -28, -86, 110, 0, 'v_silica_medium1' }, { 'silica', -28, 86, 110, 0, 'v_silica_medium1' },

	-- C ---- Co-ordinates ( 55, 65 )Position (C)METAL / Crystal / Silica

	{ 'crystal', -58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, -62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, -62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, -62, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -58, -62, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -58, -62, 350, 7, 'v_crystalmedium1a' },

	-- D ---- Co-ordinates ( 15, 90 Position (D)Silica
	---- Co-ordinates ( 20, 98 )Position D: METAL / Crystal

	{ 'metalore', -10, -94, 4000, 5, 'v_metalrich1' },
	-- { 'metalore', -12, 92, 230, 3, 'v_metalmedium1a' }, { 'metalore', -12, 93, 230, 3, 'v_metalmedium1a' }, { 'metalore', -12, 93, 230, 3, 'v_metalmedium1a' },
	{ 'crystal', -20, -98, 2000, 2, 'v_crystal_rich1' },
	{ 'crystal', -18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, -92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, -92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, -92, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -18, -92, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -18, -92, 350, 7, 'v_crystalmedium1a' },

	-- E ---- Co-ordinates (3, 87 Position (E)

	{ 'silica', -1, -85, 3500, 0, 'v_silica_node' },

	-- F ---- Co-ordinates (7, 57 )Position (F)
	{ 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' },
	{ 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' },
	-- { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -1, -55, 200, 0, 'v_silica_medium1' },
	{ 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' },
	{ 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' },
	-- { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' },
	-- { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' }, { 'silica', -3, -55, 200, 0, 'v_silica_medium1' },

	-- F ---- Co-ordinates ( 13, 58 )Position F: METAL / Crystal
	{ 'metalore', -10, -44, 5000, 5, 'v_metalrich1' },
	{ 'crystal', -13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, -58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, -58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, -58, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -13, -58, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -13, -58, 350, 7, 'v_crystalmedium1a' },


	-- G ---- Co-ordinates ( 45, 45 )Position (G)
	{ 'crystal', -37, -49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -37, -49, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -37, -49, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -37, -49, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -38, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -38, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -39, -51, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -39, -51, 350, 7, 'v_crystalmedium1a' },

	{ 'crystal', -40, -52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -40, -52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -40, -52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -40, -52, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -40, -52, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -40, -52, 350, 7, 'v_crystalmedium1a' },


	-- H ---- Co-ordinates ( 70, 40 ) Position (H)
	-- H ---- Co-ordinates ( 100, 45 )
	{ 'metalore', -100, -45, 5000, 5, 'v_metalrich1' },
	-- { 'crystal', -83, 48, 4520, 2, 'v_crystal_rich1' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -83, -50, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -83, -50, 350, 7, 'v_crystalmedium1a' },

	{ 'silica', -81, -61, 2000, 0, 'v_silica_node' },
	{ 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' },
	{ 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' },
	{ 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' }, { 'silica', -81, -61, 200, 0, 'v_silica_medium1' },

	-- I ---- Co-ordinates ( 82, 15 )Position (I)

	-- J ---- Co-ordinates ( 50, 20 )Position (J)
	{ 'crystal', -57, -7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', -57, -7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', -57, -7, 850, 7, 'v_crystalmedium1a' },
	{ 'crystal', -57, -7, 850, 6, 'v_crystalmedium1a' }, { 'crystal', -57, -7, 850, 7, 'v_crystalmedium1a' }, { 'crystal', -57, -7, 850, 7, 'v_crystalmedium1a' },
	{ 'silica', -70, -23, 3000, 0, 'v_silica_node' },
	{ 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' }, { 'silica', -70, -23, 200, 0, 'v_silica_medium1' },

	-- K ---- Co-ordinates ( 14, 30 )Position (K)
	{ 'crystal', -12, -28, 5000, 2, 'v_crystal_rich1' },
	{ 'crystal', -12, -28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -12, -28, 350, 7, 'v_crystalmedium1a' },
	{ 'crystal', -12, -28, 350, 6, 'v_crystalmedium1a' }, { 'crystal', -12, -28, 350, 7, 'v_crystalmedium1a' },

	-- L ---- Co-ordinates ( 11,8 )Position (L)
	{ 'metalore', -17, -9, 6000, 3, 'v_metalrich1' },
}

----
---- EXPLORABLE LOCATIONS
---- BUG HIVES
----

md.bugs_array = {
	-- TEAM 1: PLAYERS 1 & 2

	----- PLAYER 1 -----
	--[[
	---- Co-ordinates ( 63, 93 )Position (A)
	---- Co-ordinates ( 43, 92 )Position (B)
	{ "f_bug_hole", 42, 92, 1, 5 }, { "f_bug_hole", 41, 90, 1, 5 }, { "f_bug_hole", 41, 89, 1, 5 },

	---- Co-ordinates ( 55, 65 )Position (C)
	{ "f_bug_hive", 57, 63, 1, 12 },
	{ "f_bug_hole", 49, 65, 1, 6 }, { "f_bug_hole", 51, 67, 1, 7 }, { "f_bug_hole", 53, 70, 1, 8 },{ "f_bug_hole", 54, 70, 1, 9 },
	--]]

	---- Co-ordinates ( 15, 90 )Position (D)
	{ "f_bug_hole", 12, 90, 1, 10 }, { "f_bug_hole", 15, 91, 1, 11 }, { "f_bug_hole", 13, 92, 1, 13 }, { "f_bug_hole", 17, 94, 1, 15 },
	{ "f_bug_hole", 17, 88, 1, 13 }, { "f_bug_hole", 19, 94, 1, 16 }, { "f_bug_hole", 21, 87, 1, 12 }, { "f_bug_hole", 20, 86, 1, 15 },

	---- Co-ordinates (3, 87 )Position (E)
	{ "f_bug_hive", 1, 90, 1, 18 }, { "f_bug_hole", 1, 88, 1, 12 }, { "f_bug_hole", 2, 87, 1, 12 }, --{ "f_bug_hive", 6, -86, 1, 15 },

	---- Co-ordinates (7, 57 )Position (F)
	{ "f_bug_hive", 7, 57, 1, 15 },
	{ "f_bug_hole", 7, 55, 1, 10 }, { "f_bug_hole", 8, 59, 1, 11 }, { "f_bug_hole", 11, 60, 1, 13 }, { "f_bug_hole", 9, 61, 1, 15 },

	---- Co-ordinates ( 45, 45 )Position (G)
	{ "f_bug_hive", 45, 45, 1, 20 },

	---- Co-ordinates ( 70, 40 )Position (H)
	{ "f_bug_hive", 70, 40, 1, 20 }, { "f_bug_hive", 70, 40, 1, 15 },
	{ "f_bug_hole", 68, 45, 1, 10 }, { "f_bug_hole", 71, 41, 1, 11 }, { "f_bug_hole", 74, 38, 1, 13 }, { "f_bug_hole", 69, 39, 1, 15 },

	---- Co-ordinates ( 82, 15 )Position (I)
	{ "f_bug_hive", 82, 15, 1, 30 }, { "f_bug_hive", 82, 15, 1, 15 },

	---- Co-ordinates ( 50, 20 )Position (J)
	{ "f_bug_hive", 50, 20, 1, 30 }, { "f_bug_hive", 50, 20, 1, 20 },

	---- Co-ordinates ( 14, 30 )Position (K)
	{ "f_bug_hive", 14, 30, 1, 35 }, { "f_bug_hive", 14, 30, 1, 35 },

	---- Co-ordinates ( 11,8 )Position (L)
	{ "f_bug_hive", 11,8, 1, 35 }, { "f_bug_hive", 11,8, 1, 35 }, { "f_bug_hive", 11,8, 1, 35 },


	----- PLAYER 2 -----

	--[[
	---- Co-ordinates ( -63, 93 )Position (A)
	---- Co-ordinates ( -43, 92 )Position (B)
	{ "f_bug_hole", -42, 92, 1, 5 }, { "f_bug_hole", -41, 90, 1, 5 }, { "f_bug_hole", -41, 89, 1, 5 },

	---- Co-ordinates ( -55, 65 )Position (C)
	{ "f_bug_hive", -57, 63, 1, 12 },
	{ "f_bug_hole", -49, 65, 1, 6 }, { "f_bug_hole", -51, 67, 1, 7 }, { "f_bug_hole", -53, 70, 1, 8 }, { "f_bug_hole", -54, 70, 1, 9 },
	--]]

	---- Co-ordinates ( -15, 90 )Position (D)
	{ "f_bug_hole", -12, 90, 1, 10 }, { "f_bug_hole", -15, 91, 1, 11 }, { "f_bug_hole", -13, 92, 1, 13 }, { "f_bug_hole", -17, 94, 1, 15 },
	{ "f_bug_hole", -17, 88, 1, 13 }, { "f_bug_hole", -19, 94, 1, 16 }, { "f_bug_hole", -21, 87, 1, 12 }, { "f_bug_hole", -20, 86, 1, 15 },

	---- Co-ordinates (-3, 87 )Position (E)
	{ "f_bug_hive", -1, 90, 1, 18 }, { "f_bug_hole", -1, 88, 1, 12 }, { "f_bug_hole", -2, 87, 1, 12 }, --{ "f_bug_hive", 6, -86, 1, 15 },

	---- Co-ordinates (-7, 57 )Position (F)
	{ "f_bug_hive", -7, 57, 1, 15 },
	{ "f_bug_hole", -7, 55, 1, 10 }, { "f_bug_hole", -8, 59, 1, 11 }, { "f_bug_hole", -11, 60, 1, 13 }, { "f_bug_hole", -9, 61, 1, 15 },

	---- Co-ordinates ( -45, 45 )Position (G)
	{ "f_bug_hive", -45, 45, 1, 20 },

	---- Co-ordinates ( -70, 40 )Position (H)
	{ "f_bug_hive", -70, 40, 1, 20 }, { "f_bug_hive", -70, 40, 1, 15 },
	{ "f_bug_hole", -68, 45, 1, 10 }, { "f_bug_hole", -71, 41, 1, 11 }, { "f_bug_hole", -74, 38, 1, 13 }, { "f_bug_hole", -69, 39, 1, 15 },

	---- Co-ordinates ( -82, 15 )Position (I)
	{ "f_bug_hive", -82, 15, 1, 30 }, { "f_bug_hive", -82, 15, 1, 15 },

	---- Co-ordinates ( -50, 20 )Position (J)
	{ "f_bug_hive", -50, 20, 1, 30 }, { "f_bug_hive", -50, 20, 1, 20 },

	---- Co-ordinates ( -14, 30 )Position (K)
	{ "f_bug_hive", -14, 30, 1, 35 }, { "f_bug_hive", -14, 30, 1, 35 },

	---- Co-ordinates ( -11,8 )Position (L)
	{ "f_bug_hive", -11, 8, 1, 35 }, { "f_bug_hive", -11, 8, 1, 35 }, { "f_bug_hive", -11, 8, 1, 35 },

	-- TEAM 2: PLAYERS 3 & 4

	----- PLAYER 3 -----
	--[[
	---- Co-ordinates ( 63, -93 )Position (A)
	---- Co-ordinates ( 43, -92 ) Position (B)
	{ "f_bug_hole", 42, -92, 1, 5 }, { "f_bug_hole", 41, -90, 1, 5 }, { "f_bug_hole", 41, -89, 1, 5 },

	---- Co-ordinates ( 55, -65 )Position (C)
	{ "f_bug_hive", 57, -63, 1, 12 },
	{ "f_bug_hole", 49, -65, 1, 6 }, { "f_bug_hole", 51, -67, 1, 7 }, { "f_bug_hole", 53, -70, 1, 8 }, { "f_bug_hole", 54, -70, 1, 9 },
	--]]

	---- Co-ordinates ( 15, -90 )Position (D)
	{ "f_bug_hole", 12, -90, 1, 10 }, { "f_bug_hole", 15, -91, 1, 11 }, { "f_bug_hole", 13, -92, 1, 13 }, { "f_bug_hole", 17, -94, 1, 15 },
	{ "f_bug_hole", 17, -88, 1, 13 }, { "f_bug_hole", 19, -94, 1, 16 }, { "f_bug_hole", 21, -87, 1, 12 }, { "f_bug_hole", 20, -86, 1, 15 },

	---- Co-ordinates ( 3, -87 )Position (E)
	{ "f_bug_hive", 1, -90, 1, 18 }, { "f_bug_hole", 1, -88, 1, 12 }, { "f_bug_hole", 2, -87, 1, 12 }, --{ "f_bug_hive", 6, -86, 1, 15 },

	---- Co-ordinates ( 7, -57 )Position (F)
	{ "f_bug_hive", 7, -57, 1, 15 },
	{ "f_bug_hole", 7, -55, 1, 10 }, { "f_bug_hole", 8, -59, 1, 11 }, { "f_bug_hole", 11, -60, 1, 13 }, { "f_bug_hole", 9, -61, 1, 15 },

	---- Co-ordinates ( 45, -45 )Position (G)
	{ "f_bug_hive", 45, -45, 1, 20 },

	---- Co-ordinates ( 70, -40 )Position (H)
	{ "f_bug_hive", 70, -40, 1, 20 }, { "f_bug_hive", 70, -40, 1, 15 },
	{ "f_bug_hole", 68, -45, 1, 10 }, { "f_bug_hole", 71, -41, 1, 11 }, { "f_bug_hole", 74, -38, 1, 13 }, { "f_bug_hole", 69, -39, 1, 15 },

	---- Co-ordinates ( 82, -15 )Position (I)
	{ "f_bug_hive", 82, -15, 1, 30 }, { "f_bug_hive", 82, -15, 1, 15 },

	---- Co-ordinates ( 50, -20 )Position (J)
	{ "f_bug_hive", 50, -20, 1, 30 }, { "f_bug_hive", 50, -20, 1, 20 },

	---- Co-ordinates ( 14, -30 )Position (K)
	{ "f_bug_hive", 14, -30, 1, 35 }, { "f_bug_hive", 14, -30, 1, 35 },

	---- Co-ordinates ( 11, -8 )Position (L)
	{ "f_bug_hive", 11, -8, 1, 35 }, { "f_bug_hive", 11, -8, 1, 35 }, { "f_bug_hive", 11, -8, 1, 35 },

	----- PLAYER 4 -----

	--[[
	---- Co-ordinates ( -63, -93 )Position (A)
	---- Co-ordinates ( -43, -92 )Position (B)
	{ "f_bug_hole", -42, -92, 1, 5 }, { "f_bug_hole", -41, -90, 1, 5 }, { "f_bug_hole", -41, -89, 1, 5 },

	---- Co-ordinates ( -55, -65 )Position (C)
	{ "f_bug_hive", -57, -63, 1, 12 },
	{ "f_bug_hole", -49, -65, 1, 6 }, { "f_bug_hole", -51, -67, 1, 7 }, { "f_bug_hole", -53, -70, 1, 8 }, { "f_bug_hole", -54, -70, 1, 9 },
	--]]

	---- Co-ordinates ( 15, 90 )Position (D)
	{ "f_bug_hole", -12, -90, 1, 10 }, { "f_bug_hole", -15, -91, 1, 11 }, { "f_bug_hole", -13, -92, 1, 13 }, { "f_bug_hole", -17, -94, 1, 15 },
	{ "f_bug_hole", -17, -88, 1, 13 }, { "f_bug_hole", -19, -94, 1, 16 }, { "f_bug_hole", -21, -87, 1, 12 }, { "f_bug_hole", -20, -86, 1, 15 },

	---- Co-ordinates ( 3, 87 )Position (E)
	{ "f_bug_hive", -1, -90, 1, 18 }, { "f_bug_hole", -1, -88, 1, 12 }, { "f_bug_hole", -2, -87, 1, 12 }, --{ "f_bug_hive", -6, -86, 1, 15 },

	---- Co-ordinates ( 7, 57 )Position (F)
	{ "f_bug_hive", -7, -57, 1, 15 },
	{ "f_bug_hole", -7, -55, 1, 10 }, { "f_bug_hole", -8, -59, 1, 11 }, { "f_bug_hole", -11, -60, 1, 13 }, { "f_bug_hole", -9, -61, 1, 15 },

	---- Co-ordinates ( 45, 45 )Position (G)
	{ "f_bug_hive", -45, -45, 1, 20 },

	---- Co-ordinates ( 70, 40 )Position (H)
	{ "f_bug_hive", -70, -40, 1, 20 }, { "f_bug_hive", -70, -40, 1, 15 },
	{ "f_bug_hole", -68, -45, 1, 10 }, { "f_bug_hole", -71, -41, 1, 11 }, { "f_bug_hole", -74, -38, 1, 13 }, { "f_bug_hole", -69, -39, 1, 15 },

	---- Co-ordinates ( 82, 15 )Position (I)
	{ "f_bug_hive", -82, -15, 1, 30 }, { "f_bug_hive", -82, -15, 1, 15 },

	---- Co-ordinates ( 50, 20 )Position (J)
	{ "f_bug_hive", -50, -20, 1, 30 }, { "f_bug_hive", -50, -20, 1, 20 },

	---- Co-ordinates ( 14, 30 )Position (K)
	{ "f_bug_hive", -14, -30, 1, 35 }, { "f_bug_hive", -14, -30, 1, 35 },

	---- Co-ordinates ( 11, 8 )Position (L)
	{ "f_bug_hive", -11, -8, 1, 35 }, { "f_bug_hive", -11, -8, 1, 35 }, { "f_bug_hive", -11, -8, 1, 35 },
}

md.creep_array = {
	----- PLAYER 1 -----
	---- Position A:
	----- PLAYER 2 -----
	---- Position A:
}

md.spawn_explorables = function()

	-- ALLIANCE 1: PLAYERS 1 & 2

	----- PLAYER 1 -----

	--[[
	---- Position B:
	data.explorables.broken_ship:SpawnExplorable(44, 92)
	local exp = Map.GetEntityAt(44, 92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_small_relay = 1,
			reinforced_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", 44, 92)
	end

	---- Position C:
	data.explorables.broken_ship:SpawnExplorable(55, 65)
	local exp = Map.GetEntityAt(55, 65)
	if exp then
		exp.extra_data.rewards = {
			c_solar_cell = 2,
			c_small_relay = 1,
			c_adv_portable_turret = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", 55, 65)
	end
	--]]

	---- Position E:
	data.explorables.broken_ship:SpawnExplorable(4, 92)
	local exp = Map.GetEntityAt(4, 92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_power_relay = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 4, 92)
	end

	---- Position F:
	data.explorables.broken_ship:SpawnExplorable(6, 57)
	local exp = Map.GetEntityAt(6, 57)
	if exp then
		exp.extra_data.rewards = {
			c_repairer_aoe = 1,
			c_power_relay = 1,
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 6, 57)
	end
	---- Position G:
	data.explorables.broken_ship:SpawnExplorable(45, 45)
	local exp = Map.GetEntityAt(45, 45)
	if exp then
		exp.extra_data.rewards = {
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 45, 45)
	end
	---- Position H:
	data.explorables.broken_ship:SpawnExplorable(70, 40)
	local exp = Map.GetEntityAt(70, 40)
	if exp then
		exp.extra_data.rewards = {
			c_repairer = 1,
			c_power_core = 1,
			reinforced_plate = 20,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 70, 40)
	end

	---- Position I:
	data.explorables.broken_ship:SpawnExplorable(82, 16)
	local exp = Map.GetEntityAt(82, 16)
	if exp then
		exp.extra_data.rewards = {
			c_solar_panel = 1,
			c_power_relay = 1,
			c_turret = 1,
			reinforced_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 82, 16)
	end

	---- Position J:
	data.explorables.broken_ship:SpawnExplorable(55, 20)
	local exp = Map.GetEntityAt(55, 20)
	if exp then
		exp.extra_data.rewards = {
			c_twin_autocannons = 2,
			c_turret = 1,
			c_shield_generator3 = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 55, 20)
	end

	---- Position L:
	data.explorables.broken_ship:SpawnExplorable(10, 8)
	local exp = Map.GetEntityAt(10, 8)
	if exp then
		exp.extra_data.rewards = {
			c_plasma_cannon = 1,
			c_wind_turbine = 2,
			c_power_relay = 1,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 10, 8)
	end

	---------
	---------
	---------
	---------

	----- PLAYER 2 -----

	--[[
	---- Position B:
	data.explorables.broken_ship:SpawnExplorable(-44, 92)
	local exp = Map.GetEntityAt(-44, 92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_small_relay = 1,
			reinforced_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", -44, 92)
	end

	---- Position C:
	data.explorables.broken_ship:SpawnExplorable(-55, 65)
	local exp = Map.GetEntityAt(-55, 65)
	if exp then
		exp.extra_data.rewards = {
			c_solar_cell = 2,
			c_small_relay = 1,
			c_adv_portable_turret = 1,
			reinforced_plate = 20,
			energized_plate = 20,
		}
	else
		print("can't spawn explorable at location specified", -55, 65)
	end
	--]]

	---- Position E:
	data.explorables.broken_ship:SpawnExplorable(-4, 92)
	local exp = Map.GetEntityAt(-4, 92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_power_relay = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -4, 92)
	end

	---- Position F:
	data.explorables.broken_ship:SpawnExplorable(-6, 57)
	local exp = Map.GetEntityAt(-6, 57)
	if exp then
		exp.extra_data.rewards = {
			c_repairer_aoe = 1,
			c_power_relay = 1,
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -6, 57)
	end
	---- Position G:
	data.explorables.broken_ship:SpawnExplorable(-45, 45)
	local exp = Map.GetEntityAt(-45, 45)
	if exp then
		exp.extra_data.rewards = {
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -45, 45)
	end
	---- Position H:
	data.explorables.broken_ship:SpawnExplorable(-70, 40)
	local exp = Map.GetEntityAt(-70, 40)
	if exp then
		exp.extra_data.rewards = {
			c_repairer = 1,
			c_power_core = 1,
			reinforced_plate = 20,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -70, 40)
	end

	---- Position I:
	data.explorables.broken_ship:SpawnExplorable(-82, 16)
	local exp = Map.GetEntityAt(-82, 16)
	if exp then
		exp.extra_data.rewards = {
			c_solar_panel = 1,
			c_power_relay = 1,
			c_turret = 1,
			reinforced_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -82, 16)
	end

	---- Position J:
	data.explorables.broken_ship:SpawnExplorable(-55, 20)
	local exp = Map.GetEntityAt(-55, 20)
	if exp then
		exp.extra_data.rewards = {
			c_twin_autocannons = 2,
			c_turret = 1,
			c_shield_generator3 = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -55, 20)
	end

	---- Position L:
	data.explorables.broken_ship:SpawnExplorable(-10, 8)
	local exp = Map.GetEntityAt(-10, 8)
	if exp then
		exp.extra_data.rewards = {
			c_plasma_cannon = 1,
			c_wind_turbine = 2,
			c_power_relay = 1,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -10, 8)
	end

	---------
	---------
	---------
	---------
	---------
	---------
	---------
	---------

	---------------------------------------------------------
	-- TEAM 2: PLAYERS 3 & 4
	---------------------------------------------------------

	-- PLAYER 3

	--[[
	---- Position B:
	data.explorables.broken_ship:SpawnExplorable(44, -93)
	local exp = Map.GetEntityAt(44, -93)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_small_relay = 1,
		}
	else
		print("can't spawn explorable at location specified", 44, -93)
	end

	---- Position C:
	data.explorables.broken_ship:SpawnExplorable(55, -65)
	local exp = Map.GetEntityAt(55, -65)
	if exp then
		exp.extra_data.rewards = {
			c_solar_cell = 2,
			c_small_relay = 1,
		}
	else
		print("can't spawn explorable at location specified", 55, -65)
	end
	--]]

	---- Position E:
	data.explorables.broken_ship:SpawnExplorable(4, -92)
	local exp = Map.GetEntityAt(4, -92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_power_relay = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 4, -92)
	end

	---- Position F:
	data.explorables.broken_ship:SpawnExplorable(6, -57)
	local exp = Map.GetEntityAt(6, -57)
	if exp then
		exp.extra_data.rewards = {
			c_repairer_aoe = 1,
			c_power_relay = 1,
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 6, -57)
	end
	---- Position G:
	data.explorables.broken_ship:SpawnExplorable(45, -45)
	local exp = Map.GetEntityAt(45, -45)
	if exp then
		exp.extra_data.rewards = {
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 45, -45)
	end
	---- Position H:
	data.explorables.broken_ship:SpawnExplorable(70, -40)
	local exp = Map.GetEntityAt(70, -40)
	if exp then
		exp.extra_data.rewards = {
			c_repairer = 1,
			c_power_core = 1,
			reinforced_plate = 20,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 70, -40)
	end

	---- Position I:
	data.explorables.broken_ship:SpawnExplorable(82, -16)
	local exp = Map.GetEntityAt(82, -16)
	if exp then
		exp.extra_data.rewards = {
			c_solar_panel = 1,
			c_power_relay = 1,
			c_turret = 1,
		}
	else
		print("can't spawn explorable at location specified", 82, -16)
	end

	---- Position J:
	data.explorables.broken_ship:SpawnExplorable(55, -20)
	local exp = Map.GetEntityAt(55, -20)
	if exp then
		exp.extra_data.rewards = {
			c_twin_autocannons = 2,
			c_turret = 1,
			c_shield_generator3 = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 55, -20)
	end

	---- Position L:
	data.explorables.broken_ship:SpawnExplorable(10, -8)
	local exp = Map.GetEntityAt(10, -8)
	if exp then
		exp.extra_data.rewards = {
			c_plasma_cannon = 1,
			c_wind_turbine = 2,
			c_power_relay = 1,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", 10, -8)
	end

	---------
	---------
	---------
	---------

	-- PLAYER 4

	--[[
	---- Position B:
	data.explorables.broken_ship:SpawnExplorable(-44, -92)
	local exp = Map.GetEntityAt(-44, -92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_small_relay = 1,
		}
	else
		print("can't spawn explorable at location specified", -44, -92)
	end

	---- Position C:
	data.explorables.broken_ship:SpawnExplorable(-55, -65)
	local exp = Map.GetEntityAt(-55, -65)
	if exp then
		exp.extra_data.rewards = {
			c_solar_cell = 2,
			c_small_relay = 1,
		}
	else
		print("can't spawn explorable at location specified", -55, -65)
	end
	--]]

	---- Position E:
	data.explorables.broken_ship:SpawnExplorable(-4, -92)
	local exp = Map.GetEntityAt(-4, -92)
	if exp then
		exp.extra_data.rewards = {
			c_repairkit = 2,
			c_power_relay = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -4, -92)
	end

	---- Position F:
	data.explorables.broken_ship:SpawnExplorable(-6, -57)
	local exp = Map.GetEntityAt(-6, -57)
	if exp then
		exp.extra_data.rewards = {
			c_repairer_aoe = 1,
			c_power_relay = 1,
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -6, -57)
	end
	---- Position G:
	data.explorables.broken_ship:SpawnExplorable(-45, -45)
	local exp = Map.GetEntityAt(-45, -45)
	if exp then
		exp.extra_data.rewards = {
			c_power_transmitter = 1,
			c_turret = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -45, -45)
	end
	---- Position H:
	data.explorables.broken_ship:SpawnExplorable(-70, -40)
	local exp = Map.GetEntityAt(-70, -40)
	if exp then
		exp.extra_data.rewards = {
			c_repairer = 1,
			c_power_core = 1,
			reinforced_plate = 20,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -70, -40)
	end

	---- Position I:
	data.explorables.broken_ship:SpawnExplorable(-82, -16)
	local exp = Map.GetEntityAt(-82, -16)
	if exp then
		exp.extra_data.rewards = {
			c_solar_panel = 1,
			c_power_relay = 1,
			c_turret = 1,
		}
	else
		print("can't spawn explorable at location specified", -82, -16)
	end

	---- Position J:
	data.explorables.broken_ship:SpawnExplorable(-55, -20)
	local exp = Map.GetEntityAt(-55, -20)
	if exp then
		exp.extra_data.rewards = {
			c_twin_autocannons = 2,
			c_turret = 1,
			c_shield_generator3 = 1,
			energized_plate = 20,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -55, -20)
	end

	---- Position L:
	data.explorables.broken_ship:SpawnExplorable(-10, -8)
	local exp = Map.GetEntityAt(-10, -8)
	if exp then
		exp.extra_data.rewards = {
			c_plasma_cannon = 1,
			c_wind_turbine = 2,
			c_power_relay = 1,
			hdframe = 20,
		}
	else
		print("can't spawn explorable at location specified", -10, -8)
	end
end

md.faction_info = {
	{
		spawn_location = { x = 70, y = 83 },
	},
	{
		spawn_location = { x = -70, y = -83 },
	},
	{
		spawn_location = { x = 70, y = -83 },
	},
	{
		spawn_location = { x = -70, y = 83 },
	},
}
