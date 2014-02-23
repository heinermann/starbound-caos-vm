-- CAOS scripting emulator
-- SOURCE: http://creaturesdev.webs.com/caoscategoricalds.htm
-- SOURCE: http://creatures.wikia.com/wiki/Cellular_Automata
-- SOURCE: http://www.gamewaredevelopment.com/downloads/cdn/C2CAOSGuide.pdf

-- Main file
CAOS = {}
CAOS.__index = CAOS


CAOS.Machine = {}
CAOS.Machine.__index = CAOS.Machine
  
-- scriptorium entry:
-- [family][genus][species][event] =
-- {
--   source = { line = 1, column = 1 }
-- }
CAOS.scriptorium = {}
CAOS.subroutines = {}
CAOS.script_install = { line = 1, column = 1 }
CAOS.script_remove = { line = 1, column = 1 }

function CAOS.Machine.create(agent, run_install_script)
  local o = {}
  setmetatable(o, CAOS.Machine)
  
  o.owner       = agent
  o.target      = agent
  
  o.message_from = nil
  o.message_param_1 = nil
  o.message_param_2 = nil
  
  o.timer_interval = 0
  o.timer_step = 0
  o.update_interval = 50
  o.last_tick = os.clock()*1000

  CAOS.setVar(agent, "caos_family", agent.configParameter("caos_family", 0))
  CAOS.setVar(agent, "caos_genus", agent.configParameter("caos_genus", 0))
  CAOS.setVar(agent, "caos_species", agent.configParameter("caos_species", 0))
  CAOS.setVar(agent, "caos_sprite_file", agent.configParameter("caos_sprite_file", ""))
  CAOS.setVar(agent, "caos_image_count", agent.configParameter("caos_image_count", 1))
  CAOS.setVar(agent, "caos_first_image", agent.configParameter("caos_first_image", 1))
  CAOS.setVar(agent, "caos_plane", agent.configParameter("caos_plane", 500))
  CAOS.setVar(agent, "caos_image_base", 0)
  CAOS.setVar(agent, "caos_image_pose", 0)
      
  CAOS.setVar(agent, "caos_attributes", 0)
  CAOS.setVar(agent, "caos_permissions", 0)
  CAOS.setVar(agent, "caos_permiability", 50)
  CAOS.setVar(agent, "caos_carried_by", nil)
  CAOS.setVar(agent, "caos_carrying", nil)
  CAOS.setVar(agent, "caos_flipped", 0 )
    
  CAOS.setVar(agent, "caos_clack_msg", 1)
  CAOS.setVar(agent, "caos_click_msg_1", -2)
  CAOS.setVar(agent, "caos_click_msg_2", -2)
  CAOS.setVar(agent, "caos_click_msg_3", -2)
  CAOS.setVar(agent, "caos_current_click", 0)
    
  CAOS.setVar(agent, "caos_paused", false)
  CAOS.setVar(agent, "caos_debug_core", false)
  CAOS.setVar(agent, "caos_killed", false)
  CAOS.setVar(agent, "caos_distance_check", 100)
  CAOS.setVar(agent, "caos_float_relative", nil)
  CAOS.setVar(agent, "caos_voice", nil)
  
  CAOS.setVar(agent, "caos_vars", {})
    
  CAOS.setVar(agent, "caos_bounds", { left = agent.position()[1] - 4,
                                      top = agent.position()[2] - 4,
                                      right = agent.position()[1] + 4,
                                      bottom = agent.position()[2] + 4
                                    })
    
  -- variables
  o.caos_vars = {}
  local agent_vars = {}
  for i = 1, 100 do
    o.caos_vars[i] = { value = 0, type = "variable" }
    agent_vars[i] = { value = 0, type = "variable" }
  end
  CAOS.setVar(agent, "caos_vars", agent_vars)

  -- script file
  o.script_file = agent.configParameter("agent.source", nil)
  if ( o.script_file == nil ) then
    error("Expected an agent.ource configuration, became nil!")
  end
  table.insert(o.script_file, "ENDM")    -- hacky ENDM since scripts don't originally require it
  
  --o:parse_full_source(o.script_file)
  o.parser = CAOS.Parser.create(o)
  o.parser:init()
  
  if ( run_install_script == true ) then
    o.parser:run_install_script()
  else
    o.parser:stop()
  end
  
  return o
end

function CAOS.getVar(agent, name)
  if ( agent == entity ) then
    return getVar(name)
  else
    return world.callScriptedEntity(agent.id(), name)
  end
end

function CAOS.setVar(agent, name, value)
  if ( agent == entity ) then
    return setVar(name, value)
  else
    return world.callScriptedEntity(agent.id(), name, value)
  end
end

