-- CAOS scripting emulator
-- SOURCE: http://creaturesdev.webs.com/caoscategoricalds.htm
-- SOURCE: http://creatures.wikia.com/wiki/Cellular_Automata
-- SOURCE: http://www.gamewaredevelopment.com/downloads/cdn/C2CAOSGuide.pdf

-- string annoyance
getmetatable('').__index = function(str,i) return string.sub(str,i,i) end

-- Main file
CAOS = {}
CAOS.__index = CAOS

CAOS.engine = { caos_vars = {} }
CAOS.game = { caos_vars = {} }

CAOS.name_of_hand = "hand"
CAOS.world_search_size = 100000
CAOS.name_of_game = "Starbound"

CAOS.engine.caos_vars["engine_clone_upon_import"] = { value = 1 }
CAOS.engine.caos_vars["engine_no_auxiliary_bootstrap_1"] = { value = 1 }

CAOS.game.caos_vars["breeding_limit"] = { value = 6 }
CAOS.game.caos_vars["total_population"] = { value = 6 }
CAOS.game.caos_vars["extra_eggs_allowed"] = { value = 6 }
CAOS.game.caos_vars["Grettin"] = { value = 1 }
CAOS.game.caos_vars["status"] = { value = "offline" }
CAOS.game.caos_vars["user_of_this_world"] = { value = "" }

CAOS.game.caos_vars["chat_plane"] = { value = 8500 }
CAOS.game.caos_vars["chat_plane_max"] = { value = 8800 }
CAOS.game.caos_vars["chat_plane_highest"] = { value = 8810 }
CAOS.game.caos_vars["user_has_been_welcomed"] = { value = 0 }

CAOS.game.caos_vars["engine_debug_keys"] = { value = 0 }
CAOS.game.caos_vars["engine_full_screen_toggle"] = { value = 1 }
CAOS.game.caos_vars["engine_SkeletonUpdateDoubleSpeed"] = { value = 0 }
CAOS.game.caos_vars["engine_creature_pickup_status"] = { value = 3 }
CAOS.game.caos_vars["engine_dumb_creatures"] = { value = 0 }
CAOS.game.caos_vars["engine_pointerCanCarryObjectsBetweenMetaRooms"] = { value = 0 }
CAOS.game.caos_vars["engine_password"] = { value = "" }
CAOS.game.caos_vars["engine_creature_template_size_in_mb"] = { value = 2 }
CAOS.game.caos_vars["engine_near_death_track_name"] = { value = "" }
CAOS.game.caos_vars["engine_plane_for_lines"] = { value = 8500 }
CAOS.game.caos_vars["engine_synchronous_learning"] = { value = 0 }
CAOS.game.caos_vars["engine_zlib_compression"] = { value = 5 }
CAOS.game.caos_vars["engine_other_world"] = { value = "" }
CAOS.game.caos_vars["engine_netbabel_save_passwords"] = { value = 0 }
CAOS.game.caos_vars["engine_multiple_birth_first_chance"] = { value = 0.04 }
CAOS.game.caos_vars["engine_multiple_birth_subsequent_chance"] = { value = 0.01 }
CAOS.game.caos_vars["engine_multiple_birth_maximum"] = { value = 6 }
CAOS.game.caos_vars["engine_multiple_birth_identical_chance"] = { value = 0.5 }
CAOS.game.caos_vars["engine_LengthOfDayInMinutes"] = { value = 20 }   -- ignored due to obvious reasons
CAOS.game.caos_vars["engine_LengthOfSeasonInDays"] = { value = 4 }
CAOS.game.caos_vars["engine_NumberOfSeasons"] = { value = 4 }
CAOS.game.caos_vars["engine_mute"] = { value = 0 }
CAOS.game.caos_vars["engine_playAllSoundsAtMaximumLevel"] = { value = 0 }
CAOS.game.caos_vars["engine_usemidimusicsystem"] = { value = 0 }
CAOS.game.caos_vars["engine_distance_before_port_line_warns"] = { value = 600.0 }
CAOS.game.caos_vars["engine_distance_before_port_line_snaps"] = { value = 800.0 }
--engine_mirror_creature_body_parts

