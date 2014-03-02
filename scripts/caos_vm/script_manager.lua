CAOS.Manager = {}
CAOS.Manager.__index = CAOS.Manager

function CAOS.Manager.create(agent)
  local o = {}
  setmetatable(o, CAOS.Machine)
  
  o.parent = agent

  -- Init storage scriptorium
  
  -- sourcepool entry:
  -- [id] = []
  o.parent.storage.sourcepool = {}
  
  -- scriptorium entry:
  -- [family][genus][species][event] =
  -- {
  --   file = 0,
  --   line = 1,
  --   column = 1,
  --   subs = { [label] = {line = 1, column = 1} }
  -- }
  o.parent.storage.scriptorium = {}

  
  -- Init storage variables  
  o.storage.globals = { name_of_hand = "hand" }

  for k,v in pairs(CAOS.game.caos_vars) do
    o.storage.gamevars[k] = { value = v.value }
  end
  for k,v in pairs(CAOS.engine.caos_vars) do
    o.storage.enginevars[k] = { value = v.value }
  end
  
  
  -- Agent tracker
  
  -- [id] = { vm = nil,
  --          vars = {},
  --          entity = nil
  --        }
  o.storage.agents = {}

  
  return o
end
  
  
function CAOS.Manager.update(self)

  -- Update existing entities
  for i,v in pairs(self.parent.storage.agents) do
    if ( v == nil or not world.entityExists(i) ) then
      v = nil
    else
      if ( v.vm ~= nil ) then
        v.vm.update()
      end
    end
  end
  
  -- Find new entities
  found = world.monsterQuery(self.parent.position(), CAOS.world_search_size, { callScript = "CAOS_init" })
  for i,v in ipairs(found) do
    agent = EntityWrap.create(v)
    o.storage.agents[v] = {   vm = CAOS.Machine.create(self, agent),
                              vars = {},
                              entity = agent
                          }
  end
  
  --
end

