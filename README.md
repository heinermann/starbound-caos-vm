## What is the Creatures VM Starbound mod?
The Starbound Creatures VM mod is a CAOS virtual machine that attempts to migrate
Creatures Objects (COBs) and agents from an old game series to Starbound.

## What is Creatures?
[Creatures](http://en.wikipedia.org/wiki/Albia) is a series of games from the late 90s created by Creature
Labs that depicts a sandbox containing virtual creatures that can interact with the world objects.

The games that this mod is targetting include the following:
* Creatures (Win32/Mac)
* Creatures 2 (Win32)
* Creatures 3 (Win32/Linux/Mac)
* Docking Station (Win32/Linux Free, Mac)

## What are agents/COBs?
Agents or COBs (Creatures OBjects) are the objects found in the game.
Some examples:
 - A seed that can grow into a plant
 - An insect that mates with other insects
 - A piece of equipment that can be wired to other pieces of equipment
 - A new meta-room (w/ background) for agents to live in

## What is CAOS?
A Creatures Agent Object Script (CAOS) is a proprietary scripting
language for the Creatures engine. All agents contain a script.

## How to convert a Creatures Docking Station agent to Starbound
NOTE: A program to automate this process will eventually be released. In its current stage, nothing is final.

1. Extract the creatures `.agent` or `.agents` file with `bin/revelation.exe`
2. Extract the the image data from the `.c16` or `.s16` file with `bin/c16topng.exe`
3. Batch resize all image canvases to the largest size, centering those that are too small (Can be done with Irfanview)
4. Stitch images together horizontally (GIMP)
5. TODO

## What are the challenges?
The Starbound scripting API is extremely limited compared to CAOS script.
This means serious compromises and workarounds must be made in order to
accomplish what seems like trivial tasks for the CAOS scripting engine.

### Issues and solutions

#### Using monster entities as objects
Deciding which entity type to use was a problem because I wanted to also include wiring, however there were 
far more important matters to consider. Using monster entities as objects have the following capabilities:

 * Invincibility, explicit removal
 * Movable only with script
 * Can control graphic and frames
 * Passive
 * Persistent
 * position, velocity, gravity API (Creatures physics engine fighting with the Starbound physics engine)
 * playSound API
 * config API
 * rotation API
 * tag API (image and frame control)

#### Using 'central hub' objects as world and script controllers
There were a few major problems encountered, one is that scripts aren't global and the scriptorium
can't be shared between monster entities. Another was that persistent monster entities can't save their script data for reload.
Yet another problem, is the way entities were created/controlled. A removal script was unable to run without additional issues.
Global engine variables were not sharable between objects. And several others. The solution to all of this is using a central
hub object that acts as a core for all scripts, and controlling the objects instead of the scripts running on the objects themselves.
This has the following advantages:
 * Shared global/engine variables
 * Global scriptorium (script sharing)
 * Allows install/remove script with storage API (agents are items that can be placed in the storage)
 * Allows persistent data saving with storage API and config
 * Since every object isn't creating a full-blown virtual machine, it saves on memory
 * Allows the global debug commands such as PAWS to work easily
 
#### Using a wire converter object
I wanted to include the Creatures wiring system, but that would be impossible for several reasons:
 * Nodes need to be dynamically modifiable (add/remove nodes anywhere on the agent)
 * Nodes need to be on objects that can move
 
To solve this, a separate, dynamic wiring system for agent entities will be included. To bridge the gap,
an object must be made to convert to/from the two different wiring systems.

#### Having a configurable meta-room
Meta-rooms in Starbound need to be a bit different. In order to have the cellular automata and other room-based
options that agents may depend on, meta-rooms need to exist. There can be two solutions

1. Meta-room boundaries will be set up and connected with wire.
2. Meta-room icon is placed in a room and the room is automatically considered a meta-room.

The second being more favourable than the first, however this is not entirely decided at this time.

#### Tech for object interaction
Some agents react to certain actions such as "activate 1", "activate 2", "hit", etc. In addition, CAOS has an input API.
Tech is the only thing that currently has an input API. This will allow the following:
* CAOS input API
* Picking up agents
* Agent help popup
* Wiring agents together
* Query the "hand" object



### Unsolved issues:
* No file API
* No network API
* No music/cd/volume API
* No non-debug text/drawing api
* No plane support (z-index) (?)
* Lack of some image control (tinting, alpha)
* No camera API (view, zoom, snapshot, capture, portals showing the other side)
* No engine API (window size, fullscreen, save, load, world creation, etc.)


## What is the type relationship?
The relation mapping is as follows:
* nil <-> NULL
* string <-> string
* number <-> integer or float (depends on value)
* boolean <-> integer
* player <-> creature
* npc <-> creature
* monster <-> simple agent
* object <-> simple agent
* everything else <-> unknown

## What is the category identification of non-agent entities?
In addition to correctly categorizing agent entities, non-agent entities should still be compatible with the agent scripts.

#### self
* nothing

#### hand
* nothing (this would be the mouse pointer)

#### door
* Objects with category "door"

#### seed
* Items or objects with "seed" at the end of its name
* Saplings

#### plant
* Objects with category "farmable" that don't fall into any other categories
* Plants

#### weed
* todo

#### leaf
* todo

#### flower
* Objects with "flower" in its name

#### fruit
* Items: automato, avesmingo, banana, beakseed, boltbulb, boneboo, carrot, chili, coralcreep, corn, crystalplant, currentcorn, diodia, dirturchin, eggshoot, feathercrown, grapes, greenapple, kiwi, neonmelon, oculemon, orange, pearlpea, pineapple, potato, pussplum, redapple, reefpod, shroom, tomato, toxictop, wartweed

#### manky (bad/poisonous fruit)
* Items: rottenapple, revoltingstew

#### detritus (waste)
* Objects and items with "sewage" in the name
* Objects: poop

#### food
* Consumable items that don't fall into any other category

#### button
* Objects ending in "button" or "switch"

#### bug
* todo

#### pest
* todo

#### critter
* Passive monsters that don't fall into any other category

#### beast
* Aggressive monsters that don't fall into any other category

#### nest
* todo

#### animal egg
* todo

#### weather
* Projectiles: water, glowingrain

#### bad
* Projectiles that don't belong in any other category

#### toy
* Item types: sword, shield, gun, coin, instrument

#### incubator
* todo

#### dispenser
* Objects with category "crafting"

#### tool
* Item types: miningtool, flashlight, wiretool, beamminingtool, tillingtool, paintingbeamtool, harvestingtool, grapplinghook

#### potion
* Items: bandage, bluestim, doping, greenstim, medkit, nanowrap, redstim, yellowstim

#### elevator
* todo

#### teleporter
* Objects: teleporter

#### machinery
* Objects with category "wire" that don't belong to any other category

#### creature egg
* Objects with category "spawner" that don't belong to any other category

#### norn home
* todo

#### grendel home
* todo

#### ettin home
* todo

#### gadget
* todo

#### portal
* todo

#### vehicle
* todo

#### norn
* nothing

#### grendel
* nothing

#### ettin
* nothing

#### something
* Players
* NPCs that don't fall into any other category



## Why am I doing this?
I was bored and thought it would be a good idea at the time.
