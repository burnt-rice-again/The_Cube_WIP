local NetWalk_layout<const> =
[[
	<Box>
		<Canvas id=grid width=64 height=64/>
	</Box>
]]

local NetWalk = {}
UI.Register("ExplorableGameNetWalk", NetWalk_layout, NetWalk)

function NetWalk:construct()
	local difficulty = self.outer.entity.extra_data.difficulty or 3
	self:BuildNet(difficulty, difficulty)
end

local RIGHT<const>, DOWN<const>, LEFT<const>, UP<const>, ALLDIRS<const> = 1,2,4,8,15

local nodes = {
	[RIGHT]           = { "node_1", 0 },
	[DOWN]            = { "node_1", 1 },
	[DOWN|RIGHT]      = { "node_3", 1 },
	[LEFT]            = { "node_1", 2 },
	[LEFT|RIGHT]      = { "node_2", 0 },
	[LEFT|DOWN]       = { "node_3", 2 },
	[LEFT|DOWN|RIGHT] = { "node_4", 2 },
	[UP]              = { "node_1", 3 },
	[UP|RIGHT]        = { "node_3", 0 },
	[UP|DOWN]         = { "node_2", 3 },
	[UP|DOWN|RIGHT]   = { "node_4", 1 },
	[UP|LEFT]         = { "node_3", 3 },
	[UP|LEFT|RIGHT]   = { "node_4", 0 },
	[UP|LEFT|DOWN]    = { "node_4", 3 },
}

local gfx = {
	node_1_on  = "Main/textures/icons/explorablespanel/netwalk/on1.png",
	node_1_off = "Main/textures/icons/explorablespanel/netwalk/off1.png",
	node_2_on  = "Main/textures/icons/explorablespanel/netwalk/on2.png",
	node_2_off = "Main/textures/icons/explorablespanel/netwalk/off2.png",
	node_3_on  = "Main/textures/icons/explorablespanel/netwalk/on3.png",
	node_3_off = "Main/textures/icons/explorablespanel/netwalk/off3.png",
	node_4_on  = "Main/textures/icons/explorablespanel/netwalk/on4.png",
	node_4_off = "Main/textures/icons/explorablespanel/netwalk/off4.png",
	lamp_on    = "Main/textures/icons/explorablespanel/netwalk/on.png",
	lamp_off   = "Main/textures/icons/explorablespanel/netwalk/off.png",
	source     = "Main/textures/icons/explorablespanel/netwalk/source.png",
}

