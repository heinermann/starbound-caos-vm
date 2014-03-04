CAOS.Parser = {}
CAOS.Parser.__index = CAOS.Parser

function CAOS.Parser.create(parent_vm)
  local o = {}
  setmetatable(o, CAOS.Parser)
  
  o.vm = parent_vm
  
  o.invalid = false
  if ( parent_vm.script_file == nil or #parent_vm.script_file == 0 ) then
    o.invalid = true
  end
  
  o.source = parent_vm.script_file
  o.line = 1
  o.column = 1
  o.str = (#o.source > 0) and o.source[o.line] or ""
  
  o.var_stack = {}
  o.call_stack = {}
  
  o.instant_execution = false
  o.no_interrupt = false
  o.wait_time = 0
  o.stopped = true
  o.paused = false
  o.leave = false
  
  o.ignore_exec = false
  o.executed_if_chain = false
  
  o.loop_max = 0
  o.loop_count = 0
  o.loop_line = 0
  o.loop_column = 0
  
  o.is_install = false
  
  return o
end


-- Parses a full source and adds it to the scriptorium
function CAOS.Parser.init(self)
  local current_cmd = nil
  local expected_type = nil
  
  while ( self:valid() ) do
    local next_value = nil
    local condition_depth = 0
    
    -- treat the next identifier as a command if the call stack is not expecting any values
    if ( #self.call_stack == 0 ) then
      next_value = self:next("command")
    else
      -- Obtain the next expected argument
      current_cmd = self.call_stack[#self.call_stack]
      if ( #current_cmd.cmd.params >= current_cmd.argno ) then
        expected_type = current_cmd.cmd.params[current_cmd.argno][2]
      else
        expected_type = current_cmd.cmd.params[#current_cmd.cmd.params][2]
      end
      next_value = self:next( expected_type )

      current_cmd.argno = current_cmd.argno + 1
    end
    
    -- Add our values/commands to the stack
    table.insert(self.var_stack, next_value)
    if ( type(next_value) == "table" and next_value.params ) then
      table.insert(self.call_stack, { cmd = next_value, argno = 1 })
    end
    
    
    -- Retrieve the most recent command from the call stack and check if all of its arguments have been provided
    while ( #self.call_stack > 0 and self.call_stack[#self.call_stack].argno > #self.call_stack[#self.call_stack].cmd.params ) do

      current_cmd = self.call_stack[#self.call_stack]
      local cmd = current_cmd.cmd
      

      -- Parse conditionals
      if ( #self.call_stack == 1 ) then
        current_cmd = self.call_stack[1]
        local params = current_cmd.cmd.params
        if ( #params > 0 and params[#params][2] == "condition" ) then
          if ( self:parse_conditional() ) then
            break
          end
        end
      end
      
      
      -- Retrieve the arguments from the stack
      local cmd_args = {}
      for i = #cmd.params, 1, -1 do
        param = cmd.params[i]
        cmd_args[param[1]] = self.var_stack[#self.var_stack]
        table.remove(self.var_stack)
      end
      
      -- scriptorium registration
      if ( cmd.command == "ISCR" ) then       -- install script
        CAOS.script_install = { line = self.line, column = self.column }
      elseif ( cmd.command == "RSCR" ) then   -- removal script
        CAOS.script_remove = { line = self.line, column = self.column }
      elseif ( cmd.command == "SCRP" ) then   -- general script
        CAOS.add_to_scriptorium(cmd_args.family, cmd_args.genus, cmd_args.species, cmd_args.event, self.line, self.column)
      elseif ( cmd.command == "SUBR" ) then   -- subroutine
        CAOS.add_subroutine(cmd_args.label, self.line, self.column)
      end
      
      -- command call (if not just parsing)
      -- TODO
      -- At this point, the command is executed and replaced with the result on the var_stack
      -- table.remove(parser.var_stack)
      -- table.insert(parser.var_stack, make the call )
      --world.logInfo("[CAOS] made virtual call: " .. cmd.command .. " " .. table.tostring(cmd_args))
      
      table.remove(self.call_stack)    -- remove the command from the call stack since it has been processed
      
    end
  end
  
end

function CAOS.Parser.update(self)
  if ( self.paused or self.stopped ) then
    return
  end
  
  -- WAIT command, waits for number of ticks
  if ( self.wait_time > 0 ) then
    self.wait_time = self.wait_time - 1
    return
  end
  
  self:continue_script()
  
end

function CAOS.Parser.stop(self)
  self.stopped = true
  self.invalid = true
  self.instant_execution = false
  self.no_interrupt = false
  self.ignore_exec = false
  self.executed_if_chain = false
  
  if ( self.is_install ) then
    self.vm.owner:kill() -- TODO: separate install script
  end
end

function CAOS.Parser.continue_script(self)
  if ( not self:valid() ) then
    return
  end
  
  local current_cmd = nil
  local expected_type = nil
  local throttle = os.time()*1000
  
  --while ( (os.time()*1000 < throttle + 500) or self.instant_execution ) do
  while ( self:valid() ) do
    local next_value = nil
    local condition_depth = 0
    
    -- treat the next identifier as a command if the call stack is not expecting any values
    if ( #self.call_stack == 0 ) then
      next_value = self:next("command")
    else
      -- Obtain the next expected argument
      current_cmd = self.call_stack[#self.call_stack]
      if ( #current_cmd.cmd.params >= current_cmd.argno ) then
        expected_type = current_cmd.cmd.params[current_cmd.argno][2]
      else
        expected_type = current_cmd.cmd.params[#current_cmd.cmd.params][2]
      end
      next_value = self:next( expected_type )

      current_cmd.argno = current_cmd.argno + 1
    end
    
    -- Add our values/commands to the stack
    table.insert(self.var_stack, next_value)
    if ( type(next_value) == "table" and next_value.params ) then
      table.insert(self.call_stack, { cmd = next_value, argno = 1 })
    end
    
    
    -- Retrieve the most recent command from the call stack and check if all of its arguments have been provided
    while ( #self.call_stack > 0 and self.call_stack[#self.call_stack].argno > #self.call_stack[#self.call_stack].cmd.params ) do

      current_cmd = self.call_stack[#self.call_stack]
      local cmd = current_cmd.cmd
      

      -- Parse conditionals
      if ( #self.call_stack == 1 ) then
        current_cmd = self.call_stack[1]
        
        -- special case: conditionals' behaviour
        if ( (current_cmd.cmd.command == "ELIF" or current_cmd.cmd.command == "ELSE") and self.ignore_exec == true and self.executed_if_chain == false ) then
          self.ignore_exec = false
        elseif ( current_cmd.cmd.command == "ENDI" ) then
          self.ignore_exec = false
        end
        
        -- Parse conditional operator
        local params = current_cmd.cmd.params
        if ( #params > 0 and params[#params][2] == "condition" ) then
          if ( self:parse_conditional() ) then
            break
          end
        end
      end
      
      -- Retrieve the arguments from the stack
      local cmd_args = {}
      for i = #cmd.params, 1, -1 do
        param = cmd.params[i]
        local sval = self.var_stack[#self.var_stack]
        if ( type(sval) == "table" and sval.type == "variable" and param[2] ~= "variable" ) then
          --param[2] type checking TODO
          sval = sval:get()
        end
        table.insert(cmd_args, sval)
        table.remove(self.var_stack)
      end
      table.insert(cmd_args, self)
      
      
      if ( self.ignore_exec ~= true ) then
        
        -- Change argument stack to correct format
        local args_for_passing = table.reverse(cmd_args)
        table.remove(self.var_stack)
        
        -- Debug
        dbg_args = ""
        for i = 2, #args_for_passing do
          dbg_args = dbg_args .. " " .. tostring(args_for_passing[i])
        end
        self:log(cmd.command .. "(" .. cmd.rtype .. ")" .. dbg_args)
        
        -- Call the function
        local call_result = cmd.callback(unpack(args_for_passing, 1))
        if ( cmd.rtype ~= "command" ) then
          table.insert(self.var_stack, call_result)
        end
        
      end
      
      table.remove(self.call_stack)    -- remove the command from the call stack since it has been processed
      
    end
    
    if ( self.leave ) then
      self.leave = false
      break
    end
  end
  
end

function CAOS.Parser.move_cursor(self, line, column)
  self.line = line
  self.column = column
end

function CAOS.Parser.set_cursor(self, line, column)
  world.logInfo("Set the cursor: " .. line .. ":" .. column)
  
  self:move_cursor(line, column)
  self.stopped = false
  self.invalid = false
  
  self.str = (#self.source > 0) and self.source[self.line] or ""
  
  self.var_stack = {}
  self.call_stack = {}
  self.is_install = false
end

function CAOS.Parser.run_install_script(self)
  if ( self.no_interrupt ) then
    return
  end

  self:log("RUNNING INSTALL SCRIPT")
  self:set_cursor(CAOS.script_install.line, CAOS.script_install.column)
  self.is_install = true
end

function CAOS.Parser.run_remove_script(self)
  if ( self.no_interrupt ) then
    return
  end
  
  self:log("RUNNING REMOVE SCRIPT")
  self:set_cursor(CAOS.script_remove.line, CAOS.script_remove.column)
end

function CAOS.Parser.call_subroutine(self)
  self:log("call sub not implemented")
end

function CAOS.Parser.run_script(self, family, genus, species, event)
  if ( self.no_interrupt and not self.stopped and not self.invalid ) then
    world.logInfo("WHOOPS NO INTERRUPT!")
    return
  end
  
  if ( not self.stopped and not self.invalid ) then
    world.logInfo("denied")
    return
  end
  
  local src = nil

  if ( CAOS.script_exists(family, genus, species, event) ) then
    src = CAOS.scriptorium[family][genus][species][event].source
  elseif ( CAOS.script_exists(family, genus, 0, event) ) then
    src = CAOS.scriptorium[family][genus][0][event].source
  elseif ( CAOS.script_exists(family, 0, 0, event) ) then
    src = CAOS.scriptorium[family][0][0][event].source
  end
  
  if ( src ~= nil ) then
    self:set_cursor(src.line, src.column)
    self:log("RUNNING SCRIPT: " .. family .. " " .. genus .. " " .. species .. " " .. event)
  else
    self:log("EVENT NOT FOUND IN SCRIPTORIUM " .. family .. " " .. genus .. " " .. species .. " " .. event)
    --CAOS.debug_scriptorium()
  end
end



-- Raises an error indicating the line it occurred on
function CAOS.Parser.error(self, text)
  error("[CAOS:" .. self.line .. ":" .. self.column .. "] " .. text)
end

function CAOS.Parser.log(self, text)
  world.logInfo("[CAOS " .. self.vm.owner.id .. " " .. self.vm.target.id .. "] " .. text )
end

-- checks if the stream is valid
function CAOS.Parser.valid(self)
  return not self.invalid
end

-- Goes to the next line and returns false if it reached the end of the stream
function CAOS.Parser.next_line(self)
  self.column = 1
  
  repeat
    self.line = self.line + 1
    if ( self.line <= #self.source ) then
      self.str = self.source[self.line]
    else
      self.invalid = true
    end
  until ( self.invalid == true or #self.str > 0 )

  return self:valid()
end

-- Skip all whitespace (including new lines) and returns false if the end of the stream has been reached
-- Also skips comments
function CAOS.Parser.skip_whitespace(self)
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
function CAOS.Parser.get_string(self, expected_type)
  if ( expected_type ~= nil and expected_type ~= "string" and expected_type ~= "conditional" and expected_type ~= "any" ) then
    self:error("Type mismatch. Expected " .. expected_type .. "; Got string.")
  end
  
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
function CAOS.Parser.get_byte_string(self, expected_type)
  if ( expected_type ~= nil and expected_type ~= "byte-string" ) then
    self:error("Type mismatch. Expected " .. expected_type .. "; Got byte-string.")
  end
  
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
function CAOS.Parser.get_command(self, expected_type)
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
  
  if ( cmd == nil and (expected_type == "condition" or expected_type == "any") ) then
    cmd = cmd or CAOS.get_command(cmdstr, "integer")
    cmd = cmd or CAOS.get_command(cmdstr, "float")
    cmd = cmd or CAOS.get_command(cmdstr, "variable")
    cmd = cmd or CAOS.get_command(cmdstr, "decimal")
    cmd = cmd or CAOS.get_command(cmdstr, "agent")
    cmd = cmd or CAOS.get_command(cmdstr, "string")
  end
    
  if ( cmd == nil ) then
    self:error("The command \"" .. cmdstr .. "\" does not support the expected type \"" .. expected_type .. "\".")
  end
  
  self.column = self.column + #cmdstr
  return cmd
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
--          and - conjunction
--          or - conjunction
function CAOS.Parser.parse_conditional(self)
  self:skip_whitespace()
  if ( not self:valid() ) then
    return false
  end
  
  local stacktop = nil
  local cmd = nil
  
  -- initialize some string positions to jump to
  local start1 = self.column
  
  local end1 = string.find(self.str, " ", start1, true)
  --end1 = end1 and end1[1] or #self.str
  end1 = end1 or #self.str + 1
  
  -- get the next string
  local str = string.lower( string.sub(self.str, start1, end1-1) )
  if ( str == "eq" or str == "=" ) then
    str = "eq"
  elseif ( str == "ne" or str == "<>" ) then
    str = "ne"
  elseif ( str == "gt" or str == ">" ) then
    str = "gt"
  elseif ( str == "lt" or str == "<" ) then
    str = "lt"
  elseif ( str == "ge" or str == ">=" ) then
    str = "ge"
  elseif ( str == "le" or str == "<=" ) then
    str = "le"

  --elseif ( str == "bt" ) then
  --elseif ( str == "bf" ) then
  elseif ( str == "and" ) then
  elseif ( str == "or" ) then
  else
    return false
  end
  -- This should not fail
  cmd = CAOS.get_command("____internal_" .. str, "condition")
  
  -- re-order the table to make use of hacky functions
  stacktop = self.var_stack[#self.var_stack]
  table.remove(self.var_stack)
  table.insert(self.var_stack, cmd)
  table.insert(self.call_stack, { ["cmd"] = cmd, argno = 2 })
  table.insert(self.var_stack, stacktop)
  
  self.column = end1
  return true
end

function CAOS.Parser.next(self, expected_type)
  self:skip_whitespace()
  if ( not self:valid() ) then
    return nil
  end
  
  if ( self.str[self.column] == "\"" ) then
    return self:get_string(expected_type)
  elseif ( self.str[self.column] == "[" ) then
    return self:get_byte_string(expected_type)
  else
    -- check if there is a numeric value
    local endmatch = string.find(self.str, " ", self.column, true)
    --endmatch = endmatch and endmatch[1] or #self.str
    endmatch = endmatch or #self.str + 1
    
    local snippet = string.sub(self.str, self.column, endmatch-1)
    
    -- numeric type testing
    local num = tonumber(snippet)
    if ( num ~= nil ) then      
      -- Type checking
      if ( expected_type ~= "any" ) then
        if ( expected_type ~= nil and expected_type ~= "float" and expected_type ~= "integer" and expected_type ~= "decimal" ) then
          self:error("Type mismatch. Expected " .. expected_type .. "; Got " .. (num == math.floor(num) and "integer" or "float") .. ".")
        elseif ( expected_type == "integer" and num ~= math.floor(num) ) then
          self:error("Type mismatch. Expected " .. expected_type .. "; Got float.")
        end
      end
      
      self.column = endmatch
      return num
    else -- assume that it must be a command
      return self:get_command(expected_type)
    end
  end
end

