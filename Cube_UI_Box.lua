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
            elseif faction.extra_data.cube_cord then 
                local cord = faction.extra_data.cube_cord
                View.MoveCamera(cord.x,cord.y)
            end
        end
    end
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

