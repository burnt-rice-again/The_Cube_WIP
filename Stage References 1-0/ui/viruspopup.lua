-- virus effect
local RandomPopup = {}
UI.Register("RandomPopup", "<Box dock=top-left padding=24 width=400 height=380><Image dock=fill image={img}/></Box>", RandomPopup)

local rndpopupimg = {
	"Main/textures/tech/virus.png",
	"Main/textures/tech/virus_vaccine.png",
	"Main/textures/tech/anti_virus.png",
	"Main/textures/icons/items/virus_research_data.png",
	"Main/textures/icons/items/virus_research.png",
}

function RandomPopup:construct()
	self.img = rndpopupimg[math.random(#rndpopupimg)]
	self.x = -100 + math.random(1920 - 200)
	self.y = -95 + math.random(1080 - 190)
	self:TweenFromTo("sx", 0.01, 1, 40, "InQuad")
	self:TweenFromTo("sy", 0.01, 1, 80, "InQuad")
end

function RandomPopup:update()
	self.t = (self.t or 1) + 1
	if self.t > 10 then
		self.update = nil
		self:TweenFromTo("sy", 0.01, 1, 40, "InQuad")
		self:TweenFromTo("sx", 0.01, 1, 80, "InQuad", function() self:RemoveFromParent() end)
	end
end

local VirusEffect = {}
UI.Register("VirusPopup", '<Image image="Main/textures/icons/color/color_green.png" margin=-200/>', VirusEffect)

function VirusEffect:construct()
	self:TweenFromTo("opacity", 0, 0.1, 200, "InQuad")
end

function VirusEffect:update()
	self.t = (self.t or 1) + 1
	if self.t >= 3 and self.t < 23 then
		UI.AddLayout("RandomPopup")
	elseif self.t == 28 then
		self.update = nil
		self:TweenFromTo("opacity", 0.1, 0, 200, "InQuad", function() self:RemoveFromParent() end)
	end
end

function UIMsg.OnVirusInfection()
	UI.AddLayout("VirusPopup")
end

function UIMsg.OnVirusNotification(entity)
	if not IsShowNotification("virus_in_network") then return end

	Notification.Add("got_virus", "Main/textures/tech/virus.png", "Virus Detected", "A virus has been detected in the network", {
		tooltip = "Virus Detected",
		on_click = function(id) View.JumpCameraToEntities(entity) Notification.Clear(id) end,
	})
end
