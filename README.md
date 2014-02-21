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
 
## What are the challenges?
The Starbound scripting API is extremely limited compared to CAOS script.
This means serious compromises and workarounds must be made in order to
accomplish what seems like trivial tasks for the CAOS scripting engine.

Some major issues to consider:
* General limitations (in order for some agents to have more capabilities than others, we must determine if they will be made into a Starbound object, monster, or ship)
* Movement (teleporting to different locations generally not possible, and the physics engine is different)
* No global/engine/world environment for variables (cellular automata, scriptorium)
* Agents containing multiple objects must be split into multiple files, making it difficult to share resources
* No file API
* No network API
* No music/cd/volume API
* No non-debug text/drawing api
* No plane support (z-index)
* Lack of image control (tinting, alpha, change base image, set image frames) without workarounds
* Interaction difficulties (can't "interact" with monster)
* Wiring API difficulties: set/attach/detach wiring ports/nodes, sending integral signals through them, wire moving agents(monsters)
* No parts API (difficulty with connecting agents together, ie leaves and stems)
* No camera API (view, zoom, snapshot)
* No engine API (window size, fullscreen, save, load, world creation, etc.)
* No ability to create/remove/alter meta-rooms
* Unable to carry objects while still being functional
* No input API (keyboard, mouse)
* No player entity API (player-stored variables)
* No permiability controls (collide with certain objects only)
* Lack of cellular automata (precipitation, nutrients, etc)
* Lack of entity collision API
* No vehicle/moving objects API

... among others.


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