local function NetWalkValidate(w, h, conns, oks, i, dir)
	if not dir then
		for i=1,w*h+1 do oks[i] = false end
	end
	if oks[i] then oks[w*h+1] = true return 0 end -- circular loop remains
	local c, rev = conns[i], (dir and ((dir > DOWN) and (dir >> 2) or (dir << 2)) or 0)
	if dir and (c & rev) == 0 then return 0 end -- not connected from this side
	oks[i] = true
	return 1 -- return number of connections
		+ (c & RIGHT ~= 0 and rev ~= RIGHT and (i-1)%w  < w-1 and NetWalkValidate(w, h, conns, oks, i+1, RIGHT) or 0)
		+ (c & DOWN  ~= 0 and rev ~= DOWN  and (i-1)//w < h-1 and NetWalkValidate(w, h, conns, oks, i+w, DOWN ) or 0)
		+ (c & LEFT  ~= 0 and rev ~= LEFT  and (i-1)%w  > 0   and NetWalkValidate(w, h, conns, oks, i-1, LEFT ) or 0)
		+ (c & UP    ~= 0 and rev ~= UP    and (i-1)//w > 0   and NetWalkValidate(w, h, conns, oks, i-w, UP   ) or 0)
end

function NetWalk:BuildNet(w, h, iteration)
	local wh, conns, oks = w*h, { }, { [w*h+1] = false }

	-- fill out arrays with a fully connected grid
	for i=1,wh do
		local x, y = 1+((i-1)%w), 1+((i-1)//w)
		conns[i] = (x > 1 and LEFT or 0) | (x < w and RIGHT or 0) | (y > 1 and UP or 0) | (y < h and DOWN or 0)
		oks[i] = false
	end

	-- for all non-border nodes with connections in all 4 directions, remove 1 random connection
	for a=1,wh do
		if conns[a] == ALLDIRS then
			local dir = 1 << math.random(0,3)
			local b = a + ((dir == RIGHT and 1) or (dir == DOWN and w) or (dir == LEFT and -1) or -w)
			conns[a], conns[b] = conns[a] ~ dir, conns[b] ~ ((dir > DOWN) and (dir >> 2) or (dir << 2)) -- disconnect
		end
	end

	-- cut random connections until the grid is still valid and has no circular loops
	for random_cut=1,wh*10 do
		local a, dir = 1+(math.random(0, h-2))*w+(math.random(0, w-2)), (math.random(2) == 1 and RIGHT or DOWN)
		if conns[a] & dir ~= 0 and conns[a] ~= dir then -- still connected and not the only remaining connection
			local b = (a + (dir == DOWN and w or 1))
			conns[a], conns[b] = conns[a] ~ dir, conns[b] ~ (dir << 2) -- disconnect both sides
			if NetWalkValidate(w, h, conns, oks, 1) ~= wh then
				conns[a], conns[b] = conns[a] ~ dir, conns[b] ~ (dir << 2) -- grid became invalid, reconnect
			elseif not oks[wh+1] then -- no circular loops
				self:Finalize(w, h, conns, oks)
				return true
			end
		end
	end

	-- if we were very unlucky and failed to get a valid grid, retry up to 10 times
	return iteration ~= 10 and self:BuildNet(w, h, (iteration and (iteration + 1) or 2))
end

function NetWalk:Finalize(w, h, conns, oks)
	-- find a random node with 2 or more connections to be our starting point
	while true do
		local i = math.random(w*h)
		if nodes[conns[i]][1] ~= "node_1" then
			self.source = i
			break
		end
	end

	-- create image widgets and rotate all nodes randomly
	local sz = 64
	self.grid.width, self.grid.height, self.w, self.h, self.conns, self.oks = w * sz, h * sz, w, h, conns, oks
	for i=1,w*h do
		local x, y = ((i - 1) % w) * sz, ((i - 1) // w) * sz
		local node = self.grid:Add("<Image width=64 height=64 angle=0 rot=0 on_click={clicked}/>", { x = x, y = y, i = i })
		local c = conns[i] << math.random(0,3)
		conns[i] = (c & ALLDIRS) | ((c & ~ALLDIRS) >> 4)
		if nodes[conns[i]][1] == "node_1" then -- single connection gets a lamp
			node.lamp = self.grid:Add("<Image width=64 height=64/>", { x = x, y = y })
		elseif self.source == i then -- starting point
			self.grid:Add("<Image width=64 height=64/>", { x = x, y = y, image = gfx.source })
		end
	end

	self:Recalculate(true)
end

function NetWalk:clicked(w, mousebtn)
	local right = mousebtn == "RIGHTMOUSEBUTTON"
	local c = (self.conns[w.i] << (right and 3 or 1))
	self.conns[w.i] = (c & ALLDIRS) | ((c & ~ALLDIRS) >> 4)
	w.rot = w.rot + (right and -1 or 1)
	w:TweenFromTo("sx", .9, 1, 150, "InOutElastic")
	w:TweenFromTo("sy", .9, 1, 150, "InOutElastic")
	w:TweenTo("angle", w.rot * 90, 200, "InOutBounce", function() self:Recalculate() end)
end

function NetWalk:Recalculate(first_time)
	NetWalkValidate(self.w, self.h, self.conns, self.oks, self.source)

	local done = true
	for _,w in ipairs(self.grid) do
		local i = w.i
		local ok = self.oks[i]
		if i then
			local n = nodes[self.conns[i]]
			w.image = gfx[n[1] .. (ok and "_on" or "_off")]
			w.angle = n[2] * 90
			w.rot = n[2]
		end
		if w.lamp then
			w.lamp.image = ok and gfx.lamp_on or gfx.lamp_off
			if not ok then done = false end
		end
	end

	if first_time and done then
		-- grid was created already solved, rotate a random node
		local i = math.random(self.w * self.h)
		local c = self.conns[i] << math.random(1,3)
		self.conns[i] = (c & ALLDIRS) | ((c & ~ALLDIRS) >> 4)
		return self:Recalculate(true)
	end

	if done then
		self.outer:OnSolve()
	end
end
