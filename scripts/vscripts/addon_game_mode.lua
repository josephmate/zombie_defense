
require('libraries/timers')

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
]]

end

function moveNpc(npc, newPosn)
  local newOrder = {
    UnitIndex = npc:entindex(), 
    OrderType =  DOTA_UNIT_ORDER_MOVE_TO_POSITION,
    TargetIndex = nil, --Optional.  Only used when targeting units
    AbilityIndex = 0, --Optional.  Only used when casting abilities
    Position = newPosn, --Optional.  Only used when targeting the ground
    Queue = 0 --Optional.  Used for queueing up abilities
  }

  ExecuteOrderFromTable(newOrder)
end

function moveRandomAngle(npc)
  local angle = RandomFloat(0,2*math.pi)
  local movementX = 1000*math.cos(angle)
  local movementY = 1000*math.sin(angle)
  local movementVector = Vector(movementX,movementY,0)
  local newPosn = npc:GetAbsOrigin() + movementVector

  -- move randomly
  moveNpc(npc,newPosn)
end

function findNearbyUnits(npc)
  local units = FindUnitsInRadius(
        npc:GetTeamNumber(),         --iTeamNumber, 
        npc:GetAbsOrigin(),          --vPosition, 
        nil,                         --hCacheUnit, 
        800,                         --flRadius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, --iTeamFilter, 
        DOTA_UNIT_TARGET_NONE,       --iTypeFilter, 
        DOTA_UNIT_TARGET_FLAG_NONE,  --iFlagFilter, 
        FIND_CLOSEST,                --iOrder,
        false                        --bCanGrowCache
      )
  return units
end

function zombieMoveFunction(zombie)
  return function()
    if zombie:IsAlive() then
      local units = findNearbyUnits(zombie)

      local closestEnemy = nil;
      local enemyNearby = false;
      for key,unit in pairs(units) do
        if not enemyNearby  then
          enemyNearby = true
          closestEnemy = unit
        end
      end

      if enemyNearby then
        -- move towards enemy and attack
        local newOrder = {
          UnitIndex = zombie:entindex(), 
          OrderType =  DOTA_UNIT_ORDER_ATTACK_TARGET,
          TargetIndex = closestEnemy:entindex(), --Optional.  Only used when targeting units
          AbilityIndex = 0, --Optional.  Only used when casting abilities
          Position = nil, --Optional.  Only used when targeting the ground
          Queue = 0 --Optional.  Used for queueing up abilities
        }
 
        ExecuteOrderFromTable(newOrder)
      else
        moveRandomAngle(zombie)
      end

      Timers:CreateTimer( 1.0 , zombieMoveFunction(zombie) )
    end
  end
end


function civilianMoveFunction(civilian)
  return function()
    if civilian:IsAlive() then
      local units = findNearbyUnits(civilian)

      local accumulatedVector = Vector(0,0,0);
      local enemyNearby = false;
      for key,unit in pairs(units) do
        enemyNearby = true
        accumulatedVector = accumulatedVector + (civilian:GetAbsOrigin() - unit:GetAbsOrigin())
      end

      -- move away from the enemies
      -- computed by taking the sum of the vectors pointing to the civilian
      if enemyNearby then
        local accumVectorLen = accumulatedVector.Length()
        if accumVectorLen > 0 then 
          newPosn = civilian:GetAbsOrigin() 
            + Vector(
              1000*accumulatedVector.x/accumVectorLen,
              1000*accumulatedVector.y/accumVectorLen,
              0)
          moveNpc(npc,newPosn)
        end
      else
        moveRandomAngle(civilian)
      end

      Timers:CreateTimer( 1.0 , civilianMoveFunction(civilian) )
    end
  end
end

function addZombie(x,y)
  local zombie = CreateUnitByName("npc_zombie", Vector(x,y,0), true, nil, nil, DOTA_TEAM_BADGUYS)
  Timers:CreateTimer( 1.0 , zombieMoveFunction(zombie) )
  return zombie
end

function addCivilian(x,y)
  local civ = CreateUnitByName("npc_civilian", Vector(x,y,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
  Timers:CreateTimer( 1.0 , civilianMoveFunction(civ) )
  return civ
end 

function Level1()
	local civ = addCivilian(0,-200)
	local zombie = addZombie(0,200)
end