CAOS.game.caos_vars["cav_birthdate"] = { value = "" }
CAOS.game.caos_vars["cav_quittime"] = { value = "" }
CAOS.game.caos_vars["cav_gamelengthIsPerDay"] = { value = "" }
CAOS.game.caos_vars["cav_useparentmenu"] = { value = 0 }
CAOS.game.caos_vars["cav_CountdownClockAgent"] = { value = nil }
CAOS.game.caos_vars["cav_BirthdayBannerAgent"] = { value = nil }

CAOS.game.caos_vars["c3_creature_accg"] = { value = 5 }
CAOS.game.caos_vars["c3_creature_bhvr"] = { value = 15 }
CAOS.game.caos_vars["c3_creature_attr"] = { value = 198 }
CAOS.game.caos_vars["c3_creature_perm"] = { value = 100 }
CAOS.game.caos_vars["c3_meta_transition"] = { value = 0 }

CAOS.game.caos_vars["ds_game_type"] = { value = "undocked" }
CAOS.game.caos_vars["ds_number_of_life_events"] = { value = 10 }


-- Direction constants
CAOS.DIRECTIONS = {
  LEFT = 0,
  RIGHT = 1,
  UP = 2,
  DOWN = 3
}

-- Agent attributes
CAOS.ATTRIBUTES = {
  CARRYABLE = 1,
  MOUSEABLE = 2,
  ACTIVATEABLE = 4,
  GREEDY_CABIN = 8,
  INVISIBLE = 16,
  FLOATABLE = 32,
  SUFFER_COLLISIONS = 64,
  SUFFER_PHYSICS = 128,
  CAMERA_SHY = 256,
  OPEN_AIR_CABIN = 512,
  ROTATABLE = 1024,
  PRESENCE = 2048
}

-- Agent permissions
CAOS.PERMISSIONS = {
  ACTIVATE_1 = 1,
  ACTIVATE_2 = 2,
  DEACTIVATE = 4,
  HIT = 8,
  EAT = 16,
  PICK_UP = 32
}

CAOS.TIME_OF_DAY = {
  DAWN = 0,
  MORNING = 1,
  AFTERNOON = 2,
  EVENING = 3,
  NIGHT = 4
}

-- Cellular automata
CAOS.CA_INDEX = {
  SOUND = 0,
  LIGHT = 1,
  HEAT = 2,
  PRECIPITATION = 3,
  NUTRIENT = 4,
  WATER = 5,
  PROTEIN = 6,            -- Fruit
  CARBOHYDRATE = 7,       -- Seeds
  FAT = 8,                -- Food
  FLOWERS = 9,
  MACHINERY = 10,
  EGGS = 11,
  NORN = 12,
  GRENDEL = 13,
  ETTIN = 14,
  NORN_HOME = 15,
  GRENDEL_HOME = 16,
  ETTIN_HOME = 17,
  GADGET = 18
}

CAOS.FAMILY = {
  UI = 1,
  OBJECT = 2,
  EXTENDED = 3,
  CREATURE = 4
}

CAOS.OBJECT_GENUS = {
  SELF = 0,
  HAND = 1,
  DOOR = 2,
  SEED = 3,
  PLANT = 4,
  WEED = 5,
  LEAF = 6,
  FLOWER = 7,
  FRUIT = 8,
  MANKY = 9,          -- bad fruit
  DETRITUS = 10,      -- waste matter
  FOOD = 11,
  BUTTON = 12,
  BUG = 13,
  PEST = 14,
  CRITTER = 15,
  BEAST = 16,
  NEST = 17,
  ANIMAL_EGG = 18,
  WEATHER = 19,
  BAD = 20,
  TOY = 21,
  INCUBATOR = 22,
  DISPENSER = 23,
  TOOL = 24,
  POTION = 25
}

