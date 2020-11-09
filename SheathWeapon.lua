-- Sheath Weapon is a ESO plugin created by GlassHalfFull
-- This plug-in has one purpose, to sheath your weapon when out of combat


-- define some variables
local wm = GetWindowManager()
local em = GetEventManager()
local _

if SW == nil then SW = {} end

-- The AddOn name
SW.name = "Sheath Weapon"
SW.version = "2.23"

SW.settings = {}

--
-- initialization stuff
--
function SW.Init(event, addon)
	if addon ~= "SheathWeapon" then return end
	em:UnregisterForEvent("SheathWeaponInitialize", EVENT_ADD_ON_LOADED)

	-- make our options menu
	SW.MakeMenu()

	-- also, do this last, to minimize the chance of problem zone transitions
--	em:RegisterForEvent("SheathWeaponStart", EVENT_PLAYER_ACTIVATED, function(...) SW.RefreshWindow(...) end)
end



-- EVENT_PLAYER_COMBAT_STATE sends 'true' once when combat starts
-- and then 'nil' on every update, so we just check for 'true' to
-- start our loop
function SW.Trigger(_, inCombat)
    if inCombat then
        zo_callLater(SW.Loop, 1000)
    end
end

-- Once a second determine whether we're still in combat. If we're not, wait
-- 1000 milli-seconds to let animations finish playing, then call 
-- TogglePlayerWield to sheath weapons.  Otherwise wait 1000 milli-seconds.
function SW.Loop()
	if IsUnitInCombat("player") == false then
		zo_callLater(TogglePlayerWield, 2000)
	else
		zo_callLater(SW.Loop, 1000)
	end
end



-- register to be initialized when we're ready
em:RegisterForEvent("SheathWeaponInitialize", EVENT_ADD_ON_LOADED, function(...) SW.Init(...) end)
em:RegisterForEvent("SheathWeaponTrigger", EVENT_PLAYER_COMBAT_STATE, SW.Trigger)
