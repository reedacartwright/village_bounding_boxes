# VBB: Village Bounding Boxes

Visualize bounding boxes that are important for village mechanics.

## Summary

VBB is a behavior pack for Minecraft Bedrock that provides functions for
visualizing bounding boxes that control village mechanics. It can show a
village's axis-aligned bounding box (AABB), exclusivity zone, spawning space,
center, and activation region. Functions are provided that can toggle specific
boxes one and off.

VBB depends on the [LiteLoaderBDS-CUI Resource Pack](https://github.com/OEOTYAN/LiteLoaderBDS-CUI/releases/tag/v1.1).

VBB assumes that the village's AABB is a standard, unstretched size of 64x24x64.

## Quick Start

In world settings, activate the VBB behavior pack and enable cheats. VBB is
easiest to use on a peaceful, creative copy of a world. Activating VBB will
activate the LiteLoaderBDS-CUI resource pack as well.

Place an armor stand at the bottom-north-west corner of a village's AABB. Use a
nametag to name this armor stand "vbb". (The command
`/function vbb/mark_village`) can be used to summon the armor stand for you.)

Use the command `/function vbb/toggle_on` to turn on the display of village
bounding boxes.

## Finding a village's AABB

A village's AABB can be found in-game using bad omen or out-of-game using an NBT
viewer like `rbedrock`.

### Using Bad Omen

Bad omen disappears when a player's eyes cross the bottom, northern, and western
bounds of the village's AABB. (On peaceful difficulty bad omen will disappear
without starting a raid.) In creative you can give yourself bad omen with the
command `/effect @s bad_omen 9999 1 true`.

**Finding north.** Start 32+ blocks north of the village and after giving
  yourself bad omen, move one block at the time, horizontally. Whenever bad omen
  disappears, the block you are standing on marks the northern boundary of the
  village. If bad omen never disappears then try moving towards the center
  of the village on the east-west and top-bottom axes. If bad omen disappears
  instantly, move further north until it no longer disappears instantly.

**Finding west.** Use a similar strategy to find the western boundary of the
  village. 

**Finding bottom.** Finding the bottom boundary is a bit harder. Stand on a block
  14+ blocks below the village. Give yourself bad omen. Jump (or fly up one
  block) and see if bad omen disappears. If it does not disappear, place one
  block below your feet and try again. If it disappears, place two blocks below
  your feet, and the top block marks the bottom village boundary.

Once you find north, west, and bottom boundaries, put that information together
to find the block below the bottom-north-west corner of the village. On top of
this block, place a armor stand named "vbb" to mark the bottom-north-west
corner of the village.

### Using `rbedrock`.

The following example code can be used to find the coordinates of the
bottom-north-west corner of every village.

```r
library(tidyverse)
library(rbedrock)
dbpath <- "WORLD_ID/OR/PATH" # use list_worlds() to find

# Open World DB
db <- bedrockdb(dbpath) 

# Read NBT data for every village's INFO record
nbt <- get_keys(starts_with = "plain:VILLAGE", db = db) |>
  str_subset("INFO$") |>
  get_nbt_data( db = db )

# Convert INFO data into a table
tab <- unnbt(nbt) |> map(as_tibble) |> list_rbind(names_to="name")

# Display the bottom-north-west corner of the village
tab |> select(name, X0, Y0, Z0)

close(db)
```

## Function Reference

### `vbb/mark_village`

This function will summon an armor stand with the name "vbb" to mark the
bottom-north-west corner of a village's AABB. The bounding boxes will be drawn
based on the location of this armor stand.

### `vbb/toggle_on`

Turn on all visualizations except grid lines.

### `vbb/toggle_off`

Turn off all visualizations.

### `vbb/toggle_aabb`, `vbb/toggle_center`, etc.

Toggle on or off the visualization of specific bounding boxes.

### `vbb/with_sim4` and `vbb/with_sim6`

