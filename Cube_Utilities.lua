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
--- @cord Coordinate
--- @resource id for resource
--- @mount number for resource 
--- @frame frame such as f_resourcenode_metal
--- @visual string of visual 
function PlaceResourceNode(cord, resource, amt, frame, visual)
	Map.Defer(function()
		local new_entity = Map.CreateEntity("world", frame, visual)
		if new_entity then 
			-- resource nodes are not allowed comps
			-- if frame == "f_resourcenode_blightcrystal" then 
			-- 	new_entity:AddComponent("cc_unstable_resource","hidden")
			-- end
			new_entity:SetRegister(FRAMEREG_GOTO, {id=resource,num=amt})
			new_entity:Place(cord, cord,math.random(0,3))
		end
	end)
end
function Update_cube_location_global(owner, item)

	if item == nil then return end 

	if owner:CountItem(item) > 0 then 
		local faction = owner.faction
		faction.extra_data.cube_key = owner.key
		faction.extra_data.cube_type = item
		faction.extra_data.cube_cord = owner.location
	end
end
local update_cube_location = Update_cube_location_global
function AddCubeThroughFixed(entity, id)

	update_cube_location(entity, id)
	if entity:AddItem(id,true) == nil then 
		-- could not add cube 
		local slots = entity:GetSlotsByType("cube")
		Debug.Assert(#slots > 0, "ERROR cant add cube to an entity with no cube slots")
		if #slots > 0 then  
			-- no cube slots 
			for i, slot in ipairs(slots) do 
				if slot.stack == 0 and slot.locked == true then
					slot.component.extra_data.locked_id = slot.id
					slot.locked = false 
					slot:Clear()
					slot:SetItemAndStack(id,1)
					
					--print("Added Cube through locked slot", id, slot)
					
					break
				end
			end
		end
	end
end

-- @Entity From frame
-- @Bool True to place two anticubes instead of 1
function Place_Anti_Cube(entity, do_again)
	-- location can be entity or location
	if entity == nil then print("ERROR location is invalid for anticube") end 
	-- if location.x == nil then
	-- 	-- not coord is entity 
	-- 	if location.location ~= nil then 
	-- 		location = location.location
	-- 	end
	-- look for frame with space 
	if not entity.faction:IsUnlocked("xc_cube_anti") then entity.faction:Unlock("xc_cube_anti") end
	local range = 5
	local list_nearby = Map.GetEntitiesInRange(entity.location.x, entity.location.y, 1, 1,range, FF_OWNFACTION, entity.faction)
	for key, val in pairs(list_nearby) do
		
		if val:AddItem("ic_cube_sphere") ~= nil then
			val:PlayEffect("fx_ping")
			if do_again == true then
				  do_again = false 
				  if val:AddItem("ic_cube_sphere") ~= nil then return end 
			else return end 
			-- check if another spot is available
		end
	end
	-- place as frame 
	local cord = entity.location
	Map.Defer(function()
	local new_frame = Map.CreateEntity("world", "fc_cube_sphere")
	if new_frame ~= nil then
		local x, y = cord.x + math.random(-range,range), cord.y + math.random(-range,range)
		local check_ent = Map.GetEntityAt(x,y)
		if check_ent == nil or check_ent.id ~= "fc_cube_sphere" then
			new_frame:Place(x,y) end
		end
	end)
	if do_again == true then  Place_Anti_Cube(entity, false) end 
	
end 
-- @id string checks if id is an alt recipe and returns the original item id if found or input id
function SwitchAltIdForBase(id)
	local item = data.items[id]
	if item and item.alt_item then 
		return item.alt_item
	end
	return id
end

-- Rebinds SetLockSlot so it doesnt lock to alt recipes
EntityAction:Unbind("SetSlotLock")
EntityAction:Bind("SetSlotLock" ,function(entity, arg)
	local slot = arg.slot
	if not slot or not slot.exists or slot.owner ~= entity then return end
	if type(arg.lock) == "boolean" then
		slot.locked = arg.lock
	else
		slot:SetLockedItem(SwitchAltIdForBase(arg.item_id))
	end
end)

--@ entity object Return its cube id if it has one. does not check for sphere
function EntityHasCube(ent)
	local cube_ids = {"ic_cube_blue", 'ic_cube_green', 'ic_cube_empty', 'ic_cube_red'}
	if ent == nil then return end
	for i,id in ipairs(cube_ids) do 
		if ent:CountItem(id) > 0 then 
			return id 
		end
	end
	return false
end

function SerializeCompExtraData(ent)
	local data = {}
	table.insert(data, Tool.Copy(ent.extra_data))
	for key,val in ipairs(ent.components) do 
		--print(val.extra_data)
		table.insert(data, Tool.Copy(val.extra_data))
	end
	return data
end
function DeserializeCompExtraData(ent, data)
	local i = 1
	if next(data[i]) ~= nil then ent.extra_data = Tool.Copy(data[i]) end
	for key,val in ipairs(ent.components) do 
		i = i + 1
		--print(data[i], val.id, next(data[i]) ~= nil)
		if next(data[i]) ~= nil then 
			val.extra_data = Tool.Copy(data[i])
			if val.def.on_add then val.def:on_add(val) end
		end
	end
	return data
end
function SerializeItems(ent)
	local data = {}
	for key, val in ipairs(ent.slots) do 
		local slot_data = {}
		print(val, val.id, val.stack, val.extra_data)
		if val.entity == nil then 
			if val.id ~= nil and val.stack > 0 then 
				slot_data.id = val.id
				slot_data.stack = val.stack
				slot_data.extra_data = Tool.Copy(val.extra_data)
			end
			if val.locked then 
				slot_data.lock = val.id
			end
		end
		table.insert(data, slot_data)
	end 
	return data
end 
function DeserializeItems(ent, data)
	for key, val in ipairs(ent.slots) do 
		local slot_data = data[key]
		if slot_data.stack ~= nil and slot_data.stack > 0 then
			if slot_data.extra_data ~= nil then 
				val:SetItemAndStack(slot_data.id, slot_data.stack, Tool.Copy(slot_data.extra_data))
			else 
				val:SetItemAndStack(slot_data.id, slot_data.stack)
			end
		end
		if slot_data.locked then
			val:SetLockedItem(slot_data.id)
		end
	end 
end 