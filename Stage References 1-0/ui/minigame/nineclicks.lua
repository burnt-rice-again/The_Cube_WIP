local NineClicks_layout<const> =
[[
	<Box bg="Main/textures/icons/explorablespanel/powerclickpuzzle/powerclickpuzzle-base.png">
		<VerticalList>
			<HorizontalList>
				<Image id="11" on_click={clicked} width=64 height=64/>
				<Image id="21" on_click={clicked} width=64 height=64/>
				<Image id="31" on_click={clicked} width=64 height=64/>
			</HorizontalList>
			<HorizontalList>
				<Image id="12" on_click={clicked} width=64 height=64/>
				<Spacer width=64 height=64/>
				<Image id="32" on_click={clicked} width=64 height=64/>
			</HorizontalList>
			<HorizontalList>
				<Image id="13" on_click={clicked} width=64 height=64/>
				<Image id="23" on_click={clicked} width=64 height=64/>
				<Image id="33" on_click={clicked} width=64 height=64/>
			</HorizontalList>
		</VerticalList>
	</Box>
]]

local NineClicks = {}
UI.Register("ExplorableGameNineClicks", NineClicks_layout, NineClicks)

local imgs = {
	["11"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/top-left.png",
	["21"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/top-mid.png",
	["31"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/top-right.png",

	["12"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/mid-left.png",

	["32"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/mid-right.png",

	["13"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/btm-left.png",
	["23"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/btm-mid.png",
	["33"] = "Main/textures/icons/explorablespanel/powerclickpuzzle/btm-right.png",
}

local offimg = "Main/textures/icons/explorablespanel/powerclickpuzzle/no-connect.png"

function NineClicks:construct()
	self.ison = {}
	self.allbuttons = { self["11"], self["12"], self["13"], self["21"], self["23"], self["31"], self["32"], self["33"], }
	for i=1,3 do
		for j=1,3 do
			if (i..j) ~= "22" then
				local rndnum = math.random(3)
				local setpiece = (rndnum==1)
				--self[i..j].text = setpiece and "O" or "X"
				self.ison[i..j] = setpiece
				self[i..j].image = setpiece and imgs[i..j] or offimg
			end
		end
	end
end

function NineClicks:clicked(btn)
	local x = (tonumber(btn.id) % 10)
	local y = math.floor(tonumber(btn.id) /10)
	--print(string.format("x: %d, y: %d", x, y))
	for i=x-1,x+1 do
		if i >0 and i<4 then
			for j=y-1,y+1 do
				if j>0 and j<4 then
					if (j..i) ~= "22" then
						self.ison[j..i] = not self.ison[j..i]
						self[j..i].image = self.ison[j..i] and imgs[j..i] or offimg
					end
				end
			end
		end
	end

	-- check result
	for _,b in pairs(self.ison) do
		if b == false then return end
	end

	-- got here to win
	self.outer:OnSolve()
end
