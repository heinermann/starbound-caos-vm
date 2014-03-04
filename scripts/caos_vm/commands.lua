
-- Types:
--  command
--  integer
--  byte-string
--  string
--  agent (returned from command)
--  float
--  variable (returned from command)
--  decimal
--  condition
--  any (internal only)

CAOS.commands = {
  ["ABBA"] = {
    ["command"] = {
      command = "ABBA",
      rtype = "integer",
      params = {},
      description = [[
        Returns the absolute base for the current agent/part.  Returns -1 if an invalid part.  The absolute base 
        is the value passed into @NEW: SIMP@ and so on, it is different from the @BASE@.
      ]],
      callback =
        function(self)
          return self.vm.owner:getVar("caos_first_image") or 0
        end
    }
  },


  ["ALPH"] = {
    ["command"] = {
      command = "ALPH",
      rtype = "command",
      params = {
        { "alpha_value", "integer" },  { "yesOrNo", "integer" } },
      description = [[
        The agent will be drawn alpha blended against the background by the given value - from 256 for invisible 
        to 0 for completely solid.  For compound agents set the @PART@ to affect a particular part or to -
        1 to affect all parts.  The second parameter switches alpha blending on (1) or off (0).  Alpha graphics 
        are drawn much slower, so use sparingly and turn it off completely rather than using an intensity value 
        of 0 or 256.  At the moment alpha channels only work on compressed, non-mirrored, non-zoomed sprites.
        
      ]],
      callback =
        function(self, alpha_value, yesOrNo)
        end
    }
  },


  ["ANIM"] = {
    ["command"] = {
      command = "ANIM",
      rtype = "command",
      params = {
        { "pose_list", "byte-string" } },
      description = [[
        Specify a list of @POSE@s such as [1 2 3] to animate the current agent/part.  Put 
        255 at the end to continually loop.  The first number after the 255 is an index into the 
        animation string where the looping restarts from - this defaults to 0 if not specified.  e.g. [0 1 
        2 10 11 12 255 3] would loop just the 10, 11, 12 section.
      ]],
      callback =
        function(self, pose_list)
        end
    }
  },


  ["ANMS"] = {
    ["command"] = {
      command = "ANMS",
      rtype = "command",
      params = {
        { "anim_string", "string" } },
      description = [[
        This is like @ANIM@, only it reads the poses from a string such as "3 4 5 255".  
        Use this when you need to dynamically construct animations.  Use ANIM in general as it is quicker to 
        execute, although they are the same speed once the animation is underway.
      ]],
      callback =
        function(self, anim_string)
        end
    }
  },

  -- partial
  ["ATTR"] = {
    ["command"] = {
      command = "ATTR",
      rtype = "command",
      params = {
        { "attributes", "integer" } },
      description = "Set attributes of target.  Sum the values in the @Attribute Flags@ table to get the attribute value to pass into this command.",
      callback =
        function(self, attributes)
          self.vm.target:setVar("caos_attributes", attributes)
          
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.CARRYABLE) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.MOUSEABLE) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.ACTIVATEABLE) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.GREEDY_CABIN) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.INVISIBLE) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.FLOATABLE) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.SUFFER_COLLISIONS) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.SUFFER_PHYSICS) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.CAMERA_SHY) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.OPEN_AIR_CABIN) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.ROTATABLE) ~= 0 ) then
          end
          if ( bit32.band(attributes, CAOS.ATTRIBUTES.PRESENCE) ~= 0 ) then
          end
          
        end
    },

    ["integer"] = {
      command = "ATTR",
      rtype = "integer",
      params = {},
      description = "Return attributes of target.",
      callback =
        function(self)
          return self.vm.target:getVar("caos_attributes") or 0
        end
    }
  },

  -- partial/none
  ["BASE"] = {
    ["command"] = {
      command = "BASE",
      rtype = "command",
      params = {
        { "index", "integer" } },
      description = [[
        Set the base image for this agent or part.  The index is relative to the first_image specified in 
        the NEW: command.  Future @POSE@/@ANIM@ commands and any @ANIM@ in progress are relative to this new base.
      ]],
      callback =
        function(self, index)
          self.vm.owner:setVar("caos_image_base", index)
        end
    },

    ["integer"] = {
      command = "BASE",
      rtype = "integer",
      params = {},
      description = [[
        Returns the @BASE@ image for the current agent/part.  Returns -1 if an invalid part.
      ]],
      callback =
        function(self)
          return self.vm.owner:getVar("caos_image_base") or 0
        end
    }
  },

  -- partial/none
  ["BHVR"] = {
    ["command"] = {
      command = "BHVR",
      rtype = "command",
      params = {
        { "permissions", "integer" } },
      description = [[
        Sets the creature permissions for target.  Sum the entries in the @Creature Permissions@ table to get the value 
        to use.
      ]],
      callback =
        function(self, permissions)
          self.vm.target:setVar("caos_permissions", permissions)
        end
    },

    ["integer"] = {
      command = "BHVR",
      rtype = "integer",
      params = {},
      description = [[
        Returns the creature permissions for the target agent.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_permissions") or 0
        end
    }
  },


  ["CALL"] = {
    ["command"] = {
      command = "CALL",
    rtype = "command",
    params = {
      { "event_no", "integer" },  { "param_1", "anything" },  { "param_2", "anything" } },
    description = [[
      Calls a subroutine script on the owner with the specified event number.  When that script finishes the current 
      script is resumed.  No variables are shared between the two scripts so any return values must go through 
      OVs.  The called script starts in the same INST state as the calling script, however, it may use 
      SLOW or INST to override this initial state.  In addition, when the script returns to the calling script, 
      the INST state is reset to what it was before the CALL command, so CALL preserves INSTness in 
      the calling script.  So if the caller script is in an INST then the called script will inherit 
      that, any change in the called script to cancel this (such as OVER, WAIT, SLOW etc) will only 
      affect the called script... when execution returns to the caller script it will still be in whatever state 
      it was in before.
    ]],
    callback =
      function(self, event_no, param_1, param_2)
      end
    }
  },

  -- partial/none
  ["CARR"] = {
    ["agent"] = {
      command = "CARR",
      rtype = "agent",
      params = {},
      description = [[
        Returns the the agent currently holding the target, or @NULL@ if there is none.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_carried_by")
        end
    }
  },


  ["CATA"] = {
    ["integer"] = {
      command = "CATA",
    rtype = "integer",
    params = {},
    description = [[
      Returns the target's category.  This either depends on its classifier as described in @CATI@, or is its 
      own individual override set with @CATO@.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["CATI"] = {
    ["integer"] = {
      command = "CATI",
      rtype = "integer",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Return the category id for the given classifier.  The catalogue tag "Agent Classifiers" specifies these, and you can 
        have more than 40.  They are tested in order until the first match is found.  -1 is always 
        returned if none match.  Agents can override their classifier category with @CATO@.
      ]],
      callback =
        function(self, family, genus, species)
          return 0
        end
    }
  },


  ["CATO"] = {
    ["command"] = {
      command = "CATO",
      rtype = "command",
      params = {
        { "category", "integer" } },
      description = [[
        Change the target's category to the one specified.  The default is -1 which means the category is 
        based on classifier and the catalogue as described in @CATI@.  See also @CATX@ and @CATA@.
      ]],
      callback =
        function(self, category)
        end
    }
  },


  ["CATX"] = {
    ["string"] = {
      command = "CATX",
      rtype = "string",
      params = {
        { "category_id", "integer" } },
      description = [[
        Returns the name of the given category.  For example, "toy" or "bad bug".  The catalogue tag "Agent Categories" 
        stores these.  If the id is out of range, CATX returns an empty string.
      ]],
      callback =
        function(self, category_id)
          return ""
        end
    }
  },

  -- partial/none
  ["CORE"] = {
    ["command"] = {
      command = "CORE",
    rtype = "command",
    params = {
      { "topY", "float" },  { "bottomY", "float" },  { "leftX", "float" },  { "rightX", "float" } },
    description = [[
      Sets the bounding box of the physical core of the object TARG.  May be set to smaller (or 
      larger) than the sprite's rectangle.
    ]],
    callback =
      function(self, topY, bottomY, leftX, rightX)
        self.vm.target:setVar("caos_bounds", { left = leftx,
                                                  top = topy,
                                                  right = rightx,
                                                  bottom = bottomy
                                                })
      end
    }
  },

  -- partial/none
  ["DCOR"] = {
    ["command"] = {
      command = "DCOR",
      rtype = "command",
      params = {
        { "core_on", "integer" } },
      description = [[
        Debug command to show the physical core of the TARG agent graphically.
      ]],
      callback =
        function(self, core_on)
          self.vm.target:setVar("caos_debug_core", core_on)
        end
    }
  },

  -- full
  ["DISQ"] = {
    ["float"] = {
      command = "DISQ",
      rtype = "float",
      params = {
        { "other", "agent" } },
      description = [[
        Returns the square of the distance between the centre points of the target agent, and the other agent.  
        It is quicker to compare this square against a squared constant directly, or if you need the actual 
        distance use @SQRT@.
      ]],
      callback =
        function(self, other)
          local dist = world.distance(self.vm.target:position(), other:position())
          return dist * dist
        end
    }
  },


  ["DROP"] = {
    ["command"] = {
      command = "DROP",
      rtype = "command",
      params = {},
      description = [[
        Force the @TARG@ to drop what it is carrying.  this will try to find a safe place for 
        the agent to fall.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["DSEE"] = {
    ["command"] = {
      command = "DSEE",
      rtype = "command",
      params = {
        { "can_see_on", "integer" } },
      description = [[
        Debug command to show all the agents which can be seen by any creature.
      ]],
      callback =
        function(self, can_see_on)
        end
    }
  },


  ["ENUM"] = {
    ["command"] = {
      command = "ENUM",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Iterate through each agent which conforms to the given classification, setting @TARG@ to point to each valid agent 
        in turn. family, genus and/or species can be zero to act as wildcards.  @NEXT@ terminates the block 
        of code which is executed with each TARG.  After an ENUM, TARG is set to @OWNR@.
      ]],
      callback =
        function(self, family, genus, species)
        end
    }
  },


  ["ESEE"] = {
    ["command"] = {
      command = "ESEE",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        As @ENUM@, except only enumerates through agents which @OWNR@ can see.  An agent can see another if it 
        is within @RNGE@, its @PERM@ allows it to see through all intervening walls, and for creatures @ATTR@ @Invisible@ 
        isn't set.  See also @STAR@ and @SEEE@.  In install scripts, when there is no @OWNR@, @TARG@ is 
        used instead.
      ]],
      callback =
        function(self, family, genus, species)
        end
    }
  },


  ["ETCH"] = {
    ["command"] = {
      command = "ETCH",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        As @ENUM@, except only enumerates through agents which @OWNR@ is touching.  Agents are said to be touching if 
        their bounding rectangles overlap.  See also @TTAR@.  In install scripts, when there is no @OWNR@, @TARG@ is used 
        instead.
      ]],
      callback =
        function(self, family, genus, species)
        end
    }
  },


  ["FLTX"] = {
    ["float"] = {
      command = "FLTX",
      rtype = "float",
      params = {},
      description = [[
        This returns the X position of the @TARG@ object's floating vector.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["FLTY"] = {
    ["float"] = {
      command = "FLTY",
      rtype = "float",
      params = {},
      description = [[
        This returns the Y position of the @TARG@ object's floating vector.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },

  -- full
  ["FMLY"] = {
    ["integer"] = {
      command = "FMLY",
      rtype = "integer",
      params = {},
      description = [[
        Returns family of target.  See also @GNUS@, @SPCS@.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_family") or 0
        end
    }
  },


  ["FRAT"] = {
    ["command"] = {
      command = "FRAT",
      rtype = "command",
      params = {
        { "FrameRate", "integer" } },
      description = [[
        This command sets the frame rate on the @TARG@ agent. If it is a compound agent, then the 
        part affected can be set with the @PART@ command. Valid rates are from 1 to 255. 1 is 
        Normal rate, 2 is half speed etc...
      ]],
      callback =
        function(self, FrameRate)
        end
    }
  },

  -- partial/none (verify)
  ["FROM"] = {
    ["variable"] = {
      command = "FROM",
      rtype = "variable",
      params = {},
      description = [[
        If we're processing a message, this is the @OWNR@ who sent the message.  @NULL@ if the message 
        was sent from an injected script or an install script.  If the message was sent over the network 
        using @NET: WRIT@, then this contains the user id of the sender, as a string.
      ]],
      callback =
        function(self)
          return self.vm.message_from
        end
    }
  },


  ["GAIT"] = {
    ["command"] = {
      command = "GAIT",
      rtype = "command",
      params = {
        { "gait_number", "integer" } },
      description = [[
        Specifies the current gait for a creature. The gaits are genetically defined. It sets the gait of the 
        creature agent stored in @TARG@.
      ]],
      callback =
        function(self, gait_number)
        end
    }
  },


  ["GALL"] = {
    ["command"] = {
      command = "GALL",
      rtype = "command",
      params = {
        { "sprite_file", "string" },  { "first_image", "integer" } },
      description = [[
        Changes the gallery (sprite file) used by an agent.  This works for simple and compound agents (using the 
        current @PART@).  The current @POSE@ is kept the same in both galleries.
      ]],
      callback =
        function(self, sprite_file, first_image)
        end
    },

    ["string"] = {
      command = "GALL",
      rtype = "string",
      params = {},
      description = [[
        Returns the gallery (sprite file) used by an agent.  This works for simple and compound agents (using the 
        current @PART@).
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },

  -- full
  ["GNUS"] = {
    ["integer"] = {
      command = "GNUS",
      rtype = "integer",
      params = {},
      description = [[
        Returns genus of target.  See also @FMLY@, @SPCS@.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_genus") or 0
        end
    }
  },

  -- full
  ["HAND"] = {
    ["command"] = {
      command = "HAND",
      rtype = "command",
      params = {
        { "name_for_the_hand", "string" } },
      description = [[
        Sets the name of the hand. Bt default this is 'hand'.
      ]],
      callback =
        function(self, name_for_the_hand)
          CAOS.name_of_hand = name_for_the_hand
        end
    },

    ["string"] = {
      command = "HAND",
      rtype = "string",
      params = {},
      description = [[
        This returns the name of the hand.
      ]],
      callback =
        function(self)
          return CAOS.name_of_hand or "hand"
        end
    }
  },

  -- partial/none
  ["HELD"] = {
    ["agent"] = {
      command = "HELD",
      rtype = "agent",
      params = {},
      description = [[
        Returns the item currently held by the target.  For vehicles this returns a random carried agent if carrying 
        more than one.  Consider using @EPAS@ instead.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_carrying")
        end
    }
  },

  -- partial/none
  ["HGHT"] = {
    ["integer"] = {
      command = "HGHT",
      rtype = "integer",
      params = {},
      description = [[
        Returns the height of target.
      ]],
      callback =
        function(self)
          local bounds = self.vm.target:getVar(bounds)
          return bounds and math.abs(bounds.bottom - bounds.top) or 0
        end
    }
  },


  ["IITT"] = {
    ["agent"] = {
      command = "IITT",
      rtype = "agent",
      params = {},
      description = [[
        Returns the target creature's current agent of attention.  Compare @_IT_@.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },


  ["IMSK"] = {
    ["integer"] = {
      command = "IMSK",
      rtype = "integer",
      params = {},
      description = [[
        Returns the input event mask.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full/partial
  ["KILL"] = {
    ["command"] = {
      command = "KILL",
      rtype = "command",
      params = {
        { "agent", "agent" } },
      description = [[
        Destroys an agent.  The pointer won't be destroyed.  For creatures, you probably want to use @DEAD@ first.
      ]],
      callback =
        function(self, agent)
          agent:kill()
        end
    }
  },

  -- partial (compatibility)
  ["MESG WRIT"] = {
    ["command"] = {
      command = "MESG WRIT",
      rtype = "command",
      params = {
        { "agent", "agent" },  { "message_id", "integer" } },
      description = [[
        Send a message to another agent.  The message_id is from the table of @Message Numbers@; remember that early @
        Message Numbers@ differ slightly from @Script Numbers@.  If used from an install script, then @FROM@ for the message 
        to @NULL@ rather than @OWNR@.
      ]],
      callback =
        function(self, agent, message_id)
          -- TODO
          --self.owner.sendNotificationTo("CAOS_" .. CAOS.message_to_script(message_id), {_P1_ = 0, _P2_ = 0}, agent)
        end
    }
  },


  ["MESG WRT+"] = {
    ["command"] = {
      command = "MESG WRT+",
      rtype = "command",
      params = {
        { "agent", "agent" },  { "message_id", "integer" },  { "param_1", "anything" },  { "param_2", "anything" },  { "delay", "integer" } },
      description = [[
        Send a message with parameters to another agent.  Waits delay ticks before sending the message.  The message_id is 
        from the table of @Message Numbers@.
      ]],
      callback =
        function(self, agent, message_id, param_1, param_2, delay)
        end
    }
  },

  -- full
  ["MIRA"] = {
    ["command"] = {
      command = "MIRA",
      rtype = "command",
      params = {
        { "on_off", "integer" } },
      description = [[
        Tell the agent to draw the current sprite mirrored (send 1 as a parameter) or normally (send 0 
        as a parameter)
      ]],
      callback =
        function(self, on_off)
          self.vm.owner:setFlipped(on_off)
        end
    },

    ["integer"] = {
      command = "MIRA",
      rtype = "integer",
      params = {},
      description = [[
        Is the current sprite for this agent mirrored (returns 1) or not (returns 0)
      ]],
      callback =
        function(self)
          return self.vm.owner:isFlipped() and 1 or 0
        end
    }
  },

  -- full
  ["MOWS"] = {
    ["integer"] = {
      command = "MOWS",
      rtype = "integer",
      params = {},
      description = [[
        Returns whether the lawn was cut last Sunday or not.
      ]],
      callback =
        function(self)
          return 1
        end
    }
  },


  ["MTHX"] = {
    ["float"] = {
      command = "MTHX",
      rtype = "float",
      params = {},
      description = [[
        This returns the X position of the @TARG@ creature's mouth attachment point in absolute (map) coordinates.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["MTHY"] = {
    ["float"] = {
      command = "MTHY",
      rtype = "float",
      params = {},
      description = [[
        This returns the Y position of the @TARG@ creature's mouth attachment point in absolute (map) coordinates.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["NCLS"] = {
    ["agent"] = {
      command = "NCLS",
      rtype = "agent",
      params = {
        { "previous", "agent" },  { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Finds the next agent in the agent list which also matches the given classifier.  If the previous agent 
        doesn't exist or doesn't match the classifier then the first agent matching it is returned.  If 
        none match the classifier, then @NULL@ is returned.
      ]],
      callback =
        function(self, previous, family, genus, species)
          return nil
        end
    }
  },

  -- unknown/experimental
  ["NEW: SIMP"] = {
    ["command"] = {
      command = "NEW: SIMP",
    rtype = "command",
    params = {
      { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "sprite_file", "string" },  { "image_count", "integer" },  { "first_image", "integer" },  { "plane", "integer" } },
    description = [[
      Create a new simple agent, using the specified sprite file. The agent will have image_count sprites available, starting 
      at first_image in the file. The plane is the screen depth to show the agent at - the higher 
      the number, the nearer the camera.
    ]],
    callback =
      function(self, family, genus, species, sprite_file, image_count, first_image, plane)
        --local agent_name = CAOS.get_cob_name(family,genus,species)
        
        local agent_name = "test_agent"
        
        local agent_params = { caos_family = family,
                                caos_genus = genus,
                                caos_species = species,
                                caos_sprite_file = sprite_file,
                                caos_image_count = image_count,
                                caos_first_image = first_image,
                                caos_plane = plane,
                                first_spawn = false,
                                desired_script_line = 0,
                                desired_script_column = 0,
                                inherited_vars = {
                                  --caos_timer_interval = self.vm.timer_interval:get()    -- nope
                                  
                                }
                             }
        
        self.vm.target = EntityWrap.create(world.spawnMonster(agent_name, self.vm.owner:position(), agent_params))
      end
    }
  },


  ["NEXT"] = {
    ["command"] = {
      command = "NEXT",
    rtype = "command",
    params = {},
    description = [[
      Closes an enumeration loop.  The loop can begin with @ENUM@, @ESEE@, @ETCH@ or @EPAS@.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["NOHH"] = {
    ["command"] = {
      command = "NOHH",
    rtype = "command",
    params = {},
    description = [[
      Tell the creature to immediately stop holding hands with the pointer.  Useful when you are about to teleport 
      a norn, it prevents the pointer from continuosly changing his position back to where it was.
    ]],
    callback =
      function(self)
      end
    }
  },

  -- full
  ["NULL"] = {
    ["agent"] = {
      command = "NULL",
      rtype = "agent",
      params = {},
      description = [[
        Returns a null agent pointer.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },


  ["OVER"] = {
    ["command"] = {
      command = "OVER",
    rtype = "command",
    params = {},
    description = [[
      Wait until the current agent/part's @ANIM@ation is over before continuing.  Looping anims stop this command 
      terminating until the animation is changed to a non-looping one.
    ]],
    callback =
      function(self)
      end
    }
  },

  -- full
  ["OWNR"] = {
    ["agent"] = {
      command = "OWNR",
    rtype = "agent",
    params = {},
    description = [[
      Returns the agent who's virtual machine the script is running on.  Returns @NULL@ for injected or install 
      scripts.
    ]],
    callback =
      function(self)
        return self.vm.owner
      end
    }
  },

  -- partial/none
  ["PAUS"] = {
    ["command"] = {
      command = "PAUS",
      rtype = "command",
      params = {
        { "paused", "integer" } },
      description = [[
        Stops the target agent from running - it'll freeze completely, scripts and physics.  Set to 1 to pause, 
        0 to run.  You might want to use @WPAU@ with this to implement a pause game option.
      ]],
      callback =
        function(self, paused)
          self.vm.target:setVar("caos_paused", paused)
        end
    },

    ["integer"] = {
      command = "PAUS",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if the target agent is paused, or 0 otherwise.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_paused") or 0
        end
    }
  },


  ["PCLS"] = {
    ["agent"] = {
      command = "PCLS",
      rtype = "agent",
      params = {
        { "next", "agent" },  { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Same as @NCLS@, only cycles the other way.
      ]],
      callback =
        function(self, next, family, genus, species)
          return nil
        end
    }
  },

  -- partial
  ["PLNE"] = {
    ["command"] = {
      command = "PLNE",
      rtype = "command",
      params = {
        { "plane", "integer" } },
      description = [[
        Sets the target agent's principal drawing plane.  The higher the value, the nearer the camera.  For compound 
        agents, the principal plane is the one for the automatically made first part.  The plane of other parts 
        is relative to this one.
      ]],
      callback =
        function(self, plane)
          self.vm.target:setVar("caos_plane", plane)
        end
    },

    ["integer"] = {
      command = "PLNE",
      rtype = "integer",
      params = {},
      description = [[
        Returns the screen depth plane of the principal part.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_plane") or 0
        end
    }
  },

  -- N/A
  ["PNTR"] = {
    ["agent"] = {
      command = "PNTR",
      rtype = "agent",
      params = {},
      description = [[
        Returns the mouse pointer, which is also known as the hand.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },

  -- partial
  ["POSB"] = {
    ["float"] = {
      command = "POSB",
    rtype = "float",
    params = {},
    description = [[
      Returns bottom position of target's bounding box.
    ]],
    callback =
      function(self)
        local bounds = self.vm.target:getVar("caos_bounds")
        return bounds.bottom or (self.vm.target:position()[2] + 1.0) or 0.0
      end
    }
  },


  ["POSE"] = {
    ["command"] = {
      command = "POSE",
      rtype = "command",
      params = {
        { "pose", "integer" } },
      description = [[
        Specify a frame in the sprite file for the target agent/part.  Relative to any index specified by @
        BASE@.
      ]],
      callback =
        function(self, pose)
          local base = self.vm.target:getVar("caos_image_base") or 0
          local global_base = self.vm.target:getVar("caos_first_image") or 0
          pose = pose or 0
          
          local frameno = pose + base + global_base
          self.vm.target:setVar("caos_image_pose", frameno)
          self.vm.target:setTag("frameno", frameno)
          
          world.logInfo("Posed: " .. tostring(pose) )
        end
    },

    ["integer"] = {
      command = "POSE",
      rtype = "integer",
      params = {},
      description = [[
        Return the current @POSE@ of the target agent/part, or -1 if invalid part.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_image_pose") or 0
        end
    }
  },

  -- partial
  ["POSL"] = {
    ["float"] = {
      command = "POSL",
    rtype = "float",
    params = {},
    description = [[
      Returns left position of target's bounding box.
    ]],
    callback =
      function(self)
        local bounds = self.vm.target:getVar("caos_bounds")
        return bounds.left or (self.vm.target:position()[1] - 1.0) or 0.0
      end
    }
  },

  -- partial
  ["POSR"] = {
    ["float"] = {
      command = "POSR",
    rtype = "float",
    params = {},
    description = [[
      Returns right position of target's bounding box.
    ]],
    callback =
      function(self)
        local bounds = self.vm.target:getVar("caos_bounds")
        return bounds.right or (self.vm.target:position()[1] + 1.0) or 0.0
      end
    }
  },

  -- partial
  ["POST"] = {
    ["float"] = {
      command = "POST",
    rtype = "float",
    params = {},
    description = [[
      Returns top position of target's bounding box.
    ]],
    callback =
      function(self)
        local bounds = self.vm.target:getVar("caos_bounds")
        return bounds.top or (self.vm.target:position()[2] - 1.0) or 0.0
      end
    }
  },

  -- full
  ["POSX"] = {
    ["float"] = {
      command = "POSX",
      rtype = "float",
      params = {},
      description = [[
        Returns X position of centre of target.
      ]],
      callback =
        function(self)
          return self.vm.target:position()[1] or 0.0
        end
    }
  },

  -- full
  ["POSY"] = {
    ["float"] = {
      command = "POSY",
      rtype = "float",
      params = {},
      description = [[
        Returns Y position of centre of target.
      ]],
      callback =
        function(self)
          return self.vm.target:position()[2] or 0.0
        end
    }
  },


  ["PUHL"] = {
    ["command"] = {
      command = "PUHL",
      rtype = "command",
      params = {
        { "pose", "integer" },  { "x", "integer" },  { "y", "integer" } },
      description = [[
        Set the relative x and y coordinate of the handle that target is picked up by, for the 
        given pose.  This pose is measured from the absolute base specified in the NEW: command, rather than the 
        relative base specified by the @BASE@ command. Pose -1 sets the same point for all poses.
      ]],
      callback =
        function(self, pose, x, y)
        end
    },

    ["integer"] = {
      command = "PUHL",
      rtype = "integer",
      params = {
        { "pose", "integer" },  { "x_or_y", "integer" } },
      description = [[
        Returns the x or y coordinate of the handle that target is picked up by for the given 
        pose.  x_or_y is 1 for x, 2 for y.  The pose is measured from the absolute base specified 
        in the NEW: command, rather than the relative base specified by the @BASE@ command.
      ]],
      callback =
        function(self, pose, x_or_y)
          return 0
        end
    }
  },

  
  ["PUPT"] = {
    ["command"] = {
      command = "PUPT",
      rtype = "command",
      params = {
        { "pose", "integer" },  { "x", "integer" },  { "y", "integer" } },
      description = [[
        Set the relative x and y coordinate of the place where target picks agents up, for the given 
        pose.  This pose is measured from the absolute base specified in the NEW: command, rather than the relative 
        base specified by the @BASE@ command. Pose -1 sets the same point for all poses.  For vehicles use 
        the @CABN@ command.
      ]],
      callback =
        function(self, pose, x, y)
        end
    },

    ["integer"] = {
      command = "PUPT",
      rtype = "integer",
      params = {
        { "pose", "integer" },  { "x_or_y", "integer" } },
      description = [[
        Returns the x or y coordinate of the place where target picks agents up for the given pose.  
        x_or_y is 1 for x, 2 for y.  The pose is measured from the absolute base specified in 
        the NEW: command, rather than the relative base specified by the @BASE@ command.
      ]],
      callback =
        function(self, pose, x_or_y)
          return 0
        end
    }
  },

  -- partial/none
  ["RNGE"] = {
    ["command"] = {
      command = "RNGE",
      rtype = "command",
      params = {
        { "distance", "float" } },
      description = [[
        Sets the distance that the target can see and hear, and the distance used to test for potential 
        collisions.  See also @ESEE@, @OBST@.
      ]],
      callback =
        function(self, distance)
          self.vm.target:setVar("caos_distance_check", distance)
        end
    },

    ["float"] = {
      command = "RNGE",
      rtype = "float",
      params = {},
      description = [[
        Returns the target's range. See @ESEE@, @OBST@.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_distance_check") or 100.0
        end
    }
  },


  ["RTAR"] = {
    ["command"] = {
      command = "RTAR",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Randomly chooses an agent which matches the given classifier, and targets it.
      ]],
      callback =
        function(self, family, genus, species)
        end
    }
  },

  -- partial/full
  ["SEEE"] = {
    ["integer"] = {
      command = "SEEE",
    rtype = "integer",
    params = {
      { "first", "agent" },  { "second", "agent" } },
    description = [[
      Returns 1 if the first agent can see the second, or 0 if it can't.  See @ESEE@.
      
    ]],
    callback =
      function(self, first, second)
        if ( first.entityInSight ~= nil ) then
          return first.entityInSight(second.id()) and 1 or 0
        end
        return 0
      end
    }
  },


  ["SHOW"] = {
    ["command"] = {
      command = "SHOW",
    rtype = "command",
    params = {
      { "visibility", "integer" } },
    description = [[
      Set the parameter to 0 to hide the agent and to 1 to show the agent on camera.  
      This removes or adds the agent to the main camera and any remote cameras.  A non-shown agent 
      can still be visible to creatures, and can still be clicked on or picked up.  It just doesn'
      t appear on the cameras.
    ]],
    callback =
      function(self, visibility)
      end
    }
  },

  -- full
  ["SPCS"] = {
    ["integer"] = {
      command = "SPCS",
      rtype = "integer",
      params = {},
      description = [[
        Returns species of target.  See also @FMLY@, @GNUS@.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_species") or 0
        end
    }
  },


  ["STAR"] = {
    ["command"] = {
      command = "STAR",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Randomly chooses an agent which matches the given classifier and can be seen by the owner of the 
        script. It then sets @TARG@ to that agent.  See @ESEE@ for an explanation of seeing.
      ]],
      callback =
        function(self, family, genus, species)
        end
    }
  },

  -- full
  ["TARG"] = {
    ["agent"] = {
      command = "TARG",
      rtype = "agent",
      params = {},
      description = [[
        Returns current target, on whom many commands act.
      ]],
      callback =
        function(self)
          return self.vm.target
        end
    },

    ["command"] = {
      command = "TARG",
      rtype = "command",
      params = {
        { "agent", "agent" } },
      description = [[
        This sets the TARG variable to the agent specified.
      ]],
      callback =
        function(self, agent)
          self.vm.target = agent
        end
    }
  },


  ["TCOR"] = {
    ["integer"] = {
      command = "TCOR",
      rtype = "integer",
      params = {
        { "topY", "float" },  { "bottomY", "float" },  { "leftX", "float" },  { "rightX", "float" } },
      description = [[
        Tests setting the bounding box of the physical core of the object TARG.  May be set to smaller (
        or larger) than the sprite's rectangle.  Returns 1 if OK to set (using @CORE@), 0 if not.
        
      ]],
      callback =
        function(self, topY, bottomY, leftX, rightX)
          return 0
        end
    }
  },

  -- full/partial
  -- TODO: NOTE: May possibly be a global tick for this particular agent??
  ["TICK"] = {
    ["command"] = {
      command = "TICK",
      rtype = "command",
      params = {
        { "tick_rate", "integer" } },
      description = [[
        Start agent timer, calling @Timer@ script every tick_rate ticks.  Set to 0 to turn off the timer. (assuming target)
      ]],
      callback =
        function(self, tick_rate)
          self.vm.target:setVar("caos_timer_interval", tick_rate)
          --self.vm.target:setTick(tick_rate)
          --self.vm.timer_interval = tick_rate
        end
    },

    ["integer"] = {
      command = "TICK",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current timer rate set by the command TICK.
      ]],
      callback =
        function(self)
          --return self.vm.timer_interval or 0
          --return self.vm.target:getTick()
          return self.vm.target:getVar("caos_timer_interval")
        end
    }
  },


  ["TINO"] = {
    ["command"] = {
      command = "TINO",
      rtype = "command",
      params = {
        { "red_tint", "integer" },  { "green_tint", "integer" },  { "blue_tint", "integer" },  { "rotation", "integer" },  { "swap", "integer" } },
      description = [[
        Like @TINT@ but only tints the current frame.  The other frames are no longer available in the gallery, 
        it becomes a one frame sprite file.  Original display engine only.
      ]],
      callback =
        function(self, red_tint, green_tint, blue_tint, rotation, swap)
        end
    }
  },


  ["TINT"] = {
    ["command"] = {
      command = "TINT",
      rtype = "command",
      params = {
        { "red_tint", "integer" },  { "green_tint", "integer" },  { "blue_tint", "integer" },  { "rotation", "integer" },  { "swap", "integer" } },
      description = [[
        This tints the @TARG@ agent with the r,g,b tint and applies the colour rotation and swap 
        as per pigment bleed genes.  Specify the @PART@ first for compound agents.  The tinted agent or part now 
        uses a cloned gallery, which means it takes up more memory, and the save world files are larger.  
        However it also no longer needs the sprite file.  Also, tinting resets camera shy and other properties of 
        the gallery. See @TINO@ for a quicker version that tints only one frame.
      ]],
      callback =
        function(self, red_tint, green_tint, blue_tint, rotation, swap)
        end
    },

    ["integer"] = {
      command = "TINT",
      rtype = "integer",
      params = {
        { "attribute", "integer" } },
      description = [[
        Returns a tint value for an agent - currently it works only on Skeletal Creatures.  Attribute can be:
        1 - Red
        2 - Green
        3 - Blue
        4 - Rotation
        5 - Swap
      ]],
      callback =
        function(self, attribute)
          return 0
        end
    }
  },


  ["TOTL"] = {
    ["integer"] = {
      command = "TOTL",
      rtype = "integer",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Counts the number of agents in the world matching the classifier.
      ]],
      callback =
        function(self, family, genus, species)
          return 0
        end
    }
  },


  -- partial
  ["TOUC"] = {
    ["integer"] = {
      command = "TOUC",
      rtype = "integer",
      params = {
        { "first", "agent" },  { "second", "agent" } },
      description = [[
        Returns 1 if the two specified agents are touching, or 0 if they are not.  Agents are said 
        to be touching if their bounding rectangles overlap.
      ]],
      callback =
        function(self, first, second)
          if ( first.isTouching ~= nil ) then
            return first.isTouching(second.id()) and 1 or 0
          elseif ( second.isTouching ~= nil ) then
            return second.isTouching(first.id()) and 1 or 0
          end
          return 0
        end
    },

    ["command"] = {
      command = "TOUC",
      rtype = "command",
      params = {},
      description = [[
        Make creature reach out to touch the IT agent.  Blocks the script until the creature either reaches the 
        agent, or it's fully stretched and still can't.
      ]],
      callback =
        function(self)
        end
    }
  },
  
  -- N/A
  ["TRAN"] = {
    ["integer"] = {
      command = "TRAN",
      rtype = "integer",
      params = {
        { "xpos", "integer" },  { "ypos", "integer" } },
      description = [[
        Test for a transparent pixel, returns 1 if the given x y position coincides with a transparent pixel 
        on the @TARG@ agent, otherwise it will return 0.  This does not work for creatures.
      ]],
      callback =
        function(self, xpos, ypos)
          return 0
        end
    },
    ["command"] = {
      command = "TRAN",
      rtype = "command",
      params = {
        { "transparency", "integer" },  { "part_no", "integer" } },
      description = [[
        Sets pixel transparency awareness.  1 for pixel perfect, so transparent parts of the agent can't be clicked.  
        0 to allow anywhere on the agent rectangle to be clicked.  See also the option parameter on @PAT: 
        BUTT@ which overrides this.
      ]],
      callback =
        function(self, transparency, part_no )
        end
    }
  },


  ["TTAR"] = {
    ["command"] = {
      command = "TTAR",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Randomly chooses an agent which matches the given classifier and is touching the owner of the script. It 
        then sets @TARG@ to that agent.  See @ETCH@.
      ]],
      callback =
        function(self, family, genus, species)
        end
    }
  },


  ["TWIN"] = {
    ["agent"] = {
      command = "TWIN",
    rtype = "agent",
    params = {
      { "original", "agent" },  { "agent_null", "integer" } },
    description = [[
      Clones an agent, and returns the replica.  If agent_null is set to 1 the agents that this agent 
      points to (in OVxx, or VAxx in its running script) are set to NULL in the clone.  If 
      agent_null is 0, then the clone points to the same agents as the original.  When using agent_null 1, 
      you might want to call @STPT@ first so variables being used mid-script aren't cleared under the 
      agent's nose.
    ]],
    callback =
      function(self, original, agent_null)
        return nil
      end
    }
  },


  ["UCLN"] = {
    ["command"] = {
      command = "UCLN",
    rtype = "command",
    params = {},
    description = [[
      Make sure that an agent isn't cloned anymore, this releases the memory taken up by @TINT@ing 
      it. Agents are usually cloned for purposes such as tinting. Don't forget to set the relevant @PART@ 
      number for compound agents.
    ]],
    callback =
      function(self)
      end
    }
  },

  -- full?
  ["VISI"] = {
    ["integer"] = {
      command = "VISI",
    rtype = "integer",
    params = {
      { "checkAllCameras", "integer" } },
    description = [[
      Checks if the agent, or any of its parts, is on screen and returns 1 if it is 
      or 0 if it is not.  Set to 0 to check if the agent is on the main 
      camera. Set to 1 to check if the agent is on the main camera or any remote cameras
      
    ]],
    callback =
      function(self, checkAllCameras)
        local bounds = self.vm.owner:getVar("caos_bounds")
        return world.isVisibleToPlayer({
                minX = bounds.left,
                minY = bounds.top,
                maxX = bounds.right,
                maxY = bounds.bottom
              }) and 1 or 0
      end
    }
  },

  -- partial
  ["WDTH"] = {
    ["integer"] = {
      command = "WDTH",
    rtype = "integer",
    params = {},
    description = [[
      Returns the width of target.
    ]],
    callback =
      function(self)
        local bounds = self.vm.target:getVar(bounds)
        return bounds and math.abs(bounds.right - bounds.left) or 0
      end
    }
  },


  ["WILD"] = {
    ["string"] = {
      command = "WILD",
      rtype = "string",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "tag_stub", "string" },  { "offset", "integer" } },
      description = [[
        Searches for a catalogue tag based on the given classifier, and returns the string at the given offset.  
        See also @READ@.  As an example, with a tag_stub of "Agent Help" and a classifier 3 7 11 
        it would first look for the tag "Agent Help 3 7 11".  If that wasn't present, it 
        would go through the wildcards, eventually trying "Agent Help 0 0 0", and throwing an error if even 
        that isn't there.
      ]],
      callback =
        function(self, family, genus, species, tag_stub, offset)
          return ""
        end
    }
  },


  ["_IT_"] = {
    ["agent"] = {
      command = "_IT_",
    rtype = "agent",
    params = {},
    description = [[
      Returns the agent @OWNR@'s attention was on <i>when the current script was entered</i>.  This is 
      only valid if OWNR is a creature.  Compare @IITT@.
    ]],
    callback =
      function(self)
        return nil
      end
    }
  },


  ["ADIN"] = {
    ["command"] = {
      command = "ADIN",
      rtype = "command",
      params = {
        { "verb", "integer" },  { "noun", "integer" },  { "qualifier", "float" },  { "drive", "integer" } },
      description = [[
        Add an instinct to the creature's brain queue.  (The instinct is not processed immediately).  Example:  ADIN 3 
        4 0.5 7 encourages (by a factor of 0.5) the creature to do action 3 on 
        category 4 when drive 7 is high.
      ]],
      callback =
        function(self, verb, noun, qualifier, drive)
        end
    }
  },


  ["BRN: DMPB"] = {
    ["command"] = {
      command = "BRN: DMPB",
    rtype = "command",
    params = {},
    description = [[
      Dumps the sizes of the binary data dumps for current lobes and tracts.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["BRN: DMPD"] = {
    ["command"] = {
      command = "BRN: DMPD",
      rtype = "command",
      params = {
        { "tract_number", "integer" },  { "dendrite_number", "integer" } },
      description = [[
        Dumps a dendrite as binary data.
      ]],
      callback =
        function(self, tract_number, dendrite_number)
        end
    }
  },


  ["BRN: DMPL"] = {
    ["command"] = {
      command = "BRN: DMPL",
      rtype = "command",
      params = {
        { "lobe_number", "integer" } },
      description = [[
        Dumps a lobe as binary data.
      ]],
      callback =
        function(self, lobe_number)
        end
    }
  },


  ["BRN: DMPN"] = {
    ["command"] = {
      command = "BRN: DMPN",
      rtype = "command",
      params = {
        { "lobe_number", "integer" },  { "neuron_number", "integer" } },
      description = [[
        Dumps a neuron as binary data.
      ]],
      callback =
        function(self, lobe_number, neuron_number)
        end
    }
  },


  ["BRN: DMPT"] = {
    ["command"] = {
      command = "BRN: DMPT",
      rtype = "command",
      params = {
        { "tract_number", "integer" } },
      description = [[
        Dumps a tract as binary data.
      ]],
      callback =
        function(self, tract_number)
        end
    }
  },


  ["BRN: SETD"] = {
    ["command"] = {
      command = "BRN: SETD",
      rtype = "command",
      params = {
        { "tract_number", "integer" },  { "dendrite_number", "integer" },  { "weight_number", "integer" },  { "new_value", "float" } },
      description = [[
        Sets a dendrite weight.
      ]],
      callback =
        function(self, tract_number, dendrite_number, weight_number, new_value)
        end
    }
  },


  ["BRN: SETL"] = {
    ["command"] = {
      command = "BRN: SETL",
      rtype = "command",
      params = {
        { "lobe_number", "integer" },  { "line_number", "integer" },  { "new_value", "float" } },
      description = [[
        Sets a lobe's SV rule float value.
      ]],
      callback =
        function(self, lobe_number, line_number, new_value)
        end
    }
  },


  ["BRN: SETN"] = {
    ["command"] = {
      command = "BRN: SETN",
      rtype = "command",
      params = {
        { "lobe_number", "integer" },  { "neuron_number", "integer" },  { "state_number", "integer" },  { "new_value", "float" } },
      description = [[
        Sets a neuron weight.
      ]],
      callback =
        function(self, lobe_number, neuron_number, state_number, new_value)
        end
    }
  },


  ["BRN: SETT"] = {
    ["command"] = {
      command = "BRN: SETT",
      rtype = "command",
      params = {
        { "tract_number", "integer" },  { "line_number", "integer" },  { "new_value", "float" } },
      description = [[
        Sets a tract's SV rule float value.
      ]],
      callback =
        function(self, tract_number, line_number, new_value)
        end
    }
  },


  ["DOIN"] = {
    ["command"] = {
      command = "DOIN",
      rtype = "command",
      params = {
        { "no_of_instincts_to_process", "integer" } },
      description = [[
        Make the creature TARG process N instincts.
      ]],
      callback =
        function(self, no_of_instincts_to_process)
        end
    }
  },


  ["BKGD"] = {
    ["command"] = {
      command = "BKGD",
      rtype = "command",
      params = {
        { "metaroom_id", "integer" },  { "background", "string" },  { "transition", "integer" } },
      description = [[
        Change the current background displayed for the selected camera (with @SCAM@).  Transition is as for @META@.  The background 
        must have been specified with the @ADDM@ or @ADDB@ command first.
      ]],
      callback =
        function(self, metaroom_id, background, transition)
        end
    },

    ["string"] = {
      command = "BKGD",
      rtype = "string",
      params = {
        { "metaroom_id", "integer" } },
      description = [[
        Returns the name of the background file currently shown by the given camera.
      ]],
      callback =
        function(self, metaroom_id)
          return ""
        end
    }
  },


  ["BRMI"] = {
    ["command"] = {
      command = "BRMI",
      rtype = "command",
      params = {
        { "metaroom_base,", "integer" },  { "room_base", "integer" } },
      description = [[
        Sets the Map's Metaroom and Room index bases for adding new rooms/metarooms.
      ]],
      callback =
        function(self, metaroom_base, room_base)
        end
    }
  },


  ["CMRA"] = {
    ["command"] = {
      command = "CMRA",
      rtype = "command",
      params = {
        { "x", "integer" },  { "y", "integer" },  { "pan", "integer" } },
      description = [[
        Move current camera so top left corner of view is at world coordinate x y. Set pan 0 
        to jump straight to location, pan 1 to smoothly scroll there (unless in a different meta room).
      ]],
      callback =
        function(self, x, y, pan)
        end
    }
  },


  ["CMRP"] = {
    ["command"] = {
      command = "CMRP",
      rtype = "command",
      params = {
        { "x", "integer" },  { "y", "integer" },  { "pan", "integer" } },
      description = [[
        Centre current camera on world coordinate x y. Set pan 0 to jump straight to location, pan 1 
        to smoothly scroll there (unless in different meta room), and pan 2 to smoothly scroll only if the 
        destination is already visible.
      ]],
      callback =
        function(self, x, y, pan)
        end
    }
  },


  ["CMRT"] = {
    ["command"] = {
      command = "CMRT",
      rtype = "command",
      params = {
        { "pan", "integer" } },
      description = [[
        Centre current camera on target.  Set pan 0 to jump straight to location, pan 1 to smoothly scroll 
        there (unless in different meta room), and pan 2 to smoothly scroll only if the destination is already 
        visible.
      ]],
      callback =
        function(self, pan)
        end
    }
  },


  ["CMRX"] = {
    ["integer"] = {
      command = "CMRX",
      rtype = "integer",
      params = {},
      description = [[
        Returns the x coordinate of the centre of the current camera.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CMRY"] = {
    ["integer"] = {
      command = "CMRY",
      rtype = "integer",
      params = {},
      description = [[
        Returns the y coordinate of the centre of the current camera.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["FRSH"] = {
    ["command"] = {
      command = "FRSH",
    rtype = "command",
    params = {},
    description = [[
      Refreshes the main view port.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["LINE"] = {
    ["command"] = {
      command = "LINE",
    rtype = "command",
    params = {
      { "x1", "integer" },  { "y1", "integer" },  { "x2", "integer" },  { "y2", "integer" },  { "r", "integer" },  { "g", "integer" },  { "b", "integer" },  { "stipple_on", "integer" },  { "stipple_off", "integer" } },
    description = [[
      Adds a line to target's drawing list.  The line goes between the start and end points (world 
      coordinates) in the specified colour.  Set stipple_on and stipple_off to 0 to draw a solid line, or to 
      the number of pixels to alternate for a stippled line.  To clear all the lines for an agent, 
      call LINE with the start and end points the same.
    ]],
    callback =
      function(self, x1, y1, x2, y2, r, g, b, stipple_on, stipple_off)
      end
    }
  },


  ["LOFT"] = {
    ["integer"] = {
      command = "LOFT",
      rtype = "integer",
      params = {
        { "filename", "string" } },
      description = [[
        Declares that you have finished with a photograph image file taken by @SNAP@.  If the file is in 
        use in a gallery, this function fails and returns 1.  Otherwise it returns 0.  The file will be 
        marked for the attic, and moved there later.
      ]],
      callback =
        function(self, filename)
          return 0
        end
    }
  },


  ["META"] = {
    ["command"] = {
      command = "META",
      rtype = "command",
      params = {
        { "metaroom_id", "integer" },  { "camera_x", "integer" },  { "camera_y", "integer" },  { "transition", "integer" } },
      description = [[
        Change the current camera (set with @SCAM@) to a new meta room.  Moves the top left coordinate of the camera to the given coordinates.
      Transition can be:
        0 - no transition effect
        1 - flip horizontally
        2 - burst
      ]],
      callback =
        function(self, metaroom_id, camera_x, camera_y, transition)
        end
    },

    ["integer"] = {
      command = "META",
      rtype = "integer",
      params = {},
      description = [[
        Returns the metaroom id that the current camera is looking at.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["SCAM"] = {
    ["command"] = {
      command = "SCAM",
      rtype = "command",
      params = {
        { "compoundagent", "agent" },  { "partNumber", "integer" } },
      description = [[
        Sets the current camera to be used in subsequent camera macro commands.  This uses the given @TARG@ and 
        the given @PART@ number.  If you set this to @NULL@ then the Main Camera will be used.  This 
        is the default setting
      ]],
      callback =
        function(self, compoundagent, partNumber)
        end
    }
  },


  ["SNAP"] = {
    ["command"] = {
      command = "SNAP",
    rtype = "command",
    params = {
      { "filename", "string" },  { "x_centre", "integer" },  { "y_centre", "integer" },  { "width", "integer" },  { "height", "integer" },  { "zoom_factor", "integer" } },
    description = [[
      This takes a photograph of the world at a particular place. The zoom parameter should be between 0 
      and 100. 100 means at original size, 50 means half size etc.  It makes a new image file 
      in the world images directory - you can use it to make agents and parts as with any image 
      file.  Call @SNAX@ first to check your filename isn't already in use in any images directory.  When 
      you have finished with the file, call @LOFT@.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["SNAX"] = {
    ["integer"] = {
      command = "SNAX",
      rtype = "integer",
      params = {
        { "filename", "string" } },
      description = [[
        Returns 1 if the specified image file exists, or 0 if it doesn't.  Use with @SNAP@ to 
        find a unique filename to use.
      ]],
      callback =
        function(self, filename )
          return 0
        end
    }
  },


  ["TRCK"] = {
    ["command"] = {
      command = "TRCK",
      rtype = "command",
      params = {
        { "agent", "agent" },  { "x_percent", "integer" },  { "y_percent", "integer" },  { "style", "integer" },  { "transition", "integer" } },
      description = [[
        Camera follows the given agent.  Set to @NULL@ to stop tracking. x% and y% are percentages (0-100) of the screen size.  They describe a rectangle centred on the screen which the target stays within. 
         Style 0 is brittle - if you move the camera so the target is out of the rectangle, then the tracking is broken.
        Style 1 is flexible - you can move the camera away from the target.  If you move it back, then tracking resumes.
        Style 2 is hard - you can't move the camera so the target is out of the rectangle.
         The transition is the sort of fade to use if the tracking causes a change in meta room.  The values are the same as for the transition in the @META@ command.
      ]],
      callback =
        function(self, agent, x_percent, y_percent, style, transition )
        end
    },

    ["agent"] = {
      command = "TRCK",
      rtype = "agent",
      params = {},
      description = [[
        Returns the agent being tracked by the camera, if any.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },


  ["WDOW"] = {
    ["command"] = {
      command = "WDOW",
      rtype = "command",
      params = {},
      description = [[
        Toggle full screen mode.
      ]],
      callback =
        function(self)
        end
    },

    ["integer"] = {
      command = "WDOW",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if in full screen mode, or 0 if in windowed mode.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["WNDB"] = {
    ["integer"] = {
      command = "WNDB",
      rtype = "integer",
      params = {},
      description = [[
        Returns world coordinates of bottom of current camera window.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["WNDH"] = {
    ["integer"] = {
      command = "WNDH",
      rtype = "integer",
      params = {},
      description = [[
        Returns height of current camera window.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["WNDL"] = {
    ["integer"] = {
      command = "WNDL",
      rtype = "integer",
      params = {},
      description = [[
        Returns world coordinates of left of current camera window.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["WNDR"] = {
    ["integer"] = {
      command = "WNDR",
      rtype = "integer",
      params = {},
      description = [[
        Returns world coordinates of right of current camera window.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["WNDT"] = {
    ["integer"] = {
      command = "WNDT",
      rtype = "integer",
      params = {},
      description = [[
        Returns world coordinates of top of current camera window.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["WNDW"] = {
    ["integer"] = {
      command = "WNDW",
      rtype = "integer",
      params = {},
      description = [[
        Returns width of current camera window.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["ZOOM"] = {
    ["command"] = {
      command = "ZOOM",
      rtype = "command",
      params = {
        { "pixels", "integer" },  { "x", "integer" },  { "y", "integer" } },
      description = [[
        Zoom in on the specified position by a negative amount of pixels or out by positive amount of 
        pixels.  If you send -1 as the x and y coordinates then the camera zooms in on the 
        exising view port centre.  This only applies to remote cameras.
      ]],
      callback =
        function(self, pixels, x, y )
        end
    }
  },


  ["_CD_ EJCT"] = {
    ["command"] = {
      command = "_CD_ EJCT",
    rtype = "command",
    params = {},
    description = [[
      Open the CD tray.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["_CD_ FRQH"] = {
    ["integer"] = {
      command = "_CD_ FRQH",
      rtype = "integer",
      params = {},
      description = [[
        Returns the average value for the highest frequencies detected in the CD player for the current tick.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["_CD_ FRQL"] = {
    ["integer"] = {
      command = "_CD_ FRQL",
      rtype = "integer",
      params = {},
      description = [[
        Returns the average value for the lowest frequencies detected in the CD player for the current tick.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["_CD_ FRQM"] = {
    ["integer"] = {
      command = "_CD_ FRQM",
      rtype = "integer",
      params = {},
      description = [[
        Returns the average value for the medium frequencies detected in the CD player for the current tick.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["_CD_ INIT"] = {
    ["command"] = {
      command = "_CD_ INIT",
    rtype = "command",
    params = {},
    description = [[
      Let the game know that you wish to use the cd player.  This will shut down all in 
      game sounds and music as the mixer is needed to gauge the frequency spectrum.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["_CD_ PAWS"] = {
    ["command"] = {
      command = "_CD_ PAWS",
      rtype = "command",
      params = {
        { "on_off", "integer" } },
      description = [[
        Pause the CD player if the parameter is greater than zero, to continue playing a previous paused track 
        set the parameter to 1.
      ]],
      callback =
        function(self, on_off )
        end
    }
  },


  ["_CD_ PLAY"] = {
    ["command"] = {
      command = "_CD_ PLAY",
      rtype = "command",
      params = {
        { "first_track", "integer" },  { "last_track", "integer" } },
      description = [[
        Tell the CD Player to play the given track.
      ]],
      callback =
        function(self, first_track, last_track )
        end
    }
  },


  ["_CD_ SHUT"] = {
    ["command"] = {
      command = "_CD_ SHUT",
    rtype = "command",
    params = {},
    description = [[
      Tell the game that you have finished with the cd player.  This will reinstate the in game sounds 
      and music.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["_CD_ STOP"] = {
    ["command"] = {
      command = "_CD_ STOP",
    rtype = "command",
    params = {},
    description = [[
      Stop the cd player.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["FCUS"] = {
    ["command"] = {
      command = "FCUS",
    rtype = "command",
    params = {},
    description = [[
      Set keyboard focus to the current @PART@ of the targetted agent.  The part should be a @PAT: TEXT@.  
      If you TARG NULL first, then no part will have the focus.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["FRMT"] = {
    ["command"] = {
      command = "FRMT",
    rtype = "command",
    params = {
      { "left_margin", "integer" },  { "top_margin", "integer" },  { "right_margin", "integer" },  { "bottom_margin", "integer" },  { "line_spacing", "integer" },  { "character_spacing", "integer" },  { "justification", "integer" } },
    description = [[
      Use this command to alter the appearance of the current text part. The line and character spacing values 
      are expressed in number of extra pixels to insert between characters. Values for justification are 0 - Left, 1 - 
      Right, 2 - Center, 4 - Bottom, 8 - Middle, 16 - Last Page Scroll (if you add extra text to the 
      part and show the last page, it will scroll upwards).  You may add mutually compatible numbers.  The default 
      format values are 8 8 8 8 0 0 0.
    ]],
    callback =
      function(self, left_margin, top_margin, right_margin, bottom_margin, line_spacing, character_spacing, justification )
      end
    }
  },


  ["GRPL"] = {
    ["command"] = {
      command = "GRPL",
      rtype = "command",
      params = {
        { "red", "integer" },  { "green", "integer" },  { "blue", "integer" },  { "min_y", "float" },  { "max_y", "float" } },
      description = [[
        Add a line to a graph (previously created with @PAT: GRPH@). The first line you add will be 
        line 0.
      ]],
      callback =
        function(self, red, green, blue, min_y, max_y )
        end
    }
  },


  ["GRPV"] = {
    ["command"] = {
      command = "GRPV",
      rtype = "command",
      params = {
        { "line_index", "integer" },  { "value", "float" } },
      description = [[
        Add a value to a line on a graph. after you have added a value to each line 
        on the graph, it will be updated by scrolling the current values to the left
      ]],
      callback =
        function(self, line_index, value )
        end
    }
  },


  ["NEW: COMP"] = {
    ["command"] = {
      command = "NEW: COMP",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "sprite_file", "string" },  { "image_count", "integer" },  { "first_image", "integer" },  { "plane", "integer" } },
      description = [[
        Create a new compound agent. The sprite file is for the first part, which is made automatically.  Similarly, 
        image_count and first_image are for that first part.  The plane is the absolute plane of part 1 - the 
        planes of other parts are relative to the first part.
      ]],
      callback =
        function(self, family, genus, species, sprite_file, image_count, first_image, plane )
        end
    }
  },


  ["NPGS"] = {
    ["integer"] = {
      command = "NPGS",
      rtype = "integer",
      params = {},
      description = [[
        Returns the number of available pages for current text part.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["PAGE"] = {
    ["command"] = {
      command = "PAGE",
      rtype = "command",
      params = {
        { "page", "integer" } },
      description = [[
        Sets current page for text part. The page number should be equal or greater than zero and less 
        than the number returned by @NPGS@. Use @PAT: TEXT@ or @PAT: FIXD@ to make a text part, and @
        PART@ to set the current part.
      ]],
      callback =
        function(self, page )
        end
    },

    ["integer"] = {
      command = "PAGE",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current page for current text part.  See the @PAGE@ command for more information.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["PART"] = {
    ["command"] = {
      command = "PART",
      rtype = "command",
      params = {
        { "part_id", "integer" } },
      description = [[
        Sets the working part number.  Future command such as @POSE@ and @ANIM@, amongst others, act on that part 
        of a compound agent.  To find what parts there are on an agent use @PNXT@.
      ]],
      callback =
        function(self, part_id )
        end
    },

    ["integer"] = {
      command = "PART",
      rtype = "integer",
      params = {
        { "part_id", "integer" } },
      description = [[
        Returns 1 if the given part number exists on the @TARG@ agent and 0 if it does not.
        
      ]],
      callback =
        function(self, part_id )
          return 0
        end
    }
  },


  ["PAT: BUTT"] = {
    ["command"] = {
      command = "PAT: BUTT",
      rtype = "command",
      params = {
        { "part_id", "integer" },  { "sprite_file", "string" },  { "first_image", "integer" },  { "image_count", "integer" },  { "rel_x", "decimal" },  { "rel_y", "decimal" },  { "rel_plane", "integer" },  { "anim_hover", "byte-string" },  { "message_id", "integer" },  { "option", "integer" } },
      description = [[
        Create a button on a compound agent.  anim_hover is an animation, as in the @ANIM@ command, to use when the mouse is over the button - when the mouse is moved off, it returns to any previous animation that was going.  message_id is sent when the button is clicked.  option is 0 for the mouse to hit anywhere in the bounding box, 1 to hit only non-transparent pixels.
        @_P1_@ of the message is set to the part number of the buttons allowing you to overload your messages by button group and then switch on input value in the script.
      ]],
      callback =
        function(self, part_id, sprite_file, first_image, image_count, rel_x, rel_y, rel_plane, anim_hover, message_id, option )
        end
    }
  },


  ["PAT: CMRA"] = {
    ["command"] = {
      command = "PAT: CMRA",
      rtype = "command",
      params = {
        { "part_id", "integer" },  { "overlay_sprite", "string" },  { "baseimage", "integer" },  { "relx", "decimal" },  { "rely", "decimal" },  { "relplane", "integer" },  { "viewWidth", "integer" },  { "viewHeight", "integer" },  { "cameraWidth", "integer" },  { "cameraHeight", "integer" } },
      description = [[
        Create a camera with possible overlay sprite whose name may be blank.  Use @SCAM@ to change the camera'
        s view.
      ]],
      callback =
        function(self, part_id, overlay_sprite, baseimage, relx, rely, relplane, viewWidth, viewHeight, cameraWidth, cameraHeight )
        end
    }
  },


  ["PAT: DULL"] = {
    ["command"] = {
      command = "PAT: DULL",
    rtype = "command",
    params = {
      { "part_id", "integer" },  { "sprite_file", "string" },  { "first_image", "integer" },  { "rel_x", "decimal" },  { "rel_y", "decimal" },  { "rel_plane", "integer" } },
    description = [[
      Create a dull part for a compound agent.  A dull part does nothing except show an image from 
      the given sprite file.  You should number part ids starting at 1, as part 0 is automatically made 
      when the agent is made.  The dull part's position is relative to part 0, as is its 
      plane.  Use @PART@ to select it before you change @POSE@ or @ANIM@, or use various other commands.
    ]],
    callback =
      function(self, part_id, sprite_file, first_image, rel_x, rel_y, rel_plane )
      end
    }
  },


  ["PAT: FIXD"] = {
    ["command"] = {
      command = "PAT: FIXD",
      rtype = "command",
      params = {
        { "part_id", "integer" },  { "sprite_file", "string" },  { "first_image", "integer" },  { "rel_x", "decimal" },  { "rel_y", "decimal" },  { "rel_plane", "integer" },  { "font_sprite", "string" } },
      description = [[
        Create a fixed text part. The text is wrapped on top of the supplied gallery image. new-line 
        characters may be used.  Use @PTXT@ to set the text.
      ]],
      callback =
        function(self, part_id, sprite_file, first_image, rel_x, rel_y, rel_plane, font_sprite )
        end
    }
  },


  ["PAT: GRPH"] = {
    ["command"] = {
      command = "PAT: GRPH",
      rtype = "command",
      params = {
        { "part_id", "integer" },  { "overlay_sprite", "string" },  { "baseimage", "integer" },  { "relx", "decimal" },  { "rely", "decimal" },  { "relplane", "integer" },  { "numValues", "integer" } },
      description = [[
        Creates a graph part on a compound agent. Use @GRPL@ to add a line to the graph and @
        GRPV@ to add a value to a graph line.
      ]],
      callback =
        function(self, part_id, overlay_sprite, baseimage, relx, rely, relplane, numValues )
        end
    }
  },


  ["PAT: KILL"] = {
    ["command"] = {
      command = "PAT: KILL",
      rtype = "command",
      params = {
        { "part_id", "integer" } },
      description = [[
        Destroys the specified part of a compound agent.  You can't destroy part 0.
      ]],
      callback =
        function(self, part_id )
        end
    }
  },


  ["PAT: MOVE"] = {
    ["command"] = {
      command = "PAT: MOVE",
      rtype = "command",
      params = {
        { "part_id", "integer" },  { "rel_x", "decimal" },  { "rely", "decimal" } },
      description = [[
        Moves a compound part to the new relative position specified.
      ]],
      callback =
        function(self, part_id, rel_x, rely )
        end
    }
  },


  ["PAT: TEXT"] = {
    ["command"] = {
      command = "PAT: TEXT",
    rtype = "command",
    params = {
      { "part_id", "integer" },  { "sprite_file", "string" },  { "first_image", "integer" },  { "rel_x", "decimal" },  { "rel_y", "decimal" },  { "rel_plane", "integer" },  { "message_id", "integer" },  { "font_sprite", "string" } },
    description = [[
      Creates a text entry part.  Gains the focus when you click on it, or with the @FCUS@ command.  
      Sends the message_id when return is pressed - a good place to use @PTXT@ to get the text out, 
      and to set the focus elsewhere.  Set message_id to 0 to not call any script, or to -1 
      to not send any message and instead insert a carriage return.
    ]],
    callback =
      function(self, part_id, sprite_file, first_image, rel_x, rel_y, rel_plane, message_id, font_sprite )
      end
    }
  },


  ["PNXT"] = {
    ["integer"] = {
      command = "PNXT",
      rtype = "integer",
      params = {
        { "previous_part", "integer" } },
      description = [[
        Returns the next compound @PART@ on an agent.  Start by calling it with -1 to get the first 
        part, and it finishes by returning -1 when it reaches the end.
      ]],
      callback =
        function(self, previous_part )
          return 0
        end
    }
  },


  ["PTXT"] = {
    ["command"] = {
      command = "PTXT",
      rtype = "command",
      params = {
        { "text", "string" } },
      description = [[
        Set string of current text part.  Use @PAT: TEXT@ or @PAT: FIXD@ to make a text part, and @
        PART@ to set the current part.
      In the original display engine, you can use special tags to 
        set @TINT@ colours for characters. Use something like &lt;tint 255 255 0&gt; to begin colouring, and &
        lt;tint&gt; to end.  The tint tag takes up to five parameters as the @TINT@ command, they 
        all default to 128 if not specified.  Less than and greater than symbols are still printed if not 
        within a tint tag.  The tags also apply to text entry parts, but only when the text is 
        initially set with @PTXT@; they are obeyed in a character count fashion during editing, but not updated.
      ]],
      callback =
        function(self, text )
        end
    },

    ["string"] = {
      command = "PTXT",
      rtype = "string",
      params = {},
      description = [[
        Returns the string of the current text part.  See the @PTXT@ command for more information.
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["AGES"] = {
    ["command"] = {
      command = "AGES",
      rtype = "command",
      params = {
        { "times", "integer" } },
      description = [[
        Forces a creature to age the given number of times.  See also @CAGE@.
      ]],
      callback =
        function(self, times )
        end
    }
  },


  ["APPR"] = {
    ["command"] = {
      command = "APPR",
    rtype = "command",
    params = {},
    description = [[
      Creature approaches the IT agent.  If there is no IT agent, the creature follows the CA smell to 
      find an agent of that category.  The script resumes when it gets there, or if it can't 
      get any further.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["ASLP"] = {
    ["command"] = {
      command = "ASLP",
      rtype = "command",
      params = {
        { "asleep", "integer" } },
      description = [[
        Make the creature asleep or awake.  1 for asleep, 0 for awake.
      ]],
      callback =
        function(self, asleep )
        end
    },

    ["integer"] = {
      command = "ASLP",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if the creature is asleep, 0 otherwise.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["ATTN"] = {
    ["integer"] = {
      command = "ATTN",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current focus of attention id.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["BODY"] = {
    ["command"] = {
      command = "BODY",
      rtype = "command",
      params = {
        { "set_number", "integer" },  { "layer", "integer" } },
      description = [[
        Similar to @WEAR@, only puts the given set of clothes on every body part.
      ]],
      callback =
        function(self, set_number, layer )
        end
    },

    ["integer"] = {
      command = "BODY",
      rtype = "integer",
      params = {
        { "bodyPart", "integer" } },
      description = [[
        Return the set number of the outfit the norn is wearing on the outer most layer or -1 
        if it is not wearing anything 
      ]],
      callback =
        function(self, bodyPart )
          return 0
        end
    }
  },


  ["BOOT"] = {
    ["command"] = {
      command = "BOOT",
      rtype = "command",
      params = {
        { "subboot_number", "integer" },  { "folder_number_sum", "integer" },  { "clear_world", "integer" } },
      description = [[
        Loads in a list of numbered bootstrap folders contained within a folder called subboot. Bootstraps folders numbers are 
        powers of 2, sum the folder numbers to load those folders.  There is provision for more than one 
        subboot folder, these should be uniquely numbered. 
      ]],
      callback =
        function(self, subboot_number, folder_number_sum, clear_world )
        end
    }
  },


  ["BORN"] = {
    ["command"] = {
      command = "BORN",
    rtype = "command",
    params = {},
    description = [[
      Signals the target creature as having been born - this sends a birth event, and sets the @TAGE@ ticking.      
    ]],
    callback =
      function(self)
      end
    }
  },


  ["BVAR"] = {
    ["integer"] = {
      command = "BVAR",
      rtype = "integer",
      params = {},
      description = [[
        Returns the variant number for target creature.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["BYIT"] = {
    ["integer"] = {
      command = "BYIT",
    rtype = "integer",
    params = {},
    description = [[
      Returns 1 if the creature is within reach of the IT agent, or 0 if it isn't.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["CAGE"] = {
    ["integer"] = {
      command = "CAGE",
      rtype = "integer",
      params = {},
      description = [[
        Returns life stage of target creature.  See also @AGES@.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CALG"] = {
    ["command"] = {
      command = "CALG",
      rtype = "command",
      params = {
        { "category_id", "integer" },  { "category_representative_algorithm_id", "integer" } },
      description = [[
        Choose how a creature (TARG) decides which particular object in a category to look at.  PICK_NEAREST_IN_X_DIRECTION=0, PICK_A_RANDOM_ONE=
        1, PICK_NEAREST_IN_CURRENT_ROOM=2, PICK_NEAREST_TO_GROUND=3, PICK_RANDOM_NEAREST_IN_X_DIRECTION=4.
      ]],
      callback =
        function(self, category_id, category_representative_algorithm_id )
        end
    },

    ["integer"] = {
      command = "CALG",
      rtype = "integer",
      params = {
        { "category_id", "integer" } },
      description = [[
        Find out which algorithm is currently being used for the creature TARG to decide which particular object in 
        a category to look at.
      ]],
      callback =
        function(self, category_id )
          return 0
        end
    }
  },


  ["CHEM"] = {
    ["command"] = {
      command = "CHEM",
      rtype = "command",
      params = {
        { "chemical", "integer" },  { "adjustment", "float" } },
      description = [[
        Adjusts chemical (0 to 255) by concentration -1.0 to +1.0 in the target creature's bloodstream.
      ]],
      callback =
        function(self, chemical, adjustment )
        end
    },

    ["float"] = {
      command = "CHEM",
      rtype = "float",
      params = {
        { "chemical", "integer" } },
      description = [[
        Returns concentration (0.0 to 1.0) of chemical (1 to 255) in the target creature's bloodstream.
      ]],
      callback =
        function(self, chemical )
          return 0.0
        end
    }
  },

  -- full
  ["CREA"] = {
    ["integer"] = {
      command = "CREA",
    rtype = "integer",
    params = {
      { "agent", "agent" } },
    description = [[
      Returns 1 if the agent is a creature, 0 if not.
    ]],
    callback =
      function(self, agent )
        local typ = world.entityType(agent)
        return ( typ == "player" or typ == "npc" ) and 1 or 0
      end
    }
  },


  ["DEAD"] = {
    ["command"] = {
      command = "DEAD",
      rtype = "command",
      params = {},
      description = [[
        Makes the target creature die, triggering @Die@ script and history events, closing its eyes, and stopping brain and 
        biochemistry updates.  Not to be confused with @KILL@, which you will have to use later to remove the 
        actual body.
      ]],
      callback =
        function(self)
        end
    },

    ["integer"] = {
      command = "DEAD",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if target creature is dead, or 0 if alive.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["DECN"] = {
    ["integer"] = {
      command = "DECN",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current focus of decision id.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["DFTX"] = {
    ["float"] = {
      command = "DFTX",
      rtype = "float",
      params = {},
      description = [[
        Returns X coordinate of creature's down foot.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["DFTY"] = {
    ["float"] = {
      command = "DFTY",
      rtype = "float",
      params = {},
      description = [[
        Returns Y coordinate of creature's down foot.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["DIRN"] = {
    ["command"] = {
      command = "DIRN",
      rtype = "command",
      params = {
        { "direction", "integer" } },
      description = [[
        Change creature to face a different direction. North 0, South 1, East 2, West 3.
      ]],
      callback =
        function(self, direction )
        end
    },

    ["integer"] = {
      command = "DIRN",
      rtype = "integer",
      params = {},
      description = [[
        Returns the direction that target creature is facing.  North 0, South 1, East 2, West 3.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["DONE"] = {
    ["command"] = {
      command = "DONE",
    rtype = "command",
    params = {},
    description = [[
      Stops the targetted creature doing any involuntary actions.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DREA"] = {
    ["command"] = {
      command = "DREA",
      rtype = "command",
      params = {
        { "dream", "integer" } },
      description = [[
        Set to 1 to make the creature fall asleep and dream, 0 to stop the creature dreaming.  When 
        dreaming, a creature's instincts are processed.  See also @ASLP@.
      ]],
      callback =
        function(self, dream )
        end
    },

    ["integer"] = {
      command = "DREA",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if the creature is asleep and dreaming, 0 otherwise.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["DRIV"] = {
    ["command"] = {
      command = "DRIV",
      rtype = "command",
      params = {
        { "drive", "integer" },  { "adjustment", "float" } },
      description = [[
        Adjusts the level of the given drive by the specified amount - can be positive or negative.
      ]],
      callback =
        function(self, drive, adjustment )
        end
    },

    ["float"] = {
      command = "DRIV",
      rtype = "float",
      params = {
        { "drive", "integer" } },
      description = [[
        Returns the value (0.0 to 1.0) of the specified drive.
      ]],
      callback =
        function(self, drive )
          return 0.0
        end
    }
  },


  ["DRV!"] = {
    ["integer"] = {
      command = "DRV!",
      rtype = "integer",
      params = {},
      description = [[
        Returns the id of the highest drive for the target creature.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["EXPR"] = {
    ["integer"] = {
      command = "EXPR",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current facial expression index for the creature.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["FACE"] = {
    ["command"] = {
      command = "FACE",
      rtype = "command",
      params = {
        { "set_number", "integer" } },
      description = [[
        Sets a facial expression on target creature.
      ]],
      callback =
        function(self, set_number )
        end
    },

    ["integer"] = {
      command = "FACE",
      rtype = "integer",
      params = {},
      description = [[
        Returns the front facing pose for the current facial expression.  See the @FACE@ string rvalue.
      ]],
      callback =
        function(self)
          return 0
        end
    },

    ["string"] = {
      command = "FACE",
      rtype = "string",
      params = {},
      description = [[
        Returns the name of the sprite file for the target creature's face.  Currently automatically gives you the 
        youngest age version of the gallery but soon will work in the following way: If you set the 
        parameter to -1 you will get the name of the file the creature is currently using.  Note that 
        when the creature ages, this file name will change (the @GALL@ command could be useful here).  If you 
        set the parameter to a particular age then the filename returned will be the gallery that best matches 
        that age.  Use the @FACE@ integer rvalue to get the pose number for facing forwards.  See also @LIMB@.
        
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["FORF"] = {
    ["command"] = {
      command = "FORF",
      rtype = "command",
      params = {
        { "creature_to_learn_about", "agent" } },
      description = [[
        Set the friends or foe lobe to learn from the creature.
      ]],
      callback =
        function(self, creature_to_learn_about )
        end
    }
  },


  ["HAIR"] = {
    ["command"] = {
      command = "HAIR",
      rtype = "command",
      params = {
        { "stage", "integer" } },
      description = [[
        Tidies or ruffles hair.  Positive means tidy, negative untidy.  There can be multiple stages of tidiness or untidiness; 
        the more extreme the value the tidier or untidier.
      ]],
      callback =
        function(self, stage )
        end
    }
  },


  ["HHLD"] = {
    ["agent"] = {
      command = "HHLD",
      rtype = "agent",
      params = {},
      description = [[
        Returns the creature currently holding hands with the pointer agent. NULL if no agent is holding hands.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },


  ["INJR"] = {
    ["command"] = {
      command = "INJR",
      rtype = "command",
      params = {
        { "organ", "integer" },  { "amount", "integer" } },
      description = [[
        Injures an organ, -1 to randomly choose the organ, 0 for the body organ.
      ]],
      callback =
        function(self, organ, amount )
        end
    }
  },


  ["INS#"] = {
    ["integer"] = {
      command = "INS#",
      rtype = "integer",
      params = {},
      description = [[
        Number of instincts still queued to be processed.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["LIKE"] = {
    ["command"] = {
      command = "LIKE",
      rtype = "command",
      params = {
        { "creature_state_opinion_about", "agent" } },
      description = [[
        State a personal opinion about a creature.
      ]],
      callback =
        function(self, creature_state_opinion_about )
        end
    }
  },


  ["LIMB"] = {
    ["string"] = {
      command = "LIMB",
      rtype = "string",
      params = {
        { "body_part", "integer" },  { "genus", "integer" },  { "gender", "integer" },  { "age", "integer" },  { "variant", "integer" } },
      description = [[
        Returns the filename for the specified part of a creature.  If the exact part isn't present, a '
        nearby' file which is on the disk is returned.
      ]],
      callback =
        function(self, body_part, genus, gender, age, variant )
          return ""
        end
    }
  },


  ["LOCI"] = {
    ["command"] = {
      command = "LOCI",
      rtype = "command",
      params = {
        { "type", "integer" },  { "organ", "integer" },  { "tissue", "integer" },  { "id", "integer" },  { "new_value", "float" } },
      description = [[
        Sets a biochemical locus value.  See @Receptor Locus Numbers@ and @Emitter Locus Numbers@
      ]],
      callback =
        function(self, type, organ, tissue, id, new_value )
        end
    },

    ["float"] = {
      command = "LOCI",
      rtype = "float",
      params = {
        { "type", "integer" },  { "organ", "integer" },  { "tissue", "integer" },  { "id", "integer" } },
      description = [[
        Reads a biochemical locus value.
      ]],
      callback =
        function(self, type, organ, tissue, id )
          return 0.0
        end
    }
  },


  ["LTCY"] = {
    ["command"] = {
      command = "LTCY",
      rtype = "command",
      params = {
        { "action", "integer" },  { "min", "integer" },  { "max", "integer" } },
      description = [[
        Sets latency time on involuntary actions to a random value between min and max.  After an involuntary action 
        occurs, the same action will not be able to kick in again until after that many ticks.  Min 
        and max must range between 0 and 255. 
      ]],
      callback =
        function(self, action, min, max )
        end
    }
  },


  ["MATE"] = {
    ["command"] = {
      command = "MATE",
    rtype = "command",
    params = {},
    description = [[
      Male creature mates with the IT agent - if IT is a female of the same genus!  The female 
      doesn't need to be in reach.  If successful, the sperm is transmitted to the female and there 
      is a chance of conception.  If pregnancy occurs, gene slot 1 of the mother contains the genome of 
      the child.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["MIND"] = {
    ["command"] = {
      command = "MIND",
      rtype = "command",
      params = {
        { "state", "integer" } },
      description = [[
        Enable (1) or disable (0) the creature's brain (unlike @ZOMB#@ in that the brain actually stops processing 
        and it's output is frozen onto the one noun and verb).
      ]],
      callback =
        function(self, state )
        end
    },

    ["integer"] = {
      command = "MIND",
      rtype = "integer",
      params = {},
      description = [[
        Returns whether the creature TARG's brain is being processed or not.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MOTR"] = {
    ["command"] = {
      command = "MOTR",
      rtype = "command",
      params = {
        { "state", "integer" } },
      description = [[
        Enable (1) or disable (0) the creature's motor faculty, i.e. whether it sets the IT object 
        and fires off scripts.
      ]],
      callback =
        function(self, state )
        end
    },

    ["integer"] = {
      command = "MOTR",
      rtype = "integer",
      params = {},
      description = [[
        Returns whether the creature TARG's motor faculty is being processed or not.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MVFT"] = {
    ["command"] = {
      command = "MVFT",
      rtype = "command",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Move creature's down foot to position x,y.  Use this instead of @MVTO@ for creatures.
      ]],
      callback =
        function(self, x, y )
        end
    }
  },


  ["NEW: CRAG"] = {
    ["command"] = {
      command = "NEW: CRAG",
      rtype = "command",
      params = {
        { "family", "integer" },  { "gene_agent", "agent" },  { "gene_slot", "integer" },  { "sex", "integer" },  { "variant", "integer" },  { "sprite_file", "string" },  { "image_count", "integer" },  { "first_image", "integer" },  { "plane", "integer" } },
      description = [[
        Makes a non-skeletal creature.  The first five arguments are the same as @NEW: CREA@.  The last four, 
        starting from the sprite file, are exactly as in @NEW: COMP@.
      ]],
      callback =
        function(self, family, gene_agent, gene_slot, sex, variant, sprite_file, image_count, first_image, plane )
        end
    }
  },


  ["NEW: CREA"] = {
    ["command"] = {
      command = "NEW: CREA",
    rtype = "command",
    params = {
      { "family", "integer" },  { "gene_agent", "agent" },  { "gene_slot", "integer" },  { "sex", "integer" },  { "variant", "integer" } },
    description = [[
      Makes a creature using the genome from the given gene slot in another agent.  You'll want to 
      use @GENE CROS@ or @GENE LOAD@ to fill that slot in first.  The gene slot is cleared, as 
      control of that genome is moved to the special slot 0 of the new creature, where it is 
      expressed.  Sex is 1 for male, 2 for female or 0 for random.  The variant can also be 
      0 for a random value between 1 and 8.  See also @NEWC@.
    ]],
    callback =
      function(self, family, gene_agent, gene_slot, sex, variant )
      end
    }
  },


  ["NEWC"] = {
    ["command"] = {
      command = "NEWC",
      rtype = "command",
      params = {
        { "family", "integer" },  { "gene_agent", "agent" },  { "gene_slot", "integer" },  { "sex", "integer" },  { "variant", "integer" } },
      description = [[
        This version of @NEW: CREA@ executes over a series of ticks, helping to prevent the pause caused by 
        the creation of a creature with the @NEW: CREA@ command. However, it cannot be used in install scripts (
        e.g. the bootstrap) and so @NEW: CREA@ should be used for that.
      ]],
      callback =
        function(self, family, gene_agent, gene_slot, sex, variant )
        end
    }
  },


  ["NORN"] = {
    ["command"] = {
      command = "NORN",
      rtype = "command",
      params = {
        { "creature", "agent" } },
      description = [[
        Chooses the active creature.  Script 120 (@Selected Creature Changed@) is then executed on all agents which have it.
        
      ]],
      callback =
        function(self, creature )
        end
    },

    ["agent"] = {
      command = "NORN",
      rtype = "agent",
      params = {},
      description = [[
        Returns the creature currently selected by the user.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },


  ["NUDE"] = {
    ["command"] = {
      command = "NUDE",
    rtype = "command",
    params = {},
    description = [[
      Removes all clothes from a creature.  Any changed layer 0 will revert to drawing the body part again.  
      See @WEAR@.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["ORDR SHOU"] = {
    ["command"] = {
      command = "ORDR SHOU",
      rtype = "command",
      params = {
        { "speech", "string" } },
      description = [[
        Sends a spoken command from target to all creatures that can hear it.
      ]],
      callback =
        function(self, speech )
        end
    }
  },


  ["ORDR SIGN"] = {
    ["command"] = {
      command = "ORDR SIGN",
      rtype = "command",
      params = {
        { "speech", "string" } },
      description = [[
        Sends a spoken command from target to all creatures that can see it.
      ]],
      callback =
        function(self, speech )
        end
    }
  },


  ["ORDR TACT"] = {
    ["command"] = {
      command = "ORDR TACT",
      rtype = "command",
      params = {
        { "speech", "string" } },
      description = [[
        Sends a spoken command from target to all creatures that are touching it.
      ]],
      callback =
        function(self, speech )
        end
    }
  },


  ["ORDR WRIT"] = {
    ["command"] = {
      command = "ORDR WRIT",
      rtype = "command",
      params = {
        { "creature", "agent" },  { "speech", "string" } },
      description = [[
        Sends a spoken command from target to the specified creature.
      ]],
      callback =
        function(self, creature, speech )
        end
    }
  },


  ["ORGF"] = {
    ["float"] = {
      command = "ORGF",
    rtype = "float",
    params = {
      { "organ_number", "integer" },  { "data", "integer" } },
    description = [[
      Returns floating point data about the specified organ.  The organ number is from 0 to @ORGN@ - 1.  The data parameter specifies what information is returned:
      0 - Clock rate in updates per tick (as locus)
      1 - Short term life force as a proportion of intial (as locus)
      2 - Factor to modulate rate of repair (as locus)
      3 - Injury to apply (as locus)
      4 - Initial life force, a million is the largest initial value
      5 - Short term life force, temporary damage
      6 - Long term life force, permanent damage
      7 - Long term rate damage during repair
      8 - Energy cost to run this organ, calculated from the number of receptors, emitters and reactions
      9 - Damage done to the organ if no energy is available
    ]],
    callback =
      function(self, organ_number, data )
        return 0.0
      end
    }
  },


  ["ORGI"] = {
    ["integer"] = {
      command = "ORGI",
    rtype = "integer",
    params = {
      { "organ_number", "integer" },  { "data", "integer" } },
    description = [[
      Returns integer data about the specified organ.  The organ number is from 0 to @ORGN@ - 1.  The data parameter specifies what information is returned:
      0 - receptor count
      1 - emitter count
      2 - reaction count.
    ]],
    callback =
      function(self, organ_number, data )
        return 0
      end
    }
  },


  ["ORGN"] = {
    ["integer"] = {
      command = "ORGN",
      rtype = "integer",
      params = {},
      description = [[
        Returns the number of organs in target creature.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["PLMD"] = {
    ["command"] = {
      command = "PLMD",
      rtype = "command",
      params = {
        { "tract_index,", "integer" },  { "filename", "string" } },
      description = [[
        Dumps out all the dendrite learned information of the specified tract to a file (will be changed to 
        sync with Palm).
      ]],
      callback =
        function(self, tract_index, filename )
        end
    }
  },


  ["PLMU"] = {
    ["command"] = {
      command = "PLMU",
      rtype = "command",
      params = {
        { "tract_index,", "integer" },  { "filename", "string" } },
      description = [[
        Configures the dendrites in the specified tract with the data in the file (will be changed to sync 
        with Palm).
      ]],
      callback =
        function(self, tract_index, filename )
        end
    }
  },


  ["SAYN"] = {
    ["command"] = {
      command = "SAYN",
    rtype = "command",
    params = {},
    description = [[
      Creature expresses need, by speaking.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["SEEN"] = {
    ["agent"] = {
      command = "SEEN",
      rtype = "agent",
      params = {
        { "category", "integer" } },
      description = [[
        Returns the agent which the creature TARG has currently in mind for the category specified.
      ]],
      callback =
        function(self, category )
          return nil
        end
    }
  },


  ["SOUL"] = {
    ["command"] = {
      command = "SOUL",
      rtype = "command",
      params = {
        { "facultyId", "integer" },  { "on", "integer" } },
      description = [[
        Enable (1) or disable (0) the update on the creature's faculty as given by type id as 
        follows: Sensory Faculty (0), Brain (1), Motor Faculty (2), Linguistic Faculty (3), Biochemistry (4), Reproductive Faculty (5), Expressive 
        Faculty (6), Music Faculty (7), Life Faculty (8)
      ]],
      callback =
        function(self, facultyId, on )
        end
    },

    ["integer"] = {
      command = "SOUL",
      rtype = "integer",
      params = {
        { "facultyId", "integer" } },
      description = [[
        Returns whether the creature faculty of the type specified is being processed or not.
      ]],
      callback =
        function(self, facultyId )
          return 0
        end
    }
  },


  ["SPNL"] = {
    ["command"] = {
      command = "SPNL",
      rtype = "command",
      params = {
        { "lobe_moniker", "string" },  { "neuron_id", "integer" },  { "value", "float" } },
      description = [[
        This sets the input of the neuron in the lobe specified to be the value given.
      ]],
      callback =
        function(self, lobe_moniker, neuron_id, value )
        end
    }
  },


  ["STEP"] = {
    ["command"] = {
      command = "STEP",
      rtype = "command",
      params = {
        { "facultyId", "integer" } },
      description = [[
        Does one update of the specified faculty (for faculty id see @SOUL#@).
      ]],
      callback =
        function(self, facultyId )
        end
    }
  },


  ["STIM SHOU"] = {
    ["command"] = {
      command = "STIM SHOU",
    rtype = "command",
    params = {
      { "stimulus", "integer" },  { "strength", "float" } },
    description = [[
      Shout a stimulus to all creatures who can hear @OWNR@.  The strength is a multiplier for the stimulus.  
      Set to 1 for a default stimulation, 2 for a stronger stimulation and so on.  It is important 
      you use this, rather than send several stims, as it affects learning.  Set strength to 0 to prevent 
      learning altogether, and send a strength 1 chemical change.  See the table of @Stimulus Numbers@.
    ]],
    callback =
      function(self, stimulus, strength )
      end
    }
  },


  ["STIM SIGN"] = {
    ["command"] = {
      command = "STIM SIGN",
      rtype = "command",
      params = {
        { "stimulus", "integer" },  { "strength", "float" } },
      description = [[
        Send a stimulus to all creatures who can see @OWNR@.
      ]],
      callback =
        function(self, stimulus, strength )
        end
    }
  },


  ["STIM TACT"] = {
    ["command"] = {
      command = "STIM TACT",
      rtype = "command",
      params = {
        { "stimulus", "integer" },  { "strength", "float" } },
      description = [[
        Send a stimulus to all creatures who are touching @OWNR@.
      ]],
      callback =
        function(self, stimulus, strength )
        end
    }
  },


  ["STIM WRIT"] = {
    ["command"] = {
      command = "STIM WRIT",
      rtype = "command",
      params = {
        { "creature", "agent" },  { "stimulus", "integer" },  { "strength", "float" } },
      description = [[
        Send stimulus to a specific creature.  Can be used from an install script, but the stimulus will be 
        from @NULL@, so the creature will react but not learn.
      ]],
      callback =
        function(self, creature, stimulus, strength )
        end
    }
  },


  ["SWAY SHOU"] = {
    ["command"] = {
      command = "SWAY SHOU",
      rtype = "command",
      params = {
        { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" } },
      description = [[
        Stimulate all creatures that can hear @OWNR@ to adjust four drives by the given amounts.
      ]],
      callback =
        function(self, drive, adjust, drive, adjust, drive, adjust, drive, adjust )
        end
    }
  },


  ["SWAY SIGN"] = {
    ["command"] = {
      command = "SWAY SIGN",
      rtype = "command",
      params = {
        { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" } },
      description = [[
        Stimulate all creatures that can see @OWNR@ to adjust four drives by the given amounts.
      ]],
      callback =
        function(self, drive, adjust, drive, adjust, drive, adjust, drive, adjust )
        end
    }
  },


  ["SWAY TACT"] = {
    ["command"] = {
      command = "SWAY TACT",
      rtype = "command",
      params = {
        { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" } },
      description = [[
        Stimulate all creatures that are touching @OWNR@ to adjust four drives by the given amounts.
      ]],
      callback =
        function(self, drive, adjust, drive, adjust, drive, adjust, drive, adjust )
        end
    }
  },


  ["SWAY WRIT"] = {
    ["command"] = {
      command = "SWAY WRIT",
      rtype = "command",
      params = {
        { "creature", "agent" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" },  { "drive", "integer" },  { "adjust", "float" } },
      description = [[
        Stimulate a specific creature to adjust four drives by the given amounts.
      ]],
      callback =
        function(self, creature, drive, adjust, drive, adjust, drive, adjust, drive, adjust )
        end
    }
  },


  ["TAGE"] = {
    ["integer"] = {
      command = "TAGE",
    rtype = "integer",
    params = {},
    description = [[
      Returns the age in ticks since the target creature was @BORN@.  Ticking stops when the creature dies - see @
      DEAD@.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["UFTX"] = {
    ["float"] = {
      command = "UFTX",
      rtype = "float",
      params = {},
      description = [[
        Returns X coordinate of creature's up foot.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["UFTY"] = {
    ["float"] = {
      command = "UFTY",
      rtype = "float",
      params = {},
      description = [[
        Returns Y coordinate of creature's up foot.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["UNCS"] = {
    ["command"] = {
      command = "UNCS",
      rtype = "command",
      params = {
        { "unconscious", "integer" } },
      description = [[
        Make the creature conscious or unconscious.  0 for conscious, 1 for unconscious.
      ]],
      callback =
        function(self, unconscious )
        end
    },

    ["integer"] = {
      command = "UNCS",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if the creature is unconscious, 0 otherwise.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["URGE SHOU"] = {
    ["command"] = {
      command = "URGE SHOU",
      rtype = "command",
      params = {
        { "noun_stim", "float" },  { "verb_id", "integer" },  { "verb_stim", "float" } },
      description = [[
        Urge all creatures who can hear @OWNR@ to perform the verb_id action on @OWNR@.  Stimuli can range from -
        1 to 1, ranging from discourage to encourage.
      ]],
      callback =
        function(self, noun_stim, verb_id, verb_stim )
        end
    }
  },


  ["URGE SIGN"] = {
    ["command"] = {
      command = "URGE SIGN",
      rtype = "command",
      params = {
        { "noun_stim", "float" },  { "verb_id", "integer" },  { "verb_stim", "float" } },
      description = [[
        Urge all creatures who can see @OWNR@ to perform an action on @OWNR@.
      ]],
      callback =
        function(self, noun_stim, verb_id, verb_stim )
        end
    }
  },


  ["URGE TACT"] = {
    ["command"] = {
      command = "URGE TACT",
      rtype = "command",
      params = {
        { "noun_stim", "float" },  { "verb_id", "integer" },  { "verb_stim", "float" } },
      description = [[
        Urge all creatures who are touching @OWNR@ to perform an action on @OWNR@.
      ]],
      callback =
        function(self, noun_stim, verb_id, verb_stim )
        end
    }
  },


  ["URGE WRIT"] = {
    ["command"] = {
      command = "URGE WRIT",
      rtype = "command",
      params = {
        { "creature", "agent" },  { "noun_id", "integer" },  { "noun_stim", "float" },  { "verb_id", "integer" },  { "verb_stim", "float" } },
      description = [[
        Urge a specific creature to perform a specific action on a specific noun.  A stimulus greater than 1 
        will <i>force</i> the Creature to perform an action, or to set its attention (mind control!).  Use 
        an id -1 and stim greater than 1 to unforce it.
      ]],
      callback =
        function(self, creature, noun_id, noun_stim, verb_id, verb_stim )
        end
    }
  },


  ["VOCB"] = {
    ["command"] = {
      command = "VOCB",
    rtype = "command",
    params = {},
    description = [[
      Learn all vocabulary instantly.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["WALK"] = {
    ["command"] = {
      command = "WALK",
    rtype = "command",
    params = {},
    description = [[
      Sets creature walking indefinitely. Chooses a walking gait according to chemo-receptors.  Always means ignore IT and walk 
      in the current direction set by @DIRN@.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["WEAR"] = {
    ["command"] = {
      command = "WEAR",
    rtype = "command",
    params = {
      { "body_id", "integer" },  { "set_number", "integer" },  { "layer", "integer" } },
    description = [[
      Sets a layer of clothing on part of the creature.  The set_number is the type of clothing to 
      put on from the overlay file - think of it as an outfit number.  layer 0 is the actual 
      body of the creature, so unless you want to replace the body part itself use a higher layer.  
      Higher layers are on top of lower ones. e.g. 0 for a face, 1 for measels spots, 
      2 for a fencing mask.  See also @BODY@ and @NUDE@.
    ]],
    callback =
      function(self, body_id, set_number, layer )
      end
    }
  },


  ["ZOMB"] = {
    ["command"] = {
      command = "ZOMB",
      rtype = "command",
      params = {
        { "zombie", "integer" } },
      description = [[
        Make or undo the creature's zombification factor.  1 makes creatures zombies: in a zombie state creatures won'
        t process any decision scripts but they will respond to @POSE@s.  0 umzombifies.
      ]],
      callback =
        function(self, zombie )
        end
    },

    ["integer"] = {
      command = "ZOMB",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if the creature is zombified (has its brain to motor link severed), 0 otherwise.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["AGNT"] = {
    ["agent"] = {
      command = "AGNT",
    rtype = "agent",
    params = {
      { "unique_id", "integer" } },
    description = [[
      Given a unique identifier, returns the corresponding agent.  Returns @NULL@ if the agent no longer exists.  @UNID@ extracts 
      the unique id.  NOTE: This should only be used for external programs to persistently refer to an agent 
      during a session. Variables can use @SETA@ to store agent r-values directly for internal use.  Unique identifiers 
      can change across saved sessions.
    ]],
    callback =
      function(self, unique_id )
        return nil
      end
    }
  },


  ["APRO"] = {
    ["command"] = {
      command = "APRO",
      rtype = "command",
      params = {
        { "search_text", "string" } },
      description = [[
        Lists all command names whose help contains the text.
      ]],
      callback =
        function(self, search_text )
        end
    }
  },

  -- full
  ["BANG"] = {
    ["command"] = {
      command = "BANG",
      rtype = "command",
      params = {},
      description = [[
        Causes a division by zero exception in the processor, to test the engine's error handling routines.
      ]],
      callback =
        function(self)
          error("BANG! DIVISION BY 0 (but not really)")
        end
    }
  },


  ["CODE"] = {
    ["integer"] = {
      command = "CODE",
      rtype = "integer",
      params = {},
      description = [[
        Returns event script number currently being run by target. Returns -1 if not running anything.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CODF"] = {
    ["integer"] = {
      command = "CODF",
      rtype = "integer",
      params = {},
      description = [[
        Returns family of script currently being run by target. Returns -1 if not running anything.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CODG"] = {
    ["integer"] = {
      command = "CODG",
      rtype = "integer",
      params = {},
      description = [[
        Returns genus of script currently being run by target. Returns -1 if not running anything.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CODP"] = {
    ["integer"] = {
      command = "CODP",
    rtype = "integer",
    params = {},
    description = [[
      Returns the offset into the source code of the next instruction to be executed by the target. Use @
      SORC@ to get the source code.  Returns -1 if not running anything.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["CODS"] = {
    ["integer"] = {
      command = "CODS",
      rtype = "integer",
      params = {},
      description = [[
        Returns species of script currently being run by target. Returns -1 if not running anything.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["DBG#"] = {
    ["string"] = {
      command = "DBG#",
    rtype = "string",
    params = {
      { "variable", "integer" } },
    description = [[
      Dumps debug information for the virtual machine of target.  Whatever the type of the variable, a string is output.
      Variable can be:
       -1 : Whether in INST or not
       -2 : Whether in LOCK or not
       -3 : Current TARG of virtual machine
       -4 : OWNR - should be the same as our outer TARG
       -5 : FROM - who sent the message which is being run
       -6 : IT - if a Creature, where their attention was
       -7 : PART - part number being worked on for compound agents
       -8 : _P1_ - first parameter of message, if in a message
       -9 : _P2_ - second parameter of message, if in a mesesage
       0 to 99 : Local variables VA00 to VA99
    ]],
    callback =
      function(self, variable )
        local result = ""
        if ( variable == -1 ) then
          result = tostring(self.instant_execution)
        elseif ( variable == -2 ) then
          result = tostring(self.no_interrupt)
        elseif ( variable == -3 ) then
        elseif ( variable == -4 ) then
        elseif ( variable == -5 ) then
        elseif ( variable == -6 ) then
        elseif ( variable == -7 ) then
        elseif ( variable == -8 ) then
        elseif ( variable == -9 ) then
        elseif ( variable >= 0 and variable <= 99 ) then
          result = tostring(self.vm.caos_vars[variable+1])
        end
        return result
      end
    }
  },

  -- full/not sure
  ["DBG: ASRT"] = {
    ["command"] = {
      command = "DBG: ASRT",
    rtype = "command",
    params = {
      { "condition", "condition" } },
    description = [[
      Confirms that a condition is true.  If it isn't, it displays a runtime error dialog.
    ]],
    callback =
      function(self, condition )
        assert(condition)
      end
    }
  },


  ["DBG: CPRO"] = {
    ["command"] = {
      command = "DBG: CPRO",
    rtype = "command",
    params = {},
    description = [[
      Clears agent profiling information.  Measurements output with @DBG: PROF@ start here.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: FLSH"] = {
    ["command"] = {
      command = "DBG: FLSH",
    rtype = "command",
    params = {},
    description = [[
      This flushes the system's input buffers - usually only useful if @DBG: PAWS@ed.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: HTML"] = {
    ["command"] = {
      command = "DBG: HTML",
      rtype = "command",
      params = {
        { "sort_order", "integer" } },
      description = [[
        Sends CAOS documentation to the output stream.  Sort order is 0 for alphabetical, 1 for categorical.
      ]],
      callback =
        function(self, sort_order)
        end
    }
  },

  -- full
  ["DBG: OUTS"] = {
    ["command"] = {
      command = "DBG: OUTS",
      rtype = "command",
      params = {
        { "value", "string" } },
      description = [[
        Send a string to the debug log - use @DBG: POLL@ to retrieve.
      ]],
      callback =
        function(self, value )
          world.logInfo("%s", value)
        end
    }
  },

  -- full
  ["DBG: OUTV"] = {
    ["command"] = {
      command = "DBG: OUTV",
      rtype = "command",
      params = {
        { "value", "decimal" } },
      description = [[
        Send a number to the debug log - use @DBG: POLL@ to retrieve.
      ]],
      callback =
        function(self, value )
          world.logInfo("%s", "" .. value)
        end
    }
  },


  ["DBG: PAWS"] = {
    ["command"] = {
      command = "DBG: PAWS",
    rtype = "command",
    params = {},
    description = [[
      This pauses everything in the game. No game driven ticks will occur until a @DBG: PLAY@ command is 
      issued, so this command is only useful for debugging.  Use @PAUS@ for pausing of specific agents, which you 
      can use to implement a pause button.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: PLAY"] = {
    ["command"] = {
      command = "DBG: PLAY",
    rtype = "command",
    params = {},
    description = [[
      This command undoes a previously given @DBG: PAWS@ and allows game time to flow as normal.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: POLL"] = {
    ["command"] = {
      command = "DBG: POLL",
    rtype = "command",
    params = {},
    description = [[
      This takes all of the @DBG: OUTV@ and @DBG: OUTS@ output to date and writes it to the 
      output stream.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: PROF"] = {
    ["command"] = {
      command = "DBG: PROF",
    rtype = "command",
    params = {},
    description = [[
      Sends agent profile information to the output stream.  This gives you data about the time the engine spends 
      running the update and message handling code for each classifier.  The data is measured from engine startup, or 
      the point marked with @DBG: CPRO@.  It's output in comma separated value (CSV) format, so you can 
      load it into a spreadsheet (e.g. Gnumeric or Excel) for sorting and summing.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: TACK"] = {
    ["command"] = {
      command = "DBG: TACK",
    rtype = "command",
    params = {
      { "follow", "agent" } },
    description = [[
      Pauses the game when the given agent next executes a single line of CAOS code.  This pause is 
      mid-tick, and awaits incoming requests, or the pause key.  Either another DBG: TACK or a @DBG: PLAY@ 
      command will make the engine carry on.  Any other incoming requests will be processed as normal.  However, the 
      virtual machine of the tacking agent is effectively in mid-processing, so some CAOS commands may cause unpredictable 
      results, and even crash the engine.  In particular, you shouldn't @KILL@ the tacking agent.  You can see 
      which agent is being tracked with @TACK@.
    ]],
    callback =
      function(self, follow )
      end
    }
  },


  ["DBG: TOCK"] = {
    ["command"] = {
      command = "DBG: TOCK",
    rtype = "command",
    params = {},
    description = [[
      This command forces a tick to occur. It is useful in external apps to drive the game according 
      to a different clock instead of the game clock.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DBG: WTIK"] = {
    ["command"] = {
      command = "DBG: WTIK",
      rtype = "command",
      params = {
        { "new_world_tick", "integer" } },
      description = [[
        Changes the world tick @WTIK@ to the given value.  This should only be used for debugging, as it 
        will potentially leave confusing information in the creature history, and change the time when delayed messages are processed.  
        Its main use is to jump to different seasons and times of day.
      ]],
      callback =
        function(self, new_world_tick )
        end
    }
  },


  ["DBGA"] = {
    ["string"] = {
      command = "DBGA",
      rtype = "string",
      params = {
        { "variable", "integer" } },
      description = [[
        Dumps debug information for target.  Whatever the type of the variable, a string is output.
        Variable can be:
        0 to 99 : agent variables OV00 to OV99
        -1 : Counter for timer tick
      ]],
      callback =
        function(self, variable )
          local result = ""
          if ( variable == -1 ) then
          elseif ( variable >= 0 and variable <= 99 ) then
            result = tostring(self.vm.target:getVar("caos_vars_" .. variable+1))
          end
          return result
        end
    }
  },


  ["HEAP"] = {
    ["integer"] = {
      command = "HEAP",
      rtype = "integer",
      params = {
        { "index", "integer" } },
      description = [[
        Returns heap and garbage collection information.
        0 - current allocated heap memory (development builds only)
        1 - total agents, including ones waiting to be garbage collected
        2 - similar, but just for creatures
      ]],
      callback =
        function(self, index )
          return 0
        end
    }
  },


  ["HELP"] = {
    ["command"] = {
      command = "HELP",
      rtype = "command",
      params = {},
      description = [[
        Lists all command names to the output stream.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["MANN"] = {
    ["command"] = {
      command = "MANN",
      rtype = "command",
      params = {
        { "command", "string" } },
      description = [[
        Outputs help on the given command to the output stream.
      ]],
      callback =
        function(self, command )
        end
    }
  },


  ["MEMX"] = {
    ["command"] = {
      command = "MEMX",
      rtype = "command",
      params = {},
      description = [[
        Windows only.  Sends information about the memory allocated to the output stream.  In order, these are the Memory 
        Load (unknown), Total Physical (size in bytes of physical memory), Available Physical (free physical space), Total Page File (
        maximum possible size of page file), Available Page File (size in bytes of space available in paging file), 
        Total Virtual (size of user mode portion of the virtual address space of the engine), Available Virtual (size 
        of unreserved and uncommitted memory in the user mode portion of the virtual address space of the engine).
        
      ]],
      callback =
        function(self)
        end
    }
  },


  ["PAWS"] = {
    ["integer"] = {
      command = "PAWS",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 for debug pawsed, 0 for playing.  See @DBG: PAWS@.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["TACK"] = {
    ["agent"] = {
      command = "TACK",
      rtype = "agent",
      params = {},
      description = [[
        Returns the agent currently being @DBG: TACK@ed.
      ]],
      callback =
        function(self)
          return nil
        end
    }
  },


  ["UNID"] = {
    ["integer"] = {
      command = "UNID",
    rtype = "integer",
    params = {},
    description = [[
      Returns unique identifier for target agent.  @AGNT@ goes the opposite way.  NOTE: This should only be used for 
      external programs to persistently refer to an agent for a session.  Variables can use @SETA@ to store agent 
      r-values directly for internal use.  The unique identifier of an agent can change if you save a 
      world and load it in again.
    ]],
    callback =
      function(self)
        return self.vm.target.id
      end
    }
  },


  ["FILE GLOB"] = {
    ["command"] = {
      command = "FILE GLOB",
    rtype = "command",
    params = {
      { "directory", "integer" },  { "filespec", "string" } },
    description = [[
      This globs a journal directory (0 for world one, 1 for main one) for the filespec provided. As 
      all this can do is list files, it does not worry about where you look relative to the 
      journal directory in question. Use this with care. 
      Having globbed a directory, the listing is available on 
      the input stream as a number, followed by the names of each file. To read - ise @INOK@, @INNI@ 
      and @INNL@. Once you have finished, remember to do a @FILE ICLO@ to remove the glob output from 
      the VM.
    ]],
    callback =
      function(self, directory, filespec )
      end
    }
  },


  ["FILE ICLO"] = {
    ["command"] = {
      command = "FILE ICLO",
    rtype = "command",
    params = {},
    description = [[
      Disconnects anything which is attached to the input stream.  If this is a file, then the file is 
      closed.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["FILE IOPE"] = {
    ["command"] = {
      command = "FILE IOPE",
    rtype = "command",
    params = {
      { "directory", "integer" },  { "filename", "string" } },
    description = [[
      Sets the file for the input stream of the current virtual machine - there is a virtual machine for 
      each agent, so this is much the same as setting it for @OWNR@.  Use @INNL@, @INNI@ and @INNF@ 
      to get data from the stream, and @INOK@ to check validity of the stream.  The filename should include 
      any file extension.
      You should use @FILE ICLO@ to close the file, although this happens automatically if 
      you set a new file, if the virtual machine is destroyed, or if the engine exits.
      Directory 
      is 0 for the current world's journal directory, 1 for the main journal directory, or 2 for 
      the @GAME@ @engine_other_world@ world's journal directory.
    ]],
    callback =
      function(self, directory, filename )
      end
    }
  },


  ["FILE JDEL"] = {
    ["command"] = {
      command = "FILE JDEL",
      rtype = "command",
      params = {
        { "directory", "integer" },  { "filename", "string" } },
      description = [[
        This deletes the file (filename) specified from the journal directory specified. If directory is zero, this is the 
        current world's journal directory, otherwise it is the main journal directory.  It deletes the file immediately, rather 
        than marking it for the attic.
      ]],
      callback =
        function(self, directory, filename )
        end
    }
  },


  ["FILE OCLO"] = {
    ["command"] = {
      command = "FILE OCLO",
    rtype = "command",
    params = {},
    description = [[
      Disconnects anything which is attached to the output stream.  If this is a file, then the file is 
      closed.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["FILE OFLU"] = {
    ["command"] = {
      command = "FILE OFLU",
    rtype = "command",
    params = {},
    description = [[
      Flush output stream.  If it is attached to a disk file, this will force any data in the 
      buffer to be written to disk.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["FILE OOPE"] = {
    ["command"] = {
      command = "FILE OOPE",
    rtype = "command",
    params = {
      { "directory", "integer" },  { "filename", "string" },  { "append", "integer" } },
    description = [[
      Sets the file for the output stream of the current virtual machine - there is a virtual machine for 
      each agent, so this is much the same as setting it for @OWNR@.  Use @OUTV@ and @OUTS@ or 
      various other commands to send text data to the stream.  The filename should include any file extension.
      
      You should use @FILE OCLO@ to close the file, although this happens automatically if you set a new 
      file, if the virtual machine is destroyed, or if the engine exits.
      Directory is 0 for the 
      current world's journal directory, 1 for the main journal directory, or 2 for the @GAME@ @engine_other_world@ world'
      s journal directory.  Set append to 1 to add to the end of the file, or 0 to 
      replace any existing file.
    ]],
    callback =
      function(self, directory, filename, append )
      end
    }
  },


  ["FVWM"] = {
    ["string"] = {
      command = "FVWM",
      rtype = "string",
      params = {
        { "name", "string" } },
      description = [[
        This returns a guaranteed-safe filename for use in world names, journal file names, etc.
      ]],
      callback =
        function(self, name )
          return ""
        end
    }
  },


  ["INNF"] = {
    ["float"] = {
      command = "INNF",
    rtype = "float",
    params = {},
    description = [[
      Retrieves a float from the input stream, delimited by white space.  Defaults to 0.0 if no valid 
      data.
    ]],
    callback =
      function(self)
        return 0.0
      end
    }
  },


  ["INNI"] = {
    ["integer"] = {
      command = "INNI",
    rtype = "integer",
    params = {},
    description = [[
      Retrieves an integer from the input stream, delimited by white space.  Defaults to 0 if no valid data.
      
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["INNL"] = {
    ["string"] = {
      command = "INNL",
      rtype = "string",
      params = {},
      description = [[
        Retrieves a line of text from the input stream.
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["INOK"] = {
    ["integer"] = {
      command = "INOK",
    rtype = "integer",
    params = {},
    description = [[
      Returns 1 if the input stream is good, or 0 if it is bad.  A bad stream could 
      be a non existent file, or the end of file reached.  If the stream has never been opened 
      at all, an error is displayed.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },

  -- partial
  ["OUTS"] = {
    ["command"] = {
      command = "OUTS",
    rtype = "command",
    params = {
      { "text", "string" } },
    description = [[
      Sends a string to the output stream.  When running a script, the stream is null and this command 
      does nothing.  For an externally injected command, the data from the stream is returned to the calling process.  
      For the @CAOS@ command, the text is returned as a string.  You can use @FILE OOPE@ to set 
      the stream to a journal file.
    ]],
    callback =
      function(self, text )
        world.logInfo("%s", text)
      end
    }
  },

  -- partial
  ["OUTV"] = {
    ["command"] = {
      command = "OUTV",
      rtype = "command",
      params = {
        { "value", "decimal" } },
      description = [[
        Similar to @OUTS@ only outputs a float or integer as a decimal string.
      ]],
      callback =
        function(self, value )
          world.logInfo("%s", "" .. value)
        end
    }
  },

  -- partial
  ["OUTX"] = {
    ["command"] = {
      command = "OUTX",
    rtype = "command",
    params = {
      { "text", "string" } },
    description = [[
      This sends the string <i>text</i> to the output stream. However it first transforms 
      any escapes into quoted escapes, and it also quotes the entire string for you.
      
      e.g.:
      outx "Moooose\n"
      Would produce:
      "Moooose\n"
      on the output stream 
      instead of:
      Moooose
      
    ]],
    callback =
      function(self, text )
        world.logInfo("%s", text)
      end
    }
  },

  -- full
  ["WEBB"] = {
    ["command"] = {
      command = "WEBB",
      rtype = "command",
      params = {
        { "http_url", "string" } },
      description = [[
        Launches an external URL in the user's browser. The game engine adds http:// at the beginning to 
        prevent malicious launching of programs, so you just need to specify the domain name and path.
      ]],
      callback =
        function(self, http_url )
          world.logInfo("URL: http://", http_url)
        end
    }
  },


  ["DOIF"] = {
    ["command"] = {
      command = "DOIF",
      rtype = "command",
      params = {
        { "condition", "condition" } },
      description = [[
        Execute a block of code if the condition is true.  The code block ends at the next @ELSE@, @ELIF@ or @ENDI@. 
        A condition is composed of one or more comparisons joined by AND or OR.  A comparison compares two values 
        with EQ, NE, GT, GE, LT, LE, or alternatively =, <>, >, >=, <, <=.
        
        DOIF ov00 GE 5 AND ov00 LT 10
        --- code block 1 ---
        ELIF ov00 GE 10 OR ov00 LT 100
        --- code block 2 ---
        ELSE
        --- code block 3 ---
        ENDI
        
        Conditions are evaluated simply from left to right, so "a AND b OR c" is the same as "(
        a AND b) OR c", not "a AND ( b OR c )".
        Conditional statements may not work correctly 
        with commands overloaded by rvalue.
      ]],
      callback =
        function(self, condition )
        end
    }
  },


  ["____internal_and"] = {
    ["condition"] = {
      command = "____internal_and",
      rtype = "condition",
      params = {
        { "lhs", "condition", "rhs", "condition" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs > 0 and rhs > 0) and 1 or 0
        end
    }
  },
  ["____internal_or"] = {
    ["condition"] = {
      command = "____internal_or",
      rtype = "condition",
      params = {
        { "lhs", "condition", "rhs", "condition" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs > 0 or rhs > 0) and 1 or 0
        end
    }
  },

  ["____internal_eq"] = {
    ["condition"] = {
      command = "____internal_eq",
      rtype = "condition",
      params = {
        { "lhs", "any", "rhs", "any" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs == rhs) and 1 or 0
        end
    }
  },
  ["____internal_ne"] = {
    ["condition"] = {
      command = "____internal_ne",
      rtype = "condition",
      params = {
        { "lhs", "any", "rhs", "any" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs ~= rhs) and 1 or 0
        end
    }
  },
  ["____internal_gt"] = {
    ["condition"] = {
      command = "____internal_gt",
      rtype = "condition",
      params = {
        { "lhs", "any", "rhs", "any" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs > rhs) and 1 or 0
        end
    }
  },
  ["____internal_lt"] = {
    ["condition"] = {
      command = "____internal_lt",
      rtype = "condition",
      params = {
        { "lhs", "any", "rhs", "any" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs < rhs) and 1 or 0
        end
    }
  },
  ["____internal_ge"] = {
    ["condition"] = {
      command = "____internal_ge",
      rtype = "condition",
      params = {
        { "lhs", "any", "rhs", "any" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs >= rhs) and 1 or 0
        end
    }
  },
  ["____internal_le"] = {
    ["condition"] = {
      command = "____internal_le",
      rtype = "condition",
      params = {
        { "lhs", "any", "rhs", "any" } },
      description = [[
      ]],
      callback =
        function(self, lhs, rhs)
          return (lhs <= rhs) and 1 or 0
        end
    }
  },

  

  ["ELIF"] = {
    ["command"] = {
      command = "ELIF",
      rtype = "command",
      params = {
        { "condition", "condition" } },
      description = [[
        ELseIF command to follow a @DOIF@. If the condition in a DOIF is false, each following ELIF command 
        will be evaluated in turn.  Only the first true condition will have its code block executed.
      ]],
      callback =
        function(self, condition )
        end
    }
  },


  ["ELSE"] = {
    ["command"] = {
      command = "ELSE",
    rtype = "command",
    params = {},
    description = [[
      ELSE clause to follow @DOIF@ and @ELIF@(s). If nothing else matches, the ELSE block will be executed.
      
    ]],
    callback =
      function(self)
      end
    }
  },


  ["ENDI"] = {
    ["command"] = {
      command = "ENDI",
    rtype = "command",
    params = {},
    description = [[
      Closes a @DOIF@...@ELIF@...@ELSE@... set.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["EVER"] = {
    ["command"] = {
      command = "EVER",
    rtype = "command",
    params = {},
    description = [[
      Forms the end of a @LOOP@..EVER loop, which just loops forever.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["GOTO"] = {
    ["command"] = {
      command = "GOTO",
    rtype = "command",
    params = {
      { "destination", "label" } },
    description = [[
      Don't use this command.  It jumps directly to a label defined by @SUBR@. This command is only 
      here because it is used implicitly by @DOIF@ blocks. This is a really dangerous command to use manually, 
      because if you jump out of a block of code (eg a @LOOP@...@EVER@ block), the stack frame 
      will no longer be correct, and the script will most likely crash. Don't use it!  See @SUBR@.
      
    ]],
    callback =
      function(self, destination )
      end
    }
  },


  ["GSUB"] = {
    ["command"] = {
      command = "GSUB",
      rtype = "command",
      params = {
        { "destination", "label" } },
      description = [[
        Jumps to a subroutine defined by @SUBR@. Execution will continue at the instruction after the GSUB when the 
        subroutine hits a @RETN@ command.
      ]],
      callback =
        function(self, destination )
        end
    }
  },


  ["LOOP"] = {
    ["command"] = {
      command = "LOOP",
    rtype = "command",
    params = {},
    description = [[
      Begin a LOOP..@UNTL@ or LOOP..@EVER@ loop.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["REPE"] = {
    ["command"] = {
      command = "REPE",
    rtype = "command",
    params = {},
    description = [[
      Closes a @REPS@ loop.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["REPS"] = {
    ["command"] = {
      command = "REPS",
      rtype = "command",
      params = {
        { "count", "integer" } },
      description = [[
        Loop through a block of code a number of times. Must have a matching @REPE@ command to close 
        the block.
      ]],
      callback =
        function(self, count )
        end
    }
  },


  ["RETN"] = {
    ["command"] = {
      command = "RETN",
    rtype = "command",
    params = {},
    description = [[
      Return from subroutine. Do not use this instruction from inside a block of code (eg a @LOOP@#..@EVER@ 
      or @ENUM@...@NEXT@ etc...)!  See @SUBR@ and @GSUB@.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["SUBR"] = {
    ["command"] = {
      command = "SUBR",
    rtype = "command",
    params = { "label", "string" },
    description = [[
      Defines the start of a subroutine. Specify a label after the @SUBR@ command - the label is case sensitive, 
      and should start with a letter. If this instruction is hit during normal program flow, it works as 
      a @STOP@ instruction. See @GSUB@ and @RETN@.
    ]],
    callback =
      function(self, label)
        self:stop()
      end
    }
  },


  ["UNTL"] = {
    ["command"] = {
      command = "UNTL",
      rtype = "command",
      params = {
        { "condition", "condition" } },
      description = [[
        Forms the end of a @LOOP@..UNTL loop. The loop will execute until the condition is met.  See @
        DOIF@ for information on the form of the condition.
      ]],
      callback =
        function(self, condition )
        end
    }
  },


  ["GENE CLON"] = {
    ["command"] = {
      command = "GENE CLON",
      rtype = "command",
      params = {
        { "dest_agent", "agent" },  { "dest_slot", "integer" },  { "source_agent", "agent" },  { "source_slot", "integer" } },
      description = [[
        Clones a genome, creating a new moniker and copying the genetics file.
      ]],
      callback =
        function(self, dest_agent, dest_slot, source_agent, source_slot )
        end
    }
  },


  ["GENE CROS"] = {
    ["command"] = {
      command = "GENE CROS",
      rtype = "command",
      params = {
        { "child_agent", "agent" },  { "child_slot", "integer" },  { "mum_agent", "agent" },  { "mum_slot", "integer" },  { "dad_agent", "agent" },  { "dad_slot", "integer" },  { "mum_chance_of_mutation", "integer" },  { "mum_degree_of_mutation", "integer" },  { "dad_chance_of_mutation", "integer" },  { "dad_degree_of_mutation", "integer" } },
      description = [[
        Crosses two genomes with mutation, and fills in a child geneme slot.  Mutation variables may be in the 
        range of 0 to 255.
      ]],
      callback =
        function(self, child_agent, child_slot, mum_agent, mum_slot, dad_agent, dad_slot, mum_chance_of_mutation, mum_degree_of_mutation, dad_chance_of_mutation, dad_degree_of_mutation )
        end
    }
  },


  ["GENE KILL"] = {
    ["command"] = {
      command = "GENE KILL",
      rtype = "command",
      params = {
        { "agent", "agent" },  { "slot", "integer" } },
      description = [[
        Clears a genome slot.
      ]],
      callback =
        function(self, agent, slot )
        end
    }
  },


  ["GENE LOAD"] = {
    ["command"] = {
      command = "GENE LOAD",
    rtype = "command",
    params = {
      { "agent", "agent" },  { "slot", "integer" },  { "gene_file", "string" } },
    description = [[
      Loads an engineered gene file into a slot.  Slot 0 is a special slot used only for creatures, 
      and contains the moniker they express.  Only the @NEW: CREA@ command fills it in.  Other slot numbers are 
      used in pregnant creatures, in eggs, or to temporarily store a genome before expressing it with @NEW: CREA@.  
      You can use them as general purpose genome stores.
      The gene file can have any name, and 
      is loaded from the main genetics file.  A new moniker is generated, and a copy of the gene 
      file put in the world directory. You can use * and ? wildcards in the name, and a random matching 
      file will be used.
      You can also load monikered files from the world genetics directory with this 
      command.  If so, the file is copied and a new moniker generated.  Wildcards are matched first in the 
      main genetics directory, and only if none match is the world genetics directory searched.
    ]],
    callback =
      function(self, agent, slot, gene_file )
      end
    }
  },


  ["GENE MOVE"] = {
    ["command"] = {
      command = "GENE MOVE",
      rtype = "command",
      params = {
        { "dest_agent", "agent" },  { "dest_slot", "integer" },  { "source_agent", "agent" },  { "source_slot", "integer" } },
      description = [[
        Moves a genome from one slot to another.
      ]],
      callback =
        function(self, dest_agent, dest_slot, source_agent, source_slot )
        end
    }
  },


  ["GTOS"] = {
    ["string"] = {
      command = "GTOS",
      rtype = "string",
      params = {
        { "slot", "integer" } },
      description = [[
        Returns the target's moniker in the given gene variable slot.  This universally unique identifier is the name 
        of a genetics file.  Slot 0 is a creature's actual genome.  Other slots are used in pregnant 
        creatures, eggs and other places.
      ]],
      callback =
        function(self, slot )
          return ""
        end
    }
  },


  ["MTOA"] = {
    ["agent"] = {
      command = "MTOA",
      rtype = "agent",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the agent which references the given moniker.  The moniker could be stored in any of the gene 
        slots for that agent, including the special slot 0 for a creature.  If the moniker is not currently 
        used in the game, then returns @NULL@.  This command can be slow - use @MTOC@ if possible.
      ]],
      callback =
        function(self, moniker )
          return nil
        end
    }
  },


  ["MTOC"] = {
    ["agent"] = {
      command = "MTOC",
      rtype = "agent",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the creature with the given moniker.  If there is no agent alive with that moniker, then returns @
        NULL@.  See also @MTOA@.
      ]],
      callback =
        function(self, moniker )
          return nil
        end
    }
  },


  ["HIST CAGE"] = {
    ["integer"] = {
      command = "HIST CAGE",
      rtype = "integer",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        Returns the life stage of the creature when the given life event happened.
      ]],
      callback =
        function(self, moniker, event_no )
          return 0
        end
    }
  },


  ["HIST COUN"] = {
    ["integer"] = {
      command = "HIST COUN",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the number of life events that there are for the given moniker.  Returns 0 of there are 
        no events, or the moniker doesn't exist.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["HIST CROS"] = {
    ["integer"] = {
      command = "HIST CROS",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the number of crossover points when the genome was made by splicing its parents genomes.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["HIST EVNT"] = {
    ["command"] = {
      command = "HIST EVNT",
      rtype = "command",
      params = {
        { "moniker", "string" },  { "event_type", "integer" },  { "related_moniker_1", "string" },  { "related_moniker_2", "string" } },
      description = [[
        Triggers a life event of the given type.  Some events are triggered automatically by the engine, some events 
        need triggering from CAOS, others are custom events that you can use for your own purposes.  See @HIST 
        TYPE@ for details of the event numbers.  All new events made call the @Life Event@ script.
      ]],
      callback =
        function(self, moniker, event_type, related_moniker_1, related_moniker_2 )
        end
    }
  },


  ["HIST FIND"] = {
    ["integer"] = {
      command = "HIST FIND",
      rtype = "integer",
      params = {
        { "moniker", "string" },  { "event_type", "integer" },  { "from_index", "integer" } },
      description = [[
        Searches for a life event of a certain @HIST TYPE@ for the given moniker.  The search begins at 
        the life event <b>after</b> the from index.  Specify -1 to find the first event.  Returns the 
        event number, or -1 if there is no matching event.
      ]],
      callback =
        function(self, moniker, event_type, from_index )
          return 0
        end
    }
  },


  ["HIST FINR"] = {
    ["integer"] = {
      command = "HIST FINR",
      rtype = "integer",
      params = {
        { "moniker", "string" },  { "event_type", "integer" },  { "from_index", "integer" } },
      description = [[
        Reverse searches for a life event of a certain @HIST TYPE@ for the given moniker.  The search begins 
        at the life event <b>before</b> the from index.  Specify -1 to find the last event.  Returns 
        the event number, or -1 if there is no matching event.
      ]],
      callback =
        function(self, moniker, event_type, from_index )
          return 0
        end
    }
  },


  ["HIST FOTO"] = {
    ["string"] = {
      command = "HIST FOTO",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        For the given life event, returns the filename of the associated photograph, or an empty string if there 
        is no photo.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    },

    ["command"] = {
      command = "HIST FOTO",
      rtype = "command",
      params = {
        { "moniker", "string" },  { "event_no", "integer" },  { "new_value", "string" } },
      description = [[
        For the given life event, sets the associated photograph.  Use @SNAP@ to take the photograph first.
      If 
        there was already a photograph for the event, then it is automatically marked for the attic as in @
        LOFT@, and overwritten with the new photo.  Hence you can use an empty string to clear a photo.  
        If @HIST WIPE@ is used to clear the event, the photo is similarly stored in the attic.
      
        It is considered an error to send a photograph that is in use (unless cloned with @TINT@) to 
        the attic.  If this happens, you will get a runtime error.  You should either be confident that no 
        agents are using the photo, or call @LOFT@ first to test if they are.
      ]],
      callback =
        function(self, moniker, event_no, new_value )
        end
    }
  },


  ["HIST GEND"] = {
    ["integer"] = {
      command = "HIST GEND",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the sex that the creature with the given moniker has or had.  1 for male, 2 for 
        female.  If the creature hasn't been born yet, returns -1.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["HIST GNUS"] = {
    ["integer"] = {
      command = "HIST GNUS",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the genus of the moniker.  This is 1 for Norn, 2 for Grendel, 3 for Ettin by 
        convention.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["HIST MON1"] = {
    ["string"] = {
      command = "HIST MON1",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        For the given life event, returns the first associated moniker.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    }
  },


  ["HIST MON2"] = {
    ["string"] = {
      command = "HIST MON2",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        For the given life event, returns the second associated moniker.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    }
  },


  ["HIST MUTE"] = {
    ["integer"] = {
      command = "HIST MUTE",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the number of point mutations the genome received during crossover from its parents.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["HIST NAME"] = {
    ["string"] = {
      command = "HIST NAME",
      rtype = "string",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the name of the creature with the given moniker.
      ]],
      callback =
        function(self, moniker )
          return ""
        end
    },

    ["command"] = {
      command = "HIST NAME",
      rtype = "command",
      params = {
        { "moniker", "string" },  { "new_name", "string" } },
      description = [[
        Renames the creature with the given moniker.
      ]],
      callback =
        function(self, moniker, new_name )
        end
    }
  },


  ["HIST NETU"] = {
    ["string"] = {
      command = "HIST NETU",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        Returns the network identifier of the user when the given life event happened.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    }
  },


  ["HIST NEXT"] = {
    ["string"] = {
      command = "HIST NEXT",
      rtype = "string",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the next moniker which has a history, or an empty string if we're at the end 
        already.  If the specified moniker is an empty string or doesn't have a history, then the first 
        moniker with a history entry is returned, or an empty string if there isn't one.
      ]],
      callback =
        function(self, moniker )
          return ""
        end
    }
  },


  ["HIST PREV"] = {
    ["string"] = {
      command = "HIST PREV",
      rtype = "string",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the previous moniker which has a history.  If the specified moniker is an empty string or doesn'
        t have a history, then the last moniker with a history entry is returned, or an empty string 
        if there isn't one.
      ]],
      callback =
        function(self, moniker )
          return ""
        end
    }
  },


  ["HIST RTIM"] = {
    ["integer"] = {
      command = "HIST RTIM",
      rtype = "integer",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        Returns the real world time when the given life event happened.  This is measured in seconds since midnight, 
        1 January 1970 in UTC.  To display, use @RTIF@.
      ]],
      callback =
        function(self, moniker, event_no )
          return 0
        end
    }
  },


  ["HIST TAGE"] = {
    ["integer"] = {
      command = "HIST TAGE",
    rtype = "integer",
    params = {
      { "moniker", "string" },  { "event_no", "integer" } },
    description = [[
      Returns the age in ticks of the creature when the given life event happened to it.  If the 
      creature was not in the world, wasn't born yet, or was fully dead, then -1 is returned.  
      If the creature was dead, but its body still in the world, then its age on death is 
      returned.  See also @TAGE@.
    ]],
    callback =
      function(self, moniker, event_no )
        return 0
      end
    }
  },


  ["HIST TYPE"] = {
    ["integer"] = {
      command = "HIST TYPE",
    rtype = "integer",
    params = {
      { "moniker", "string" },  { "event_no", "integer" } },
    description = [[
      For the given life event, returns its type.
      All histories begin with one of the following four events.  You can read the associated monikers with @HIST MON1@ and @HIST MON2@.
      0 Conceived - a natural start to life, associated monikers are the mother's and father's
      1 Spliced - created using @GENE CROS@ to crossover the two associated monikers
      2 Engineered - from a human made genome with @GENE LOAD@, the first associated moniker is blank, and the second is the filename
      14 Cloned - such as when importing a creature that already exists in the world and reallocating the new moniker, when @TWIN@ing or @GENE CLON@ing; associated moniker is who we were cloned from
      The following events happen during a creature's life:
      3  Born - triggered by the @BORN@ command, associated monikers are the parents.
      4 Aged - reached the next life stage, either naturally from the ageing loci or with @AGES@
      5 Exported - emmigrated to another world
      6 Imported - immigrated back again
      7 Died - triggered naturally with the death trigger locus, or by the @DEAD@ command
      8 Became pregnant - the first associated moniker is the child, and the second the father
      9 Impregnated - first associated moniker is the child, second the mother
      10 Child born - first moniker is the child, second the other parent
      15 Clone source - someone was cloned from you, first moniker is whom
      16 Warped out - exported through a worm hole with @NET: EXPO@
      17 Warped in - imported through a worm hole
      These events aren't triggered by the engine, but reserved for CAOS to use with these numbers:
      11 Laid by mother
      12 Laid an egg
      13 Photographed
      Other numbers can also be used for custom life events.  Start with numbers 100 and 
      above, as events below that are reserved for the engine.  You send your own events using @HIST EVNT@.
      
    ]],
    callback =
      function(self, moniker, event_no )
        return 0
      end
    }
  },


  ["HIST UTXT"] = {
    ["command"] = {
      command = "HIST UTXT",
      rtype = "command",
      params = {
        { "moniker", "string" },  { "event_no", "integer" },  { "new_value", "string" } },
      description = [[
        For the given life event, sets the user text.
      ]],
      callback =
        function(self, moniker, event_no, new_value )
        end
    },

    ["string"] = {
      command = "HIST UTXT",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        For the given life event, returns the user text.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    }
  },


  ["HIST VARI"] = {
    ["integer"] = {
      command = "HIST VARI",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns the variant that the creature with the given moniker has or had.  If the creature hasn't 
        been born yet, returns -1.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["HIST WIPE"] = {
    ["command"] = {
      command = "HIST WIPE",
      rtype = "command",
      params = {
        { "moniker", "string" } },
      description = [[
        Purge the creature history for the given moniker.  Only applies if the genome isn't referenced by any 
        slot, and the creature is fully dead or exported.  Use @OOWW@ to test this first.
      ]],
      callback =
        function(self, moniker )
        end
    }
  },


  ["HIST WNAM"] = {
    ["string"] = {
      command = "HIST WNAM",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        Returns the name of the world the given life event happened in.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    }
  },


  ["HIST WTIK"] = {
    ["integer"] = {
      command = "HIST WTIK",
      rtype = "integer",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        Returns the world tick when the life event happened, for the world that the event happened in. 
      ]],
      callback =
        function(self, moniker, event_no )
          return 0
        end
    }
  },


  ["HIST WUID"] = {
    ["string"] = {
      command = "HIST WUID",
      rtype = "string",
      params = {
        { "moniker", "string" },  { "event_no", "integer" } },
      description = [[
        Returns the unique identifier of the world the given life event happened in.
      ]],
      callback =
        function(self, moniker, event_no )
          return ""
        end
    }
  },


  ["HIST WVET"] = {
    ["integer"] = {
      command = "HIST WVET",
      rtype = "integer",
      params = {
        { "moniker", "string" } },
      description = [[
        Returns 1 if the Creature is a warp hole veteran, 0 otherwise.  The creature is a veteran if 
        they have ever been exported with @NET: EXPO@.  They must have been the main exported creature - warping as 
        an embryo doesn't make you a veteran.
      ]],
      callback =
        function(self, moniker )
          return 0
        end
    }
  },


  ["OOWW"] = {
    ["integer"] = {
      command = "OOWW",
    rtype = "integer",
    params = {
      { "moniker", "string" } },
    description = [[
      Returns the status of the moniker.
      0 - never existed, or history purged
      1 - genome referenced by a slot, for example an egg
      2 - creature made with @NEW: CREA@
      3 - creature properly @BORN@
      4 - out of world, exported
      5 - dead, body still exists
      6 - dead, body @KILL@ed
      7 - unreferenced genome
    ]],
    callback =
      function(self, moniker )
        return 0
      end
    }
  },


  ["CLAC"] = {
    ["command"] = {
      command = "CLAC",
      rtype = "command",
      params = {
        { "message", "integer" } },
      description = [[
        Set the click action, which is the identifier of the message sent to the agent when it is 
        clicked on, provided attribute @Activateable@ is set.  Default is activate 1.  Use -1 to prevent it sending a 
        message.  Also overriden by @CLIK@.  Remember that the early @Message Numbers@ differ slightly from @Script Numbers@.
      ]],
      callback =
        function(self, message )
          self.vm.target:setVar("caos_clack_msg", CAOS.message_to_script(message))
          self.vm.target:setVar("caos_click_msg_1", -2)
          self.vm.target:setVar("caos_click_msg_2", -2)
          self.vm.target:setVar("caos_click_msg_3", -2)
        end
    },

    ["integer"] = {
      command = "CLAC",
      rtype = "integer",
      params = {},
      description = [[
        This returns the CLAC action of the @TARG@ object. If the TARG is in @CLIK@ mode, then the 
        return value is -2. Otherwise it is the CLAC action.
      ]],
      callback =
        function(self)
          return CAOS.script_to_message( self.vm.target:getVar("caos_clack_msg") ) or -1
        end
    }
  },


  ["CLIK"] = {
    ["command"] = {
      command = "CLIK",
      rtype = "command",
      params = {
        { "message_1", "integer" },  { "message_2", "integer" },  { "message_3", "integer" } },
      description = [[
        Sets a chain of three message ids to cycle through as the agent is clicked on.  Entries of -
        1 are ignored.  Overriden by @CLAC@.
      ]],
      callback =
        function(self, message_1, message_2, message_3 )
          self.vm.target:setVar("caos_clack_msg", -2)
          self.vm.target:setVar("caos_click_msg_1", CAOS.message_to_script(which_value_or_msg1))
          self.vm.target:setVar("caos_click_msg_2", CAOS.message_to_script(message_2))
          self.vm.target:setVar("caos_click_msg_3", CAOS.message_to_script(message_3))
        end
    },

    ["integer"] = {
      command = "CLIK",
      rtype = "integer",
      params = {
        { "which_value", "integer" } },
      description = [[
        This returns the CLIK action of the @TARG@ object. If the object is in @CLAC@ mode, then it returns -2, else the return values are as follows:
        0 -&gt; Current click action number (1,2,3)
        1 -&gt; First CLIK action.
        2 -&gt; Second CLIK action.
        3 -&gt; Third CLIK action
      ]],
      callback =
        function(self, which_value)
          if ( which_value == 0 ) then
            return 1  -- TODO
          elseif ( which_value == 1 ) then
            return self.vm.target:getVar("caos_click_msg_1") or -1
          elseif ( which_value == 2 ) then
            return self.vm.target:getVar("caos_click_msg_2") or -1
          elseif ( which_value == 3 ) then
            return self.vm.target:getVar("caos_click_msg_3") or -1
          end
          return 0
        end
    }
  },


  ["HOTP"] = {
    ["integer"] = {
      command = "HOTP",
    rtype = "integer",
    params = {},
    description = [[
      Returns the number of the compound part under the pointer.  Returns -1 if no agent is under the 
      pointer, and 0 if the agent is simple or a skeletal creature.  Transparency of the parts is ignored, 
      so each part is a rectangle.  Transparency of the agent as a whole is, however, obeyed.  Planes are 
      also ignored, except later part numbers are treated as above earlier ones.  See also @HOTS@ to find the 
      agent under the pointer.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["HOTS"] = {
    ["agent"] = {
      command = "HOTS",
    rtype = "agent",
    params = {},
    description = [[
      Returns the agent nearest the screen under the hotspot of the pointer.  For each agent, @TRAN@ decides whether 
      this allows for transparent pixels.  See also @HOTP@, which does the same for compound parts.
    ]],
    callback =
      function(self)
        return nil
      end
    }
  },


  ["IMSK"] = {
    ["command"] = {
      command = "IMSK",
    rtype = "command",
    params = {
      { "mask", "integer" } },
    description = [[
      Set the input event mask.  Indicates which types of global input events the agent is interested in, if any. For example, if the flag for "key up" events is set here, the agents "key up" script will be run every time a key is released.
      Input event bit flags are 
      1  @Raw Key Down@
      2 @Raw Key Up@
      4 @Raw Mouse Move@
      8 @Raw Mouse Down@
      16 @Raw Mouse Up@
      32 @Raw Mouse Wheel@
      64 @Raw Translated Char@
      You can find the script numbers executed by following the links above.
    ]],
    callback =
      function(self, mask )
      end
    }
  },


  ["KEYD"] = {
    ["integer"] = {
      command = "KEYD",
      rtype = "integer",
      params = {
        { "keycode", "integer" } },
      description = [[
        Returns 1 if the specified key is currently pressed down, 0 if not.
      ]],
      callback =
        function(self, keycode )
          return 0
        end
    }
  },


  ["MOPX"] = {
    ["integer"] = {
      command = "MOPX",
      rtype = "integer",
      params = {},
      description = [[
        Returns x position of mouse in world coordinates.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MOPY"] = {
    ["integer"] = {
      command = "MOPY",
      rtype = "integer",
      params = {},
      description = [[
        Returns y position of mouse in world coordinates.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MOUS"] = {
    ["command"] = {
      command = "MOUS",
    rtype = "command",
    params = {
      { "behaviour", "integer" } },
    description = [[
      Defines the behaviour of the mouse button for the default pointer behaviour - see @PURE@.
      0 is normal
      1 means the right button does what the left button does
      2 means the left button does what the right button does
    ]],
    callback =
      function(self, behaviour )
      end
    }
  },


  ["MOVX"] = {
    ["float"] = {
      command = "MOVX",
      rtype = "float",
      params = {},
      description = [[
        Returns horizontal mouse velocity.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["MOVY"] = {
    ["float"] = {
      command = "MOVY",
      rtype = "float",
      params = {},
      description = [[
        Returns vertical mouse velocity.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["PURE"] = {
    ["command"] = {
      command = "PURE",
      rtype = "command",
      params = {
        { "value", "integer" } },
      description = [[
        Enables or disables the default clicking and moving behaviour of the pointer.  This default behaviour is to implement @
        CLAC@ and @CLIK@, and to operate ports.  Set to 1 to enable, 0 to disable.  When disabled, use @
        IMSK@ to hook mouse events.
      ]],
      callback =
        function(self, value )
        end
    },

    ["integer"] = {
      command = "PURE",
      rtype = "integer",
      params = {},
      description = [[
        Returns whether default pointer behaviour is disabled or enabled.  1 if enabled, 0 if disabled.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["ADDB"] = {
    ["command"] = {
      command = "ADDB",
      rtype = "command",
      params = {
        { "metaroom_id", "integer" },  { "background_file", "string" } },
      description = [[
        Add a new background to the given metaroom.  Use @BKGD@ to change the current displayed background.
      ]],
      callback =
        function(self, metaroom_id, background_file )
        end
    }
  },


  ["ADDM"] = {
    ["integer"] = {
      command = "ADDM",
      rtype = "integer",
      params = {
        { "x", "integer" },  { "y", "integer" },  { "width", "integer" },  { "height", "integer" },  { "background", "string" } },
      description = [[
        Creates a new metaroom with the given coordinates.  Specifies the starting background file.  Returns the id of the 
        new metaroom.
      ]],
      callback =
        function(self, x, y, width, height, background )
          return 0
        end
    }
  },


  ["ADDR"] = {
    ["integer"] = {
      command = "ADDR",
      rtype = "integer",
      params = {
        { "metaroom_id", "integer" },  { "x_left", "integer" },  { "x_right", "integer" },  { "y_left_ceiling", "integer" },  { "y_right_ceiling", "integer" },  { "y_left_floor", "integer" },  { "y_right_floor", "integer" } },
      description = [[
        Creates a new room within a metaroom.  Rooms have vertical left and right walls, but potentially sloped floors 
        and ceilings.  The coordinates specify the exact shape.  Returns the id of the new room.
      ]],
      callback =
        function(self, metaroom_id, x_left, x_right, y_left_ceiling, y_right_ceiling, y_left_floor, y_right_floor )
          return 0
        end
    }
  },


  ["ALTR"] = {
    ["command"] = {
      command = "ALTR",
      rtype = "command",
      params = {
        { "room_id", "integer" },  { "ca_index", "integer" },  { "ca_delta", "float" } },
      description = [[
        Directly adjusts the level of a CA in a room.  Specify an identifier of -1 to use the 
        room of the midpoint of the target agent.
      ]],
      callback =
        function(self, room_id, ca_index, ca_delta )
        end
    }
  },


  ["BKDS"] = {
    ["string"] = {
      command = "BKDS",
      rtype = "string",
      params = {
        { "metaroom_id", "integer" } },
      description = [[
        Returns a string containing all the background names for the specified metaroom in a comma seperated list.
      ]],
      callback =
        function(self, metaroom_id )
          return ""
        end
    }
  },


  ["CACL"] = {
    ["command"] = {
      command = "CACL",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "ca_index", "integer" } },
      description = [[
        This associates the classification specified with the CA specified. This allows the linking of CA's to classifiers 
        within creatures' brains.
      ]],
      callback =
        function(self, family, genus, species, ca_index )
        end
    }
  },


  ["CALC"] = {
    ["command"] = {
      command = "CALC",
    rtype = "command",
    params = {},
    description = [[
      Recalculates all the navigational CAs (warning: slow).
    ]],
    callback =
      function(self)
      end
    }
  },


  ["DELM"] = {
    ["command"] = {
      command = "DELM",
      rtype = "command",
      params = {
        { "metaroom_id", "integer" } },
      description = [[
        Deletes the specified metaroom from the map.
      ]],
      callback =
        function(self, metaroom_id )
        end
    }
  },


  ["DELR"] = {
    ["command"] = {
      command = "DELR",
      rtype = "command",
      params = {
        { "room_id", "integer" } },
      description = [[
        Deletes the specified room from the map.
      ]],
      callback =
        function(self, room_id )
        end
    }
  },


  ["DMAP"] = {
    ["command"] = {
      command = "DMAP",
      rtype = "command",
      params = {
        { "debug_map", "integer" } },
      description = [[
        Set to 1 to turn the debug map image on, 0 to turn it off. The debug map 
        includes vehicle cabin lines.
      ]],
      callback =
        function(self, debug_map )
        end
    }
  },


  ["DOCA"] = {
    ["command"] = {
      command = "DOCA",
      rtype = "command",
      params = {
        { "no_of_updates", "integer" } },
      description = [[
        Updates all CAs the specified number of times.
      ]],
      callback =
        function(self, no_of_updates )
        end
    }
  },


  ["DOOR"] = {
    ["command"] = {
      command = "DOOR",
      rtype = "command",
      params = {
        { "room_id1", "integer" },  { "room_id2", "integer" },  { "permiability", "integer" } },
      description = [[
        Sets the permiability of the door between two rooms.  This is used for both CAs and physical motion.  
        See also @PERM@.
      ]],
      callback =
        function(self, room_id1, room_id2, permiability )
        end
    },

    ["integer"] = {
      command = "DOOR",
      rtype = "integer",
      params = {
        { "room_id1", "integer" },  { "room_id2", "integer" } },
      description = [[
        Returns the door permiability between two rooms.
      ]],
      callback =
        function(self, room_id1, room_id2 )
          return 0
        end
    }
  },

  -- full
  ["DOWN"] = {
    ["integer"] = {
      command = "DOWN",
      rtype = "integer",
      params = {},
      description = [[
        Returns the value of the down constant.
      ]],
      callback =
        function(self)
          return CAOS.DIRECTIONS.DOWN
        end
    }
  },


  ["EMID"] = {
    ["string"] = {
      command = "EMID",
      rtype = "string",
      params = {},
      description = [[
        Returns a string containing all the metaroom ids in the world seperated by spaces.
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["EMIT"] = {
    ["command"] = {
      command = "EMIT",
      rtype = "command",
      params = {
        { "ca_index", "integer" },  { "amount", "float" } },
      description = [[
        Target now constantly emits an amount of a CA into the room it is in.
      ]],
      callback =
        function(self, ca_index, amount )
        end
    }
  },


  ["ERID"] = {
    ["string"] = {
      command = "ERID",
      rtype = "string",
      params = {
        { "metaroom_id", "integer" } },
      description = [[
        Returns a string containing all the room ids in the specified metaroom separated by spaces.  Returns all rooms 
        in the world if metaroom_id is -1.
      ]],
      callback =
        function(self, metaroom_id )
          return ""
        end
    }
  },


  ["GMAP"] = {
    ["integer"] = {
      command = "GMAP",
      rtype = "integer",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Returns the metaroom id at point x,y on the map. If the point is outside the room 
        system, it returns -1.
      ]],
      callback =
        function(self, x, y )
          return 0
        end
    }
  },


  ["GRAP"] = {
    ["integer"] = {
      command = "GRAP",
      rtype = "integer",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Returns the room id at point x,y on the map. If the point is outside the room 
        system, it returns -1.
      ]],
      callback =
        function(self, x, y )
          return 0
        end
    }
  },


  ["GRID"] = {
    ["integer"] = {
      command = "GRID",
      rtype = "integer",
      params = {
        { "agent", "agent" },  { "direction", "integer" } },
      description = [[
        Returns the ID of a room adjacent to the agent in the given direction.  A straight line is 
        drawn from the centre of the agent until it hits a room.  Directions are @LEFT@, @RGHT@, @_UP_@, or @
        DOWN@. A value of -1 is returned if no room can be found.
      ]],
      callback =
        function(self, agent, direction )
          return 0
        end
    }
  },


  ["HIRP"] = {
    ["integer"] = {
      command = "HIRP",
      rtype = "integer",
      params = {
        { "room_id", "integer" },  { "ca_index", "integer" },  { "directions", "integer" } },
      description = [[
        Returns id of the room adjacent to this one with the highest concentration of the given CA.  direction 
        is 0 for left/right, 1 for any direction.
      ]],
      callback =
        function(self, room_id, ca_index, directions )
          return 0
        end
    }
  },

  -- full
  ["LEFT"] = {
    ["integer"] = {
      command = "LEFT",
      rtype = "integer",
      params = {},
      description = [[
        Returns the value of the left constant.
      ]],
      callback =
        function(self)
          return CAOS.DIRECTIONS.LEFT
        end
    }
  },


  ["LINK"] = {
    ["command"] = {
      command = "LINK",
      rtype = "command",
      params = {
        { "room1", "integer" },  { "room2", "integer" },  { "permiability", "integer" } },
      description = [[
        Sets the permiability of the link between the rooms specified, creating the link if none exists before.  Set 
        to 0 to close (destroy) the link.  This is used for CAs.  See also @DOOR@.
      ]],
      callback =
        function(self, room1, room2, permiability )
        end
    },

    ["integer"] = {
      command = "LINK",
      rtype = "integer",
      params = {
        { "room1", "integer" },  { "room2", "integer" } },
      description = [[
        Returns the permiability of the link between the rooms specified or 0 if no link exists.
      ]],
      callback =
        function(self, room1, room2 )
          return 0
        end
    }
  },


  ["LORP"] = {
    ["integer"] = {
      command = "LORP",
      rtype = "integer",
      params = {
        { "room_id", "integer" },  { "ca_index", "integer" },  { "directions", "integer" } },
      description = [[
        Returns id of the room adjacent to this one with the lowest concentration of the given CA.  direction 
        is 0 for left/right, 1 for any direction.
      ]],
      callback =
        function(self, room_id, ca_index, directions )
          return 0
        end
    }
  },


  ["MAPD"] = {
    ["command"] = {
      command = "MAPD",
      rtype = "command",
      params = {
        { "width", "integer" },  { "height", "integer" } },
      description = [[
        Sets the dimensions of the map.  These are the maximum world coordinates.  Metarooms are rectangles within this area.
        
      ]],
      callback =
        function(self, width, height )
        end
    }
  },


  ["MAPH"] = {
    ["integer"] = {
      command = "MAPH",
      rtype = "integer",
      params = {},
      description = [[
        Returns the total height of the map.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MAPK"] = {
    ["command"] = {
      command = "MAPK",
    rtype = "command",
    params = {},
    description = [[
      Resets the map to be empty.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["MAPW"] = {
    ["integer"] = {
      command = "MAPW",
      rtype = "integer",
      params = {},
      description = [[
        Returns the total width of the map.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MLOC"] = {
    ["string"] = {
      command = "MLOC",
      rtype = "string",
      params = {
        { "metaroom_id", "integer" } },
      description = [[
        Returns the location of the specified metaroom as a string formated as follows: x y width height.
      ]],
      callback =
        function(self, metaroom_id )
          return ""
        end
    }
  },

  -- partial/none
  ["PERM"] = {
    ["command"] = {
      command = "PERM",
      rtype = "command",
      params = {
        { "permiability", "integer" } },
      description = [[
        Value from 1 to 100. Sets which room boundaries the agent can pass through.  The smaller the @PERM@ 
        the more it can go through.  @DOOR@ sets the corresponding room boundary permiability.  Also used for @ESEE@, to 
        decide what it can see through. (assumed target)
      ]],
      callback =
        function(self, permiability )
          self.vm.target:setVar("caos_permiability", permiability)
        end
    },

    ["integer"] = {
      command = "PERM",
      rtype = "integer",
      params = {},
      description = [[
        Returns the target's map permiability.
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_permiability") or 50
        end
    }
  },

  -- partial/none
  ["PROP"] = {
    ["command"] = {
      command = "PROP",
      rtype = "command",
      params = {
        { "room_id", "integer" },  { "ca_index", "integer" },  { "ca_value", "float" } },
      description = [[
        Sets the level of a CA (cellular automata) in a particular room.  There are 16 CAs, and their 
        meaning depends on the game.  The level is between 0 and 1.
      ]],
      callback =
        function(self, room_id, ca_index, ca_value )
        end
    },

    ["float"] = {
      command = "PROP",
      rtype = "float",
      params = {
        { "room_id", "integer" },  { "ca_index", "integer" } },
      description = [[
        Returns the value of a CA in a room.
      ]],
      callback =
        function(self, room_id, ca_index )
          -- TODO: map room_id to position from previous call
          if ( ca_index == CAOS.CA_INDEX.SOUND ) then
            return world.windLevel(self.vm.owner:position())
          elseif ( ca_index == CAOS.CA_INDEX.LIGHT ) then
            return world.lightLevel(self.vm.owner:position())
          elseif ( ca_index == CAOS.CA_INDEX.HEAT ) then
            return world.temperature(self.vm.owner:position())
          elseif ( ca_index == CAOS.CA_INDEX.PRECIPITATION ) then
          elseif ( ca_index == CAOS.CA_INDEX.NUTRIENT ) then
          elseif ( ca_index == CAOS.CA_INDEX.WATER ) then
          elseif ( ca_index == CAOS.CA_INDEX.PROTEIN ) then
          elseif ( ca_index == CAOS.CA_INDEX.CARBOHYDRATE ) then
          elseif ( ca_index == CAOS.CA_INDEX.FAT ) then
          elseif ( ca_index == CAOS.CA_INDEX.FLOWERS ) then
          elseif ( ca_index == CAOS.CA_INDEX.MACHINERY ) then
          elseif ( ca_index == CAOS.CA_INDEX.EGGS ) then
          elseif ( ca_index == CAOS.CA_INDEX.NORN ) then
          elseif ( ca_index == CAOS.CA_INDEX.GRENDEL ) then
          elseif ( ca_index == CAOS.CA_INDEX.ETTIN ) then
          elseif ( ca_index == CAOS.CA_INDEX.NORN_HOME ) then
          elseif ( ca_index == CAOS.CA_INDEX.GRENDEL_HOME ) then
          elseif ( ca_index == CAOS.CA_INDEX.ETTIN_HOME ) then
          elseif ( ca_index == CAOS.CA_INDEX.GADGET ) then
          end
          return 0.0
        end
    }
  },


  ["RATE"] = {
    ["command"] = {
      command = "RATE",
      rtype = "command",
      params = {
        { "room_type", "integer" },  { "ca_index", "integer" },  { "gain", "float" },  { "loss", "float" },  { "diffusion", "float" } },
      description = [[
        Sets various rates for a CA (cellular automata) in a particular type of room.  The values can be 
        from 0 to 1.  Gain is the susceptibility to absorb from agents in the room, and loss is 
        the amount lost to the atmosphere.  The diffusion is the amount it spreads to adjacent rooms.
      ]],
      callback =
        function(self, room_type, ca_index, gain, loss, diffusion )
        end
    },

    ["string"] = {
      command = "RATE",
      rtype = "string",
      params = {
        { "room_type", "integer" },  { "ca_index", "integer" } },
      description = [[
        Returns a string containing gain, loss and diffusion rates for that combination of room type and CA.
      ]],
      callback =
        function(self, room_type, ca_index )
          return ""
        end
    }
  },

  -- full
  ["RGHT"] = {
    ["integer"] = {
      command = "RGHT",
      rtype = "integer",
      params = {},
      description = [[
        Returns the value of the right constant.
      ]],
      callback =
        function(self)
          return CAOS.DIRECTIONS.RIGHT
        end
    }
  },


  ["RLOC"] = {
    ["string"] = {
      command = "RLOC",
      rtype = "string",
      params = {
        { "room_id", "integer" } },
      description = [[
        Returns the location of the specified room as a string formated as follows: xLeft xRight yLeftCeiling yRightCeiling yLeftFloor 
        yRightFloor.
      ]],
      callback =
        function(self, room_id )
          return ""
        end
    }
  },


  ["ROOM"] = {
    ["integer"] = {
      command = "ROOM",
      rtype = "integer",
      params = {
        { "agent", "agent" } },
      description = [[
        Returns the id of the room containing the midpoint of the specified agent.
      ]],
      callback =
        function(self, agent )
          return 0
        end
    }
  },


  ["RTYP"] = {
    ["command"] = {
      command = "RTYP",
      rtype = "command",
      params = {
        { "room_id", "integer" },  { "room_type", "integer" } },
      description = [[
        Sets the type of a room.  The meaning of the types depends on the game.  @RATE@ also uses 
        the room type.
      ]],
      callback =
        function(self, room_id, room_type )
        end
    },
    
    -- 0 Under the Albian surface. (C2)
    -- 1 On the Albian surface. (C2)
    -- 2 In the sea. (C2)
    -- 3 In the sky. (C2)
    -- 0 Atmosphere (C3, heat/light, lack of water and nutrients)
    -- 1 Wooden Walkway (C3, heat insulated, water can fall)
    -- 2 Concrete Walkway (C3, less permeable than 1)
    -- 3 Indoor Concrete
    -- 4 Outdoor Concrete
    -- 5 Normal Soil (permeable)
    -- 6 Boggy Soil (more moisture than 5)
    -- 7 Drained Soil (less moisture than 5)
    -- 8 Fresh Water (heat restrictive)
    -- 9 Salt water (heat restrictive)
    -- 10 Ettin Home (no machinery smell)
    ["integer"] = {
      command = "RTYP",
      rtype = "integer",
      params = {
        { "room_id", "integer" } },
      description = [[
        Returns the type of a room, or -1 if not a valid room id.
      ]],
      callback =
        function(self, room_id )
          return 6
        end
    }
  },


  ["TORX"] = {
    ["float"] = {
      command = "TORX",
      rtype = "float",
      params = {
        { "room_id", "integer" } },
      description = [[
        Returns relative X position of the centre of the given room from target's top left corner.
      ]],
      callback =
        function(self, room_id )
          return 0.0
        end
    }
  },


  ["TORY"] = {
    ["float"] = {
      command = "TORY",
      rtype = "float",
      params = {
        { "room_id", "integer" } },
      description = [[
        Returns relative Y position of the centre of the given room from target's top left corner.
      ]],
      callback =
        function(self, room_id )
          return 0.0
        end
    }
  },

  -- full
  ["_UP_"] = {
    ["integer"] = {
      command = "_UP_",
      rtype = "integer",
      params = {},
      description = [[
        Returns the value of the up constant.
      ]],
      callback =
        function(self)
          return CAOS.DIRECTIONS.UP
        end
    }
  },


  ["ACCG"] = {
    ["command"] = {
      command = "ACCG",
      rtype = "command",
      params = {
        { "acceleration", "float" } },
      description = [[
        Set acceleration due to gravity in pixels per tick squared. (assumed target)
      ]],
      callback =
        function(self, acceleration )
        end
    },

    ["float"] = {
      command = "ACCG",
      rtype = "float",
      params = {},
      description = [[
        Returns target's acceleration due to gravity in pixels per tick squared.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["ADMP"] = {
    ["command"] = {
      command = "ADMP",
      rtype = "command",
      params = {
        { "damping_factor", "float" } },
      description = [[
        Damp angular velocity by this much each tick.  The value is from 0.0 to 1.0 where 
        0.0 means no damping, 1.0 maximum.
      ]],
      callback =
        function(self, damping_factor )
        end
    },

    ["float"] = {
      command = "ADMP",
      rtype = "float",
      params = {},
      description = [[
        Get current angular damping.  The value is from 0.0 to 1.0 where 0.0 means no 
        damping, 1.0 maximum.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["AERO"] = {
    ["command"] = {
      command = "AERO",
      rtype = "command",
      params = {
        { "aerodynamics", "integer" } },
      description = [[
        Set aerodynamic factor as a percentage.  The velocity is reduced by this factor each tick.
      ]],
      callback =
        function(self, aerodynamics )
        end
    },

    ["integer"] = {
      command = "AERO",
      rtype = "integer",
      params = {},
      description = [[
        Returns aerodynamic factor as a percentage.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full
  ["ANGL"] = {
    ["float"] = {
      command = "ANGL",
    rtype = "float",
    params = {
      { "x", "float" },  { "y", "float" } },
    description = [[
      Gets the angle (as a fraction of a circle) from TARG's position to the position specified.
    ]],
    callback =
      function(self, x, y )
        local pos = self.vm.target:position()
        return math.atan2(pos[2] - y, pos[1] - x) / (2*math.pi)
      end
    }
  },


  ["AVEL"] = {
    ["command"] = {
      command = "AVEL",
      rtype = "command",
      params = {
        { "amount_in_fraction_of_whole_circle", "float" } },
      description = [[
        Set angular velocity.
      ]],
      callback =
        function(self, amount_in_fraction_of_whole_circle )
        end
    },

    ["float"] = {
      command = "AVEL",
      rtype = "float",
      params = {},
      description = [[
        Get current angular velocity.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["ELAS"] = {
    ["command"] = {
      command = "ELAS",
      rtype = "command",
      params = {
        { "elasticity", "integer" } },
      description = [[
        Set the elasticity percentage.  An agent with elasticity 100 will bounce perfectly, one with elasticity 0 won't 
        bounce at all. (Assumed to be target)
      ]],
      callback =
        function(self, elasticity)
        end
    },

    ["integer"] = {
      command = "ELAS",
      rtype = "integer",
      params = {},
      description = [[
        Return the elasticity percentage.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full/partial
  ["FALL"] = {
    ["integer"] = {
      command = "FALL",
    rtype = "integer",
    params = {},
    description = [[
      Returns 1 if target is moving under the influence of gravity, or 0 if it is at rest.
    ]],
    callback =
      function(self)
        -- check for world gravity or the physics flag
        if ( math.abs(world.gravity(self.vm.target:position())) < 1 
            or bit32.band( self.vm.target:getVar("caos_attributes"), CAOS.ATTRIBUTES.SUFFER_PHYSICS) == 0 ) then
          return 0
        end
        
        -- if there is world gravity and agent suffers from physics
        return (self.vm.target:velocity()[2] == 0) and 0 or 1
      end
    }
  },


  ["FDMP"] = {
    ["command"] = {
      command = "FDMP",
      rtype = "command",
      params = {
        { "damping_factor", "float" } },
      description = [[
        Damp forward velocity by this much each tick.  The value is from 0.0 to 1.0 where 
        0.0 means no damping, 1.0 maximum.
      ]],
      callback =
        function(self, damping_factor )
        end
    },

    ["float"] = {
      command = "FDMP",
      rtype = "float",
      params = {},
      description = [[
        Get current forwards damping.  The value is from 0.0 to 1.0 where 0.0 means no 
        damping, 1.0 maximum.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },

  -- progress
  ["FLTO"] = {
    ["command"] = {
      command = "FLTO",
    rtype = "command",
    params = {
      { "screen_x", "float" },  { "screen_y", "float" } },
    description = [[
      Move the top left corner of target to either the given screen coordinates, or the given coordinates relative 
      to the agent it is @FREL@ to.  Useful for floating agents.
    ]],
    callback =
      function(self, screen_x, screen_y )
        -- float to
        local pos = { screen_x, screen_y }
        local rel = self.vm.target:getVar("caos_float_relative")
        if ( rel ~= nil ) then
          local targp = rel.position()
          pos[1] = pos[1] + targp[1]
          pos[2] = pos[2] + targp[2]
        end
        
        -- teleport to pos
      end
    }
  },

  -- full
  ["FREL"] = {
    ["command"] = {
      command = "FREL",
    rtype = "command",
    params = {
      { "relative", "agent" } },
    description = [[
      Sets an agent for target to float relative to.  To make target actually float, you need to set 
      attribute @Floatable@ as well.  Set @FREL@ to @NULL@ to make the target float relative to the main camera - 
      this is the default.  Use @FLTO@ to set the relative position of the top left corner of the 
      floating agent to the top left corner of the agent it is floating relative to.
    ]],
    callback =
      function(self, relative )
        self.vm.target:setVar("caos_float_relative")
      end
    }
  },


  ["FRIC"] = {
    ["command"] = {
      command = "FRIC",
      rtype = "command",
      params = {
        { "friction", "integer" } },
      description = [[
        Set physics friction percentage, normally from 0 to 100.  Speed is lost by this amount when an agent 
        slides along the floor. (assumed target)
      ]],
      callback =
        function(self, friction )
        end
    },

    ["integer"] = {
      command = "FRIC",
      rtype = "integer",
      params = {},
      description = [[
        Return physics friction percentage.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["FVEL"] = {
    ["command"] = {
      command = "FVEL",
      rtype = "command",
      params = {
        { "amount_in_pixels", "float" } },
      description = [[
        Set forwards velocity.
      ]],
      callback =
        function(self, amount_in_pixels )
        end
    },

    ["float"] = {
      command = "FVEL",
      rtype = "float",
      params = {},
      description = [[
        Get current forwards velocity.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["MOVS"] = {
    ["integer"] = {
      command = "MOVS",
      rtype = "integer",
      params = {},
      description = [[
        Returns the movement status of the target.  
        0 Autonomous
        1 Mouse driven
        2 Floating
        3 In vehicle
        4 Carried
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["MVBY"] = {
    ["command"] = {
      command = "MVBY",
      rtype = "command",
      params = {
        { "delta_x", "float" },  { "delta_y", "float" } },
      description = [[
        Move the target agent by relative distances, which can be negative or positive.
      ]],
      callback =
        function(self, delta_x, delta_y )
        end
    }
  },


  ["MVSF"] = {
    ["command"] = {
      command = "MVSF",
      rtype = "command",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Move the target agent into a safe map location somewhere in the vicinity of x, y. Only works 
        on autonomous agents - see @MOVS@.  Works like a safe @MVFT@ for creatures.
      ]],
      callback =
        function(self, x, y )
        end
    }
  },


  ["MVTO"] = {
    ["command"] = {
      command = "MVTO",
      rtype = "command",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Move the top left corner of the target agent to the given world coordinates.  Use @MVFT@ instead to 
        move creatures.
      ]],
      callback =
        function(self, x, y )
        end
    }
  },


  ["OBST"] = {
    ["float"] = {
      command = "OBST",
      rtype = "float",
      params = {
        { "direction", "integer" } },
      description = [[
        Returns the distance from the agent to the nearest wall that it might collide with in the given 
        direction. Directions are @LEFT@, @RGHT@, @_UP_@, or @DOWN@. If the distance to the collsion is greater than @RNGE@ 
        then a very large number is returned.
      ]],
      callback =
        function(self, direction )
          return 0.0
        end
    }
  },

  -- full
  ["RELX"] = {
    ["float"] = {
      command = "RELX",
      rtype = "float",
      params = {
        { "first", "agent" },  { "second", "agent" } },
      description = [[
        Returns the relative X distance of the centre point of the second agent from the centre point of 
        the first.
      ]],
      callback =
        function(self, first, second )
          return second.position()[1] - first.position()[1]
        end
    }
  },

  -- full
  ["RELY"] = {
    ["float"] = {
      command = "RELY",
      rtype = "float",
      params = {
        { "first", "agent" },  { "second", "agent" } },
      description = [[
        Returns the relative Y distance of the centre point of the second agent from the centre point of 
        the first.
      ]],
      callback =
        function(self, first, second )
          return second.position()[2] - first.position()[2]
        end
    }
  },


  ["ROTN"] = {
    ["command"] = {
      command = "ROTN",
      rtype = "command",
      params = {
        { "no_of_sprites_for_each_rotation", "float" },  { "no_of_rotations", "float" } },
      description = [[
        For automatic change of sprite when the agent rotates the engine assumes that the sprite file is stored 
        with all the sprites for one rotation together starting with pointing north.
      ]],
      callback =
        function(self, no_of_sprites_for_each_rotation, no_of_rotations )
        end
    }
  },


  ["SDMP"] = {
    ["command"] = {
      command = "SDMP",
      rtype = "command",
      params = {
        { "damping_factor", "float" } },
      description = [[
        Damp sideways velocity by this much each tick.  The value is from 0.0 to 1.0 where 
        0.0 means no damping, 1.0 maximum.
      ]],
      callback =
        function(self, damping_factor )
        end
    },

    ["float"] = {
      command = "SDMP",
      rtype = "float",
      params = {},
      description = [[
        Get current sideways damping.  The value is from 0.0 to 1.0 where 0.0 means no 
        damping, 1.0 maximum.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },

  -- full (needs verification)
  ["SPIN"] = {
    ["command"] = {
      command = "SPIN",
      rtype = "command",
      params = {
        { "amount_in_fraction_of_whole_circle", "float" } },
      description = [[
        Rotate to a particular facing.
      ]],
      callback =
        function(self, amount_in_fraction_of_whole_circle )
          self.vm.owner:rotate(amount_in_fraction_of_whole_circle*2*math.pi)
        end
    },

    ["float"] = {
      command = "SPIN",
      rtype = "float",
      params = {},
      description = [[
        Get current facing angle.
      ]],
      callback =
        function(self)
          return self.vm.owner:currentRotation() or 0
        end
    }
  },


  ["SVEL"] = {
    ["command"] = {
      command = "SVEL",
      rtype = "command",
      params = {
        { "amount_in_pixels", "float" } },
      description = [[
        Set sideways velocity.
      ]],
      callback =
        function(self, amount_in_pixels )
        end
    },

    ["float"] = {
      command = "SVEL",
      rtype = "float",
      params = {},
      description = [[
        Get current sideways velocity.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["TMVB"] = {
    ["integer"] = {
      command = "TMVB",
      rtype = "integer",
      params = {
        { "delta_x", "float" },  { "delta_y", "float" } },
      description = [[
        Similar to @TMVT@ only tests a @MVBY@.
      ]],
      callback =
        function(self, delta_x, delta_y )
          return 0
        end
    }
  },


  ["TMVF"] = {
    ["integer"] = {
      command = "TMVF",
      rtype = "integer",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Test if a creature could move it's down foot to position x,y.
      ]],
      callback =
        function(self, x, y )
          return 0
        end
    }
  },


  ["TMVT"] = {
    ["integer"] = {
      command = "TMVT",
      rtype = "integer",
      params = {
        { "x", "float" },  { "y", "float" } },
      description = [[
        Test if target can move to the given location and still lie validly within the room system.  Returns 
        1 if it can, 0 if it can't.
      ]],
      callback =
        function(self, x, y )
          return 0
        end
    }
  },


  ["VARC"] = {
    ["command"] = {
      command = "VARC",
      rtype = "command",
      params = {
        { "view_arc_size", "float" } },
      description = [[
        [not implemented yet]
      ]],
      callback =
        function(self, view_arc_size )
        end
    },

    ["float"] = {
      command = "VARC",
      rtype = "float",
      params = {},
      description = [[
        [not implemented yet]
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["VECX"] = {
    ["float"] = {
      command = "VECX",
      rtype = "float",
      params = {
        { "angle", "float" } },
      description = [[
        Returns a normalised vector for the given angle (X coordinate).
      ]],
      callback =
        function(self, angle )
          return 0.0
        end
    }
  },


  ["VECY"] = {
    ["float"] = {
      command = "VECY",
      rtype = "float",
      params = {
        { "angle", "float" } },
      description = [[
        Returns a normalised vector for the given angle (Y coordinate).
      ]],
      callback =
        function(self, angle )
          return 0.0
        end
    }
  },

  -- full
  ["VELO"] = {
    ["command"] = {
      command = "VELO",
      rtype = "command",
      params = {
        { "x_velocity", "float" },  { "y_velocity", "float" } },
      description = [[
        Set velocity, measured in pixels per tick.
      ]],
      callback =
        function(self, x_velocity, y_velocity )
          self.vm.owner:setVelocity( {x_velocity, y_velocity} )
        end
    }
  },

  -- full
  ["VELX"] = {
    ["variable"] = {
      command = "VELX",
      rtype = "variable",
      params = {},
      description = [[
        Horizontal velocity in pixels per tick - floating point.
      ]],
      callback =
        function(self)
          return self.vm.owner:velocity()[1] or 0
        end
    }
  },

  -- full
  ["VELY"] = {
    ["variable"] = {
      command = "VELY",
      rtype = "variable",
      params = {},
      description = [[
        Vertical velocity in pixels per tick - floating point.
      ]],
      callback =
        function(self)
          return self.vm.owner:velocity()[2] or 0
        end
    }
  },


  ["WALL"] = {
    ["integer"] = {
      command = "WALL",
      rtype = "integer",
      params = {},
      description = [[
        Returns the direction of the last wall the agent collided with.  Directions are @LEFT@, @RGHT@, @_UP_@, or @DOWN@.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["NET: ERRA"] = {
    ["integer"] = {
      command = "NET: ERRA",
      rtype = "integer",
      params = {},
      description = [[
        Returns an error code from the last command.  Currently @NET: LINE@ is the only command to set it.
        Error codes are:
        0 - Unknown
        1 - Connection OK
        2 - Connection failed, you or the server are offline
        3 - Connection failed, invalid user name/password
        4 - Connection failed, you are already logged in elsewhere
        5 - Connection failed, too many users for server
        6 - Connection failed, internal error
        7 - Connection failed, new client version required.
        Try @NET: RAWE@ for more detailed diagnostic codes.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["NET: EXPO"] = {
    ["integer"] = {
      command = "NET: EXPO",
      rtype = "integer",
      params = {
        { "chunk_type", "string" },  { "dest_user_id", "string" } },
      description = [[
        Transwarp the target creature to the given user.  The Creature is exported to the warp out directory; this command is very similar to @PRAY EXPO@. Return value is one of the following:
        0 for success
        1 if the creature, or if pregnant any of its offspring, are already on disk in some form.  This case won't happen much, if you use a special chunk name like WARP.
        2 if the user hasn't been online in this world yet / since the user name changed, so 
        we don't know who they are.
        When receiving a creature, use @NET: FROM@ to find out 
        who sent it.
      ]],
      callback =
        function(self, chunk_type, dest_user_id )
          return 0
        end
    }
  },


  ["NET: FROM"] = {
    ["string"] = {
      command = "NET: FROM",
      rtype = "string",
      params = {
        { "resource_name", "string" } },
      description = [[
        The user who sent the PRAY file which contains the specified resource.  If the resource did not arrive 
        as a message over the network via @NET: MAKE@ or @NET: EXPO@, then this returns an empty string. 
        The user returned by this command is guaranteed in a way that looking at the content of the 
        PRAY file would not be.  For example, the "Last Network User" attribute in an exported Creature made with @
        NET: EXPO@ could be faked.
      ]],
      callback =
        function(self, resource_name )
          return ""
        end
    }
  },


  ["NET: HEAD"] = {
    ["command"] = {
      command = "NET: HEAD",
      rtype = "command",
      params = {},
      description = [[
        Dump debugging informatino about who is @NET: HEAR@ing on what channels.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["NET: HEAR"] = {
    ["command"] = {
      command = "NET: HEAR",
      rtype = "command",
      params = {
        { "channel", "string" } },
      description = [[
        The target agent will now accept CAOS messages over the network on the specified channel, and execute their 
        script as appropriate.  Use @NET: WRIT@ to send the message.
      ]],
      callback =
        function(self, channel )
        end
    }
  },


  ["NET: HOST"] = {
    ["string"] = {
      command = "NET: HOST",
      rtype = "string",
      params = {},
      description = [[
        Returns the hostname, port, id and friendly name on that host that we are currently connected to, or 
        empty string if offline.  The fields are space separated, although the last field (friendly name) may contain spaces.
        
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["NET: LINE"] = {
    ["command"] = {
      command = "NET: LINE",
      rtype = "command",
      params = {
        { "state", "integer" } },
      description = [[
        Goes on or offline, connecting or disconnecting from the Babel server.  Set to 1 to connect, 0 to 
        disconnect.  A @NET: USER@ must be set first.  @NET: ERRA@ is set to any error code.  While the 
        connection is being made, this command can block for several ticks.  This command never runs in an @INST@.
        
      ]],
      callback =
        function(self, state )
        end
    },

    ["integer"] = {
      command = "NET: LINE",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if you are connected to the Babel server, or 0 if you aren't.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["NET: PASS"] = {
    ["string"] = {
      command = "NET: PASS",
      rtype = "string",
      params = {},
      description = [[
        Returns the currently set username, as selected with @PASS@.
      ]],
      callback =
        function(self)
          return ""
        end
    },

    ["command"] = {
      command = "NET: PASS",
      rtype = "command",
      params = {
        { "nick_name", "string" },  { "password", "string" } },
      description = [[
        Set nickname and password - do this before connecting with @NET: LINE@.  If you set @GAME@ "@engine_netbabel_save_passwords@" to 1 
        then the password for each nickname is saved in user.cfg, so you can specify an empty string 
        for the password after the first time.  The nickname is saved with the serialised world, so is cleared 
        when you start a new world.  You can use @NET: PASS@ to retrieve the user later.
      ]],
      callback =
        function(self, nick_name, password )
        end
    }
  },


  ["NET: RAWE"] = {
    ["integer"] = {
      command = "NET: RAWE",
      rtype = "integer",
      params = {},
      description = [[
        Returns an internal error code from Babel.  Only use this for display and diagnostic purpose, use @NET: ERRA@ 
        for documented error codes which you can rely on.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["NET: RUSO"] = {
    ["command"] = {
      command = "NET: RUSO",
      rtype = "command",
      params = {
        { "store_result", "variable" } },
      description = [[
        Returns (into store_result) a random user who is currently online.  Returns an empty string if you're offline, 
        or if you aren't using the Docking Station Babel server module.  Since you're online, it can 
        return yourself (especially if you're the only person online!).  The user is also only <i>likely</i> 
        to be online - they could have gone offline since the server replied to you.
        This is a 
        command rather than an integer r-value because it is <i>blocking</i>.  This means that it might 
        take several ticks before the server returns the result.  In this sense it is similar to a command 
        like @OVER@, so it does not run in an @INST@.  You should use @LOCK@ if you don't 
        want your script interrupting.
      ]],
      callback =
        function(self, store_result )
        end
    }
  },


  ["NET: STAT"] = {
    ["command"] = {
      command = "NET: STAT",
      rtype = "command",
      params = {
        { "time_online", "variable" },  { "users_online", "variable" },  { "bytes_received", "variable" },  { "bytes_sent", "variable" } },
      description = [[
        Returns statistics for the current Babel connection, or -1 if offline.  This command can block (doesn't execute in an @INST@).  The statistics are:
        time_online - Time online in milliseconds
        users_online - Number of users currently connected to the server
        bytes_received - Bytes received by the client
        bytes_sent - Bytes sent from the client
      ]],
      callback =
        function(self, time_online, users_online, bytes_received, bytes_sent )
        end
    }
  },


  ["NET: ULIN"] = {
    ["integer"] = {
      command = "NET: ULIN",
      rtype = "integer",
      params = {
        { "user_id", "string" } },
      description = [[
        Returns 1 if the specified user is online, or 0 if they are offline.  This is slow (i.
        e. has to call the server) unless the user is in the whose wanted register of any agent.  
        Use @NET: WHON@ to add a user to the register.
      ]],
      callback =
        function(self, user_id )
          return 0
        end
    }
  },


  ["NET: UNIK"] = {
    ["command"] = {
      command = "NET: UNIK",
      rtype = "command",
      params = {
        { "user_id", "string" },  { "store_result", "variable" } },
      description = [[
        Returns the specified user's screen or nick name.  Returns empty string if offline, or no such user.  
        This command can take many ticks to execute while the server is quizzed, like @NET: RUSO@.
      ]],
      callback =
        function(self, user_id, store_result )
        end
    }
  },


  ["NET: USER"] = {
    ["string"] = {
      command = "NET: USER",
      rtype = "string",
      params = {},
      description = [[
        Returns the user's numeric Babel id, or an empty string if they have never logged in with 
        this world since they last changed user name.
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["NET: WHAT"] = {
    ["string"] = {
      command = "NET: WHAT",
      rtype = "string",
      params = {},
      description = [[
        For debugging only.  Returns a string describing what the upload/query network thread is currently doing.  For example, 
        it may be fetching a random online user, or uploading some creature history.  Returns an emptry string if 
        it is doing nothing.
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },


  ["NET: WHOD"] = {
    ["command"] = {
      command = "NET: WHOD",
      rtype = "command",
      params = {},
      description = [[
        Dump debugging information about the whose wanted register.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["NET: WHOF"] = {
    ["command"] = {
      command = "NET: WHOF",
      rtype = "command",
      params = {
        { "user", "string" } },
      description = [[
        Removes a user from the whose wanted list for the target agent.  See @NET: WHON@.
      ]],
      callback =
        function(self, user )
        end
    }
  },


  ["NET: WHON"] = {
    ["command"] = {
      command = "NET: WHON",
      rtype = "command",
      params = {
        { "user", "string" } },
      description = [[
        Add a user to the whose wanted register for the target agent.  Scripts @User Online@ and @User Offline@ 
        are now called on this agent when that user goes on or offline, or indeed when the local 
        user goes offline.  Use @NET: WHOF@ to remove them from the register.  This command is blocking, it can 
        take several ticks to return.
      ]],
      callback =
        function(self, user )
        end
    }
  },


  ["NET: WHOZ"] = {
    ["command"] = {
      command = "NET: WHOZ",
      rtype = "command",
      params = {},
      description = [[
        Zap the target agent's whose wanted register, removing all entries.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["NET: WRIT"] = {
    ["command"] = {
      command = "NET: WRIT",
      rtype = "command",
      params = {
        { "user_id", "string" },  { "channel", "string" },  { "message_id", "integer" },  { "param_1", "anything" },  { "param_2", "anything" } },
      description = [[
        Send a message to a remote machine, as specified by the user identifier.  All agents which are @NET: 
        HEAR@ing on the given channel will receive the message, and run the appropriate script.  If the specified 
        user is offline, then the message is discarded.  The @FROM@ variable of the receiving script contains the user 
        id of the sender, as a string.  See also @MESG WRIT@.
      ]],
      callback =
        function(self, user_id, channel, message_id, param_1, param_2 )
        end
    }
  },


  ["ECON"] = {
    ["command"] = {
      command = "ECON",
      rtype = "command",
      params = {
        { "agent", "agent" } },
      description = [[
        Starts an enumeration across all the agents in a connective system, where agent is any agent within the 
        connective system.
      ]],
      callback =
        function(self, agent )
        end
    }
  },


  ["PRT: BANG"] = {
    ["command"] = {
      command = "PRT: BANG",
      rtype = "command",
      params = {
        { "bang_strength", "integer" } },
      description = [[
        Breaks connections randomly with other machines (as if the machine had been 'banged'. Use a bang_strength of 100 
        to disconnect all ports, 50 to disconnect about half etc.
      ]],
      callback =
        function(self, bang_strength )
        end
    }
  },


  ["PRT: FRMA"] = {
    ["agent"] = {
      command = "PRT: FRMA",
      rtype = "agent",
      params = {
        { "inputport", "integer" } },
      description = [[
        Returns the agent from which the input port is fed. Returns NULLHANDLE if that port does not exist, 
        or is not connected.
      ]],
      callback =
        function(self, inputport )
          return nil
        end
    }
  },


  ["PRT: FROM"] = {
    ["integer"] = {
      command = "PRT: FROM",
      rtype = "integer",
      params = {
        { "inputport", "integer" } },
      description = [[
        Returns the output port index on the source agent, feeding that input port on the @TARG@ agent.
        Return values are -ve for error.
      ]],
      callback =
        function(self, inputport )
          return 0
        end
    }
  },

  -- N/A
  ["PRT: INEW"] = {
    ["command"] = {
      command = "PRT: INEW",
    rtype = "command",
    params = {
      { "id", "integer" },  { "name", "string" },  { "description", "string" },  { "x", "integer" },  { "y", "integer" },  { "message_num", "integer" } },
    description = [[
      Create a new input port on target. You should number input port ids starting at 0.  The message_num 
      is the message that will be sent to the agent when a signal comes in through the input 
      port. _P1_ of that message will contain the data value of the signal. The position of the port, 
      relative to the agent, is given by x, y.
    ]],
    callback =
      function(self, id, name, description, x, y, message_num )
      end
    }
  },

  -- partial
  ["PRT: ITOT"] = {
    ["integer"] = {
      command = "PRT: ITOT",
      rtype = "integer",
      params = {},
      description = [[
        Returns the number of input ports, assuming they are indexed sequentially.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- N/A
  ["PRT: IZAP"] = {
    ["command"] = {
      command = "PRT: IZAP",
      rtype = "command",
      params = {
        { "id", "integer" } },
      description = [[
        Remove the specified input port.
      ]],
      callback =
        function(self, id )
        end
    }
  },

  
  ["PRT: JOIN"] = {
    ["command"] = {
      command = "PRT: JOIN",
      rtype = "command",
      params = {
        { "source_agent", "agent" },  { "output_id", "integer" },  { "dest_agent", "agent" },  { "input_id", "integer" } },
      description = [[
        Connect an output port on the source agent to an input port on the destination. An input may 
        only be connected to one output at at time, but an output may feed any number of inputs.
      ]],
      callback =
        function(self, source_agent, output_id, dest_agent, input_id )
        end
    }
  },


  ["PRT: KRAK"] = {
    ["command"] = {
      command = "PRT: KRAK",
      rtype = "command",
      params = {
        { "agent", "agent" },  { "in_or_out", "integer" },  { "port_index", "integer" } },
      description = [[
        Breaks a specific connection on a machine. If in_or_out is zero, it is an input port whose connection 
        is broken, if it is an output port, then all inputs are disconnected.
      ]],
      callback =
        function(self, agent, in_or_out, port_index )
        end
    }
  },


  ["PRT: NAME"] = {
    ["string"] = {
      command = "PRT: NAME",
      rtype = "string",
      params = {
        { "agent", "agent" },  { "in_or_out", "integer" },  { "port_index", "integer" } },
      description = [[
        Returns the name of the indexed port (input port if in_or_out is zero, output port if non-zero) 
        on the specified agent. Returns "" in error.
      ]],
      callback =
        function(self, agent, in_or_out, port_index )
          return ""
        end
    }
  },


  ["PRT: ONEW"] = {
    ["command"] = {
      command = "PRT: ONEW",
      rtype = "command",
      params = {
        { "id", "integer" },  { "name", "string" },  { "description", "string" },  { "x", "integer" },  { "y", "integer" } },
      description = [[
        Create a new output port on target. You should number input port ids starting at 0.  The port'
        s relative position is given by x, y.
      ]],
      callback =
        function(self, id, name, description, x, y )
        end
    }
  },

  -- partial
  ["PRT: OTOT"] = {
    ["integer"] = {
      command = "PRT: OTOT",
    rtype = "integer",
    params = {},
    description = [[
      Returns the number of output ports, assuming they are indexed sequentially.
    ]],
    callback =
      function(self)
        return 0
      end
    }
  },


  ["PRT: OZAP"] = {
    ["command"] = {
      command = "PRT: OZAP",
      rtype = "command",
      params = {
        { "id", "integer" } },
      description = [[
        Remove the specified output port.
      ]],
      callback =
        function(self, id )
        end
    }
  },

  -- partial/broken
  ["PRT: SEND"] = {
    ["command"] = {
      command = "PRT: SEND",
      rtype = "command",
      params = {
        { "id", "integer" },  { "data", "anything" } },
      description = [[
        Send a signal from the specified output port to all connected inputs.  The data can be any integer.
      ]],
      callback =
        function(self, id, data )
        end
    }
  },


  ["NET: MAKE"] = {
    ["integer"] = {
      command = "NET: MAKE",
      rtype = "integer",
      params = {
        { "which_journal_spot", "integer" },  { "journal_name", "string" },  { "user", "string" },  { "report_destination", "variable" } },
      description = [[
        Like @PRAY MAKE@, only sends the made pray file to the specified user. This will arrive in their 
        inbox, where it can be read with normal PRAY commands and deleted with @PRAY KILL@.
      ]],
      callback =
        function(self, which_journal_spot, journal_name, user, report_destination )
          return 0
        end
    }
  },


  ["PRAY AGTI"] = {
    ["integer"] = {
      command = "PRAY AGTI",
      rtype = "integer",
      params = {
        { "resource_name", "string" },  { "integer_tag", "string" },  { "default_value", "integer" } },
      description = [[
        This returns the value of the integer tag associated with the named resource. If the resource does not 
        contain such a tag, then the default value specified is returned. This call pairs with @PRAY AGTS@.
      ]],
      callback =
        function(self, resource_name, integer_tag, default_value )
          return 0
        end
    }
  },


  ["PRAY AGTS"] = {
    ["string"] = {
      command = "PRAY AGTS",
      rtype = "string",
      params = {
        { "resource_name", "string" },  { "string_tag", "string" },  { "default_value", "string" } },
      description = [[
        This returns the value of the string tag associated with the named resource. If the resource does not 
        contain such a tag, then the default value specified is returned. This call pairs with @PRAY AGTI@.
      ]],
      callback =
        function(self, resource_name, string_tag, default_value )
          return ""
        end
    }
  },


  ["PRAY BACK"] = {
    ["string"] = {
      command = "PRAY BACK",
      rtype = "string",
      params = {
        { "resource_type", "string" },  { "last_known", "string" } },
      description = [[
        Like @PRAY PREV@, only doesn't loop at the end.  If you go beyond the first entry then 
        it returns an empty string.
      ]],
      callback =
        function(self, resource_type, last_known )
          return ""
        end
    }
  },


  ["PRAY COUN"] = {
    ["integer"] = {
      command = "PRAY COUN",
      rtype = "integer",
      params = {
        { "resource_type", "string" } },
      description = [[
        This returns the number of resource chunks which are tagged with the resource type passed in. Resource types 
        are four characters only. Anything over that length will be silently truncated.
      ]],
      callback =
        function(self, resource_type )
          return 0
        end
    }
  },


  ["PRAY DEPS"] = {
    ["integer"] = {
      command = "PRAY DEPS",
    rtype = "integer",
    params = {
      { "resource_name", "string" },  { "do_install", "integer" } },
    description = [[
      This performs a scan of the specified resource, and checks out the dependency data. The primary use for this would be in the preparation for injection of agents. If you pass zero in the do_install parameter, then the dependencies are only checked. If do_install is non-zero, then they are installed also. The return values are as follows:
      0 = Success
      -1 = Agent Type not found
      -2 = Dependency Count not found
      -3 to -(2 + count) is the dependency string missing
      -(3+count) to -(2+2*count) is the dependency type missing
      2*count to 3*count is the category ID for that dependency being invalid
      1 to count is the dependency failing
    ]],
    callback =
      function(self, resource_name, do_install )
        return 0
      end
    }
  },


  ["PRAY EXPO"] = {
    ["integer"] = {
      command = "PRAY EXPO",
      rtype = "integer",
      params = {
        { "chunk_type", "string" } },
      description = [[
        This function exports the target creature. If the creature is exported successfully then it has been removed from the world. Returns value is one of the following:
        0 for success
        1 if the creature, or if pregnant any of its offspring, are already on disk in some form.
        The chunk type should be used to find the creature again to import it.  In Creatures 3, most exported creatures have a chunk type EXPC, and the starter family uses SFAM.
        For new games, you should not use SFAM, as its data would get confused with that of an EXPC with the same moniker. This is for backwards compatibility with Creatures 3's use of SFAM, which works because the CAOS code guarantees different monikers.
        For other chunk names, creatures exported with a different type are kept entirely separately, and will not get confused with each other. The chunk type is added to the end of the moniker to form the chunk name.
        The exported creature has some fields associated with it, that can be read by @PRAY AGTI@ or @PRAY AGTS@ before importing:
        "Exported At World Time" <i>integer</i>	
        "Creature Age In Ticks" <i>integer</i>	
        "Exported At Real Time" <i>integer</i>	
        "Creature Life Stage" <i>integer</i>	
        "Exported From World Name" <i>string</i>	
        "Exported From World UID" <i>string</i>	
        "Native Network User" <i>string</i>	
        "Last Network User" (could be faked, @NET: FROM@ is safer) <i>string</i>	
        "Creature Name" <i>string</i>	
        "Gender" <i>integer</i>	
        "Genus" <i>integer</i>	
        "Variant" <i>integer</i>	
        "Head Gallery" <i>string</i> (this is calculated on the sending computer, so the file may be missing on the receiving one - try @LIMB@ instead)
        "Pregnancy Status" <i>integer</i>
        In addition you can add custom fields by setting @NAME@ variables on the Creature before export.  Any strings or integers whose name begin "Pray Extra " are added as entries to the export file.
      ]],
      callback =
        function(self, chunk_type )
          return 0
        end
    }
  },


  ["PRAY FILE"] = {
    ["integer"] = {
      command = "PRAY FILE",
      rtype = "integer",
      params = {
        { "resource_name", "string" },  { "resource_type", "integer" },  { "do_install", "integer" } },
      description = [[
        This performs the "installation" of one file from the resource files. The resource_type is defined in the agent 
        resource guide. If do_install is zero, the command simply checks if the file install should succeed. Return value 
        is 0 for success, 1 for error.
      ]],
      callback =
        function(self, resource_name, resource_type, do_install )
          return 0
        end
    }
  },


  ["PRAY FORE"] = {
    ["string"] = {
      command = "PRAY FORE",
      rtype = "string",
      params = {
        { "resource_type", "string" },  { "last_known", "string" } },
      description = [[
        Like @PRAY NEXT@, only doesn't loop at the end.  If you go beyond the last entry then 
        it returns an empty string.
      ]],
      callback =
        function(self, resource_type, last_known )
          return ""
        end
    }
  },


  ["PRAY GARB"] = {
    ["command"] = {
      command = "PRAY GARB",
      rtype = "command",
      params = {
        { "force", "integer" } },
      description = [[
        This command clears the manager's cached resource data. Execute this after a lot of resource accesses (E.
        g. installing an agent) to clean up the memory used during the process. If you don't do 
        this, excess memory can be held for a while, If the parameter is zero (the most usual) then 
        the manager will only forget resources which are not in use at the moment. If force is non-
        zero, then the manager will forget all the previously loaded resources. As the resources currently in use go 
        out of scope, they are automatically garbage collected.
      ]],
      callback =
        function(self, force )
        end
    }
  },


  ["PRAY IMPO"] = {
    ["integer"] = {
      command = "PRAY IMPO",
      rtype = "integer",
      params = {
        { "moniker_chunk", "string" },  { "actually_do_it", "integer" },  { "keep_file", "integer" } },
      description = [[
        This function imports the creature with the requested moniker and chunk type. Returns one of the following codes:
        0 - success
        1 - couldn't reconcile histories so creature was cloned
        2 - moniker not found in PRAY system
        3 - unused error code
        4 - internal / file format error
        Set actually_do_it to 1 to try and perform the import, or 0 
        to perform a query giving just the return value.  You can use the query to test if the 
        creature is available, and if the creature would have to be cloned upon importing, and warn the user.  
        The new creature is @TARG@etted after import.  If you set keep file to 1, then the exported 
        file won't be deleted (moved to the porch).  The creature will appear in the same place that 
        it was exported, but as with @NEW: CREA@, it will be in limbo, and won't function until 
        moved to a valid place.
      ]],
      callback =
        function(self, moniker_chunk, actually_do_it, keep_file )
          return 0
        end
    }
  },


  ["PRAY INJT"] = {
    ["integer"] = {
      command = "PRAY INJT",
      rtype = "integer",
      params = {
        { "resource_name", "string" },  { "do_install", "integer" },  { "report_var", "variable" } },
      description = [[
        This command injects an agent. The agent must be in the chunk named. If do_install is zero, the command simply checks for the presence of the required scripts and dependencies. If non-zero, it attempts to inject the agent. The report var is a string variable, and is set to the name of the offending script if the injection/check fails. 
        Return is 0 for success, -1 for "Script not found" and if injecting, -2 for "Injection failed". 
        Return value -3 indicates that a dependency evaluation failed, and in this case, the report var is the 
        return code from @PRAY DEPS@
      ]],
      callback =
        function(self, resource_name, do_install, report_var )
          return 0
        end
    }
  },


  ["PRAY KILL"] = {
    ["integer"] = {
      command = "PRAY KILL",
      rtype = "integer",
      params = {
        { "resource_name", "string" } },
      description = [[
        Deletes the resource file which contains the specified chunk. This is permanent and irreversible. Returns 1 if there 
        was such a chunk and file, or 0 if there wasn't.
      ]],
      callback =
        function(self, resource_name )
          return 0
        end
    }
  },


  ["PRAY MAKE"] = {
    ["integer"] = {
      command = "PRAY MAKE",
      rtype = "integer",
      params = {
        { "which_journal_spot", "integer" },  { "journal_name", "string" },  { "which_pray_spot", "integer" },  { "pray_name", "string" },  { "report_destination", "variable" } },
      description = [[
        <b>Please see the documentation accompanying the praybuilder on CDN</b>
        Suffice it to say: return value is zero for success, otherwise non-zero, and report is set to the praybuilder output for you
        Also, the which_journal_spot is zero for world journal, 1 for global journal. Also the which_pray_spot is zero for "My Agents" and 1 for "My Creatures"
      ]],
      callback =
        function(self, which_journal_spot, journal_name, which_pray_spot, pray_name, report_destination )
          return 0
        end
    }
  },


  ["PRAY NEXT"] = {
    ["string"] = {
      command = "PRAY NEXT",
      rtype = "string",
      params = {
        { "resource_type", "string" },  { "last_known", "string" } },
      description = [[
        This returns the name of the resource chunk directly after the named one, given that they are of 
        the same type. It loops when it reaches the end.  If the named resource cannot be found in 
        the list of resources of the type specified, then the last resource of that type is returned. This 
        call pairs with @PRAY PREV@.  Compare @PRAY FORE@.
      ]],
      callback =
        function(self, resource_type, last_known )
          return ""
        end
    }
  },


  ["PRAY PREV"] = {
    ["string"] = {
      command = "PRAY PREV",
      rtype = "string",
      params = {
        { "resource_type", "string" },  { "last_known", "string" } },
      description = [[
        This returns the name of the resource chunk directly before the named one, given that they are of 
        the same type. It loops when it reaches the end.  If the named resource cannot be found in 
        the list of resources of the type specified, then the first resource of that type is returned. This 
        call pairs with @PRAY NEXT@.  Compare @PRAY BACK@.
      ]],
      callback =
        function(self, resource_type, last_known )
          return ""
        end
    }
  },


  ["PRAY REFR"] = {
    ["command"] = {
      command = "PRAY REFR",
      rtype = "command",
      params = {},
      description = [[
        This command refreshes the engine's view of the Resource directory. Execute this if you have reason to 
        believe that the files in the directory may have changed. It only detects changes if there is a 
        new file or a deleted file - if a file has only changed it won't notice.  This is 
        awkward during development, you can use @PRAY KILL@ to kill the old file before copying the new one 
        over.  PRAY REFR forces a @PRAY GARB@ to happen automatically.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["PRAY TEST"] = {
    ["integer"] = {
      command = "PRAY TEST",
      rtype = "integer",
      params = {
        { "resource_name", "string" } },
      description = [[
        This checks for the existence of a chunk, returning zero if it is not found, and a value from 1-3 indicating the cost to load if it is.
        Return values are currently defined as:
        0 - Chunk not available at this time
        1 - Chunk Available, Cached and ready for use
        2 - Chunk available, on disk uncompressed and fine for loading
        3 - Chunk available, on disk compressed and ready for loading. 
        Thus the return value could be thought 
        of as the cost of loading, where 1 is no cost, and 3 is high cost.
      ]],
      callback =
        function(self, resource_name )
          return 0
        end
    }
  },


  ["CAOS"] = {
    ["string"] = {
      command = "CAOS",
      rtype = "string",
      params = {
        { "inline", "integer" },  { "state_trans", "integer" },  { "p1", "anything" },  { "p2", "anything" },  { "commands", "string" },  { "throws", "integer" },  { "catches", "integer" },  { "report", "variable" } },
      description = [[
        Executes the specified CAOS commands instantly. The local environment (@_IT_@ @VAxx@ @TARG@ @OWNR@ etc.) will be promoted to 
        the script's environment if inline is non-zero. If state_trans is non-zero, then @FROM@ and @OWNR@ 
        are propogated, if zero, then the script is run orphaned. CAOS returns the output of the script. As 
        you can put multiple scripts through in one call, the output is potentially concatenated. Note that all sets 
        of scripts are executed in the same virtual machine if inline is non-zero, otherwise the virtual machine 
        is reset before each script is passed. The params _p0_ and _p1_ are passed in as the parameters 
        to the script, even when inline.  You can execute "outv 7 endm scrp 3 7 11 6 outv 
        3 endm outv 9", which will make a script 3 7 11 6 and return "79". 
        If 
        throws is non-zero then the system will throw exceptions, otherwise it will return "***" with report set to 
        the exception sid in the CAOS catalogue TAG. If catches is non-zero then the system will catch 
        any run errors encountered and return them in report, having set the return value to "###" first.
      ]],
      callback =
        function(self, inline, state_trans, p1, p2, commands, throws, catches, report )
          return ""
        end
    }
  },

  -- full
  ["GIDS FMLY"] = {
    ["command"] = {
      command = "GIDS FMLY",
      rtype = "command",
      params = {
        { "family", "integer" } },
      description = [[
        Output the genus numbers for which there are scripts in the scriptorium for the given family.  List is 
        space delimited.
      ]],
      callback =
        function(self, family )
          if ( CAOS.script_exists(family) ) then
          
            local keyset = {}
            local n = 0

            for k,v in pairs(CAOS.scriptorium[family]) do
              n = n+1
              keyset[n] = k
            end
            
            world.logInfo("%s", table.concat(keyset, " "))
          end
        end
    }
  },

  -- full
  ["GIDS GNUS"] = {
    ["command"] = {
      command = "GIDS GNUS",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" } },
      description = [[
        Output the species numbers for which there are scripts in the scriptorium for the given family and genus.  
        List is space delimited.
      ]],
      callback =
        function(self, family, genus )
          if ( CAOS.script_exists(family, genus) ) then
          
            local keyset = {}
            local n = 0

            for k,v in pairs(CAOS.scriptorium[family][genus]) do
              n = n+1
              keyset[n] = k
            end
            
            world.logInfo("%s", table.concat(keyset, " "))
          end
        end
    }
  },

  -- full
  ["GIDS ROOT"] = {
    ["command"] = {
      command = "GIDS ROOT",
      rtype = "command",
      params = {},
      description = [[
        Output the family numbers for which there are scripts in the scriptorium.  List is space delimited.
      ]],
      callback =
        function(self)
          if ( CAOS.script_exists() ) then
          
            local keyset = {}
            local n = 0

            for k,v in pairs(CAOS.scriptorium) do
              n = n+1
              keyset[n] = k
            end
            
            world.logInfo("%s", table.concat(keyset, " "))
          end
        end
    }
  },

  -- full
  ["GIDS SPCS"] = {
    ["command"] = {
      command = "GIDS SPCS",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Output the event numbers of scripts in the scriptorium for the given classifier.  List is space delimited.
      ]],
      callback =
        function(self, family, genus, species )
          if ( CAOS.script_exists(family, genus, species) ) then
          
            local keyset = {}
            local n = 0

            for k,v in pairs(CAOS.scriptorium[family][genus][species]) do
              n = n+1
              keyset[n] = k
            end
            
            world.logInfo("%s", table.concat(keyset, " "))
          end
        end
    }
  },

  -- full
  ["INST"] = {
    ["command"] = {
      command = "INST",
      rtype = "command",
      params = {},
      description = [[
        This command indicates that the following commands should execute in a single tick - ie the script cannot be 
        interrupted by the script 'scheduler'. This can be important for certain tasks which might leave an agent in 
        an undefined (and dangerous) state if interrupted. The INST state is broken either manually, using a @SLOW@ command, 
        or implictly, if a blocking instruction is encountered (eg @WAIT@). Blocking instructions force the remainder of the script'
        s timeslice to be discarded.
      ]],
      callback =
        function(self)
          self.instant_execution = true
        end
    }
  },


  ["JECT"] = {
    ["command"] = {
      command = "JECT",
      rtype = "command",
      params = {
        { "cos_file", "string" },  { "flags", "integer" } },
      description = [[
        Injects a COS file from the bootstrap directory.  The file is searched for (case insensitively) in all bootstrap subdirectories.  You must specify the file extension (it doesn't have to be .cos).  Flags is a combination of what you want to inject:
        1 - Remove sctipt
        2 - Event scripts
        4 - Install script
        The scripts (if present) are injected in that order.  So, setting flags to 7 
        will fully uninstall and reinstall the cos file.  Error messages and output are written to the current output 
        stream.
      ]],
      callback =
        function(self, cos_file, flags )
        end
    }
  },

  -- full
  ["LOCK"] = {
    ["command"] = {
      command = "LOCK",
      rtype = "command",
      params = {},
      description = [[
        Prevent the current script being interrupted until @UNLK@.  Normally, events other than timer scripts interrupt (abort) currently running 
        scripts.  You can also use @INST@ for similar, stronger protection.
      ]],
      callback =
        function(self)
          self.no_interrupt = true
        end
    }
  },

  -- full
  ["SCRX"] = {
    ["command"] = {
      command = "SCRX",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "event", "integer" } },
      description = [[
        Remove specified script from the scriptorium.
      ]],
      callback =
        function(self, family, genus, species, event )
          if ( CAOS.script_exists(family, genus, species, event) ) then
            CAOS.scriptorium[family][genus][species][event] = nil
          end
        end
    }
  },

  -- full
  ["SLOW"] = {
    ["command"] = {
      command = "SLOW",
      rtype = "command",
      params = {},
      description = [[
        Turn off @INST@ state.
      ]],
      callback =
        function(self)
          self.instant_execution = false
        end
    }
  },

  -- full
  ["SORC"] = {
    ["string"] = {
      command = "SORC",
      rtype = "string",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "event", "integer" } },
      description = [[
        Returns the source code for the specified script.  Use the @GIDS@ commands to find available scripts.
      ]],
      callback =
        function(self, family, genus, species, event )
          --if ( CAOS.script_exists(family, genus, species, event) ) then
          --  return CAOS.scriptorium[family][genus][species][event]["source"]
          --end
          return ""
        end
    }
  },

  -- full
  ["SORQ"] = {
    ["integer"] = {
      command = "SORQ",
      rtype = "integer",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "event", "integer" } },
      description = [[
        Returns 1 if the script is in the scriptorium, or if there is a general event script for 
        the entire genus, or family.  Returns 0 if there is no matching script.
      ]],
      callback =
        function(self, family, genus, species, event )
          if ( CAOS.script_exists(family, genus, species, event)
                or CAOS.script_exists(family, genus, 0, event)
                or CAOS.script_exists(family, 0, 0, event) ) then
            return 1
          end
          return 0
        end
    }
  },

  -- full
  ["STOP"] = {
    ["command"] = {
      command = "STOP",
      rtype = "command",
      params = {},
      description = [[
        Stops running the current script.  Compare @STPT@.
      ]],
      callback =
        function(self)
          self:stop()
        end
    }
  },

  -- full
  ["STPT"] = {
    ["command"] = {
      command = "STPT",
      rtype = "command",
      params = {},
      description = [[
        Stops any currently running script in the target agent.  See also @STOP@.
      ]],
      callback =
        function(self)
          local vm = self.vm.target:getVar("caos_vm")
          vm.parser:stop()
        end
    }
  },

  -- full
  ["UNLK"] = {
    ["command"] = {
      command = "UNLK",
      rtype = "command",
      params = {},
      description = [[
        End the @LOCK@ section.
      ]],
      callback =
        function(self)
          self.no_interrupt = false
        end
    }
  },

  -- full
  ["WAIT"] = {
    ["command"] = {
      command = "WAIT",
      rtype = "command",
      params = {
        { "ticks", "integer" } },
      description = [[
        Block the script for the specified number of ticks. This command does an implicit @SLOW@.
      ]],
      callback =
        function(self, ticks )
          self.instant_execution = false
          self.wait_time = ticks
        end
    }
  },

  -- N/A
  ["FADE"] = {
    ["command"] = {
      command = "FADE",
      rtype = "command",
      params = {},
      description = [[
        Fade out a controlled sound.
      ]],
      callback =
        function(self)
        end
    }
  },

  -- N/A ?
  ["MCLR"] = {
    ["command"] = {
      command = "MCLR",
      rtype = "command",
      params = {
        { "x", "integer" },  { "y", "integer" } },
      description = [[
        Clear the music for the metaroom at the given location.
      ]],
      callback =
        function(self, x, y )
        end
    }
  },

  -- N/A or needs workaround
  ["MIDI"] = {
    ["command"] = {
      command = "MIDI",
      rtype = "command",
      params = {
        { "midi_file", "string" } },
      description = [[
        Plays a MIDI file.  Set to an empty string to stop the MIDI player.
      ]],
      callback =
        function(self, midi_file )
        end
    }
  },

  -- needs workaround?
  ["MMSC"] = {
    ["command"] = {
      command = "MMSC",
      rtype = "command",
      params = {
        { "x", "integer" },  { "y", "integer" },  { "track_name", "string" } },
      description = [[
        Associates a music track with the meta room at the specified coordinates.
      ]],
      callback =
        function(self, x, y, track_name )
        end
    },

    ["string"] = {
      command = "MMSC",
      rtype = "string",
      params = {
        { "x", "integer" },  { "y", "integer" } },
      description = [[
        Returns the name of the music track played at the metaroom in the given location.
      ]],
      callback =
        function(self, x, y )
          return ""
        end
    }
  },

  -- N/A
  ["MUTE"] = {
    ["integer"] = {
      command = "MUTE",
      rtype = "integer",
      params = {
        { "andMask", "integer" },  { "eorMask", "integer" } },
      description = [[
        This returns (and potentially sets) the mute values for the sound managers in the game. Sensible settings for the parameters are as follows:
        <table border=1><tr><th>andMask</th><th>eorMask</th><th>returns</th></tr><tr><td>0</td><td>3</td><td>3 - Mutes both sound and music</td></tr><tr><td>3</td><td>0</td><td>0 for no mute
        1 for sound muted
        2 for music muted
        3 for both muted
        Sets nothing</td></tr><tr><td>1</td><td>2</td><td>Returns 2 for music muted, or 3 for both muted
        Only sets mute on music, leaves sound alone</td></tr></table>
      ]],
      callback =
        function(self, andMask, eorMask )
          return 0
        end
    }
  },

  -- N/A ?
  ["RCLR"] = {
    ["command"] = {
      command = "RCLR",
      rtype = "command",
      params = {
        { "x", "integer" },  { "y", "integer" } },
      description = [[
        Clear the music for the room at the given location.
      ]],
      callback =
        function(self, x, y )
        end
    }
  },

  -- needs workaround?
  ["RMSC"] = {
    ["command"] = {
      command = "RMSC",
      rtype = "command",
      params = {
        { "x", "integer" },  { "y", "integer" },  { "track_name", "string" } },
      description = [[
        Associates a music track with the room at the specified coordinates.  This overrides any track specified for the 
        metaroom that the room is in.
      ]],
      callback =
        function(self, x, y, track_name )
        end
    },

    ["string"] = {
      command = "RMSC",
      rtype = "string",
      params = {
        { "x", "integer" },  { "y", "integer" } },
      description = [[
        Returns the name of the music track played at the room in the given location.
      ]],
      callback =
        function(self, x, y )
          return ""
        end
    }
  },

  -- partial
  ["SEZZ"] = {
    ["command"] = {
      command = "SEZZ",
    rtype = "command",
    params = {
      { "text", "string" } },
    description = [[
      Makes the @TARG@ agent speak the specified text with voice as set by @VOIS@ or @VOIC@. If @TARG@ 
      is a creature then it will be spoken properly (speech bubble et al).
    ]],
    callback =
      function(self, text )
        self.vm.target:playVoice( self.vm.target:getVar("caos_voice") )
        self.vm.target:say(text)
        
          -- TODO: use debug text??
        world.logInfo("%s says \"%s\"", self.vm.target:name(), text)
      end
    }
  },

  -- full
  ["SNDC"] = {
    ["command"] = {
      command = "SNDC",
      rtype = "command",
      params = {
        { "sound_file", "string" } },
      description = [[
        Plays a controlled sound effect emitted from the target.  Updates volume and panning 
        as the agent moves.
      ]],
      callback =
        function(self, sound_file )
          self.vm.target:playSound(sound_file)
        end
    }
  },

  -- full
  ["SNDE"] = {
    ["command"] = {
      command = "SNDE",
      rtype = "command",
      params = {
        { "sound_file", "string" } },
      description = [[
        Play a sound effect audible as if emitted from target's current location.
      ]],
      callback =
        function(self, sound_file )
          self.vm.target:playSound(sound_file)
        end
    }
  },


  ["SNDL"] = {
    ["command"] = {
      command = "SNDL",
      rtype = "command",
      params = {
        { "sound_file", "string" } },
      description = [[
        Play a sound effect as in @SNDC@, only the sound is looped.
      ]],
      callback =
        function(self, sound_file )
        end
    }
  },

  -- partial, uncommon
  ["SNDQ"] = {
    ["command"] = {
      command = "SNDQ",
      rtype = "command",
      params = {
        { "sound_file", "string" },  { "delay", "integer" } },
      description = [[
        As @SNDE@, only with a delay before playing.
      ]],
      callback =
        function(self, sound_file, delay )
          -- TODO
          self.vm.target:playSound(sound_file)
        end
    }
  },

  -- N/A ?
  ["STPC"] = {
    ["command"] = {
      command = "STPC",
      rtype = "command",
      params = {},
      description = [[
        Stops a controlled sound.
      ]],
      callback =
        function(self)
        end
    }
  },


  ["STRK"] = {
    ["command"] = {
      command = "STRK",
      rtype = "command",
      params = {
        { "latency", "integer" },  { "track", "string" } },
      description = [[
        This triggers the music track specified. The track will play for at least latency seconds before being overridden 
        by room or metaroom music.
      ]],
      callback =
        function(self, latency, track )
        end
    }
  },


  ["VOIC"] = {
    ["command"] = {
      command = "VOIC",
      rtype = "command",
      params = {
        { "genus", "integer" },  { "gender", "integer" },  { "age", "integer" } },
      description = [[
        This sets the @TARG@ agent's voice to the specified creature voice, using standard cascade techniques to select 
        the nearest match.  On failure, "DefaultVoice" will be reloaded.  Use @SEZZ@ to actually say something.
      ]],
      callback =
        function(self, genus, gender, age )
        end
    }
  },

  -- full
  ["VOIS"] = {
    ["command"] = {
      command = "VOIS",
      rtype = "command",
      params = {
        { "voice_name", "string" } },
      description = [[
        Sets the @TARG@ agent's voice to the specified value. The voice name must be valid in the 
        catalogue. If it fails, then "DefaultVoice" will be reloaded.  Use @SEZZ@ to actually say something.
      ]],
      callback =
        function(self, voice_name )
          self.vm.target:setVar("caos_voice", voice_name)
        end
    },

    ["string"] = {
      command = "VOIS",
      rtype = "string",
      params = {},
      description = [[
        This returns the voice name for the @TARG@ agent. (Unless it has been serialised in :( In which case 
        it returns "Lozenged" if the agent had a voice before the save, or "" as normal if the agent 
        can't speak.)
      ]],
      callback =
        function(self)
          return self.vm.target:getVar("caos_voice") or ""
        end
    }
  },

  -- N/A
  ["VOLM"] = {
    ["command"] = {
      command = "VOLM",
      rtype = "command",
      params = {
        { "channel", "integer" },  { "volume", "integer" } },
      description = [[
        Set overall the volume of the sound effects (channel 0), the MIDI (channel 1) or the generated music (
        channel 2).  Values range from -10000 (silent) to 0 (loudest).
      ]],
      callback =
        function(self, channel, volume )
        end
    },

    ["integer"] = {
      command = "VOLM",
      rtype = "integer",
      params = {
        { "channel", "integer" } },
      description = [[
        Returns the overall the volume of the sound effects (channel 0), the MIDI (channel 1) or the generated 
        music (channel 2).  Values range from -10000 (silent) to 0 (loudest).  Currently not supported for MIDI.
      ]],
      callback =
        function(self, channel )
          return 0
        end
    }
  },

  -- full/partial
  ["BUZZ"] = {
    ["command"] = {
      command = "BUZZ",
      rtype = "command",
      params = {
        { "interval", "integer" } },
      description = [[
        Sets the ideal interval in milliseconds between each tick.  However fast the machine, it won't tick quicker 
        than this, but it might tick slower.  You can find the actual time taken with @RACE@.  Changing this 
        from the default value of 50 midgame will damage profiling and seasons.  Things such as creature brains are 
        designed for the default 50 millisecond update interval.  Change this with caution!
      ]],
      callback =
        function(self, interval )
          self.vm.update_interval = interval
        end
    },

    ["integer"] = {
      command = "BUZZ",
      rtype = "integer",
      params = {},
      description = [[
        Returns the ideal interval in milliseconds between each tick.  You can find the actual interval with @RACE@.
      ]],
      callback =
        function(self)
          return self.vm.update_interval or 50
        end
    }
  },

  -- full
  ["DATE"] = {
    ["integer"] = {
      command = "DATE",
    rtype = "integer",
    params = {},
    description = [[
      Returns the day within the current season, from 0 to @GAME@ "engine_LengthOfSeasonInDays" - 1.  See also @HIST DATE@.
    ]],
    callback =
      function(self)
        local days_in_season = self.vm:get_game_var("engine_LengthOfSeasonInDays").get()
        if ( days_in_season <= 0 ) then
          days_in_season = 4
        end
        
        return math.floor(world.day()) % days_in_season
      end
    }
  },


  ["DAYT"] = {
    ["integer"] = {
      command = "DAYT",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current day of the month
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full
  ["ETIK"] = {
    ["integer"] = {
      command = "ETIK",
      rtype = "integer",
      params = {},
      description = [[
        Returns the number of ticks since the engine was loaded in.
      ]],
      callback =
        function(self)
          return math.floor(os.clock()*1000 / (math.max(self.vm.update_interval, 1)) )
        end
    }
  },


  ["HIST DATE"] = {
    ["integer"] = {
      command = "HIST DATE",
      rtype = "integer",
      params = {
        { "world_tick", "integer" } },
      description = [[
        Returns the day within the current season.  This is the same as @DATE@.  See also @WTIK@ and @HIST 
        WTIK@.
      ]],
      callback =
        function(self, world_tick )
          return 0
        end
    }
  },


  ["HIST SEAN"] = {
    ["integer"] = {
      command = "HIST SEAN",
      rtype = "integer",
      params = {
        { "world_tick", "integer" } },
      description = [[
        Returns the current season for a given world tick.  This is the same as @SEAN@.  See also @WTIK@ 
        and @HIST WTIK@.
      ]],
      callback =
        function(self, world_tick )
          return 0
        end
    }
  },


  ["HIST TIME"] = {
    ["integer"] = {
      command = "HIST TIME",
      rtype = "integer",
      params = {
        { "world_tick", "integer" } },
      description = [[
        Returns the time of day for a given world tick.  This is the same as @TIME@.  See also @
        WTIK@ and @HIST WTIK@.
      ]],
      callback =
        function(self, world_tick )
          return 0
        end
    }
  },


  ["HIST YEAR"] = {
    ["integer"] = {
      command = "HIST YEAR",
      rtype = "integer",
      params = {
        { "world_tick", "integer" } },
      description = [[
        Returns the number of game years elapsed for a given world tick.  This is the same as @YEAR@.  
        See also @WTIK@ and @HIST WTIK@.
      ]],
      callback =
        function(self, world_tick )
          return 0
        end
    }
  },


  ["MONT"] = {
    ["integer"] = {
      command = "MONT",
      rtype = "integer",
      params = {},
      description = [[
        Returns the month of the year
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full
  ["MSEC"] = {
    ["integer"] = {
      command = "MSEC",
    rtype = "integer",
    params = {},
    description = [[
      Returns a time stamp measured in milliseconds.  It is not specified when the time is measured from; the 
      stamp is only guaranteed to be consistent during one session.
    ]],
    callback =
      function(self)
        return math.floor(os.clock()*1000)
      end
    }
  },


  ["PACE"] = {
    ["float"] = {
      command = "PACE",
      rtype = "float",
      params = {},
      description = [[
        Returns the tick rate satisfaction factor.
        Factor 1 - ticks are taking the time we would expect them to, which is set by @BUZZ@.
        Factor more than 1 - the engine is running too slowly.
        Factor less than 1 - the engine is leaving spare processing time.
        This is averaged over the last 10 ticks.
        Agents can look at this to adjust the resources 
        they use according to current spare processing time.  For example, if you have a random snowflake generator in 
        winter, you could increase the chance of generation if PACE is low, and decrease the chance if PACE 
        is high.  When you do this remember that computers will be arbitarily faster in the future, so you 
        should place an extra upper limit on the number of snowflakes to stop them filling the whole screen.<
        p>Note that PACE only measures the time the engine takes for tick processing, not for handling requests 
        from external applications, or adding Windows events to its internal queue.  Because of this, you should aim for 
        a value which is a bit less than 1.
        Compare @RACE@.
      ]],
      callback =
        function(self)
          return 0.0
        end
    }
  },


  ["RACE"] = {
    ["integer"] = {
      command = "RACE",
      rtype = "integer",
      params = {},
      description = [[
        Returns the time in milliseconds which the last tick took overall.  This differs from @PACE@ in that on 
        fast machines it will have a minimum of 50 milliseconds, or the value set by @BUZZ@.  It accounts 
        for all the time in the tick, including event handling and window processing.
      ]],
      callback =
        function(self)
          return self.vm.owner:dt()
        end
    }
  },

  ["RTIF"] = {
    ["string"] = {
      command = "RTIF",
      rtype = "string",
      params = {
        { "real_time", "integer" },  { "format", "string" } },
      description = [[
        Takes a real world time, as returned by @RTIM@ or @HIST RTIM@ and converts it to	a localised string for display.  The format string is made up of any text, with the following special codes:
        %a - Abbreviated weekday name
        %A - Full weekday name
        %b - Abbreviated month name
        %B - Full month name
        %c - Date and time representation appropriate for locale
        %d - Day of month as decimal number (01 - 31)
        %H - Hour in 24-hour format (00 - 23)
        %I - Hour in 12-hour format (01 - 12)
        %j - Day of year as decimal number (001 - 366)
        %m - Month as decimal number (01 - 12)
        %M - Minute as decimal number (00 - 59)
        %p - Current localeâ€™s AM/PM indicator for 12-hour clock
        %S - Second as decimal number (00 - 59)
        %U - Week of year as decimal number, with Sunday as first day of week (00 - 53)
        %w - Weekday as decimal number (0 - 6; Sunday is 0)
        %W - Week of year as decimal number, with Monday as first day of week (00 - 53)
        %x - Date representation for current locale
        %X - Time representation for current locale
        %y - Year without century, as decimal number (00 - 99)
        %Y - Year with century, as decimal number
        %z, %Z - Time-zone name or abbreviation; no characters if time zone is unknown
        %% - Percent sign
        The # flag may prefix any formatting code, having the following meanings:
        %#a, %#A, %#b, %#B, %#p, %#X, %#z, %#Z, %#% # flag is ignored. 
        %#c Long date and time representation, appropriate for current locale. For example: Tuesday, March 14, 1995, 12:41:29. 
        %#x Long date representation, appropriate to current locale. For example: Tuesday, March 14, 1995. 
        %#d, %#H, %#I, %#j, %#m, %#M, %#S, %#U, %#w, %#W, %#y, %#Y Remove leading zeros (if any).
        You probably want to @READ@ any formatted string you use from a catalogue file.
      ]],
      callback =
        function(self, real_time, format_ )
          return ""
        end
    }
  },

  -- full
  ["RTIM"] = {
    ["integer"] = {
      command = "RTIM",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current real world time.  This is measured in seconds since midnight, 1 January 1970 in UTC. 
        To display, use @RTIF@.
      ]],
      callback =
        function(self)
          return os.time()
        end
    }
  },


  ["SCOL"] = {
    ["integer"] = {
      command = "SCOL",
      rtype = "integer",
      params = {
        { "and_mask", "integer" },  { "eor_mask", "integer" },  { "up_speeds", "byte-string" },  { "down_speeds", "byte-string" } },
      description = [[
        Set an AND and an EOR mask, to control the following scrolling functions:
        1 - Screen edge nudgy scrolling
        2 - Keyboard scrolling
        4 - Middle mouse button screen dragging
        8 - Mouse wheel screen scrolling
        The byte strings is used for nudgy and keyboard scrolling.  The defaults 
        are [1 2 4 8 16 32 64] and [0 1 2 4 8 16 32].  They represent 
        the number of pixels scrolled each consecutive tick, as the scrolling gets slower and faster.
        If you use [] for a byte string, then the string won't be changed at all.
      ]],
      callback =
        function(self, and_mask, eor_mask, up_speeds, down_speeds )
          return 0
        end
    }
  },

  -- full
  ["SEAN"] = {
    ["integer"] = {
      command = "SEAN",
      rtype = "integer",
      params = {},
      description = [[
        Returns the current season.  This can be
        0 - spring
        1 - summer
        2 - autumn
        3 - winter
        The @GAME@ variable engine_LengthOfSeasonInDays sets the season length.  See also @HIST SEAN@.
      ]],
      callback =
        function(self)
          local days_in_season = self.vm:get_game_var("engine_LengthOfSeasonInDays").get()
          if ( days_in_season <= 0 ) then
            days_in_season = 4
          end
          
          local seasons_in_year = self.vm:get_game_var("engine_NumberOfSeasons").get()
          if ( seasons_in_year <= 0 ) then
            seasons_in_year = 4
          end
          
          return math.floor(world.day() / days_in_season) % seasons_in_year
        end
    }
  },

  -- full
  ["TIME"] = {
    ["integer"] = {
      command = "TIME",
      rtype = "integer",
      params = {},
      description = [[
        Returns the time of day.  This can be
        0 - dawn
        1 - morning
        2 - afternoon
        3 - evening
        4 - night
        The @GAME@ variable engine_LengthOfDayInMinutes sets the day length.  See also @HIST TIME@.
      ]],
      callback =
        function(self)
          local elapsed = world.timeOfDay()      -- from 0.0 to 1.0
          
          if ( elapsed < 0.2 ) then
            return CAOS.TIME_OF_DAY.DAWN
          elseif ( elapsed < 0.4 ) then
            return CAOS.TIME_OF_DAY.MORNING
          elseif ( elapsed < 0.6 ) then
            return CAOS.TIME_OF_DAY.AFTERNOON
          elseif ( elapsed < 0.8 ) then
            return CAOS.TIME_OF_DAY.EVENING
          else
            return CAOS.TIME_OF_DAY.NIGHT
          end
        end
    }
  },

  -- N/A (don't care)
  ["WOLF"] = {
    ["integer"] = {
      command = "WOLF",
      rtype = "integer",
      params = {
        { "kanga_mask", "integer" },  { "eeyore_mask", "integer" } },
      description = [[
        Provides various functions to distort space-time and otherwise help with wolfing runs.  Set an AND and an EOR mask, to control the following bits:
        1 - Display rendering.  Turning it off speeds the game up.
        2 - Fastest ticks.  The game usually runs at a maximum of 20 frames per second.  If this is set, it instead runs as fast as it can.
        4 - Refresh display at end of tick.  If set, then the display is updated at the end of the tick, and the flag is cleared.
        8 - Autokill.  If set, agents which generate run errors are automatically killed, as the command line option.
      ]],
      callback =
        function(self, kanga_mask, eeyore_mask )
          return 0
        end
    }
  },


  ["WPAU"] = {
    ["command"] = {
      command = "WPAU",
      rtype = "command",
      params = {
        { "paused", "integer" } },
      description = [[
        Stops world ticks from running.  Days, seasons and years won't change and any delayed messages are paused, 
        as are CAs and some sound effects.  Set to 1 to pause, 0 to run.  Use along with @
        PAUS@.
      ]],
      callback =
        function(self, paused )
        end
    },

    ["integer"] = {
      command = "WPAU",
      rtype = "integer",
      params = {},
      description = [[
        Returns 1 if world ticks are paused, or 0 otherwise.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full
  ["WTIK"] = {
    ["integer"] = {
      command = "WTIK",
    rtype = "integer",
    params = {},
    description = [[
      Returns the number of ticks since the world was first made.  For debugging purposes only you can change 
      this value with @DBG: WTIK@.
    ]],
    callback =
      function(self)
        return world.time()
      end
    }
  },

  -- full
  ["YEAR"] = {
    ["integer"] = {
      command = "YEAR",
      rtype = "integer",
      params = {},
      description = [[
        Returns the number of game years elapsed.  The @GAME@ variable engine_NumberOfSeasons sets the year length.  See also @HIST 
        YEAR@.
      ]],
      callback =
        function(self)
          local days_in_season = self.vm:get_game_var("engine_LengthOfSeasonInDays").get()
          if ( days_in_season <= 0 ) then
            days_in_season = 4
          end
          
          local seasons_in_year = self.vm:get_game_var("engine_NumberOfSeasons").get()
          if ( seasons_in_year <= 0 ) then
            seasons_in_year = 4
          end
          
          return math.floor(world.day() / (days_in_season * seasons_in_year))
        end
    }
  },

  -- full
  ["ABSV"] = {
    ["command"] = {
      command = "ABSV",
      rtype = "command",
      params = {
        { "var", "variable" } },
      description = [[
        Makes a variable positive (its absolute value), so if var is negative var = 0 - var, otherwise var is 
        left alone.
      ]],
      callback =
        function(self, var )
          var:set( math.abs(var:get()) )
        end
    }
  },

  -- full
  ["ACOS"] = {
    ["float"] = {
      command = "ACOS",
      rtype = "float",
      params = {
        { "x", "float" } },
      description = [[
        Returns arccosine of x in degrees.
      ]],
      callback =
        function(self, x )
          return math.acos(x) * 180.0 / math.pi
        end
    }
  },

  -- full
  ["ADDS"] = {
    ["command"] = {
      command = "ADDS",
      rtype = "command",
      params = {
        { "var", "variable" },  { "append", "string" } },
      description = [[
        Concatenates two strings, so var = var + append.
      ]],
      callback =
        function(self, var, append )
          var:set( var:get() .. append)
        end
    }
  },

  -- full
  ["ADDV"] = {
    ["command"] = {
      command = "ADDV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "sum", "decimal" } },
      description = [[
        Adds two integers or floats, so var = var + sum.
      ]],
      callback =
        function(self, var, sum )
          var:set( var:get() + sum )
        end
    }
  },

  -- full
  ["ANDV"] = {
    ["command"] = {
      command = "ANDV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "value", "integer" } },
      description = [[
        Peform a bitwise AND on an integer variable, so var = var & value.
      ]],
      callback =
        function(self, var, value )
          var:set( bit32.band(var:get(), value) )
        end
    }
  },

  -- full
  ["ASIN"] = {
    ["float"] = {
      command = "ASIN",
      rtype = "float",
      params = {
        { "x", "float" } },
      description = [[
        Returns arcsine of x in degrees.
      ]],
      callback =
        function(self, x )
          return math.asin(x) * 180.0 / math.pi
        end
    }
  },

  -- full
  ["ATAN"] = {
    ["float"] = {
      command = "ATAN",
      rtype = "float",
      params = {
        { "x", "float" } },
      description = [[
        Returns arctangent of x in degrees.
      ]],
      callback =
        function(self, x )
          return math.atan(x) * 180.0 / math.pi
        end
    }
  },


  ["AVAR"] = {
    ["variable"] = {
      command = "AVAR",
      rtype = "variable",
      params = {
        { "agent", "agent" },  { "index", "integer" } },
      description = [[
        This is the OVnn variable of the agent passed in.  It is equivalent to target agent, OVnn, but 
        means that you don't need to target it first :)  You can also use them to implement primitive 
        arrays.
      ]],
      callback =
        function(self, agent, index )
          return nil
        end
    }
  },

  -- full (needs verification)
  ["CHAR"] = {
    ["command"] = {
      command = "CHAR",
      rtype = "command",
      params = {
        { "string", "variable" },  { "index", "integer" },  { "character", "integer" } },
      description = [[
        Sets a character in a string.  String indices begin at 1.
      ]],
      callback =
        function(self, string_, index, character )
          loc_str = string_:get()
          loc_str[index] = character
          string_:set(loc_str)
        end
    },

    ["integer"] = {
      command = "CHAR",
      rtype = "integer",
      params = {
        { "string", "string" },  { "index", "integer" } },
      description = [[
        Returns a character from a string.  String indicies begin at 1.
      ]],
      callback =
        function(self, string_, index )
          return string_:get()[index]
        end
    }
  },

  -- full
  ["COS_"] = {
    ["float"] = {
      command = "COS_",
      rtype = "float",
      params = {
        { "theta", "float" } },
      description = [[
        Returns cosine of theta. Theta should be in degrees.
      ]],
      callback =
        function(self, theta )
          return math.cos(theta * math.pi / 180.0)
        end
    }
  },

  -- full
  ["DELE"] = {
    ["command"] = {
      command = "DELE",
      rtype = "command",
      params = {
        { "variable_name", "string" } },
      description = [[
        Deletes the specified @EAME@ variable.
      ]],
      callback =
        function(self, variable_name )
          self.vm:get_engine_var(variable_name).set(nil)
        end
    }
  },

  -- full
  ["DELG"] = {
    ["command"] = {
      command = "DELG",
      rtype = "command",
      params = {
        { "variable_name", "string" } },
      description = [[
        Deletes the specified @GAME@ variable.
      ]],
      callback =
        function(self, variable_name )
          self.vm:get_game_var(variable_name).set(nil)
        end
    }
  },

  -- full
  ["DELN"] = {
    ["command"] = {
      command = "DELN",
      rtype = "command",
      params = {
        { "variable_name", "anything" } },
      description = [[
        Deletes the specified @NAME@ variable on @TARG@.
      ]],
      callback =
        function(self, variable_name )
          self.vm:get_target_var(variable_name).set(nil)
        end
    }
  },

  -- full
  ["DIVV"] = {
    ["command"] = {
      command = "DIVV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "div", "decimal" } },
      description = [[
        Divides a variable by an integer or float, so var = var / div.  Uses integer division if both numbers 
        are integers, or floating point division otherwise.
      ]],
      callback =
        function(self, var, div )
          var:set(var:get() / div)
        end
    }
  },

  -- full
  ["EAME"] = {
    ["variable"] = {
      command = "EAME",
      rtype = "variable",
      params = {
        { "variable_name", "string" } },
      description = [[
        Very similar to @GAME@ variables only they aren't saved or loaded with the world; they keep their 
        value between worlds for one session of the engine.  The E in EAME stands for for Engine.  See 
        the table of engine @Eame Variables@.
      ]],
      callback =
        function(self, variable_name )
          return self.vm:get_engine_var(variable_name)
        end
    }
  },


  ["EAMN"] = {
    ["string"] = {
      command = "EAMN",
      rtype = "string",
      params = {
        { "previous", "string" } },
      description = [[
        Enumerates through @EAME@ variable names, roughly as @GAMN@ does through @GAME@ variables.  Start and end with an empty 
        string.
      ]],
      callback =
        function(self, previous )
          return ""
        end
    }
  },

  -- full
  ["FTOI"] = {
    ["integer"] = {
      command = "FTOI",
      rtype = "integer",
      params = {
        { "number_to_convert", "float" } },
      description = [[
        Converts a floating-point value into its integer equivalent.
      ]],
      callback =
        function(self, number_to_convert )
          return math.floor(number_to_convert)
        end
    }
  },

  -- full
  ["GAME"] = {
    ["variable"] = {
      command = "GAME",
      rtype = "variable",
      params = {
        { "variable_name", "string" } },
      description = [[
        A game variable is a global variable which can be referenced by name.  <blockquote>eg: SETV GAME "pi" 3.142</blockquote>Game 
        variables are stored as part of the world and so will be saved out in the world file. If a script uses a non-existant game 
        variable, that variable will be created automatically (with value integer zero).  Agents, integers, floats and strings can be 
        stored in game variables.  Variable names are case sensitive.  When a new world is loaded, all the game variables are cleared.
        There are some conventions for the variable names:
         engine_ for Creatures Engine
         cav_ for Creatures Adventures
         c3_	for Creatures 3
        It's important to follow these, as 3rd party developers will just use whatever names they fancy.  @DELG@ deletes a game variable.  
        See also the table of engine @Game Variables@.
      ]],
      callback =
        function(self, variable_name )
          return self.vm:get_game_var(variable_name)
        end
    }
  },


  ["GAMN"] = {
    ["string"] = {
      command = "GAMN",
      rtype = "string",
      params = {
        { "previous", "string" } },
      description = [[
        Enumerates through game variable names.  Pass in an empty string to find the first one, and then the 
        previous one to find the next.  Empty string is returned at the end.
      ]],
      callback =
        function(self, previous )
          return ""
        end
    }
  },

  -- full
  ["GNAM"] = {
    ["string"] = {
      command = "GNAM",
      rtype = "string",
      params = {},
      description = [[
        Returns the game name.  For example "Creatures 3".
      ]],
      callback =
        function(self)
          return CAOS.name_of_game or "Starbound"
        end
    }
  },

  -- full
  ["ITOF"] = {
    ["float"] = {
      command = "ITOF",
      rtype = "float",
      params = {
        { "number_to_convert", "integer" } },
      description = [[
        Converts an integer value into its floating-point equivalent.
      ]],
      callback =
        function(self, number_to_convert )
          return number_to_convert
        end
    }
  },

  -- full
  ["LOWA"] = {
    ["string"] = {
      command = "LOWA",
      rtype = "string",
      params = {
        { "any_old", "string" } },
      description = [[
        Converts the given string into all lower case letters.
      ]],
      callback =
        function(self, any_old )
          return string.lower(any_old)
        end
    }
  },

  -- full
  ["MAME"] = {
    ["variable"] = {
      command = "MAME",
      rtype = "variable",
      params = {
        { "variable_name", "anything" } },
      description = [[
        Machine variable version of @NAME@. Accesses the same variables, only via @OWNR@ rather than @TARG@.  This is the 
        same difference as between @MVxx@ and @OVxx@.
      ]],
      callback =
        function(self, variable_name )
          return self.vm:get_owner_var(variable_name)
        end
    }
  },


  ["MODU"] = {
    ["string"] = {
      command = "MODU",
      rtype = "string",
      params = {},
      description = [[
        Returns a string listed the loaded modules, and the display engine type.  You can use @SINS@ to parse 
        this for particular values.
      ]],
      callback =
        function(self)
          return ""
        end
    }
  },

  -- full
  ["MODV"] = {
    ["command"] = {
      command = "MODV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "mod", "integer" } },
      description = [[
        Gives the remainder (or modulus) when a variable is divided by an integer, so var = var % mod.  Both 
        values should to be integers.
      ]],
      callback =
        function(self, var, mod_ )
          var:set(var:get() % mod_)
        end
    }
  },

  -- full
  ["MULV"] = {
    ["command"] = {
      command = "MULV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "mul", "decimal" } },
      description = [[
        Multiplies a variable by an integer or float, so var = var * mul.
      ]],
      callback =
        function(self, var, mul )
          var:set(var:get() * mul)
        end
    }
  },

  ["MV00"] = { ["variable"] = { command = "MV00", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[1] end } },
  ["MV01"] = { ["variable"] = { command = "MV01", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[2] end } },
  ["MV02"] = { ["variable"] = { command = "MV02", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[3] end } },
  ["MV03"] = { ["variable"] = { command = "MV03", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[4] end } },
  ["MV04"] = { ["variable"] = { command = "MV04", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[5] end } },
  ["MV05"] = { ["variable"] = { command = "MV05", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[6] end } },
  ["MV06"] = { ["variable"] = { command = "MV06", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[7] end } },
  ["MV07"] = { ["variable"] = { command = "MV07", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[8] end } },
  ["MV08"] = { ["variable"] = { command = "MV08", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[9] end } },
  ["MV09"] = { ["variable"] = { command = "MV09", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[10] end } },
  ["MV10"] = { ["variable"] = { command = "MV10", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[11] end } },
  ["MV11"] = { ["variable"] = { command = "MV11", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[12] end } },
  ["MV12"] = { ["variable"] = { command = "MV12", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[13] end } },
  ["MV13"] = { ["variable"] = { command = "MV13", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[14] end } },
  ["MV14"] = { ["variable"] = { command = "MV14", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[15] end } },
  ["MV15"] = { ["variable"] = { command = "MV15", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[16] end } },
  ["MV16"] = { ["variable"] = { command = "MV16", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[17] end } },
  ["MV17"] = { ["variable"] = { command = "MV17", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[18] end } },
  ["MV18"] = { ["variable"] = { command = "MV18", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[19] end } },
  ["MV19"] = { ["variable"] = { command = "MV19", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[20] end } },
  ["MV20"] = { ["variable"] = { command = "MV20", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[21] end } },
  ["MV21"] = { ["variable"] = { command = "MV21", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[22] end } },
  ["MV22"] = { ["variable"] = { command = "MV22", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[23] end } },
  ["MV23"] = { ["variable"] = { command = "MV23", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[24] end } },
  ["MV24"] = { ["variable"] = { command = "MV24", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[25] end } },
  ["MV25"] = { ["variable"] = { command = "MV25", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[26] end } },
  ["MV26"] = { ["variable"] = { command = "MV26", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[27] end } },
  ["MV27"] = { ["variable"] = { command = "MV27", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[28] end } },
  ["MV28"] = { ["variable"] = { command = "MV28", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[29] end } },
  ["MV29"] = { ["variable"] = { command = "MV29", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[30] end } },
  ["MV30"] = { ["variable"] = { command = "MV30", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[31] end } },
  ["MV31"] = { ["variable"] = { command = "MV31", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[32] end } },
  ["MV32"] = { ["variable"] = { command = "MV32", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[33] end } },
  ["MV33"] = { ["variable"] = { command = "MV33", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[34] end } },
  ["MV34"] = { ["variable"] = { command = "MV34", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[35] end } },
  ["MV35"] = { ["variable"] = { command = "MV35", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[36] end } },
  ["MV36"] = { ["variable"] = { command = "MV36", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[37] end } },
  ["MV37"] = { ["variable"] = { command = "MV37", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[38] end } },
  ["MV38"] = { ["variable"] = { command = "MV38", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[39] end } },
  ["MV39"] = { ["variable"] = { command = "MV39", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[40] end } },
  ["MV40"] = { ["variable"] = { command = "MV40", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[41] end } },
  ["MV41"] = { ["variable"] = { command = "MV41", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[42] end } },
  ["MV42"] = { ["variable"] = { command = "MV42", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[43] end } },
  ["MV43"] = { ["variable"] = { command = "MV43", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[44] end } },
  ["MV44"] = { ["variable"] = { command = "MV44", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[45] end } },
  ["MV45"] = { ["variable"] = { command = "MV45", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[46] end } },
  ["MV46"] = { ["variable"] = { command = "MV46", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[47] end } },
  ["MV47"] = { ["variable"] = { command = "MV47", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[48] end } },
  ["MV48"] = { ["variable"] = { command = "MV48", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[49] end } },
  ["MV49"] = { ["variable"] = { command = "MV49", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[50] end } },
  ["MV50"] = { ["variable"] = { command = "MV50", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[51] end } },
  ["MV51"] = { ["variable"] = { command = "MV51", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[52] end } },
  ["MV52"] = { ["variable"] = { command = "MV52", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[53] end } },
  ["MV53"] = { ["variable"] = { command = "MV53", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[54] end } },
  ["MV54"] = { ["variable"] = { command = "MV54", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[55] end } },
  ["MV55"] = { ["variable"] = { command = "MV55", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[56] end } },
  ["MV56"] = { ["variable"] = { command = "MV56", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[57] end } },
  ["MV57"] = { ["variable"] = { command = "MV57", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[58] end } },
  ["MV58"] = { ["variable"] = { command = "MV58", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[59] end } },
  ["MV59"] = { ["variable"] = { command = "MV59", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[60] end } },
  ["MV60"] = { ["variable"] = { command = "MV60", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[61] end } },
  ["MV61"] = { ["variable"] = { command = "MV61", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[62] end } },
  ["MV62"] = { ["variable"] = { command = "MV62", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[63] end } },
  ["MV63"] = { ["variable"] = { command = "MV63", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[64] end } },
  ["MV64"] = { ["variable"] = { command = "MV64", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[65] end } },
  ["MV65"] = { ["variable"] = { command = "MV65", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[66] end } },
  ["MV66"] = { ["variable"] = { command = "MV66", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[67] end } },
  ["MV67"] = { ["variable"] = { command = "MV67", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[68] end } },
  ["MV68"] = { ["variable"] = { command = "MV68", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[69] end } },
  ["MV69"] = { ["variable"] = { command = "MV69", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[70] end } },
  ["MV70"] = { ["variable"] = { command = "MV70", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[71] end } },
  ["MV71"] = { ["variable"] = { command = "MV71", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[72] end } },
  ["MV72"] = { ["variable"] = { command = "MV72", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[73] end } },
  ["MV73"] = { ["variable"] = { command = "MV73", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[74] end } },
  ["MV74"] = { ["variable"] = { command = "MV74", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[75] end } },
  ["MV75"] = { ["variable"] = { command = "MV75", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[76] end } },
  ["MV76"] = { ["variable"] = { command = "MV76", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[77] end } },
  ["MV77"] = { ["variable"] = { command = "MV77", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[78] end } },
  ["MV78"] = { ["variable"] = { command = "MV78", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[79] end } },
  ["MV79"] = { ["variable"] = { command = "MV79", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[80] end } },
  ["MV80"] = { ["variable"] = { command = "MV80", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[81] end } },
  ["MV81"] = { ["variable"] = { command = "MV81", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[82] end } },
  ["MV82"] = { ["variable"] = { command = "MV82", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[83] end } },
  ["MV83"] = { ["variable"] = { command = "MV83", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[84] end } },
  ["MV84"] = { ["variable"] = { command = "MV84", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[85] end } },
  ["MV85"] = { ["variable"] = { command = "MV85", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[86] end } },
  ["MV86"] = { ["variable"] = { command = "MV86", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[87] end } },
  ["MV87"] = { ["variable"] = { command = "MV87", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[88] end } },
  ["MV88"] = { ["variable"] = { command = "MV88", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[89] end } },
  ["MV89"] = { ["variable"] = { command = "MV89", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[90] end } },
  ["MV90"] = { ["variable"] = { command = "MV90", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[91] end } },
  ["MV91"] = { ["variable"] = { command = "MV91", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[92] end } },
  ["MV92"] = { ["variable"] = { command = "MV92", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[93] end } },
  ["MV93"] = { ["variable"] = { command = "MV93", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[94] end } },
  ["MV94"] = { ["variable"] = { command = "MV94", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[95] end } },
  ["MV95"] = { ["variable"] = { command = "MV95", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[96] end } },
  ["MV96"] = { ["variable"] = { command = "MV96", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[97] end } },
  ["MV97"] = { ["variable"] = { command = "MV97", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[98] end } },
  ["MV98"] = { ["variable"] = { command = "MV98", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[99] end } },
  ["MV99"] = { ["variable"] = { command = "MV99", rtype = "variable", params = {}, description = [[MV00 to MV99 are variables specific to an agent. They are read from @OWNR@, the owner agent of the current script.  These are the exact same variables as @OVxx@, except read from owner not targ.  If owner and targ are the same, then OV23 is MV23, for example.]], callback = function(self) return self.vm.owner:getVar("caos_vars")[100] end } },

  -- full
  ["NAME"] = {
    ["variable"] = {
      command = "NAME",
      rtype = "variable",
      params = {
        { "variable_name", "anything" } },
      description = [[
        This is a named variable, similar to a @GAME@ variable, only local to the target agent.  See also @
        MAME@. The "name" of the variable is not limited to strings, but can be anything stored in a 
        variable. i.e. integer, float, string, even an agent.
      ]],
      callback =
        function(self, variable_name )
          return self.vm:get_target_var(variable_name)
        end
    }
  },


  ["NAMN"] = {
    ["command"] = {
      command = "NAMN",
      rtype = "command",
      params = {
        { "previous", "variable" } },
      description = [[
        Enumerates through @NAME@ variable names, roughly as @GAMN@ does through @GAME@ variables.  Start and end with an empty 
        string.
      ]],
      callback =
        function(self, previous )
        end
    }
  },

  -- full
  ["NEGV"] = {
    ["command"] = {
      command = "NEGV",
      rtype = "command",
      params = {
        { "var", "variable" } },
      description = [[
        Reverse the sign of the given integer or float variable, so var = 0 - var.
      ]],
      callback =
        function(self, var )
          var:set(0 - var:get())
        end
    }
  },

  -- full
  ["NOTV"] = {
    ["command"] = {
      command = "NOTV",
      rtype = "command",
      params = {
        { "var", "variable" } },
      description = [[
        Peform a bitwise NOT on an integer variable.
      ]],
      callback =
        function(self, var )
          var:set(bit32.bnot(var:get()))
        end
    }
  },

  -- full
  ["ORRV"] = {
    ["command"] = {
      command = "ORRV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "value", "integer" } },
      description = [[
        Peform a bitwise OR on an integer variable, so var = var | value.
      ]],
      callback =
        function(self, var, value )
          var:set( bit32.bor(var:get(), value) )
        end
    }
  },


  ["OV00"] = { ["variable"] = { command = "OV00", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 1) end } },
  ["OV01"] = { ["variable"] = { command = "OV01", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 2) end } },
  ["OV02"] = { ["variable"] = { command = "OV02", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 3) end } },
  ["OV03"] = { ["variable"] = { command = "OV03", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 4) end } },
  ["OV04"] = { ["variable"] = { command = "OV04", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 5) end } },
  ["OV05"] = { ["variable"] = { command = "OV05", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 6) end } },
  ["OV06"] = { ["variable"] = { command = "OV06", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 7) end } },
  ["OV07"] = { ["variable"] = { command = "OV07", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 8) end } },
  ["OV08"] = { ["variable"] = { command = "OV08", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 9) end } },
  ["OV09"] = { ["variable"] = { command = "OV09", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 10) end } },
  ["OV10"] = { ["variable"] = { command = "OV10", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 11) end } },
  ["OV11"] = { ["variable"] = { command = "OV11", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 12) end } },
  ["OV12"] = { ["variable"] = { command = "OV12", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 13) end } },
  ["OV13"] = { ["variable"] = { command = "OV13", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 14) end } },
  ["OV14"] = { ["variable"] = { command = "OV14", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 15) end } },
  ["OV15"] = { ["variable"] = { command = "OV15", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 16) end } },
  ["OV16"] = { ["variable"] = { command = "OV16", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 17) end } },
  ["OV17"] = { ["variable"] = { command = "OV17", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 18) end } },
  ["OV18"] = { ["variable"] = { command = "OV18", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 19) end } },
  ["OV19"] = { ["variable"] = { command = "OV19", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 20) end } },
  ["OV20"] = { ["variable"] = { command = "OV20", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 21) end } },
  ["OV21"] = { ["variable"] = { command = "OV21", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 22) end } },
  ["OV22"] = { ["variable"] = { command = "OV22", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 23) end } },
  ["OV23"] = { ["variable"] = { command = "OV23", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 24) end } },
  ["OV24"] = { ["variable"] = { command = "OV24", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 25) end } },
  ["OV25"] = { ["variable"] = { command = "OV25", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 26) end } },
  ["OV26"] = { ["variable"] = { command = "OV26", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 27) end } },
  ["OV27"] = { ["variable"] = { command = "OV27", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 28) end } },
  ["OV28"] = { ["variable"] = { command = "OV28", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 29) end } },
  ["OV29"] = { ["variable"] = { command = "OV29", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 30) end } },
  ["OV30"] = { ["variable"] = { command = "OV30", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 31) end } },
  ["OV31"] = { ["variable"] = { command = "OV31", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 32) end } },
  ["OV32"] = { ["variable"] = { command = "OV32", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 33) end } },
  ["OV33"] = { ["variable"] = { command = "OV33", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 34) end } },
  ["OV34"] = { ["variable"] = { command = "OV34", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 35) end } },
  ["OV35"] = { ["variable"] = { command = "OV35", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 36) end } },
  ["OV36"] = { ["variable"] = { command = "OV36", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 37) end } },
  ["OV37"] = { ["variable"] = { command = "OV37", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 38) end } },
  ["OV38"] = { ["variable"] = { command = "OV38", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 39) end } },
  ["OV39"] = { ["variable"] = { command = "OV39", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 40) end } },
  ["OV40"] = { ["variable"] = { command = "OV40", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 41) end } },
  ["OV41"] = { ["variable"] = { command = "OV41", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 42) end } },
  ["OV42"] = { ["variable"] = { command = "OV42", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 43) end } },
  ["OV43"] = { ["variable"] = { command = "OV43", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 44) end } },
  ["OV44"] = { ["variable"] = { command = "OV44", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 45) end } },
  ["OV45"] = { ["variable"] = { command = "OV45", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 46) end } },
  ["OV46"] = { ["variable"] = { command = "OV46", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 47) end } },
  ["OV47"] = { ["variable"] = { command = "OV47", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 48) end } },
  ["OV48"] = { ["variable"] = { command = "OV48", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 49) end } },
  ["OV49"] = { ["variable"] = { command = "OV49", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 50) end } },
  ["OV50"] = { ["variable"] = { command = "OV50", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 51) end } },
  ["OV51"] = { ["variable"] = { command = "OV51", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 52) end } },
  ["OV52"] = { ["variable"] = { command = "OV52", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 53) end } },
  ["OV53"] = { ["variable"] = { command = "OV53", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 54) end } },
  ["OV54"] = { ["variable"] = { command = "OV54", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 55) end } },
  ["OV55"] = { ["variable"] = { command = "OV55", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 56) end } },
  ["OV56"] = { ["variable"] = { command = "OV56", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 57) end } },
  ["OV57"] = { ["variable"] = { command = "OV57", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 58) end } },
  ["OV58"] = { ["variable"] = { command = "OV58", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 59) end } },
  ["OV59"] = { ["variable"] = { command = "OV59", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 60) end } },
  ["OV60"] = { ["variable"] = { command = "OV60", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 61) end } },
  ["OV61"] = { ["variable"] = { command = "OV61", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 62) end } },
  ["OV62"] = { ["variable"] = { command = "OV62", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 63) end } },
  ["OV63"] = { ["variable"] = { command = "OV63", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 64) end } },
  ["OV64"] = { ["variable"] = { command = "OV64", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 65) end } },
  ["OV65"] = { ["variable"] = { command = "OV65", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 66) end } },
  ["OV66"] = { ["variable"] = { command = "OV66", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 67) end } },
  ["OV67"] = { ["variable"] = { command = "OV67", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 68) end } },
  ["OV68"] = { ["variable"] = { command = "OV68", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 69) end } },
  ["OV69"] = { ["variable"] = { command = "OV69", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 70) end } },
  ["OV70"] = { ["variable"] = { command = "OV70", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 71) end } },
  ["OV71"] = { ["variable"] = { command = "OV71", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 72) end } },
  ["OV72"] = { ["variable"] = { command = "OV72", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 73) end } },
  ["OV73"] = { ["variable"] = { command = "OV73", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 74) end } },
  ["OV74"] = { ["variable"] = { command = "OV74", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 75) end } },
  ["OV75"] = { ["variable"] = { command = "OV75", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 76) end } },
  ["OV76"] = { ["variable"] = { command = "OV76", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 77) end } },
  ["OV77"] = { ["variable"] = { command = "OV77", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 78) end } },
  ["OV78"] = { ["variable"] = { command = "OV78", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 79) end } },
  ["OV79"] = { ["variable"] = { command = "OV79", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 80) end } },
  ["OV80"] = { ["variable"] = { command = "OV80", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 81) end } },
  ["OV81"] = { ["variable"] = { command = "OV81", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 82) end } },
  ["OV82"] = { ["variable"] = { command = "OV82", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 83) end } },
  ["OV83"] = { ["variable"] = { command = "OV83", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 84) end } },
  ["OV84"] = { ["variable"] = { command = "OV84", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 85) end } },
  ["OV85"] = { ["variable"] = { command = "OV85", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 86) end } },
  ["OV86"] = { ["variable"] = { command = "OV86", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 87) end } },
  ["OV87"] = { ["variable"] = { command = "OV87", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 88) end } },
  ["OV88"] = { ["variable"] = { command = "OV88", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 89) end } },
  ["OV89"] = { ["variable"] = { command = "OV89", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 90) end } },
  ["OV90"] = { ["variable"] = { command = "OV90", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 91) end } },
  ["OV91"] = { ["variable"] = { command = "OV91", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 92) end } },
  ["OV92"] = { ["variable"] = { command = "OV92", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 93) end } },
  ["OV93"] = { ["variable"] = { command = "OV93", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 94) end } },
  ["OV94"] = { ["variable"] = { command = "OV94", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 95) end } },
  ["OV95"] = { ["variable"] = { command = "OV95", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 96) end } },
  ["OV96"] = { ["variable"] = { command = "OV96", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 97) end } },
  ["OV97"] = { ["variable"] = { command = "OV97", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 98) end } },
  ["OV98"] = { ["variable"] = { command = "OV98", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 99) end } },
  ["OV99"] = { ["variable"] = { command = "OV99", rtype = "variable", params = {}, description = [[OV00 to OV99 are variables specific to an agent.  They are read from @TARG@, the target agent.  You can also access these same variables via owner using @MVxx@.]], callback = function(self) return self.vm.target:getVarDynamic("caos_vars_" .. 100) end } },


  -- full
  ["RAND"] = {
    ["integer"] = {
      command = "RAND",
      rtype = "integer",
      params = {
        { "value1", "integer" },  { "value2", "integer" } },
      description = [[
        Returns a random integer between value1 and value2 inclusive of both values.  You can use negative values, and 
        have them either way round.
      ]],
      callback =
        function(self, value1, value2 )
          return math.random(math.min(value1,value2), math.max(value1,value2))
        end
    }
  },

  -- full
  ["RNDV"] = {
    ["command"] = {
      command = "RNDV",
      rtype = "command",
      params = {
        { "variable", "variable" }, { "min", "integer" },  { "max", "integer" } },
      description = [[
        DEPRECATED (Creatures 2)
        Set a variable to a random number between min and max.
      ]],
      callback =
        function(self, variable, min_, max_ )
          variable:set( math.random(math.min(min_,max_), math.max(min_,max_)) )
        end
    }
  },


  ["READ"] = {
    ["string"] = {
      command = "READ",
      rtype = "string",
      params = {
        { "catalogue_tag", "string" },  { "offset", "integer" } },
      description = [[
        Returns a string from the catalogue.  This is used for localisation.  offset 0 is the first string after 
        the TAG command in the catalogue file.  See also @REAN@ and @WILD@.
      ]],
      callback =
        function(self, catalogue_tag, offset )
          return ""
        end
    }
  },


  ["REAF"] = {
    ["command"] = {
      command = "REAF",
      rtype = "command",
      params = {},
      description = [[
        Refreshes the catalogue from files on disk, from the main catalogue directory and the world catalogue directory.  These 
        are normally read in at startup, when a new world is read in, or when the PRAY resources 
        system installs a catalogue file.  Use while developing CAOS programs to refresh the catalogue as you add entries.
        
      ]],
      callback =
        function(self)
        end
    }
  },


  ["REAN"] = {
    ["integer"] = {
      command = "REAN",
      rtype = "integer",
      params = {
        { "catalogue_tag", "string" } },
      description = [[
        Returns the number of entries in the catalogue for the given tag.  For the same tag, you can @
        READ@ values from 0 to one less than REAN returns.
      ]],
      callback =
        function(self, catalogue_tag )
          return 0
        end
    }
  },


  ["REAQ"] = {
    ["integer"] = {
      command = "REAQ",
      rtype = "integer",
      params = {
        { "catalogue_tag", "string" } },
      description = [[
        Returns 1 if the catalogue tag is present, 0 if not.
      ]],
      callback =
        function(self, catalogue_tag )
          return 0
        end
    }
  },

  -- full
  ["SETA"] = {
    ["command"] = {
      command = "SETA",
      rtype = "command",
      params = {
        { "var", "variable" },  { "value", "agent" } },
      description = [[
        Stores a reference to an agent in a variable.
      ]],
      callback =
        function(self, var, value )
          var:set(value)
        end
    }
  },

  -- full
  ["SETS"] = {
    ["command"] = {
      command = "SETS",
      rtype = "command",
      params = {
        { "var", "variable" },  { "value", "string" } },
      description = [[
        Sets a variable to a string value.
      ]],
      callback =
        function(self, var, value )
          var:set(value)
        end
    }
  },

  -- full
  ["SETV"] = {
    ["command"] = {
      command = "SETV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "value", "decimal" } },
      description = [[
        Stores an integer or float in a variable.
      ]],
      callback =
        function(self, var, value )
          var:set(value)
        end
    }
  },

  -- full
  ["SINS"] = {
    ["integer"] = {
      command = "SINS",
      rtype = "integer",
      params = {
        { "main", "string" },  { "index_to_search_from", "integer" },  { "search", "string" } },
      description = [[
        Looks for the search string as an exact substring of the main string (<b>s</b>tring <b>
        in</b> <b>s</b>tring).  Starts searching at the given index into the main string - to find 
        the first occurence, set this to 1.  String indices begin at 1.  Returns the index of the position 
        of the substring, if found, or -1 otherwise.  The search is case sensitive - use @UPPA@ and @LOWA@ to 
        convert all strings first, for a case insensitive search.
      ]],
      callback =
        function(self, main, index_to_search_from, search )
          local result = string.find(main, search, index_to_search_from, true)
          return result or -1
        end
    }
  },

  -- full
  ["SIN_"] = {
    ["float"] = {
      command = "SIN_",
      rtype = "float",
      params = {
        { "theta", "float" } },
      description = [[
        Returns sine of theta. Theta should be in degrees.
      ]],
      callback =
        function(self, theta )
          return math.sin(theta * math.pi / 180.0)
        end
    }
  },

  -- full
  ["SQRT"] = {
    ["float"] = {
      command = "SQRT",
      rtype = "float",
      params = {
        { "value", "float" } },
      description = [[
        Calculates a square root.
      ]],
      callback =
        function(self, value )
          return math.sqrt(value)
        end
    }
  },

  -- full
  ["STOF"] = {
    ["float"] = {
      command = "STOF",
      rtype = "float",
      params = {
        { "value", "string" } },
      description = [[
        Converts a string in decimal to a floating point number.  Characters in the string after an initial number 
        are quietly ignored.  If there is no obvious number then zero is returned.
      ]],
      callback =
        function(self, value )
          return tonumber(value)
        end
    }
  },

  -- full
  ["STOI"] = {
    ["integer"] = {
      command = "STOI",
      rtype = "integer",
      params = {
        { "value", "string" } },
      description = [[
        Converts a string in decimal to an integer.  Characters in the string after an initial number are quietly 
        ignored.  If there is no obvious number then zero is returned.
      ]],
      callback =
        function(self, value )
          return math.floor(tonumber(value))
        end
    }
  },

  -- full
  ["STRL"] = {
    ["integer"] = {
      command = "STRL",
      rtype = "integer",
      params = {
        { "string", "string" } },
      description = [[
        Returns the length of a string.
      ]],
      callback =
        function(self, string_ )
          return string.len(string_)
        end
    }
  },

  -- full
  ["SUBS"] = {
    ["string"] = {
      command = "SUBS",
      rtype = "string",
      params = {
        { "value", "string" },  { "start", "integer" },  { "count", "integer" } },
      description = [[
        Slices up a string, returning the substring starting at position start, with length count.  String indices begin at 
        1.
      ]],
      callback =
        function(self, value, start, count )
          return ""
        end
    }
  },

  -- full
  ["SUBV"] = {
    ["command"] = {
      command = "SUBV",
      rtype = "command",
      params = {
        { "var", "variable" },  { "sub", "decimal" } },
      description = [[
        Subtracts an integer or float from a variable, so var = var - sub.
      ]],
      callback =
        function(self, var, sub )
          var:set( var:get() - sub )
        end
    }
  },

  -- full
  ["TAN_"] = {
    ["float"] = {
      command = "TAN_",
      rtype = "float",
      params = {
        { "theta", "float" } },
      description = [[
        Returns tangent of theta. Theta should be in degrees. Watch out for those nasty discontinuities at 90 and 
        270.
      ]],
      callback =
        function(self, theta )
          return math.tan(theta * math.pi / 180.0)
        end
    }
  },

  -- full
  ["TYPE"] = {
    ["integer"] = {
      command = "TYPE",
    rtype = "integer",
    params = {
      { "something", "anything" } },
    description = [[
      Determines the type of a variable. The type is one of the following:
      0 - integer
      1 - floating-point
      2 - string
      3 - simple agent
      4 - pointer agent
      5 - compound agent
      6 - vehicle
      7 - creature
      ERROR codes for agents:
      -1 - NULL agent handle
      -2 - Unknown agent - you should <i>never</i> get this
    ]],
    callback =
      function(self, something)
        local t = world.entityType(something) or type(something)
        if ( t == nil ) then
          return -1
        elseif ( t == "string" ) then
          return 2
        elseif ( t == "number" ) then
          return (something == math.floor(something)) and 0 or 1
        elseif ( t == "boolean" ) then
          return 0
        elseif ( t == "player" or t == "npc" ) then
          return 7
        elseif ( t == "monster" or t == "object" ) then
          return 3
        elseif ( t == "itemDrop" or t == "projectile" or t == "plantDrop" or t == "effect" or t == "plant" ) then
          return -2
        else
          return -2
        end
      end
    }
  },


  ["UFOS"] = {
    ["string"] = {
      command = "UFOS",
    rtype = "string",
    params = {},
    description = [[
      This returns the equivalent of "uname -a" on compatible systems, or a description of your operating system on 
      others. This is a descriptive string and should not be taken as fixed format, or parseable.
    ]],
    callback =
      function(self)
        return ""
      end
    }
  },

  -- full
  ["UPPA"] = {
    ["string"] = {
      command = "UPPA",
      rtype = "string",
      params = {
        { "any_old", "string" } },
      description = [[
        Converts the given string into all upper case letters.
      ]],
      callback =
        function(self, any_old )
          return string.upper(any_old)
        end
    }
  },


  ["VA00"] = {["variable"] = { command = "VA00", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[1] end }},
  ["VA01"] = {["variable"] = { command = "VA01", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[2] end }},
  ["VA02"] = {["variable"] = { command = "VA02", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[3] end }},
  ["VA03"] = {["variable"] = { command = "VA03", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[4] end }},
  ["VA04"] = {["variable"] = { command = "VA04", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[5] end }},
  ["VA05"] = {["variable"] = { command = "VA05", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[6] end }},
  ["VA06"] = {["variable"] = { command = "VA06", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[7] end }},
  ["VA07"] = {["variable"] = { command = "VA07", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[8] end }},
  ["VA08"] = {["variable"] = { command = "VA08", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[9] end }},
  ["VA09"] = {["variable"] = { command = "VA09", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[10] end }},
  ["VA10"] = {["variable"] = { command = "VA10", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[11] end }},
  ["VA11"] = {["variable"] = { command = "VA11", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[12] end }},
  ["VA12"] = {["variable"] = { command = "VA12", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[13] end }},
  ["VA13"] = {["variable"] = { command = "VA13", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[14] end }},
  ["VA14"] = {["variable"] = { command = "VA14", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[15] end }},
  ["VA15"] = {["variable"] = { command = "VA15", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[16] end }},
  ["VA16"] = {["variable"] = { command = "VA16", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[17] end }},
  ["VA17"] = {["variable"] = { command = "VA17", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[18] end }},
  ["VA18"] = {["variable"] = { command = "VA18", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[19] end }},
  ["VA19"] = {["variable"] = { command = "VA19", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[20] end }},
  ["VA20"] = {["variable"] = { command = "VA20", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[21] end }},
  ["VA21"] = {["variable"] = { command = "VA21", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[22] end }},
  ["VA22"] = {["variable"] = { command = "VA22", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[23] end }},
  ["VA23"] = {["variable"] = { command = "VA23", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[24] end }},
  ["VA24"] = {["variable"] = { command = "VA24", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[25] end }},
  ["VA25"] = {["variable"] = { command = "VA25", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[26] end }},
  ["VA26"] = {["variable"] = { command = "VA26", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[27] end }},
  ["VA27"] = {["variable"] = { command = "VA27", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[28] end }},
  ["VA28"] = {["variable"] = { command = "VA28", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[29] end }},
  ["VA29"] = {["variable"] = { command = "VA29", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[30] end }},
  ["VA30"] = {["variable"] = { command = "VA30", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[31] end }},
  ["VA31"] = {["variable"] = { command = "VA31", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[32] end }},
  ["VA32"] = {["variable"] = { command = "VA32", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[33] end }},
  ["VA33"] = {["variable"] = { command = "VA33", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[34] end }},
  ["VA34"] = {["variable"] = { command = "VA34", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[35] end }},
  ["VA35"] = {["variable"] = { command = "VA35", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[36] end }},
  ["VA36"] = {["variable"] = { command = "VA36", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[37] end }},
  ["VA37"] = {["variable"] = { command = "VA37", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[38] end }},
  ["VA38"] = {["variable"] = { command = "VA38", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[39] end }},
  ["VA39"] = {["variable"] = { command = "VA39", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[40] end }},
  ["VA40"] = {["variable"] = { command = "VA40", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[41] end }},
  ["VA41"] = {["variable"] = { command = "VA41", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[42] end }},
  ["VA42"] = {["variable"] = { command = "VA42", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[43] end }},
  ["VA43"] = {["variable"] = { command = "VA43", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[44] end }},
  ["VA44"] = {["variable"] = { command = "VA44", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[45] end }},
  ["VA45"] = {["variable"] = { command = "VA45", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[46] end }},
  ["VA46"] = {["variable"] = { command = "VA46", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[47] end }},
  ["VA47"] = {["variable"] = { command = "VA47", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[48] end }},
  ["VA48"] = {["variable"] = { command = "VA48", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[49] end }},
  ["VA49"] = {["variable"] = { command = "VA49", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[50] end }},
  ["VA50"] = {["variable"] = { command = "VA50", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[51] end }},
  ["VA51"] = {["variable"] = { command = "VA51", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[52] end }},
  ["VA52"] = {["variable"] = { command = "VA52", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[53] end }},
  ["VA53"] = {["variable"] = { command = "VA53", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[54] end }},
  ["VA54"] = {["variable"] = { command = "VA54", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[55] end }},
  ["VA55"] = {["variable"] = { command = "VA55", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[56] end }},
  ["VA56"] = {["variable"] = { command = "VA56", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[57] end }},
  ["VA57"] = {["variable"] = { command = "VA57", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[58] end }},
  ["VA58"] = {["variable"] = { command = "VA58", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[59] end }},
  ["VA59"] = {["variable"] = { command = "VA59", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[60] end }},
  ["VA60"] = {["variable"] = { command = "VA60", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[61] end }},
  ["VA61"] = {["variable"] = { command = "VA61", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[62] end }},
  ["VA62"] = {["variable"] = { command = "VA62", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[63] end }},
  ["VA63"] = {["variable"] = { command = "VA63", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[64] end }},
  ["VA64"] = {["variable"] = { command = "VA64", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[65] end }},
  ["VA65"] = {["variable"] = { command = "VA65", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[66] end }},
  ["VA66"] = {["variable"] = { command = "VA66", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[67] end }},
  ["VA67"] = {["variable"] = { command = "VA67", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[68] end }},
  ["VA68"] = {["variable"] = { command = "VA68", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[69] end }},
  ["VA69"] = {["variable"] = { command = "VA69", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[70] end }},
  ["VA70"] = {["variable"] = { command = "VA70", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[71] end }},
  ["VA71"] = {["variable"] = { command = "VA71", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[72] end }},
  ["VA72"] = {["variable"] = { command = "VA72", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[73] end }},
  ["VA73"] = {["variable"] = { command = "VA73", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[74] end }},
  ["VA74"] = {["variable"] = { command = "VA74", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[75] end }},
  ["VA75"] = {["variable"] = { command = "VA75", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[76] end }},
  ["VA76"] = {["variable"] = { command = "VA76", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[77] end }},
  ["VA77"] = {["variable"] = { command = "VA77", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[78] end }},
  ["VA78"] = {["variable"] = { command = "VA78", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[79] end }},
  ["VA79"] = {["variable"] = { command = "VA79", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[80] end }},
  ["VA80"] = {["variable"] = { command = "VA80", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[81] end }},
  ["VA81"] = {["variable"] = { command = "VA81", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[82] end }},
  ["VA82"] = {["variable"] = { command = "VA82", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[83] end }},
  ["VA83"] = {["variable"] = { command = "VA83", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[84] end }},
  ["VA84"] = {["variable"] = { command = "VA84", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[85] end }},
  ["VA85"] = {["variable"] = { command = "VA85", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[86] end }},
  ["VA86"] = {["variable"] = { command = "VA86", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[87] end }},
  ["VA87"] = {["variable"] = { command = "VA87", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[88] end }},
  ["VA88"] = {["variable"] = { command = "VA88", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[89] end }},
  ["VA89"] = {["variable"] = { command = "VA89", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[90] end }},
  ["VA90"] = {["variable"] = { command = "VA90", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[91] end }},
  ["VA91"] = {["variable"] = { command = "VA91", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[92] end }},
  ["VA92"] = {["variable"] = { command = "VA92", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[93] end }},
  ["VA93"] = {["variable"] = { command = "VA93", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[94] end }},
  ["VA94"] = {["variable"] = { command = "VA94", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[95] end }},
  ["VA95"] = {["variable"] = { command = "VA95", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[96] end }},
  ["VA96"] = {["variable"] = { command = "VA96", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[97] end }},
  ["VA97"] = {["variable"] = { command = "VA97", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[98] end }},
  ["VA98"] = {["variable"] = { command = "VA98", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[99] end }},
  ["VA99"] = {["variable"] = { command = "VA99", rtype = "variable", params = {}, description = [[VA00 to VA99 are local variables, whose values are lost when the current script ends.]], callback = function(self) return self.vm.caos_vars[100] end }},

  ["VMJR"] = {
    ["integer"] = {
      command = "VMJR",
      rtype = "integer",
      params = {},
      description = [[
        Returns the major version number of the engine.
      ]],
      callback =
        function(self)
          return 1
        end
    }
  },


  ["VMNR"] = {
    ["integer"] = {
      command = "VMNR",
      rtype = "integer",
      params = {},
      description = [[
        Returns the minor version number of the engine.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },

  -- full
  ["VTOS"] = {
    ["string"] = {
      command = "VTOS",
      rtype = "string",
      params = {
        { "value", "decimal" } },
      description = [[
        Converts an integer or float into a string in decimal.
      ]],
      callback =
        function(self, value )
          return tostring(value)
        end
    }
  },

  -- full
  ["_P1_"] = {
    ["variable"] = {
      command = "_P1_",
      rtype = "variable",
      params = {},
      description = [[
        Returns the first parameter sent to a script.
      ]],
      callback =
        function(self)
          return self.vm.message_param_1
        end
    }
  },

  -- full
  ["_P2_"] = {
    ["variable"] = {
      command = "_P2_",
      rtype = "variable",
      params = {},
      description = [[
        Returns the second parameter sent to a script.
      ]],
      callback =
        function(self)
          return self.vm.message_param_2
        end
    }
  },


  ["CABB"] = {
    ["integer"] = {
      command = "CABB",
      rtype = "integer",
      params = {},
      description = [[
        Returns relative position of bottom side of cabin.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CABL"] = {
    ["integer"] = {
      command = "CABL",
      rtype = "integer",
      params = {},
      description = [[
        Returns relative position of left side of cabin.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CABN"] = {
    ["command"] = {
      command = "CABN",
      rtype = "command",
      params = {
        { "left", "integer" },  { "top", "integer" },  { "right", "integer" },  { "bottom", "integer" } },
      description = [[
        Set a vehicles cabin rectangle.  The cabin is the area in which agents inside the vehicle are kept.  
        The rectangle is relative to the position of the vehicle.  Default cabin is the bounding rectangle of part 
        0.  You might want to use @ATTR@ to set attribute @Greedy Cabin@, on the vehicle.  This will make 
        it automatically pick up items which are dropped in the cabin.
      ]],
      callback =
        function(self, left, top, right, bottom )
        end
    }
  },


  ["CABP"] = {
    ["command"] = {
      command = "CABP",
      rtype = "command",
      params = {
        { "plane", "integer" } },
      description = [[
        Set the plane that vehicle passengers are at.  This is relative to the vehicle's plane.
      ]],
      callback =
        function(self, plane )
        end
    },

    ["integer"] = {
      command = "CABP",
      rtype = "integer",
      params = {},
      description = [[
        Returns the plane that passengers of the vehicle are at.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CABR"] = {
    ["integer"] = {
      command = "CABR",
      rtype = "integer",
      params = {},
      description = [[
        Returns relative position of right side of cabin.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CABT"] = {
    ["integer"] = {
      command = "CABT",
      rtype = "integer",
      params = {},
      description = [[
        Returns relative position of topside of cabin.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["CABV"] = {
    ["command"] = {
      command = "CABV",
      rtype = "command",
      params = {
        { "cabin_room_id", "integer" } },
      description = [[
        Sets the room number which things in the cabin think they are in.  By default, the value is -
        1, and the room is the one underneath wherever the agent happens to be.  Make sure you set 
        this if the vehicle ever remotely leaves the room system.  This command effects values returned from @ROOM@ and @
        GRID@.  It won't apply to some aspects of Creatures in the vehicle.
      ]],
      callback =
        function(self, cabin_room_id )
        end
    },

    ["integer"] = {
      command = "CABV",
      rtype = "integer",
      params = {},
      description = [[
        Returns the cabin room number.
      ]],
      callback =
        function(self)
          return 1
        end
    }
  },


  ["CABW"] = {
    ["command"] = {
      command = "CABW",
      rtype = "command",
      params = {
        { "cabin_capacity", "integer" } },
      description = [[
        Set the capacity or width of the cabin.  This will determine how many passengers the cabin can hold, 
        each passenger will be on a separate plane within the cabin.  Use @CABP@ to set the plane of 
        the first agent relative to the cabin.  The default width is zero, this means that the cabin will 
        accept any number of passengers and will place them all on the same plane. 
      ]],
      callback =
        function(self, cabin_capacity )
        end
    }
  },


  ["DPAS"] = {
    ["command"] = {
      command = "DPAS",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Drop all passengers matching classifier.
      ]],
      callback =
        function(self, family, genus, species )
        end
    }
  },


  ["EPAS"] = {
    ["command"] = {
      command = "EPAS",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" } },
      description = [[
        Enumerate over owner vehicle's passengers which match the given classifier.  Similar to @ENUM@.
      ]],
      callback =
        function(self, family, genus, species )
        end
    }
  },


  ["GPAS"] = {
    ["command"] = {
      command = "GPAS",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "rect_to_use", "integer" } },
      description = [[
        Collect all nearby agents matching the classifier as passengers. 
        rect_to_use 0 : Nearby means touching bounding rectangle of agent
        rect_to_use 1 : Nearby means touching cabin rectangle
      ]],
      callback =
        function(self, family, genus, species, rect_to_use )
        end
    }
  },


  ["NEW: VHCL"] = {
    ["command"] = {
      command = "NEW: VHCL",
      rtype = "command",
      params = {
        { "family", "integer" },  { "genus", "integer" },  { "species", "integer" },  { "sprite_file", "string" },  { "image_count", "integer" },  { "first_image", "integer" },  { "plane", "integer" } },
      description = [[
        Create a new vehicle.  Parameters are the same as @NEW: COMP@.
      ]],
      callback =
        function(self, family, genus, species, sprite_file, image_count, first_image, plane )
        end
    }
  },


  ["RPAS"] = {
    ["command"] = {
      command = "RPAS",
      rtype = "command",
      params = {
        { "vehicle", "agent" },  { "passenger", "agent" } },
      description = [[
        Specified vehicle drops the specified passenger.
      ]],
      callback =
        function(self, vehicle, passenger )
        end
    }
  },


  ["SPAS"] = {
    ["command"] = {
      command = "SPAS",
      rtype = "command",
      params = {
        { "vehicle", "agent" },  { "new_passenger", "agent" } },
      description = [[
        Specified vehicle picks up the specified passenger.
      ]],
      callback =
        function(self, vehicle, new_passenger )
        end
    }
  },


  ["DELW"] = {
    ["command"] = {
      command = "DELW",
      rtype = "command",
      params = {
        { "world_name", "string" } },
      description = [[
        Deletes the specified world directory.
      ]],
      callback =
        function(self, world_name )
        end
    }
  },


  ["LOAD"] = {
    ["command"] = {
      command = "LOAD",
      rtype = "command",
      params = {
        { "world_name", "string" } },
      description = [[
        Loads the specified world at the start of the next tick.  See also @QUIT@ for important information about 
        using @INST@.  See @BOOT@ and @engine_no_auxiliary_bootstrap_nnn@ for extra information about bootstrapping a world.
      ]],
      callback =
        function(self, world_name )
        end
    }
  },


  ["NWLD"] = {
    ["integer"] = {
      command = "NWLD",
      rtype = "integer",
      params = {},
      description = [[
        Returns the number of world directories.
      ]],
      callback =
        function(self)
          return 0
        end
    }
  },


  ["PSWD"] = {
    ["command"] = {
      command = "PSWD",
      rtype = "command",
      params = {
        { "password", "string" } },
      description = [[
        Sets the password for the next world loaded.  The world must be loaded (and saved) before it is 
        actually set.
      ]],
      callback =
        function(self, password )
        end
    },

    ["string"] = {
      command = "PSWD",
      rtype = "string",
      params = {
        { "worldIndex", "integer" } },
      description = [[
        Returns the password for the specified world.  If the world is not password protected the return value will 
        be an empty string.
      ]],
      callback =
        function(self, worldIndex )
          return ""
        end
    }
  },


  ["QUIT"] = {
    ["command"] = {
      command = "QUIT",
    rtype = "command",
    params = {},
    description = [[
      Quits the engine at the start of the next tick, without saving any changes.  Call @SAVE@ first to 
      make it save the current world.  If doing a sequence like "SAVE QUIT" or "SAVE LOAD menu", do 
      it in an @INST@ section.  Otherwise it will sometimes save between the two instructions, meaning it quits (or 
      loads menu) immediately upon reloading.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["RGAM"] = {
    ["command"] = {
      command = "RGAM",
    rtype = "command",
    params = {},
    description = [[
      Refresh all settings that are always read from game variables at start up e.g. the length of 
      a day.  This allows you to change such setting on the fly.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["SAVE"] = {
    ["command"] = {
      command = "SAVE",
    rtype = "command",
    params = {},
    description = [[
      Saves the current world at the start of the next tick.  See also @QUIT@ for important information about 
      using @INST@.
    ]],
    callback =
      function(self)
      end
    }
  },


  ["TNTW"] = {
    ["command"] = {
      command = "TNTW",
      rtype = "command",
      params = {
        { "index", "integer" } },
      description = [[
        This tints the @TARG@ agent with the global tint manager at index.  Specify the @PART@ first for compound 
        agents.  See also @TINT@.
      ]],
      callback =
        function(self, index )
        end
    }
  },

  -- full
  ["WNAM"] = {
    ["string"] = {
      command = "WNAM",
    rtype = "string",
    params = {},
    description = [[
      Returns the name of the currently loaded world.
    ]],
    callback =
      function(self)
        local info = world.info()
        return info.name or "Ship"
      end
    }
  },

  -- none/partial
  ["WNTI"] = {
    ["integer"] = {
      command = "WNTI",
      rtype = "integer",
      params = {
        { "world", "string" } },
      description = [[
        This returns the index of the <i>world</i>. If you pass in a world name which is 
        not within the system, -1 is returned.
      ]],
      callback =
        function(self, world )
          return -1
        end
    }
  },


  ["WRLD"] = {
    ["command"] = {
      command = "WRLD",
      rtype = "command",
      params = {
        { "world_name", "string" } },
      description = [[
        Creates a new world directory for the specified world. 
      ]],
      callback =
        function(self, world_name )
        end
    },

    ["string"] = {
      command = "WRLD",
      rtype = "string",
      params = {
        { "world_index", "integer" } },
      description = [[
        Returns the name of the world specified by world_index which must be in the range 0 to (@NWLD@-
        1).
      ]],
      callback =
        function(self, world_index )
          return ""
        end
    }
  },


  ["WTNT"] = {
    ["command"] = {
      command = "WTNT",
      rtype = "command",
      params = {
        { "index", "integer" },  { "red_tint", "integer" },  { "green_tint", "integer" },  { "blue_tint", "integer" },  { "rotation", "integer" },  { "swap", "integer" } },
      description = [[
        This sets up the world (global) tint table. The index is the number associated with the tint table - (
        keep it small please) and the r,g,b is the tint level. Rotation and Swap work as 
        for pigment bleed genes.
      ]],
      callback =
        function(self, index, red_tint, green_tint, blue_tint, rotation, swap )
        end
    }
  },

  -- full
  ["WUID"] = {
    ["string"] = {
      command = "WUID",
    rtype = "string",
    params = {},
    description = [[
      Returns the unique identifier of the currently loaded world.
    ]],
    callback =
      function(self)
        local info = world.info()
        if ( info == nil ) then
          return "SHIP"
        end
        return ""..(info.id or info.handle or info.name or "")
      end
    }
  },
  
  ["ISCR"] = {
    ["command"] = {
      command = "ISCR",
    rtype = "command",
    params = {},
    description = [[
      Marks the following chunk of script as being for the installation
      of an object. The presence of SCRP, RSCR or ENDM is used to
      delimit the installation chunk
    ]],
    callback =
      function(self)
        -- Install SCRipt
        self:stop()
      end
    }
  },

  ["RSCR"] = {
    ["command"] = {
      command = "RSCR",
    rtype = "command",
    params = {},
    description = [[
      Marks the following chunk of scripts as being for the removal of
      an object. The presence of SCRP, ISCR or ENDM is used to
      delimit the removal chunk
    ]],
    callback =
      function(self)
        -- Remove SCRipt
        self:stop()
      end
    }
  },

  ["SCRP"] = {
    ["command"] = {
      command = "SCRP",
    rtype = "command",
    params = {
      { "family", "integer" }, { "genus", "integer" }, { "species", "integer" }, { "event", "integer" }
    },
    description = [[
      Indicates that the rest of this macro is to be installed into the
      scriptorium, making it available as a new/replacement event
      script for a given type of object.
      family genus species – indicate the owner of this script, if values
      of 0 are used for any of these then the script will be installed as a
      default script for a wide range of objects. i.e. if species is 0 then
      the script will apply to all who share the same family and genus.
      event – indicates the event that will invoke this script, see the
      reference section for a list of event numbers.
    ]],
    callback =
      function(self, family, genus, species, event)
        -- SCRiPt (event callback)
        self:stop()
      end
    }
  },

  ["ENDM"] = {
    ["command"] = {
      command = "ENDM",
      rtype = "command",
      params = {},
      description = [[
        Compulsory command at end of macro script.
      ]],
      callback =
        function(self)
          -- End script block
          self:stop()
        end
    }
  }  
}
