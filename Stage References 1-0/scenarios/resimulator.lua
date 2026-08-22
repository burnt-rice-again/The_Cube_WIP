local package = ...

function package:setup_scenario(settings)
	settings.seed = 0
	settings.is_challenge = true
end

function package:init()
	data.frames.f_building_sim.on_placed = function(self, entity)
		if entity.faction.is_player_controlled and not entity.faction.extra_data.challenge_resimulator then
			entity.faction.extra_data.challenge_resimulator = true
			Map.SetGameSpeed(0)
			UI.Run("FinishChallenge", "challenge_resimulator", "Resimulator challenge Complete!", "Main/textures/icons/frame/3x3_SIM.png", function() Action.SendFromPlayer("PauseGame", { pause = false }) end)
		end
	end
end

function UIMsg.OnSetup(faction)
	UI.Run("StartChallenge", "Resimulator challenge", "Main/textures/icons/frame/3x3_SIM.png", "Complete the Resimulator")
end