Set the sim distance.

### `vbb/toggle_zone_grid` and `vbb/toggle_sim_grid`

Toggle on or off the grid lines for the zone box and the sim box.

### `vbb/show_vbb`, `vbb/show_zone_grid`, and `vbb/show_sim_grid`

Functions that can be run from a command block to show bounding boxes without
using a marked armor stand.

## Village Mechanics

### Coordinate systems

Minecraft uses two different coordinate systems: (1) entity coordinates and (2)
block positions. Entity coordinates use real numbers and specify the position of
entities in the game. Block positions use integers and specify the location
of blocks in the game. A 1.0m x 1.0m x 1.0m cube in entity coordinates takes up
the same amount of space as a single, full block in Minecraft. In this
documentation, entity coordinates will be specified in meters (m) and block
positions in blocks (b). Positions, distances, etc. are usually described in
x-y-z order unless otherwise specified.

Entity coordinates are rounded down (floored) when
converted to block positions. Block positions are promoted to real numbers when
converted to entity coordinates. Most village mechanics use entity coordinates.

### Bounding boxes

#### Axis-aligned bounding box (AABB)

An axis-aligned bounding box (AABB) stores the location of a village. An
AABB is defined by two points in the entity-coordinate system: a 
bottom-north-west point and a top-south-east point. The AABB controls most
village mechanics in one way or another. The default and smallest size of an
AABB is 64.0m x 24.0m x 64.0m. We call villages with the default size "normal",
"standard", or "unstretched."

