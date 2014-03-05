Physics = {}
Physics.__index = Physics

function Physics.create(agent)
  local o = {}
  setmetatable(o, Physics)
  
  -- store the agent
  o.agent = agent
  
  o.collide_left = false
  o.collide_up = false
  o.collide_right = false
  o.collide_down = false
  
  o.last_collision = CAOS.DIRECTIONS.LEFT
  
  o.used_collision_callback = false
  
  return o
end

function Physics.update(self)
  local bounds = self.agent:getBounds()
  local pos = self.agent:position()
  local permiability = self.agent:getVar("caos_permiability") or 100
  local gravity = -(self.agent:getVar("caos_gravity_accel") or -10)
  local elasticity = self.agent:getVar("caos_elasticity") or 0   -- percentage
  local friction = self.agent:getVar("caos_friction") or 100       -- percentage
  local aerodynamics = self.agent:getVar("caos_aerodynamics") or 100       -- percentage
  local velocity = self.agent:velocity()
    
  -- If the agent can collide with things
  if ( self.agent:caos_suffer_collisions() ) then
    -- left
    if ( world.rectCollision({  pos[1] - bounds.left - 0.1,   pos[2] - bounds.bottom + 0.1,
                                pos[1],  pos[2] + bounds.top - 0.1 }, permiability < 50) ) then
      self.collide_left = true
      self.last_collision = CAOS.DIRECTIONS.LEFT
    else
      self.collide_left = false
    end
    -- up
    if ( world.rectCollision({  pos[1] - bounds.left + 0.1,   pos[2],
                                pos[1] + bounds.right - 0.1,  pos[2] + bounds.top - 0.1 }, permiability < 50) ) then
      self.collide_up = true
      self.last_collision = CAOS.DIRECTIONS.UP
    else
      self.collide_up = false
    end
    -- right
    if ( world.rectCollision({  pos[1],   pos[2] - bounds.bottom + 0.1,
                                pos[1] + bounds.right + 0.1,  pos[2] + bounds.top - 0.1 }, permiability < 50) ) then
      self.collide_right = true
      self.last_collision = CAOS.DIRECTIONS.RIGHT
    else
      self.collide_right = false
    end
    -- down
    if ( world.rectCollision({  pos[1] - bounds.left + 0.1,   pos[2] - bounds.bottom - 0.1,
                                pos[1] + bounds.right - 0.1,  pos[2] }, permiability < 50) ) then
      self.collide_down = true
      self.last_collision = CAOS.DIRECTIONS.DOWN
    else
      self.collide_down = false
    end

    -- Perform collision event
    local has_collision = self.collide_left or self.collide_up or self.collide_right or self.collide_down
    if ( self.used_collision_callback == false and has_collision ) then
      self.used_collision_callback = true
      -- TODO: call the collision event
    elseif ( has_collision ~= true ) then
      self.used_collision_callback = false
    end
  end
  
  -- If the agent has physics applied to it (gravity etc)
  if ( self.agent:caos_suffer_physics() ) then
   
    -- When colliding with right wall
    if ( velocity[1] > 0 and self.collide_right ) then
      velocity[1] = -math.abs(velocity[1]) * (elasticity / 100.0)   -- elasticity
      
    end
    -- When colliding with left wall
    if ( velocity[1] < 0 and self.collide_left ) then
      velocity[1] = math.abs(velocity[1]) * (elasticity / 100.0)   -- elasticity
      
    end
    -- When colliding with top wall
    if ( velocity[2] > 0 and self.collide_up ) then
      velocity[2] = -math.abs(velocity[2]) * (elasticity / 100.0)   -- elasticity
      velocity[1] = velocity[1] * ((100 - friction) / 100.0)        -- friction
    end
    -- When colliding with bottom wall
    if ( velocity[2] < 0 and self.collide_down ) then
      velocity[2] = math.abs(velocity[2]) * (elasticity / 100.0)    -- elasticity
      velocity[1] = velocity[1] * ((100 - friction) / 100.0)        -- friction
    end
    
    -- Apply aerodynamic factor
    velocity[1] = velocity[1] * aerodynamics

    -- Apply gravity!~
    velocity[2] = velocity[2] + gravity
    --world.logInfo("We should have velocity: " .. velocity[1] .. " " .. velocity[2])
    
    ------ Constraints
    if ( velocity[2] < 0 and self.collide_down ) then   -- don't fall through floor
      velocity[2] = 0
      local colPos = world.collisionBlocksAlongLine(pos, {pos[1], pos[2] - bounds.bottom - 0.1}, permiability < 50, 1)
      if ( colPos ~= nil and #colPos > 0 ) then
        self.agent:setPosition({pos[1], colPos[1][2] + bounds.bottom})
      end
      --world.logInfo("Attached to floor " .. tostring(self.collide_left) .. " " .. tostring(self.collide_up) .. " " .. tostring(self.collide_right) .. " " .. tostring(self.collide_down))
    end
    if ( velocity[2] > 0 and self.collide_up ) then   -- don't fly through ceiling
      velocity[2] = 0
      local colPos = world.collisionBlocksAlongLine(pos, {pos[1], pos[2] + bounds.top + 0.1}, permiability < 50, 1)
      if ( colPos ~= nil and #colPos > 0 ) then
        self.agent:setPosition({pos[1], colPos[1][2] - bounds.top})
      end
      --world.logInfo("Attached to ceiling " .. tostring(self.collide_left) .. " " .. tostring(self.collide_up) .. " " .. tostring(self.collide_right) .. " " .. tostring(self.collide_down))
    end
    if ( velocity[1] < 0 and self.collide_left ) then   -- don't go through left wall
      velocity[1] = 0
      --world.logInfo("Attached to left " .. tostring(self.collide_left) .. " " .. tostring(self.collide_up) .. " " .. tostring(self.collide_right) .. " " .. tostring(self.collide_down))
    end
    if ( velocity[1] > 0 and self.collide_right ) then   -- don't go through right wall
      velocity[1] = 0
      --world.logInfo("Attached to right " .. tostring(self.collide_left) .. " " .. tostring(self.collide_up) .. " " .. tostring(self.collide_right) .. " " .. tostring(self.collide_down))
    end

    -- Finally set the new velocity
    self.agent:setVelocity(velocity)
  end
end
