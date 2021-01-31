-- This plug-in has one purpose, to sheath your weapon when out of combat

local ADDON_NAME = "AutoSheath"

local function SheathWeapon()
	if not ArePlayerWeaponsSheathed() then
        TogglePlayerWield()
	end
end

local function DismissTwilight()
	-- All the abilityIDs for Twilights
	local PetList = { 24613, 30581, 30584, 30587, 24636, 30592, 30595, 30598, 24639, 30618, 30622, 30626 }

	local i, k, v

	-- Walk through the player's active buffs
	for i = 1, GetNumBuffs("player") do
		local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff = GetUnitBuffInfo("player", i)
		-- Compare each buff's abilityID to the list of IDs we were given
		for k, v in pairs(PetList) do
			if abilityId == v then
				-- Cancel the buff if we got a match
				CancelBuff(buffSlot)
			end
		end
	end

end

local SecondsToDebounceCombatState = 20

local ConsecutiveNotInCombatResults = 0

local function OnEventCombatStateChange(_, inCombat)
	if IsUnitInCombat("player") == false and ConsecutiveNotInCombatResults < SecondsToDebounceCombatState then
		ConsecutiveNotInCombatResults = ConsecutiveNotInCombatResults + 1
		zo_callLater(OnEventCombatStateChange, 1000)
	else
		ConsecutiveNotInCombatResults = 0
	end

	if ConsecutiveNotInCombatResults >= SecondsToDebounceCombatState then
		SheathWeapon()
		DismissTwilight()
	end
end

local function OnAddonLoaded(event, addon)
	if addon ~= ADDON_NAME then return end
	EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_COMBAT_STATE, OnEventCombatStateChange)
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)
