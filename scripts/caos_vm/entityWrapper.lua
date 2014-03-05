EntityWrap = {}
EntityWrap.__index = EntityWrap

function EntityWrap.create(agentId)
  local o = {}
  setmetatable(o, EntityWrap)
  
  -- set the type
  o.type = "agent"
  
  -- get the entity id
  if ( type(agentId) == table ) then
    o.id = agentId.id()
  else
    o.id = agentId
  end
  
  -- misc. variables
  o.is_flipped = false
  
  return o
end

function EntityWrap.position(self)
  return world.entityPosition(self.id)
end

function EntityWrap.setPosition(self, position)
  world.callScriptedEntity(self.id, "entity.setPosition", position)
end

function EntityWrap.getVarDynamic(self, name)
  return Variable.create(self.id, name)
end

function EntityWrap.getVar(self, name)
  return world.callScriptedEntity(self.id, "CAOS_get_var", name)
end

function EntityWrap.setVar(self, name, value)
  world.callScriptedEntity(self.id, "CAOS_set_var", name, value)
end

function EntityWrap.setFlipped(self, flip)
  world.callScriptedEntity(self.id, "entity.setFlipped", flip)
  self.is_flipped = flip
end

function EntityWrap.isFlipped(self)
  return self.is_flipped
end

function EntityWrap.setTag(self, name, value)
  world.callScriptedEntity(self.id, "entity.setGlobalTag", name, value)
  --world.callScriptedEntity(self.id, "entity.setPartTag", body, name, value)
end

function EntityWrap.rotate(self, value)
  world.callScriptedEntity(self.id, "entity.rotateGroup", "all", value)
end

function EntityWrap.getRotation(self)
  return world.callScriptedEntity(self.id, "entity.currentRotationAngle", "all")
end

function EntityWrap.setVelocity(self, velocity)
  world.callScriptedEntity(self.id, "entity.setVelocity", velocity)
end

function EntityWrap.velocity(self)
  return world.callScriptedEntity(self.id, "entity.velocity")
end

function EntityWrap.dt(self)
  return world.callScriptedEntity(self.id, "entity.dt")
end

function EntityWrap.playSound(self, sfx)
  world.callScriptedEntity(self.id, "entity.playSound", sfx)
end

function EntityWrap.playVoice(self, voice)
  self:playSound( world.callScriptedEntity(self.id, "entity.randomizeParameter", voice) )
end

function EntityWrap.say(self, text)
  world.callScriptedEntity(self.id, "entity.say", text)
end

function EntityWrap.name(self)
  return world.entityName(self.id)
end

function EntityWrap.configParameter(self, name, default)
  return world.callScriptedEntity(self.id, "entity.configParameter", name, default)
end

function EntityWrap.kill(self)
  world.callScriptedEntity(self.id, "CAOS_kill")
end

function EntityWrap.caos_carryable(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.CARRYABLE) ~= 0
end

function EntityWrap.caos_mouseable(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.MOUSEABLE) ~= 0
end

function EntityWrap.caos_activateable(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.ACTIVATEABLE) ~= 0
end

function EntityWrap.caos_invisible(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.INVISIBLE) ~= 0
end

function EntityWrap.caos_floatable(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.FLOATABLE) ~= 0
end

function EntityWrap.caos_suffer_collisions(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.SUFFER_COLLISIONS) ~= 0
end

function EntityWrap.caos_suffer_physics(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.SUFFER_PHYSICS) ~= 0
end

function EntityWrap.caos_rotatable(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.ROTATABLE) ~= 0
end

function EntityWrap.caos_presence(self)
  local attributes = self:getVar("caos_attributes")
  return bit32.band(attributes or 0, CAOS.ATTRIBUTES.PRESENCE) ~= 0
end

          --if ( bit32.band(attributes, CAOS.ATTRIBUTES.GREEDY_CABIN) ~= 0 ) then
          --if ( bit32.band(attributes, CAOS.ATTRIBUTES.CAMERA_SHY) ~= 0 ) then
          --if ( bit32.band(attributes, CAOS.ATTRIBUTES.OPEN_AIR_CABIN) ~= 0 ) then
