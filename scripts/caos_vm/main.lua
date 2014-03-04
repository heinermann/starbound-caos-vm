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
  
  o.owner   = EntityWrap.create(agent)
  o.target  = EntityWrap.create(agent)
  
  o.message_from = nil
  o.message_param_1 = nil
  o.message_param_2 = nil
  
  o.timer_interval = o.owner:getVarDynamic("caos_timer_interval")
  if ( o.timer_interval:get() == nil ) then
    o.timer_interval:set(0)
  end
  o.timer_step = 0
  o.update_interval = 50
  o.last_tick = os.clock()*1000
  
  o.owner:setVar("caos_family", tonumber(o.owner:configParameter("caos_family", 0)))
  o.owner:setVar("caos_genus", tonumber(o.owner:configParameter("caos_genus", 0)))
  o.owner:setVar("caos_species", tonumber(o.owner:configParameter("caos_species", 0)))
  o.owner:setVar("caos_sprite_file", o.owner:configParameter("caos_sprite_file", ""))
  o.owner:setVar("caos_image_count", tonumber(o.owner:configParameter("caos_image_count", 1)))
  o.owner:setVar("caos_first_image", tonumber(o.owner:configParameter("caos_first_image", 0)))
  --world.logInfo("caos_first_image = " .. tostring(o.owner:getVar("caos_first_image")) .. " vs " .. tostring(o.owner:configParameter("caos_first_image", 0)) )
  
  
  o.owner:setVar("caos_plane", tonumber(o.owner:configParameter("caos_plane", 500)))
  o.owner:setVar("caos_image_base", 0)
  o.owner:setVar("caos_image_pose", 0)
      
  o.owner:setVar("caos_attributes", 0)
  o.owner:setVar("caos_permissions", 0)
  o.owner:setVar("caos_permiability", 50)
  o.owner:setVar("caos_carried_by", nil)
  o.owner:setVar("caos_carrying", nil)
  o.owner:setVar("caos_flipped", 0 )
    
  o.owner:setVar("caos_clack_msg", 1)
  o.owner:setVar("caos_click_msg_1", -2)
  o.owner:setVar("caos_click_msg_2", -2)
  o.owner:setVar("caos_click_msg_3", -2)
  o.owner:setVar("caos_current_click", 0)
    
  o.owner:setVar("caos_paused", false)
  o.owner:setVar("caos_debug_core", false)
  o.owner:setVar("caos_killed", false)
  o.owner:setVar("caos_distance_check", 100)
  o.owner:setVar("caos_float_relative", nil)
  o.owner:setVar("caos_voice", nil)
  
  o.owner:setVar("caos_vars", {})
    
  o.owner:setVar("caos_bounds", {     left    = o.owner:position()[1] - 4,
                                      top     = o.owner:position()[2] - 4,
                                      right   = o.owner:position()[1] + 4,
                                      bottom  = o.owner:position()[2] + 4
                                    })
    
  -- variables
  o.caos_vars = {}
  local agent_vars = {}
  for i = 1, 100 do
    o.caos_vars[i] = Variable.createValue(0)
    o.owner:getVarDynamic("caos_vars_" .. i):set(0)
  end

  -- script file
  o.script_file = o.owner:configParameter("agent.source", nil)
  if ( o.script_file == nil ) then
    error("Expected an agent.source configuration, became nil!")
  end
  table.insert(o.script_file, "ENDM")    -- hacky ENDM since scripts don't originally require it
  
  --o:parse_full_source(o.script_file)
  o.parser = CAOS.Parser.create(o)
  o.parser:init()
  
  if ( run_install_script == true ) then
    o.parser:run_install_script()
    o.parser:update()
    --o.owner:kill()  -- Kill the agent that ran the install script; The installer/injector is actually not supposed to appear
  else
    local desired_line = tonumber(o.owner:configParameter("desired_script_line", 0))
    local desired_column = tonumber(o.owner:configParameter("desired_script_column", 0))
    if ( desired_line == 0 ) then
      o.parser:stop()
    else
      o.parser:set_cursor(desired_line, desired_column)
    end
  end
  
  return o
end



function CAOS.Machine.update(self)

  -- Prevents execution until the update interval has passed
  -- The update interval is number of milliseconds per tick
  if ( os.clock()*1000 < self.last_tick + self.update_interval ) then
    return
  end
  self.last_tick = os.clock()*1000
  
  
  local interval = self.timer_interval:get()
  if ( interval > 0 ) then
    if ( self.timer_step >= interval ) then
      if ( self.parser.wait_time == 0 ) then
        world.logInfo("RAN TIMER SCRIPT")
        self.timer_step = 0
        self.parser:run_script( self.owner:getVar("caos_family"),
                                self.owner:getVar("caos_genus"),
                                self.owner:getVar("caos_species"),
                                CAOS.EVENT.TIMER)
      end
    else
      self.timer_step = self.timer_step + 1
    end
  end
  
  self.parser:update()
end

function CAOS.Machine.killed(self)
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

function CAOS.debug_scriptorium()
  world.logInfo(table.tostring(CAOS.scriptorium))
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
  return Variable.create(self.owner.id, var_name)
end

-- DELN, NAME, OVxx, NAMN
function CAOS.Machine.get_target_var(self, var_name)
  return Variable.create(self.target.id, var_name)
end

-- DELG, GAME, GAMN
function CAOS.Machine.get_game_var(self, var_name)
  if ( CAOS.game.caos_vars[var_name] == nil ) then
    CAOS.game.caos_vars[var_name] = Variable.createValue(0)
  end
  
  return CAOS.game.caos_vars[var_name]
end

-- DELE, EAME, EAMN
function CAOS.Machine.get_engine_var(self, var_name)
  if ( CAOS.engine.caos_vars[var_name] == nil ) then
    CAOS.engine.caos_vars[var_name] = Variable.createValue(0)
  end
  
  return CAOS.engine.caos_vars[var_name]
end
