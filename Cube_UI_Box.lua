local package = ...

-- define the layout of the widget
local cube_locator_layout <const> =
[[
	<Box dock=top-left padding=3 margin_top={margin_top} margin_left = 5>
		<Canvas on_click={goto_cube} tooltip={cube_tooltip}>
            <Reg bg=item_default def_id={cube_id} on_click={goto_cube} width=40 height=40/>
        </Canvas>
	</Box>
]]

-- register the widget layout
local cube_locator <const> = {}
UI.Register("cube_locator", cube_locator_layout, cube_locator)
local cube_ids = {"ic_cube_blue", 'ic_cube_green', 'ic_cube_empty', 'ic_cube_red'}

-- called when the registered widget is created
function cube_locator:construct()
    self.margin_top = 128
end
-- Check to see if the Cube is on the Map 
local function lost_cube_check_faction(faction)
    for i,id in ipairs(cube_ids) do 
        local ent = faction:GetItemAvailability(id)
        if ent ~= nil then
            return ent[1]
        end
    end
end
-- place a new cube at the home position
function FactionAction.replace_lost_cube(player_faction)
    Map.Defer(function()
        local loc = player_faction.home_location 
        if loc == nil then loc = {x=0,y=0} end 
        local ent = Map.CreateEntity(player_faction, "f_bot_1m_a")
        ent:AddComponent("cc_cube_storage")
        ent:AddItem("ic_cube_blue")
        ent:Place(loc)
    end)
end
-- need to specifically check dropped items
local function Check_For_Dropped_Cube(location)     
    -- print("dropped cube check loc", location)
    local entity_list = nil 
    if location == nil then
        entity_list =  Map.GetFaction("world").entities
    else
        entity_list = Map.GetEntitiesInRange(location.x,location.y,1,1,2,FF_DROPPEDITEM)
    end
    if entity_list == nil then print("No Entites") return end 
    for i,ent in ipairs(entity_list) do 
        if ent.id == "f_dropped_item" then 
            local new_id = EntityHasCube(ent)
            if new_id then 
                return ent, new_id
            end
        end
    end
end
function FactionAction.update_cube_location(faction, args)
    if faction == nil then return end 
    if args[1] then faction.extra_data.cube_key = args[1] end
    if args[2] then faction.extra_data.cube_id = args[2] end
    if args[3] then faction.extra_data.cube_cord = args[3] end
end

-- check each faction for the cube
local function lost_cube_check(player_faction)
    local ent = Check_For_Dropped_Cube(player_faction.extra_data.cube_cord)
    if ent == nil then
        for i,faction in ipairs(Map:GetFactions()) do 
            ent = lost_cube_check_faction(faction) 
            if ent ~= nil then 
                --print(faction.id, ent, "Cube Found")
                break
            end
        end
    end
    if ent == nil then 
        ent = Check_For_Dropped_Cube()
    end
    if ent ~= nil then 
        Action.SendForLocalFaction("update_cube_location",{ent.key,false,ent.location})
        View.JumpCameraToEntities(ent)
        View.SelectEntities(ent)
        return  
    end
    -- could not find Cube 
    ConfirmBox("Can Not Find Cube on the Map\n\nIf your save has lost the Cube click okay to spawn a new one", function() Action.SendForLocalFaction("replace_lost_cube", {player_faction}) end , nil, "Cube Lost!") -- 
end


-- called when the button is clicked
function cube_locator:goto_cube(btn)
    local faction = Game.GetLocalPlayerFaction()
    if faction and faction.has_extra_data then 
        local key = faction.extra_data.cube_key
        if key then 
            local ent = Map.GetEntityFromKey(key)
            if ent.location ~= nil then 
                View.JumpCameraToEntities(ent)
                View.SelectEntities(ent)
                return 
            elseif faction.extra_data.cube_cord then 
                local cord = faction.extra_data.cube_cord
                View.MoveCamera(cord.x,cord.y)
                return 
            end
        end
    end
    -- could not find the cube on the map
    lost_cube_check(faction)
end
-- display the Cubes current form 
function cube_locator:update()
    local faction = Game.GetLocalPlayerFaction()
    if faction then
        --update reg id
        local extra_data = faction.extra_data
        self.cube_id = extra_data.cube_type
        -- update cube location if it has no entity 
        if extra_data.cube_key == nil then
            local ent, id = Check_For_Dropped_Cube(extra_data.cube_cord) 
            if ent ~= nil then 
                Action.SendForLocalFaction("update_cube_location",{ent.key,id,ent.location})
            end
        end
        if (faction:IsUnlocked("tc_cube_anti_4")) then 
            self.margin_top = 140
        else
            self.margin_top = 167
        end
    end
end

-- called when the UI is being set up
function UIMsg.OnSetup()
	UI.AddLayout("cube_locator", 0)
end

-- called when mod is initializing
function package:init_ui()
end



