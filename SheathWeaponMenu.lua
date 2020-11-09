if SW == nil then SW = {} end

--
-- Register with LibMenu and ESO
--
function SW.MakeMenu()
	local menu = LibAddonMenu2

	local panel = {
		type = "panel",
		name = "" .. SW.name,
		displayName = "" .. SW.name,
		author = "GlassHalfFull",
        version = "" .. SW.version,
	}

	menu:RegisterAddonPanel("Sheath_Weapon", panel)
--	menu:RegisterOptionControls("Sheath_Weapon", options)
end