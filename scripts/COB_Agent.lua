--------------------------------------------------------------------------------
-- Called from C++
--- Called once when the NPC is initialized
function init(args)

end

--------------------------------------------------------------------------------
-- Called from C++
--- Called when the NPC is interacted with (e.g. by a player)
--
-- @param args Table (map) of interaction event arguments:
--        sourceId -> Entity id of the entity interacting with this NPC
--        sourcePosition -> The {x,y} position of the interacting entity
--
-- @returns nil, or a string describing an interaction response, or a table
--          (array) of { <interaction response string>, <interaction response config table (map)> }
--          Available interaction responses are:
--            "OpenCockpitInterface"
--            "SitDown"
--            "OpenCraftingInterface"
--            "OpenCookingInterface"
--            "OpenTechInterface"
--            "Teleport"
--            "OpenStreamingVideoInterface"
--            "PlayCinematic"
--            "OpenSongbookInterface"
--            "OpenNpcInterface"
--            "OpenNpcCraftingInterface"
--            "OpenTech3DPrinterDialog"
--            "ShowPopup"
function interact(args)
  
end

--------------------------------------------------------------------------------
-- Called from C++
--- Called after the NPC has taken damage
-- @param args Table (map) of info about the damage, structured as:
--             {
--               sourceId = <entity id of entity that caused the damage>,
--               damage = <numeric amount of damage that was taken>,
--               sourceDamage = <numeric amount of damage that was originally dealt>,
--               sourceKind = <string kind of damage being applied, as defined in "damageKind" value in a *.projectile config>
--             }
--        Note that "sourceDamage" can be higher than "damage" if - for
--        instance - some damage was blocked by a shield.
function damage(args)
  entity.heal(args.damage)
end

--------------------------------------------------------------------------------
-- Called from C++
--- Called when the npc has died and is about to be removed
function die()

end

function shouldDie()
  if ( self.caos_killed ~= nil ) then
    return self.caos_killed
  else
    return true
  end
end

--------------------------------------------------------------------------------
-- Called from C++
--- Update loop handler, called once every scriptDelta (defined in *.npctype) ticks
function main()

end

--------------------------------------------------------------------------------
function debugLog(format, ...)
  world.logInfo("[" .. entity.id() .. "] " .. format, ...)
end

--------------------------------------------------------------------------------
-- Calls receiveNotification for all nearby NPCs
function sendNotification(name, args, radius)
  local selfId = entity.id()
  local notification = {
    name = name,
    handled = false,
    sourceEntityId = selfId,
    args = args
  }

  if radius == nil then
    radius = entity.configParameter("notificationRadius", 25)
  end

  for _, entityId in pairs(world.entityQuery(entity.position(), radius, { inSightOf = selfId, withoutEntityId = selfId })) do
    notification.handled = world.callScriptedEntity(entityId, "receiveNotification", notification) or notification.handled
  end

  return notification.handled
end

function sendNotificationTo(name, args, target)
  local selfId = entity.id()
  local notification = {
    name = name,
    handled = false,
    sourceEntityId = selfId,
    args = args
  }

  notification.handled = world.callScriptedEntity(target.id(), "receiveNotification", notification)
  return notification.handled
end