VBB displays AABBs using lavender edges ![](https://shields.io/badge/-8E65F3?style=flat).

#### Center point

The center of a village is a point in entity-coords. It is calculated as the
center of the village's AABB. In a standard village, the center point of a
village is located (+32.0m, +12.0m, +32.0m) from the bottom-north-west corner
of the AABB.

VBB displays center points using the red crosses ![](https://shields.io/badge/-FF3040?style=flat)
and a 2.0m x 2.0m x 20.0m vat wire frames ![](https://shields.io/badge/-29ADFF?style=flat)
around the cross. The block positions that corresponds to the center
points are indicated by a vertical green lines ![](https://shields.io/badge/-10E436?style=flat)
through the centers of the blocks.

#### Exclusivity zone

The exclusivity zone of a village is calculated by growing the village's AABB 
by 64.0m in all directions. A standard village has an exclusivity zone with
dimensions 192.0m x 152.0m x 152.0m. The exclusivity zone defines the region in
which an existing village can claim a newly discovered bed without creating
a new village.

VBB displays exclusivity zones using teal edges ![](https://shields.io/badge/-07946e?style=flat).

#### Activation region

A village will only be active if a player's position (i.e. eyes) is within the
activation region of the village. A village will not spawn golems or cats
unless it is active. The size of the activation region depends on sim distance.
The activation region is calculated by growing the village's AABB by 
sim-distance * 8.0m in all directions. On sim 4 the increase is 32.0m
in all directions, and on sim 6 it is 48.0m.

VBB displays activation regions using apricot edges ![](https://shields.io/badge/-FF7300?style=flat).

#### Spawning space

The spawning space for cats and iron golems is different than other village
bounding boxes, as it uses block positions instead of entity coordinates.
The spawning space is calculated based on the center point of the village. First
the the center point is rounded down and converted to the block position. This
block is then used as a center of a 17b x 13b x 17b region of blocks. Golems
can spawn on the bottom-north-west corner of blocks in the region with higher
blocks being preferred before lower blocks, along with other conditions.

VBB displays the spawning spaces using white edges ![](https://shields.io/badge/-FFFFFF?style=flat).

### Calculation of the AABB and center of the village

The center of a village is determined by the village's AABB and not the location
of the bed of a special, "village leader" villager. To understand this, it is
important to know how and when the game calculates the location of the village's
AABB.

When a villager links to a point-of-interest (POI), the POI is considered
"claimed". A villager may claim up to three POI: one bed, one job site
(workstation), and one meeting place (bell). Claimed POI are placed in a
special data structure called an "unordered map". The unordered map associates
the villager with its claimed POI. Each villager has three slots in the map,
the first slot is used by the villager's bed if any, the second slot by the
villager's meeting place if any, and the third slot by the villager's
job site if any.

Minecraft calculates a village's AABB so that it encompasses the location of all
claimed POI. Here "location" is defined as the bottom-north-west corner of the
POI as an entity coordinate, and any coordinate that coincides with any edge
of the AABB is considered "inside" the AABB. The algorithm first constructs an
initial 64.0m x 24.0m x 64.0m AABB for the village and then stretches that AABB
as necessary to fit the locations of all claimed POI in the village inside of
it. The center of the initial AABB is the location of the first claimed POI
in the POI list. This coordinate is called the "origin" of the village. If
every villager in the village has claimed a bed, and the village does not have
to stretch beyond the initial AABB to encompass all POI, then the center of the
village will coincide with the origin of the village, which will coincide with
the bottom-north-west corner of the pillow of the bed of one of the villages.

However, an unordered map is just that, unordered. The C++ standard does not
define any requirements on the order of elements in the map. Therefore, different
C++ libraries are free to implement different orders in their unordered maps, and
Minecraft is free to ignore any efforts to preserve the order of elements in 
the map when loading and saving the POI list to disk. This means that the actual
order of elements in the POI list — when it sits in memory or on disk — will vary
between operating systems, platforms, and even different runs of the game.
And even if a player knows how all these things influence the order of elements
in the unordered map, they still cannot predict with 100% accuracy the order
of elements in the unordered map because it also depends on information that
the player does not have: the numeric ID of villagers.

It is rather unfortunate that the algorithm that calculates the village's AABB
is order dependent, when the POI list itself has no defined order. Therefore,
once a village's AABB has been found, care must be taken to not cause it to be
recalculated. Otherwise, the AABB may change and VBB will show inaccurate
information unless the village marker is moved.

A village's AABB is recalculated whenever a POI is claimed by a villager in 
the village or the village detects that a POI currently claimed is no longer
valid. To avoid making the game recalculate a village's AABB, avoid adding
or removing POI from the village, including villagers who unlink from their POI
because they are unable to find a path to the POI.

### False bounding boxes

There are several regions in the game that do not truly exist in the internals
of the game but appear because of how other mechanics interact with one of a
villages five bounding boxes. Most of these interactions are due to programming
mistakes or logic errors in the development of the game.

#### Raid spawning region

A player with bad omen triggers a raid when they enter a village's AABB.
However, the game rounds a player's position down to the nearest integer before
checking if the player is inside the village's AABB. Additionally, due to a
logic error, a position on the edge of the AABB is considered inside the AABB
regardless of which edge it is. As a consequence a player within 1 block to the
south, east, or top of the AABB can trigger a raid before the player physically
enters the village's AABB. This is why using bad omen to measure a village's
AABB is only accurate for the north, west, and bottom edges of the AABB.

#### POI claiming region

When a game checks if a point-of-interest block (POI) is within the exclusivity
zone of a village, it converts the block's position to entity coordinates.
Therefore, a POI will be considered to be inside a zone if its
bottom-north-west corner is inside the zone or on any edge of the zone. For
a standard village this means that there is a 65b x 25b x 65b volume of blocks
that are considered "inside" the exclusivity zone. 

#### Extra iron-golem spawning space

Iron golems spawn at the bottom-north-west corner of a block in the spawning
space. Additionally iron golems need 2x3x2 blocks of space when spawning. If you
considered this extra space in addition to the 17x13x17 block spawning space,
the total room needed for golems to spawn would be 18x15x18 blocks and the 
spawning space would be extended 1 block north and west and 2 blocks up.