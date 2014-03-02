Variable = {}
Variable.__index = Variable

function Variable.create(agentId, varName)
  local o = {}
  setmetatable(o, Variable)
  
  -- set the type
  o.type = "variable"
  
  -- get the entity id
  if ( type(agentId) == table ) then
    o.id = agentId.id()
  elseif ( agentId == nil ) then
    o.id = -1
  else
    o.id = agentId
  end
  
  -- Assign the name to reference from
  o.name = varName
  o.value = 0
  
  return o
end

function Variable.createValue(value)
  local o = Variable.create()
  o:set(value)
  return o
end

function Variable.set(self, value)
  if ( self.id >= 0 ) then
    world.callScriptedEntity(self.id, "CAOS_set_var", self.name, value)
  else
    self.value = value
  end
end

function Variable.get(self)
  if ( self.id >= 0 ) then
    return world.callScriptedEntity(self.id, "CAOS_get_var", self.name)
  else
    return self.value
  end
end
