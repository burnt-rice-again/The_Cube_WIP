local active_music = nil

local function StartMusic(fx)
	--print("[StartMusic] music: " .. fx)
	active_music = fx
	UI.PlaySound(fx)
end

local discovered_blight = false
local function PlayDefaultMusic()
	local faction = Game.GetLocalPlayerFaction()
	local moods = faction.moods
	local total, sum, track_chances = 0, 0, nil
	local locked_blight= not faction:IsUnlocked("t_blight_plasma")

	if moods.battle > 80 then
		track_chances = {
			fx_music_alien_darkness   = 100,
			fx_music_alien_encounter  = 100,
		}
	elseif moods.blight > 50 and locked_blight then
		track_chances = {
			fx_music_alien_mystery    = 100,
			fx_music_alien_encounter  = 100,
		}
		FactionCount("entered_blight", true)
	else
		track_chances = {
			fx_music_storytelling    = 100,
			fx_music_storytelling2   = 100,
			fx_music_upbeat          = 100,
			fx_music_upbeat2         = 100,
			fx_music_base_building   = 100,
			fx_music_base_building2  = 100,
			fx_music_base_building3  = 100,
			fx_music_base_building4  = 100,
			fx_music_puzzle          = 100,
			fx_music_alien_darkness  = moods.battle,
			fx_music_alien_mystery   = moods.blight,
			fx_music_alien_encounter = (moods.battle+moods.blight)/2,
		}
	end

	if track_chances[active_music] then
		track_chances[active_music] = track_chances[active_music] / 3
	end

	for fx,value in pairs(track_chances) do
		total = total + value
	end

	local roll = math.random() * total
	--print("[PlayDefaultMusic] track_chances: " .. tostring(track_chances) .. " - total: " .. total .. " - roll: " .. roll)
	for fx,value in pairs(track_chances) do
		sum = sum + value
		if sum >= roll then
			--print("[PlayDefaultMusic] start music: " .. fx .. " - value: " .. value .. " - total: " .. total .. " - sum: " .. sum .. " - roll: " .. roll)
			return StartMusic(fx)
		end
	end
end

function UIMsg.OnUpdateLocalFaction(faction)
	local moods = faction.moods
	local locked_blight = not Game.GetLocalPlayerFaction():IsUnlocked("t_blight_plasma")
	local switch_blight_in = locked_blight and moods.blight > 90
	local switch_blight_out = locked_blight and moods.blight < 10
	local switch_track
	if active_music == "fx_music_alien_darkness" then
		switch_track = moods.battle < 10 -- End battle music
	elseif active_music == "fx_music_alien_mystery" then
		switch_track = moods.battle > 90 or switch_blight_out -- Start battle music / End blight music
	elseif active_music == "fx_music_alien_encounter" then
		switch_track = moods.battle < 10 and switch_blight_out -- End encounter music
	else
		switch_track = moods.battle > 90 or switch_blight_in -- Start battle music / Start blight music
	end
	if switch_track then
		PlayDefaultMusic()
	end
end

function UIMsg.OnMusicFinished()
	--print("[UIOnMusicFinished]")
	if Map.GetTick() == 1 then
		StartMusic("fx_music_base_building2")
	else
		PlayDefaultMusic()
	end
end

function UIMsg.OnViewTile(x, y, discovered, elevation, blightness)
	--print("[UIOnViewTile] (x, y, discovered, elevation, blightness)", x, y, discovered, elevation, blightness)
	if not discovered then
		UI.StopAmbienceSound()
	elseif blightness > 0.07 then
		UI.PlaySound("fx_ambience_BLIGHT_AMBIENT_ZONE")
	elseif elevation < -0.18 then
		UI.PlaySound("fx_ambience_GENERAL_AMBIENT_ZONE")
	elseif elevation < 0.12 then
		UI.PlaySound("fx_ambience_FOREST_AMBIENT_ZONE")
	else
		UI.PlaySound("fx_ambience_PLATEAU_AMBIENT_ZONE")
	end
end
