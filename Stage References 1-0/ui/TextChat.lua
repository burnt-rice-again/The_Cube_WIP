local TextChat_layout<const> = [[
	<VerticalList x=50 width=600 y=80 dock=top-left>
		<Box height=300 margin_bottom=4 bg=false><ScrollList opacity=0 id=logbox/></Box>
		<InputText opacity=0 id=editinput on_change={on_change} on_enter={on_commit} on_leave={hideinput}/>
	</VerticalList>
]]

local TextChat, chatinst, chatshowinput = {}
UI.Register("TextChat", TextChat_layout, TextChat)

function TextChat:construct(v)
	chatinst = self
	self:SetIgnoreHitTest()
end

function TextChat:showinput()
	chatshowinput = true
	self.editinput:TweenTo("opacity", 1, 150)
	self.editinput:Focus()
	self:SetIgnoreHitTest(false)
	self:Show()
end

function TextChat:hideinput(editinput)
	chatshowinput = false
	editinput.text = ""
	editinput:TweenTo("opacity", 0, 500)
	editinput:Unfocus()
	self:SetIgnoreHitTest()
	self:Show(10)
end

function TextChat:on_change(editinput, value)
	local trunc = Tool.TruncateString(value, 2048)
	if #trunc ~= #value then editinput.text = trunc end
end

function TextChat:on_commit(editinput, value)
	self:hideinput(editinput)
	if not value or value == "" then return end
	UI.SendChatGlobal("Text", { txt = Tool.TruncateString(value, 2048) })
end

function TextChat:Show(hidetime)
	self.logbox:TweenTo("opacity", 1, 500, not chatshowinput and hidetime and function()
		if not chatinst then return end
		chatinst.logbox:TweenTo("opacity", 0.3, 500, hidetime * 1000 - 500, function()
			if not chatinst then return end
			chatinst.logbox:TweenTo("opacity", 0, 500, 4500)
		end)
	end)
end

function UIShowTextChat()
	if chatinst then
		chatinst:showinput()
	end
end

function Chat.Text(arg, player_id)
	arg.player_id = player_id
	UI.Run("OnReceivedChat", arg)
end

function UIMsg.OnReceivedChat(arg)
	if chatinst then
		chatinst:Show(10)
		local txt = L("%S[%S]</> %S", (Game.IsLocalPlayer(arg.player_id) and "-> <bl>" or "<hl>"), Game.GetPlayerName(arg.player_id), Tool.TruncateString(arg.txt, 2048))
		chatinst.logbox:Add("<Text style=outline wrap=true wrapsize=590/>").text = txt
		chatinst.logbox:ScrollToEnd()
	end
end
