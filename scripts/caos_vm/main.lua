-- CAOS scripting emulator
-- SOURCE: http://creaturesdev.webs.com/caoscategoricalds.htm
-- SOURCE: http://creatures.wikia.com/wiki/Cellular_Automata
-- SOURCE: http://www.gamewaredevelopment.com/downloads/cdn/C2CAOSGuide.pdf

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
  
  -- scriptorium entry:
  -- [family][genus][species][event] =
  -- {
  --   source = ""
  --   subs[name] = ""
  -- }
  o.scriptorium = {}
  o.script_install = { source = "" }
  o.script_remove = { source = "" }
  o.caos_vars = {}
  
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
  local agent_vars = {}
  for i = 0, 99 do
    o.caos_vars[i] = { value = 0 }
    agent_vars[i] = { value = 0 }
  end
  CAOS.setVar(agent, "caos_vars", agent_vars)
  
  
  
  return o
end

function CAOS.getVar(agent, name)
  return world.callScriptedEntity(agent.id(), name)
end

function CAOS.setVar(agent, name, value)
  return world.callScriptedEntity(agent.id(), name, value)
end

function CAOS.Machine.add_to_scriptorium(self, family, genus, species, event, source)
  if ( self.scriptorium[family] == nil ) then
    self.scriptorium[family] = {}
  end
  if ( self.scriptorium[family][genus] == nil ) then
    self.scriptorium[family][genus] = {}
  end
  if ( self.scriptorium[family][genus][species] == nil ) then
    self.scriptorium[family][genus][species] = {}
  end
  if ( self.scriptorium[family][genus][species][event] == nil ) then
    self.scriptorium[family][genus][species][event] = {}
  end

  self.scriptorium[family][genus][species][event]["source"] = source
  self.scriptorium[family][genus][species][event]["subs"] = {}
end

function CAOS.Machine.script_exists(self, family, genus, species, event)
  local exists = true
  if ( exists and family ~= nil ) then
    exists = exists and self.scriptorium[family] ~= nil
  end
  
  if ( exists and genus ~= nil ) then
    exists = exists and self.scriptorium[family][genus] ~= nil
  end
  
  if ( exists and species ~= nil ) then
    exists = exists and self.scriptorium[family][genus][species] ~= nil
  end

  if ( exists and event ~= nil ) then
    exists = exists and self.scriptorium[family][genus][species][event] ~= nil
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

-- NOTE: conditional relations:
--          eq - equal
--          ne - not equal
--          gt - greater than
--          lt - less than
--          ge - greater or equal
--          le - less or equal
--          bt - bit test (AND)
--          bf - bit fail (NAND)

-- Parses a full source and adds it to the scriptorium
function CAOS.Machine.parse_full_source(self, raw_source)
  --local current_src = ""
  --for i, line in ipairs(raw_source) do
  --  for w in string.gmatch(raw_source, "(%g+)")
  --  end
  --end
  
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
