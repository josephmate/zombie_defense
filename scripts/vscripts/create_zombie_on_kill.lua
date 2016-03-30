

--------------------------------------------------------------------------------

-- used sample:
-- data driven: https://github.com/Pizzalol/SpellLibrary/blob/0ebc18d0f34b109b33887848709041cfcc5e05fb/game/scripts/npc/abilities/alchemist/goblins_greed_datadriven.txt 
-- lua:         https://github.com/Pizzalol/SpellLibrary/blob/0ebc18d0f34b109b33887848709041cfcc5e05fb/game/scripts/vscripts/heroes/hero_alchemist/goblins_greed.lua
function CreateZombieOnKill(event)
	-- Variables
	local killer = event.caster
	local unitKilled = event.unit
	--local playerid = PlayerResource:GetPlayer( event.caster:GetPlayerID() )
	
	Msg("CreateZombieOnKill")
	PrintLinkedConsoleMessage("info", "CreateZombieOnKill")
	if unitKilled:GetUnitName() == "npc_civilian" then
		Msg("Was npc_civlian, making npc_zombie")
		PrintLinkedConsoleMessage("info", "Was npc_civlian, making npc_zombie")
		--  handle CreateUnitByName(string string_1, Vector Vector_2, bool bool_3, handle handle_4, handle handle_5, int int_6)
		-- Creates a DOTA unit by its dota_npc_units.txt name ( szUnitName, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber ) 
		local zombie = CreateUnitByName("npc_zombie", unitKilled:GetAbsOrigin(), true, nil, nil, killer:GetTeam())
	end
end