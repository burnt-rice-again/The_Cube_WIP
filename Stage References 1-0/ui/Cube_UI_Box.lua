-- local layout =
-- [[<HorizontalList child_align=top dock=top-fill margin_left=4 margin_top=4 margin_right=312 child_padding=4>
-- 	    <VerticalList child_padding=4>
-- 			<Box padding=4>
-- 				<Canvas on_click={goto_cube} tooltip={power_tooltip} min_width=84>
-- 					<Image margin_left=-5 id={cube_id} color=ui_light/>
-- 					<Text halign=fill margin_left=24 textalign=right y=0  id=produced/>
-- 					<Text halign=fill margin_left=24 textalign=right y=15 id=required/>
-- 				</Canvas>
-- 			</Box>
-- 		</VerticalList>
-- 	</HorizontalList>
-- ]]

local cube_location = {}

UI.Register("cube_location", layout, cube_location)

function cube_location:power_tooltip()
    return UI.New([[<Box bg=popup_box_bg padding=12 blur=true><VerticalList width=300/>
    Click to locate Cube
    </Box>]]
)end

function cube_location:goto_cube()
    local faction = Game.GetLocalPlayerFaction()
    if faction and faction.has_extra_data then 
        local key = faction.extra_data.cube_key
        if key then 
            local ent = Map:GetEntityFromKey(key)
            if ent then 

            end
        end
    end


		faction.extra_data.cube_key = comp.owner.key
		faction.extra_data.cube_type = item
		faction.extra_data.cube_cord = comp.owner.location
end