CAOS.EXTENDED_GENUS = {
  ELEVATOR = 1,
  TELEPORTER = 2,
  MACHINERY = 3,
  CREATURE_EGG = 4,
  NORN_HOME = 5,
  GRENDEL_HOME = 6,
  ETTIN_HOME = 7,
  GADGET = 8,
  PORTAL = 9,
  VEHICLE = 10
}

CAOS.CREATURE_GENUS = {
  NORN = 1,
  GRENDEL = 2,
  ETTIN = 3,
  SOMETHING = 4
}

CAOS.Machine = {}
CAOS.Machine.__index = CAOS.Machine
  
-- scriptorium entry:
-- [family][genus][species][event] =
-- {
--   source = { line = 1, column = 1 }
-- }
CAOS.scriptorium = {}
CAOS.subroutines = {}
CAOS.script_install = {}
CAOS.script_remove = {}

function CAOS.Machine.create(agent)
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
  o.instant_execution = false
  o.no_interrupt = false
  o.wait_time = 0
  o.stopped = false
  o.paused = false

  CAOS.setVar(agent, "caos_family", agent.configParameter("caos_family", 0))
  CAOS.setVar(agent, "caos_genus", agent.configParameter("caos_genus", 0))
  CAOS.setVar(agent, "caos_species", agent.configParameter("caos_species", 0))
  CAOS.setVar(agent, "caos_sprite_file", agent.configParameter("caos_sprite_file", ""))
  CAOS.setVar(agent, "caos_image_count", agent.configParameter("caos_image_count", 1))
  CAOS.setVar(agent, "caos_first_image", agent.configParameter("caos_first_image", 1))
  CAOS.setVar(agent, "caos_plane", agent.configParameter("caos_plane", 500))
  CAOS.setVar(agent, "caos_image_base", 0)
      
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
  for i = 0, 99 do
    o.caos_vars[i] = { value = 0 }
    agent_vars[i] = { value = 0 }
  end
  CAOS.setVar(agent, "caos_vars", agent_vars)

  -- script file
  o.script_file = agent.configParameter("agent.source", nil)
  if ( o.script_file == nil ) then
    error("Expected an agent.ource configuration, became nil!")
  end
  table.insert(o.script_file, "ENDM")    -- hacky ENDM since scripts don't originally require it
  
  o:parse_full_source(o.script_file)
  
  return o
end

function CAOS.getVar(agent, name)
  return world.callScriptedEntity(agent.id(), name)
end

function CAOS.setVar(agent, name, value)
  return world.callScriptedEntity(agent.id(), name, value)
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

  return exists
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

-- NOTE: conditional relations:
--          eq - equal
--          ne - not equal
--          gt - greater than
--          lt - less than
--          ge - greater or equal
--          le - less or equal
--          bt - bit test (AND)
--          bf - bit fail (NAND)

CAOS.Machine.Parser = {}
CAOS.Machine.Parser.__index = CAOS.Machine.Parser

