local package = ...

package.includes = {
    "Cube_UI_mod.lua",
}
-- define the layout of the widget
local ModSampleUI_layout<const> =
[[
	<Box dock=bottom padding=3>
		<Button text="Hello World" on_click={on_click_hello}/>
	</Box>
]]

-- register the widget layout
local ModSampleUI<const> = {}
UI.Register("ModSampleUI", ModSampleUI_layout, ModSampleUI)

-- called when the registered widget is created
function ModSampleUI:construct()
end

-- called when the button is clicked
function ModSampleUI:on_click_hello(btn)
	MessageBox("Hello World from the UI Sample")
end

-- called when the UI is being set up
function UIMsg.OnSetup()
	UI.AddLayout("ModSampleUI", 9)
end

-- called when mod is initializing
function package:init_ui()
end