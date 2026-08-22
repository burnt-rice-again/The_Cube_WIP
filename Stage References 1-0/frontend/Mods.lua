local Mods_layout<const> =
[[
	<HorizontalList child_padding=6 child_align=top>
		<Box bg=popup_box_bg blur=true id=mover padding=10 margin_bottom=20>
			<VerticalList>
				<HorizontalList child_padding=4 child_fill=true>
					<Button icon=icon_refresh text="Refresh List" on_click={on_refresh}/>
					<Button icon=icon_steam text="Steam Workshop" id=browse on_click={on_browse}/>
				</HorizontalList>
				<Text color=ui_light text="Installed Mods:" margin_top=20 margin_bottom=10/>
				<ScrollList child_padding=2 id=list width=446 fill=true/>
			</VerticalList>
		</Box>
		<Spacer id=information/>
	</HorizontalList>
]]

local item_layout<const> =
[[
	<Button on_click={on_select_mod} height=48>
		<HorizontalList dock=fill>
			<Button id=toggle on_click={on_toggle_mod} margin=4 width=32 height=32/>
			<Text id=name margin_left=10 valign=center fill=true/>
		</HorizontalList>
	</Button>
]]

local item_information<const> =
[[
	<Box bg=popup_box_bg blur=true valign=top padding=10 margin_bottom=20>
		<ScrollList id=details child_padding=16>
			<Text text="Author:" color=ui_light/>
			<Text id=mod_author/>
			<Text text="Version:" color=ui_light/>
			<Text id=mod_version/>
			<Text text="Description:" color=ui_light/>
			<Text id=mod_description/>
			<Text text="Packages:" color=ui_light/>
			<VerticalList id=mod_packages/>
		</ScrollList>
	</Box>
]]

-------------------------------------------
local Mods = {}
UI.Register("Mods", Mods_layout, Mods)

function Mods:construct()
	local modmgr = Game.GetNativeModManagerName()
	if modmgr then
		--TODO: Handle other mod managers other than steam
		--self.browse.text = modmgr
	else
		self.browse.hidden = true
	end

	self:fill_list()

	self.class.open = self
	self.mover:TweenFromTo("sx", 0.01, 1, 40, 'OutQuad')
	self.mover:TweenFromTo("sy", 0.01, 1, 80, 'OutQuad')
	UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN")
end

function Mods:on_refresh()
	Game.RefreshInstalledMods()
	self:fill_list()
end

function Mods:on_browse()
	Game.OpenNativeModManager()
end

function Mods:fill_list()
	self.lastButton = nil
	self.information:Clear()
	self.list:Clear()
	for i,mod in ipairs(Game.GetInstalledMods()) do
		if not mod.is_base then
			local item = self.list:Add(item_layout, {
				mod = mod,
				construct = function(item)
					item.name.text = NOLOC(item.mod.name)
					item.toggle.icon = item.mod.is_enabled and "icon_small_confirm" or nil
				end,
			})
		end
	end
end

function Mods:on_select_mod(item)
	local info = self.information:SetContent(item_information)
	if self.lastButton then
		self.lastButton.active = false
		self.lastButton.name.color = data.default_style.color
	end
	if self.lastButton == item then
		self.lastButton = nil
		self.information:Clear()
		return
	end
	self.lastButton = item
	item.active = true
	item.name.color = data.styles.button_active.color

	local mod = item.mod
	--info.mod_title.text = mod.name
	info.mod_author.text = NOLOC(mod.author)
	info.mod_version.text = NOLOC(mod.version_name)
	info.mod_description.text = mod.description

	for i,pkg in ipairs(Game.GetInstalledModPackages(mod.id)) do
		info.mod_packages:Add("Text", {
			text = L("<package_title>%S - </>%s%s", pkg.name, pkg.type, pkg.is_missing_dependencies and L(" <header>***%s***</>", "MISSING DEPENDENCIES") or ""),
		})
	end
end


function Mods:on_toggle_mod(item)
	item.mod.is_enabled = not item.mod.is_enabled
	local missing_dependency = Game.SetModEnabled(item.mod.id, item.mod.is_enabled)
	if missing_dependency then
		MessageBox(L("Failed to enable mod '%S' due to missing dependency mod '%S'", item.mod.name, missing_dependency))
		return
	end
	self:fill_list()
end

function UIMsg.OnModAdded(id, name)
	Notification.Info(L("New mod '%S' has been installed and enabled", name))
	if Mods.open and Mods.open:IsValid() then Mods.open:fill_list() end
end

function UIMsg.OnModRemoved(id, name)
	Notification.Info(L("Mod '%S' has been uninstalled", name))
	if Mods.open and Mods.open:IsValid() then Mods.open:fill_list() end
end