function CAOS.Machine.Parser.create(source_data)
  local o = {}
  setmetatable(o, CAOS.Machine.Parser)
  
  if ( source_data == nil or #source_data == 0 ) then
    o.invalid = true
  end
  
  o.source = source_data
  o.line = 1
  o.column = 1
  o.str = (#o.source > 0) and o.source[o.line] or ""
  
  o.var_stack = {}
  o.call_stack = {}
  
  return o
end

-- Raises an error indicating the line it occurred on
function CAOS.Machine.Parser.error(self, text)
  error("[CAOS:" .. self.line .. ":" .. self.column .. "] " .. text)
end

-- checks if the stream is valid
function CAOS.Machine.Parser.valid(self)
  return self.invalid and false or true
end

-- Goes to the next line and returns false if it reached the end of the stream
function CAOS.Machine.Parser.next_line(self)
  self.column = 1
  
  repeat
    self.line = self.line + 1
    if ( self.line <= #self.source ) then
      self.str = self.source[self.line]
    else
      self.invalid = true
    end
  until ( self.invalid or #self.str > 0 )

  return self:valid()
end

-- Skip all whitespace (including new lines) and returns false if the end of the stream has been reached
-- Also skips comments
function CAOS.Machine.Parser.skip_whitespace(self)
  if ( self.column > #self.str ) then
    self:next_line()
  end
  
  while ( self:valid() and self.column <= #self.str and 
          (self.str[self.column] == " " or self.str[self.column] == "*") ) 
  do
    if ( self.str[self.column] == "*" ) then
      self:next_line()
    else
      self.column = self.column + 1
      if ( self.column > #self.str ) then
        self:next_line()
      end
    end
  end
  return self:valid()
end

-- Gets a string from the parser, assumes that it is currently pointing to the string's starting quotes
function CAOS.Machine.Parser.get_string(self)
  local startpos = self.column + 1
  local endpos = string.find(self.str, "\"", startpos, true)
  if ( endpos == nil ) then
    self:error("String missing closing quotes.")
  end
  
  --self.column = endpos[2]
  self.column = endpos+1
  --endpos = endpos[1]
  return string.sub(self.str, startpos, endpos-1)
end

-- Gets an array of values from the parser, assumes that it is currently pointing to an open bracket
function CAOS.Machine.Parser.get_byte_string(self)
  local startpos = self.column + 1
  local endpos = string.find(self.str, "]", startpos, true)
  if ( endpos == nil ) then
    self:error("Byte-string missing closing square bracket.")
  end
  
  --self.column = endpos[2]
  self.column = endpos+1
  --endpos = endpos[1]
  local subs = string.sub(self.str, startpos, endpos-1)
  local result = {}
  -- we use non-space here for better error checking
  for wval in string.gmatch(subs, "[^%s]+") do
    local val = tonumber(wval)
    if ( type(val) ~= "number" or val ~= math.floor(val) ) then
      self:error("Byte-string contains non-integral value.")
    end
    table.insert(result, val)
  end
  return result
end

-- Retrieves the next command string from the parser, and advances the cursor if one is found
function CAOS.Machine.Parser.get_command(self, expected_type)
  expected_type = expected_type or "command"
  
  -- initialize some string positions to jump to
  local start1 = self.column
  
  local end1 = string.find(self.str, " ", start1, true)
  --end1 = end1 and end1[1] or #self.str
  end1 = end1 or #self.str + 1
  
  local end2 = string.find(self.str, " ", end1+1, true)
  --end2 = end2 and end2[1] or #self.str
  end2 = end2 or #self.str + 1
  
  -- find the command
  local cmdstr = string.upper( string.sub(self.str, start1, end2-1) )
  if ( CAOS.commands[cmdstr] == nil ) then
    cmdstr = string.upper( string.sub(self.str, start1, end1-1) )
    if ( CAOS.commands[cmdstr] == nil ) then
      self:error("Unrecognized command \"" .. cmdstr .. "\".")
    end
  end
  
  -- Retrieve the command and perform type check
  local cmd = CAOS.get_command(cmdstr, expected_type)
  if ( cmd == nil and (expected_type == "decimal" or expected_type == "float") ) then
    cmd = CAOS.get_command(cmdstr, "integer")
    if ( cmd == nil ) then
      cmd = CAOS.get_command(cmdstr, "float")
    end
  end
  
  if ( cmd == nil and expected_type ~= "command" ) then
    cmd = CAOS.get_command(cmdstr, "variable")
  end
    
  if ( cmd == nil ) then
    self:error("The command \"" .. cmdstr .. "\" does not support the expected type \"" .. expected_type .. "\".")
  end
  
  self.column = self.column + #cmdstr
  return cmd
end

function CAOS.Machine.Parser.next(self, expected_type)
  self:skip_whitespace()
  if ( not self:valid() ) then
    return nil
  end
  
  if ( self.str[self.column] == "\"" ) then
    if ( expected_type ~= nil and expected_type ~= "string" ) then
      self:error("Type mismatch. Expected " .. expected_type .. "; Got string.")
    end
    return self:get_string()
  elseif ( self.str[self.column] == "[" ) then
    if ( expected_type ~= nil and expected_type ~= "byte-string" ) then
      self:error("Type mismatch. Expected " .. expected_type .. "; Got byte-string.")
    end
    return self:get_byte_string()
  else
    -- check if there is a numeric value
    local endmatch = string.find(self.str, " ", self.column, true)
    --endmatch = endmatch and endmatch[1] or #self.str
    endmatch = endmatch or #self.str + 1
    
    local snippet = string.sub(self.str, self.column, endmatch-1)
    local num = tonumber(snippet)
    if ( num ~= nil ) then
      if ( expected_type ~= nil and expected_type ~= "float" and expected_type ~= "integer" and expected_type ~= "decimal" ) then
        self:error("Type mismatch. Expected " .. expected_type .. "; Got " .. (num == math.floor(num) and "integer" or "float") .. ".")
      elseif ( expected_type == "integer" and num ~= math.floor(num) ) then
        self:error("Type mismatch. Expected " .. expected_type .. "; Got float.")
      end
      self.column = endmatch
      return num
    else -- assume that it must be a command
      return self:get_command(expected_type)
    end
  end
end

-- Thing for debugging
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

-- Parses a full source and adds it to the scriptorium
function CAOS.Machine.parse_full_source(self, raw_source)
  local parser = CAOS.Machine.Parser.create(raw_source)
  local current_cmd = nil
  
  while ( parser:valid() ) do
    local next_value = nil
    if ( #parser.call_stack == 0 ) then
      next_value = parser:next("command")
      print(tostring(next_value))
    else
      current_cmd = parser.call_stack[#parser.call_stack]
      next_value = parser:next( current_cmd.cmd.params[current_cmd.argno][2] )
      print(tostring(next_value))
      current_cmd.argno = current_cmd.argno + 1
    end
    table.insert(parser.var_stack, next_value)
    if ( type(next_value) == "table" and next_value.params ) then
      table.insert(parser.call_stack, { cmd = next_value, argno = 1 })
    end
    
    -- Retrieve the most recent command from the call stack and check if all of its arguments have been provided
    while ( #parser.call_stack > 0 and parser.call_stack[#parser.call_stack].argno > #parser.call_stack[#parser.call_stack].cmd.params ) do
      current_cmd = parser.call_stack[#parser.call_stack]
      local cmd = current_cmd.cmd
      
      -- Retrieve the arguments from the stack
      local cmd_args = {}
      for i = #cmd.params, 1, -1 do
        param = cmd.params[i]
        cmd_args[param[1]] = parser.var_stack[#parser.var_stack]
        table.remove(parser.var_stack)
      end
      
      -- scriptorium registration
      if ( cmd.command == "ISCR" ) then       -- install script
        CAOS.script_install = { line = parser.line, column = parser.column }
      elseif ( cmd.command == "RSCR" ) then   -- removal script
        CAOS.script_remove = { line = parser.line, column = parser.column }
      elseif ( cmd.command == "SCRP" ) then   -- general script
        CAOS.add_to_scriptorium(cmd_args.family, cmd_args.genus, cmd_args.species, cmd_args.event, parser.line, parser.column)
      elseif ( cmd.command == "SUBR" ) then   -- subroutine
        CAOS.add_subroutine(cmd_args.label, parser.line, parser.column)
      end
      
      -- command call (if not just parsing)
      -- TODO
      -- At this point, the command is executed and replaced with the result on the var_stack
      -- table.remove(parser.var_stack)
      -- table.insert(parser.var_stack, make the call )
      --world.logInfo("[CAOS] made virtual call: " .. cmd.command .. " " .. table.tostring(cmd_args))
      
      table.remove(parser.call_stack)    -- remove the command from the call stack as we do not require the call
      
    end
  end
  
end

-- Executes a piece of source code
function CAOS.Machine.execute_source(self, source)
end

function CAOS.Machine.update(self)
  self.clock_begin = os.clock()
  
  
  
  
  
  -- reset all script-local variables
  --for i = 0, 99 do
  --  self.caos_vars[string.format("VA%02d", i)] = { value = 0 }
  --end
  
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
