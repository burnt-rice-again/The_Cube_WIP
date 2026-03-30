-- This file is only used in challenge scenarios
if not Map.GetSettings().is_challenge then return end

data.objectives = {}

function UIMsg.StartChallenge(title, icon, text)
	Game.OfflinePause(true)
	MessageBox(L('<img image="%S"/>\n%s', icon, text), title, function() Game.OfflinePause(false) DoChallengeObjective("start_game", Game.GetLocalPlayerFaction()) end)
end

function UIMsg.FinishChallenge(score_profile_key, title, icon, on_close)
	local action_count, tick_count = Map.GetExecutedActionCount(), Map.GetTick()

	local newbest = false
	if score_profile_key and tick_count < (Game.GetProfile()[score_profile_key] or 99999) then
		Game.GetProfile()[score_profile_key] = tick_count
		newbest = true
	end

	local msg = L('<img image="%S"/>\n%s\n%s: %s', icon, newbest and L(" ** %s **", "New Best") or "", "Time", Tool.GetTimeDurationStr(tick_count//TICKS_PER_SECOND))
	MessageBox(msg, title, on_close)
end

function UIMsg.EndChallenge(score_profile_key, title, icon, next_challenge)
	local action_count, tick_count = Map.GetExecutedActionCount(), Map.GetTick()

	local newbest = false
	if score_profile_key and tick_count < (Game.GetProfile()[score_profile_key] or 99999) then
		Game.GetProfile()[score_profile_key] = tick_count
		newbest = true
	end

	UI.AddLayout("<ConfirmDialog ok_text='Next Challenge' cancel_text='Back to Main Menu' buttons_width=600/>", {
		title = title,
		body = L('<img image="%S"/>\n%s\n%s: %s', icon, newbest and L(" ** %s **", "New Best") or "", "Time", Tool.GetTimeDurationStr(tick_count//TICKS_PER_SECOND)),
		ok = next_challenge and function()
			Game.NewGame({scenario = next_challenge})
		end,
		cancel = function()
			Game.EndGame()
		end,
	}, 99)
end

function DoChallengeObjective(id, faction)
	local fac = faction or Game.GetLocalPlayerFaction()
	if Map.IsSimulation() then
		FactionAction.ChallengeObjective(fac, { id = id })
	elseif not Action.IsReplayPlayback() and not (fac.extra_data.freeplay_objectives or {})[id] then
		Action.SendForLocalFaction("ChallengeObjective", { id = id })
	end
end

function FactionAction.ChallengeObjective(faction, arg)
	if not arg.id then return end
	local obj = data.objectives[arg.id]
	if not obj then return end
	if obj.notification then
		faction:RunUI(function() obj:notification() end)
	end
	if obj.action then
		obj:action(faction)
	end
end