--------------------------------------------------------------------------------
-- Handles notifications from nearby NPCs
function receiveNotification(notification)
  self.caos_vm.message_from = notification.sourceEntityId
  self.caos_vm.message_param_1 = notification.args._P1_
  self.caos_vm.message_param_2 = notification.args._P2_
  
  if notification.name == "CAOS_0" then                 -- Deactivate
  elseif notification.name = "CAOS_1" then              -- Activate 1
  elseif notification.name = "CAOS_2" then              -- Activate 2
  elseif notification.name = "CAOS_3" then              -- Hit (received)
  elseif notification.name = "CAOS_4" then              -- Pickup (non-vehicle)
  elseif notification.name = "CAOS_5" then              -- Drop (non-vehicle)
  elseif notification.name = "CAOS_6" then              -- Collision (collided with obstacle)
  elseif notification.name = "CAOS_7" then              -- Bump (walked into a wall)
  elseif notification.name = "CAOS_8" then              -- Impact (presence impacted with another agent)
  elseif notification.name = "CAOS_9" then              -- Timer (regular timer interval)
  elseif notification.name = "CAOS_10" then             -- Constructor (creation)
  elseif notification.name = "CAOS_11" then             -- 
  elseif notification.name = "CAOS_12" then             -- Eat (creature has eaten this)
  elseif notification.name = "CAOS_13" then             -- Start hold hands (with cursor)
  elseif notification.name = "CAOS_14" then             -- Stop hold hands (with cursor)
  elseif notification.name = "CAOS_15" then             -- 
  elseif notification.name = "CAOS_16" then             -- Creature stands and watches agent
  elseif notification.name = "CAOS_17" then             -- Creature uses activate 1 on agent
  elseif notification.name = "CAOS_18" then             -- Creature uses activate 2 on agent
  elseif notification.name = "CAOS_19" then             -- Creature uses deactivate on agent
  elseif notification.name = "CAOS_20" then             -- Creature approaches agent
  elseif notification.name = "CAOS_21" then             -- Creature retreats from agent
  elseif notification.name = "CAOS_22" then             -- Creature picks up agent
  elseif notification.name = "CAOS_23" then             -- Creature drops what is being carried (agent)
  elseif notification.name = "CAOS_24" then             -- Creature says what is bothering it (agent)
  elseif notification.name = "CAOS_25" then             -- Creature becomes sleepy (agent)
  elseif notification.name = "CAOS_26" then             -- Creature walks west (agent)
  elseif notification.name = "CAOS_27" then             -- Creature walks east (agent)
  elseif notification.name = "CAOS_28" then             -- Creature eats agent
  elseif notification.name = "CAOS_29" then             -- Creature hits agent
  elseif notification.name = "CAOS_30" then             -- 
  elseif notification.name = "CAOS_31" then             -- 
  elseif notification.name = "CAOS_32" then             -- Creature stands and watches creature
  elseif notification.name = "CAOS_33" then             -- Creature uses activate 1 on creature (mating script)
  elseif notification.name = "CAOS_34" then             -- Creature uses activate 2 on creature (mating script)
  elseif notification.name = "CAOS_35" then             -- Creature uses deactivate on creature
  elseif notification.name = "CAOS_36" then             -- Creature approaches creature
  elseif notification.name = "CAOS_37" then             -- Creature retreats from creature
  elseif notification.name = "CAOS_38" then             -- Creature picks up creature
  elseif notification.name = "CAOS_39" then             -- Creature drops what is being carried (creature)
  elseif notification.name = "CAOS_40" then             -- Creature says what is bothering it (creature)
  elseif notification.name = "CAOS_41" then             -- Creature becomes sleepy (creature)
  elseif notification.name = "CAOS_42" then             -- Creature walks west (creature)
  elseif notification.name = "CAOS_43" then             -- Creature walks east (creature)
  elseif notification.name = "CAOS_44" then             -- Creature eats creature ??
  elseif notification.name = "CAOS_45" then             -- Creature hits creature
  elseif notification.name = "CAOS_64" then             -- Creature flinches
  elseif notification.name = "CAOS_65" then             -- Creature lays egg
  elseif notification.name = "CAOS_66" then             -- Creature sneezes
  elseif notification.name = "CAOS_67" then             -- Creature coughs
  elseif notification.name = "CAOS_68" then             -- Creature shivers
  elseif notification.name = "CAOS_69" then             -- Creature sleeps
  elseif notification.name = "CAOS_70" then             -- Creature faints
  elseif notification.name = "CAOS_71" then             -- 
  elseif notification.name = "CAOS_72" then             -- Creature dies
  elseif notification.name = "CAOS_73" then             -- Key is down
  elseif notification.name = "CAOS_74" then             -- Key is up
  elseif notification.name = "CAOS_75" then             -- Mouse is moved
  elseif notification.name = "CAOS_76" then             -- Mouse button is down
  elseif notification.name = "CAOS_77" then             -- Mouse button is up
  elseif notification.name = "CAOS_78" then             -- Mouse wheel is moved
  elseif notification.name = "CAOS_79" then             -- Raw translated character is received
  elseif notification.name = "CAOS_92" then             -- Mouse clicks an agent
  elseif notification.name = "CAOS_101" then            -- Pointer activate 1
  elseif notification.name = "CAOS_102" then            -- Pointer activate 2
  elseif notification.name = "CAOS_103" then            -- Pointer deactivate
  elseif notification.name = "CAOS_104" then            -- Pointer pickup
  elseif notification.name = "CAOS_105" then            -- Pointer drop
  elseif notification.name = "CAOS_110" then            -- Pointer port manipulated (wire)
  elseif notification.name = "CAOS_111" then            -- Pointer port connection (wire)
  elseif notification.name = "CAOS_112" then            -- Pointer port disconnection (wire)
  elseif notification.name = "CAOS_113" then            -- Pointer cancel port manipulation (wire)
  elseif notification.name = "CAOS_114" then            -- Pointer port error (wire)
  elseif notification.name = "CAOS_115" then            -- 
  elseif notification.name = "CAOS_116" then            -- Pointer clicked on background (no agents)
  elseif notification.name = "CAOS_117" then            -- Pointer get action on click (hovered over a creature)
  elseif notification.name = "CAOS_118" then            -- Agent port has been broken (wire disconnected/snapped)
  elseif notification.name = "CAOS_119" then            -- 
  elseif notification.name = "CAOS_120" then            -- Selected creature changed (UI)
  elseif notification.name = "CAOS_121" then            -- Agent picked up by vehicle
  elseif notification.name = "CAOS_122" then            -- Agent dropped by vehicle
  elseif notification.name = "CAOS_123" then            -- Window resized
  elseif notification.name = "CAOS_124" then            -- Agent has picked something up
  elseif notification.name = "CAOS_125" then            -- Agent has dropped something
  elseif notification.name = "CAOS_126" then            -- Creature is speaking (called by all agents)
  elseif notification.name = "CAOS_127" then            -- Creature Life event
  elseif notification.name = "CAOS_128" then            -- World was just loaded
  elseif notification.name = "CAOS_135" then            -- Network Connection was established
  elseif notification.name = "CAOS_136" then            -- Network connection was broken
  elseif notification.name = "CAOS_137" then            -- User has gone online
  elseif notification.name = "CAOS_138" then            -- User has gone offline
  elseif notification.name = "CAOS_150" then            -- Creature navigation callback valid (approach)
  elseif notification.name = "CAOS_151" then            -- Creature navigation callback outside room (approach, unable to use)
  elseif notification.name = "CAOS_152" then            -- Creature navigation callback neighbour (no object, looking for room)
  elseif notification.name = "CAOS_153" then            -- Creature navigation callback link (no object, current room is a link)
  elseif notification.name = "CAOS_154" then            -- Creature navigation callback best (no object, current room is the best)
  elseif notification.name = "CAOS_160" then            -- Creature aging callback (creature getting older)
  elseif notification.name = "CAOS_200" then            -- Mate (mating)
  elseif notification.name = "CAOS_255" then            -- Agent exception, script tried performing an action on an invalid agent
    debugLog("Agent attempted to perform an action on an invalid target.");
  end

  return false
end
