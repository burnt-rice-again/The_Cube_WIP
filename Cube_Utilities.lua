---@param ingredients table Table with ingredient item id and amount
---@param producers table Table with production component id and ticks
---@param amount? number Amount of items produced in one step (defaults 1)
---@param byproduct? table Table with extra items to create
function CreateProductionRecipeWithWaste(ingredients, producers, amount, byproduct)
	if type(ingredients) ~= "table" then Debug.Assert(false, "List of production ingredients must be defined") ingredients = {} end
	if type(producers) ~= "table" then Debug.Assert(false, "List of production producers must be defined") producers = {} end
	if type(byproduct) ~= "table" then byproduct = {} end

	return { ingredients = ingredients, producers = producers, amount = amount or 1, byproduct = byproduct }
end

local race_foundations = {
	robot = "f_foundation",
	human = "f_human_foundation_basic",
--	alien = "f_alien_foundation_base",
}
function CreateFoundationsAtArea(x, y, dx, dy, foundation_id, faction)
	--local l, r = x - 1, x + dx
	for mew_y = y, y + dy do
		for new_x = x, x + dx do
			if not Map.GetFoundationEntityAt(new_x, mew_y) then
				Map.CreateEntity(faction, foundation_id):Place(new_x, mew_y)
			end
		end
	end
end
function CreateFoundationsFromCentre(x, y, dx, dy, foundation_id, faction)
	--local l, r = x - 1, x + dx
	for new_y = y - dy, y + dy do
		for new_x = x - dx, x + dx do
			if not Map.GetFoundationEntityAt(new_x, new_y) then

				-- remove any exisiting entities 
				local entities = Map.GetEntitiesAt(new_x,new_y, FF_WALL | FF_GATE | FF_RESOURCE)
				for i, v in ipairs(entities) do
					v:Destroy()
				end


				Map.CreateEntity(faction, foundation_id):Place(new_x, new_y)
			end
		end
	end
end
function CheckFreeSpace(x,y)
	local elv = Map.GetElevation(x, y)
	--print("    - tile:", x..","..y, " - elv:", elv, " - blight:", Map.GetBlightness(x, y))
	local mapsettings = Map.GetSettings()
	local min_level, max_level = mapsettings.water_level, mapsettings.plateau_level - 0.1
	if elv > min_level and elv < max_level then
		if Map.GetBlightness(x, y) < 0 then
			return true
		end
	end
	return false
end
---check area is buildable
--- @x number 
--- @y number 
--- @max_layer Maxiumum size to search for (OPTIONAL Default 10)
--- @size number is the amount of square space at the choosen location  
function CheckFreeAreaFromCentre(x,y,max_layer)
	
	if not max_layer then max_layer = 10 end 

	for layer = 0, max_layer do

		for n = -layer, layer do
			--next layer 
			if CheckFreeSpace(x+layer,y+n) and CheckFreeSpace(x-layer,y+n) and CheckFreeSpace(x+n,y+layer) and CheckFreeSpace(x+n,y-layer) then 
			else
				return layer - 1
			end
		end
	end
	return max_layer
end

