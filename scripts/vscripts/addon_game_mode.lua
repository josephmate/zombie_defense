

if GameMode == nil then
	GameMode = class({})
end

function Precache( context )
	PrecacheResource( "model", "*.vmdl", context )
	PrecacheResource( "soundfile", "*.vsndevts", context )
	PrecacheResource( "particle", "*.vpcf", context )
	PrecacheResource( "particle_folder", "particles/folder", context )
	PrecacheResource( "particle_folder", "particles/folder", context )
	PrecacheResource( "models/creeps/lane_creeps/creep_radiant_melee/", "*.vmdl", context )
	PrecacheResource( "soundevents", "game_sounds_creeps.vsndevts", context )
	PrecacheResource( "particles/neutral_fx", "gnoll_base_attack.vpcf", context )
	PrecacheResource( "models/creeps/lane_creeps/creep_bad_melee_diretide", "*.vmdl", context )
	PrecacheResource( "soundevents/creatures", "game_sounds_zombie.vsndevts", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = GameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function GameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	
	ListenToGameEvent('player_chat', Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)
end

-- Evaluate the state of the game
function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function GameMode:OnPlayerChat(keys)

    local text = keys.text
    local teamonly = keys.teamonly
    local userID = keys.userid
    userID = userID - 1
    local hero = PlayerResource:GetPlayer(userID):GetAssignedHero()
    local name = tostring(PlayerResource:GetPlayerName(hero:GetPlayerOwnerID()))

	if text == "-level1" then
		Level1()
	end
--[[
	-- how to check for player name
    if tostring(PlayerResource:GetPlayerName(hero:GetPlayerOwnerID())) == "fokita" then
      if text == "dev_mode" then
        GameMode:CC_dev()
      end
    

    if dev_mode == true then
      if text == "att_r" then
        GameMode:att_r()
      end

      if text == "g2" then
        GameMode:CC_g2()
      end
      
      if text == "e9" then
        GameMode:CC_e9()
      end
      
      if text == "e2" then
        GameMode:CC_e2()
      end
      
      if text == "g1" then
        GameMode:CC_g1()
      end
      
      if text == "att_d" then
        GameMode:att_d()
      end

      if text == "LUS" then
        GameMode:LightUpShowcase()
      end

      if text == "l2" then
        for i=1,cpListLength do
          GameMode:CC_LightDown(i)
        end
      end
]]
end

function Level1()
	local civ = CreateUnitByName("npc_civilian", Vector(0,-200,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
	local zombie = CreateUnitByName("npc_zombie", Vector(0,200,0), true, nil, nil, DOTA_TEAM_BADGUYS)
end