function CAOS.add_to_scriptorium(family, genus, species, event, line, column)
  if ( CAOS.scriptorium[family] == nil ) then
    CAOS.scriptorium[family] = {}
  end
  if ( CAOS.scriptorium[family][genus] == nil ) then
    CAOS.scriptorium[family][genus] = {}
  end
  if ( CAOS.scriptorium[family][genus][species] == nil ) then
    CAOS.scriptorium[family][genus][species] = {}
  end
  if ( CAOS.scriptorium[family][genus][species][event] == nil ) then
    CAOS.scriptorium[family][genus][species][event] = {}
  end

  CAOS.scriptorium[family][genus][species][event]["source"] = { ["line"] = line, ["column"] = column }
end

function CAOS.add_subroutine(label, line, column)
  CAOS.subroutines[label] = { ["line"] = line, ["column"] = column }
end

function CAOS.script_exists(family, genus, species, event)
  local exists = true
  if ( exists and family ~= nil ) then
    exists = exists and CAOS.scriptorium[family] ~= nil
  end
  
  if ( exists and genus ~= nil ) then
    exists = exists and CAOS.scriptorium[family][genus] ~= nil
  end
  
  if ( exists and species ~= nil ) then
    exists = exists and CAOS.scriptorium[family][genus][species] ~= nil
  end

  if ( exists and event ~= nil ) then
    exists = exists and CAOS.scriptorium[family][genus][species][event] ~= nil
  end
  
  return exists and CAOS.scriptorium[family][genus][species][event].source ~= nil
end

function CAOS.script_to_message(script_no)
  if ( script_no == 0 ) then 
    script_no = 2
  elseif ( script_no == 1 ) then 
    script_no = 0
  elseif ( script_no == 2 ) then 
    script_no = 1
  end
  return script_no
end

function CAOS.message_to_script(message_no)
  if ( message_no == 0 ) then 
    message_no = 1
  elseif ( message_no == 1 ) then 
    message_no = 2
  elseif ( message_no == 2 ) then 
    message_no = 0
  end
  return message_no
end

function CAOS.get_cob_name(family, genus, species)
  return "COB_" .. family .. "_" .. genus .. "_" .. species
end

function CAOS.get_command(name, expected_type)
  local cmd_store = CAOS.commands[name]
  if ( cmd_store == nil ) then
    return nil
  end
  
  return cmd_store[expected_type or "command"]
end



-- Executes a piece of source code
function CAOS.Machine.execute_source(self, source)
end

function CAOS.Machine.update(self)

  -- Prevents execution until the update interval has passed
  -- The update interval is number of milliseconds per tick
  if ( os.clock()*1000 < self.last_tick + self.update_interval ) then
    return
  end
  self.last_tick = os.clock()*1000
  
  if ( self.timer_interval > 0 ) then
    if ( self.timer_step == self.timer_interval ) then
      self.timer_step = 0
      parser:run_script(  CAOS.getVar(self.owner, "caos_family"),
                          CAOS.getVar(self.owner, "caos_genus"),
                          CAOS.getVar(self.owner, "caos_species"),
                          CAOS.EVENT.TIMER)
    end
  end
  
  self.parser:update()
end

function CAOS.Machine.killed(self)
end

-- VAxx
function CAOS.Machine.get_local_var(self, var_name)
  if ( self.caos_vars[var_name] == nil ) then
    self.caos_vars[var_name] = { value = nil }
  end

  return self.caos_vars[var_name]
end

-- MAME, MVxx
function CAOS.Machine.get_owner_var(self, var_name)
  local pool = CAOS.getVar(self.owner, "caos_vars")
  
  -- Create a CAOS variable pool if one is not found.
  if ( pool == nil ) then
    if ( CAOS.setVar(self.owner, "caos_vars", {}) == nil ) then
      return { value = nil }
    end
  end
  
  -- Create a variable for the value if it doesn't exist
  if ( pool[var_name] == nil ) then
    pool[var_name] = { value = nil }
  end

  return pool[var_name]
end

-- DELN, NAME, OVxx, NAMN
function CAOS.Machine.get_target_var(self, var_name)
  local pool = CAOS.getVar(self.target, "caos_vars")
  
  -- Create a CAOS variable pool if one is not found.
  if ( pool == nil ) then
    if ( CAOS.setVar(self.target, "caos_vars", {}) == nil ) then
      return { value = nil }
    end
  end
  
  -- Create a variable for the value if it doesn't exist
  if ( pool[var_name] == nil ) then
    pool[var_name] = { value = nil }
  end

  return pool[var_name]
end

-- DELG, GAME, GAMN
function CAOS.Machine.get_game_var(self, var_name)
  if ( CAOS.game.caos_vars[var_name] == nil ) then
    CAOS.game.caos_vars[var_name] = { value = nil }
  end
  
  return CAOS.game.caos_vars[var_name]
end

-- DELE, EAME, EAMN
function CAOS.Machine.get_engine_var(self, var_name)
  if ( CAOS.engine.caos_vars[var_name] == nil ) then
    CAOS.engine.caos_vars[var_name] = { value = nil }
  end
  
  return CAOS.engine.caos_vars[var_name]
end
