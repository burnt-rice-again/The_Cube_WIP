local Slide_layout<const> =
[[
	<Box>
		<Canvas id=grid width=64 height=64/>
	</Box>
]]

local Slide = {}
UI.Register("ExplorableGameSlide", Slide_layout, Slide)

local imgs = {
	"Main/textures/icons/values/number_1.png",
	"Main/textures/icons/values/number_2.png",
	"Main/textures/icons/values/number_3.png",
	"Main/textures/icons/values/number_4.png",
	"Main/textures/icons/values/number_5.png",
	"Main/textures/icons/values/number_6.png",
	"Main/textures/icons/values/number_7.png",
	"Main/textures/icons/values/number_8.png",
	"Main/textures/icons/values/number_9.png",
}

local offimg = "Main/textures/icons/explorablespanel/powerclickpuzzle/no-connect.png"

--[[
1  2  3

4  5  6

7  8  9

--]]


function Slide:ShiftSwapAdjacent(_swap)
	self.board[self.gap] = self.board[_swap]
	self.gap = _swap
	self.board[_swap] = 0
end

function Slide:construct()
	self.ison = {}
	self.board = {1, 2, 3, 4, 5, 6, 7, 8, 0} -- board, 0 is gap
	self.sliding = false
	self.gap = 9 -- index to gap
	self.nodes = {}

	local function ShiftRandomAdjacent(_gap)
		local all
		if _gap == 1 then all = {2, 4}
		elseif _gap == 2 then all = {1, 3, 5}
		elseif _gap == 3 then all = {2, 6}
		elseif _gap == 4 then all = {1, 5, 7}
		elseif _gap == 5 then all = {2, 4, 6, 8}
		elseif _gap == 6 then all = {3, 5, 9}
		elseif _gap == 7 then all = {4, 8}
		elseif _gap == 8 then all = {5, 7, 9}
		elseif _gap == 9 then all = {6, 8}
		end
		return all[math.random(1, #all)]
	end

	-- mix it up
	local last = -1
	for i=1,21 do -- odd number to make sure its not solved on start
		local swapwith = ShiftRandomAdjacent(self.gap)
		if last == swapwith then
			i = i - 1
		else
			last = swapwith
			self:ShiftSwapAdjacent(swapwith)
		end
	end

	-- create graphics
	local w = 3
	local h = 3
	local sz = 64
	self.grid.width, self.grid.height, self.w, self.h = w * sz, h * sz, w, h
	for i=1,w*h do
		local x, y = ((i - 1) % w) * sz, ((i - 1) // w) * sz
		local node = self.grid:Add("<Image width=64 height=64 angle=0 rot=0 on_click={clicked}/>", { x = x, y = y, p = i, i = self.board[i] })
		if self.board[i]==0 then
			self.gapbtn = node
			node.image = offimg
		else
			node.image = imgs[self.board[i]]
			self.nodes[#self.nodes+1] = node
		end
	end
end

function Slide:clicked(btn)
	if self.sliding == true then return end

	-- swap with gap (need adjacent check)
	if btn.i == 0 then return end
	local gap = self.gap

	local function SwapButtonP(b1, b2)
		local pp = b1.p
		b1.p = b2.p
		b2.p = pp
	end

	if gap == (btn.p - 3) then -- up
		btn:TweenTo("y", self.gapbtn.y, 250, "InOutQuart")
		self.gapbtn:TweenTo("y", btn.y, 250, "InOutQuart", function() self.sliding = false end)
	elseif gap == (btn.p + 3) then -- down
		btn:TweenTo("y", self.gapbtn.y, 250, "InOutQuart")
		self.gapbtn:TweenTo("y", btn.y, 250, "InOutQuart", function() self.sliding = false end)
	elseif gap == (btn.p + 1) and gap ~= 4 and gap ~= 7 then -- right
		btn:TweenTo("x", self.gapbtn.x, 250, "InOutQuart")
		self.gapbtn:TweenTo("x", btn.x, 250, "InOutQuart", function() self.sliding = false end)
	elseif gap == (btn.p - 1) and gap ~= 6 and gap ~= 3 then -- left
		btn:TweenTo("x", self.gapbtn.x, 250, "InOutQuart")
		self.gapbtn:TweenTo("x", btn.x, 250, "InOutQuart", function() self.sliding = false end)
	else return
	end

	self.sliding = true
	self:ShiftSwapAdjacent(btn.p)
	SwapButtonP(self.gapbtn, btn)

	for tst = 1,#self.nodes do
		local tstnode = self.nodes[tst]
		if tstnode.i ~= tstnode.p then
			return
		end
	end

	-- got here to win
	self.outer:OnSolve()
end
