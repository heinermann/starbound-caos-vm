--- Stubs for functions that object scripts can define which will then be called by C++

--- Called (once) after the object is added to the world.
--
-- @bool virtual indicates whether the object is in placement preview mode
-- (true) or is actually placed in the world (false)
function init(virtual)
end

--- Update loop handler.
-- Called once every scriptDelta (defined in *.object) ticks
function main() 
  if ( storage.caos_manager == nil ) then
    storage.caos_manager = CAOS.Manager.create(self)
  else
    storage.caos_manager:update()
  end
end

--- Called when the object is about to be removed from the world.
function die() 
end

--- Called when the object is interacted with.
-- Available interaction responses are:
--    "OpenCockpitInterface"
--    "SitDown"
--    "OpenCraftingInterface"
--    "OpenCookingInterface"
--    "OpenTechInterface"
--    "Teleport"
--    "OpenStreamingVideoInterface"
--    "PlayCinematic"
--    "OpenSongbookInterface"
--    "OpenNpcInterface"
--    "OpenNpcCraftingInterface"
--    "OpenTech3DPrinterDialog"
--    "OpenTeleportDialog"
--    "ShowPopup"
--
-- @tab args Map of interaction event arguments:
--    {
--      sourceId = <Entity id of the entity interacting with this NPC>
--      sourcePosition = <The {x,y} position of the interacting entity>
--    }
--
-- @return[1] nil (no interaction response)
-- @treturn[2] string the interaction response that should be performed
-- @treturn[3] array the interaction response and configuration:
--    {
--       <interaction response string>,
--       <interaction response config table (map)>
--    }
--function onInteraction(args)
--  return "None"
--end

--- Called when the level of an inbound connected node changes
--
-- @tab args Map of:
--    {
--      node = <(int) index of the node that is changing>
--      level = <new level of the node>
--    }
--function onInboundNodeChange(args) 
--end

--- Called when a node is connected or disconnected
--function onNodeConnectionChange() 
--end
