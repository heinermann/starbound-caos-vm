--- Stubs for global functions monster scripts can define, which will be called by C++


--- Called (once) when the monster is added to the world.
--
-- Note that the monster's position may not yet be valid.
function init() 
  -- Start with common (safe) properties
  entity.setAggressive(false)
  entity.setDamageOnTouch(false)
  entity.setFlipped(false)
  entity.setDropPool(nil)
  
  -- temporary unless I decide not to write its own internal gravity engine
  entity.setGravityEnabled(false)
  
  entity.setVelocity({0,0})
  entity.setRunning(false)
  entity.setActiveSkillName(nil)
  
  entity.setGlobalTag("frameno", 0)
  
  -- Initialize the CAOS variable storage
  if ( storage.caos_vars == nil ) then
    storage.caos_vars = {}
  end
  
  -- Check if this is the entity's first time spawning, in which case it should immediately despawn
  local first_spawn = entity.configParameter("first_spawn")
  storage.should_install = first_spawn == "true" or first_spawn == true
  if ( storage.should_install == true ) then
    entity.setAnimationState("portrait", "invisible")
  end
  
  -- Assign inherited variables
  local inherited_vars = entity.configParameter("inherited_vars")
  if ( type(inherited_vars) == "table" ) then
    for k,v in pairs(inherited_vars) do
      CAOS_set_var(k, v)
    end
  end
  
  world.logInfo("Entity created")
end

--- Update loop handler, called once every scriptDelta (defined in *.monstertype) ticks
function main()
  if ( vm ~= nil ) then
    vm:update()
  else
    vm = CAOS.Machine.create(entity.id(), storage.should_install)
    world.logInfo("VM Created")
  end
end

--- Called when shouldDie has returned true and the monster and is about to be removed from the world
function die()
end

--- Called after the NPC has taken damage
--
-- @tab args Map of info about the damage, structured as:
--    {
--      sourceId = <entity id of entity that caused the damage>,
--      damage = <numeric amount of damage that was taken>,
--      sourceDamage = <numeric amount of damage that was originally dealt>,
--      sourceKind = <string kind of damage being applied, as defined in "damageKind" value in a *.projectile config>
--    }
-- Note that "sourceDamage" can be higher than "damage" if - for
-- instance - some damage was blocked by a shield.
function damage(args)
  -- N/A? Might use args.sourceKind for activate1/activate2/deactivate/hit/etc
  
  entity.heal(args.damage)
end

--- Called each update to determine if the monster should die.
--
-- If not defined in the monster's lua, will default to returning true when
-- the monster's health has been depleted.
--
-- @treturn bool true if the monster can die, false to keep the monster alive
function shouldDie()
  return storage.CAOS_killed == true
  --return true
end

-- Tells the VM controller if this agent was just initialized. If it was already initialized then it will return false,
-- allowing the controller to exclude it from initializing it as an agent.
function CAOS_init()
  if ( storage.CAOS_controlled ~= true ) then
    storage.CAOS_controlled = true
    return true
  end
  return false
end

-- Resets control, this is for when the entity is no longer being controlled by the VM controller (exited the space, controller was destroyed, etc.)
function CAOS_reset()
  storage.CAOS_controlled = false
end

-- Tells the agent to kill itself
function CAOS_kill()
  storage.CAOS_killed = true
end

function CAOS_get_var(name)
  if ( storage.caos_vars == nil ) then
    storage.caos_vars = {}
  end
  return storage.caos_vars[name]
end

function CAOS_set_var(name, value)
  if ( storage.caos_vars == nil ) then
    storage.caos_vars = {}
  end
  storage.caos_vars[name] = value
end
