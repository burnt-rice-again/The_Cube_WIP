local package = ...

-- define the layout of the widget
local cube_locator_layout <const> =
[[
	<Box dock=top-left padding=3 margin_top=139 margin_left = 6>
		<Canvas on_click={goto_cube} tooltip={cube_tooltip}>
            <Reg bg=item_default def_id={cube_id} on_click={goto_cube} width=40 height=40/>
        </Canvas>
	</Box>
]]

-- register the widget layout
local cube_locator <const> = {}
UI.Register("cube_locator", cube_locator_layout, cube_locator)

-- called when the registered widget is created
function cube_locator:construct()
end
-- Check to see if the Cube is on the Map 
local function lost_cube_check_faction(faction)
    local cube_ids = {"ic_cube_blue", 'ic_cube_green', 'ic_cube_empty', 'ic_cube_red'}
    local ent_found = nil
    for i,id in ipairs(cube_ids) do 
        local ent = faction:GetItemAvailability(id)
        print(ent)
        if ent ~= nil then
            ent_found = ent[1]
            break
        end
    end
    if ent_found == nil then 
        print("No Cube Found!", faction.id)
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
-- check each faction for the cube
local function lost_cube_check(player_faction)
    for i,faction in ipairs(Map:GetFactions()) do 
        local ent = lost_cube_check_faction(faction) 
        if ent ~= nil then 
            print(faction.id, ent, "Cube Found")
            player_faction.extra_data.key = ent.key
            View.JumpCameraToEntities(ent)
            View.SelectEntities(ent)
            return  
        end
    end
    -- could not find Cube 
    print("No Cube Popup")
    ConfirmBox("Can Not Find Cube on the Map\n\nIf your save has lost the Cube click okay to spawn a new one", function() Action.SendForLocalFaction("replace_lost_cube", {player_faction}) end , nil, "Cube Lost!")
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
    print("starting lost cube check")
    lost_cube_check(faction)
end
-- display the Cubes current form 
function cube_locator:update()
    local faction = Game.GetLocalPlayerFaction()
    if faction then 
        self.cube_id = faction.extra_data.cube_type
    end
end

-- called when the UI is being set up
function UIMsg.OnSetup()
	UI.AddLayout("cube_locator", 0)
end

-- called when mod is initializing
function package:init_ui()
end



