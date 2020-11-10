-- This plug-in has one purpose, to sheath your weapon when out of combat

local ADDON_NAME = "AutoSheath"

local ConsecutiveNotInCombatResults = 0

local function OnAddonLoaded(event, addon)
	if addon ~= ADDON_NAME then return end
	EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_COMBAT_STATE, OnEventCombatStateChange)
end

local function OnEventCombatStateChange(_, inCombat)
	if IsUnitInCombat("player") == false then
		ConsecutiveNotInCombatResults = ConsecutiveNotInCombatResults + 1
		zo_callLater(OnEventCombatStateChange, 1000)
	else
		ConsecutiveNotInCombatResults = 0
	end

	if ConsecutiveNotInCombatResults > 9 then
		TogglePlayerWield()
	end
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
