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
  entity.setGravityEnabled(true)
  
  entity.setVelocity({0,0})
  entity.setRunning(false)
  entity.setActiveSkillName(nil)
  
  entity.setGlobalTag("frameno", 0)
  
  world.logInfo("Spawned an agent!")
  
  if ( CAOS ~= nil and CAOS.Machine ~= nil ) then
    self.caos_vm = CAOS.Machine.create(entity, entity.configParameter("first_spawn", false))
  end
end

--- Update loop handler, called once every scriptDelta (defined in *.monstertype) ticks
function main() 
  if ( self.caos_vm ~= nil ) then
    self.caos_vm:update()
  end

end

--- Called when shouldDie has returned true and the monster and is about to be removed from the world
function die() 
  if ( self.caos_vm ~= nil ) then
    self.caos_vm:killed()
  end
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
  return self.caos_killed == true
end


-- Get and set functions so that CAOS can interact with external entities' local variables
function setVar(name, value)
  self[name] = value
  return true
end
function getVar(name)
  return self[name]
end
