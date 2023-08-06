# VBB: Village Bounding Boxes

Display the bounding boxes that are important for village mechanics.

## Summary

VBB is a behavior pack for Minecraft Bedrock that provides functions for
visualizing bounding boxes that control village mechanics. It can show a
village's axis-aligned bounding box (AABB), center, exclusivity zone,
spawning space, and activation region. Functions are provided that can toggle
specific boxes one and off.

VBB depends on the [LiteLoaderBDS-CUI Resource Pack](https://github.com/OEOTYAN/LiteLoaderBDS-CUI/releases/tag/v1.1).

VBB also assumes that the village's AABB has a standard, unstretched size of
64.0m x 24.0m x 64.0m.

## Quick Start

Download and import both VBB and the
[LiteLoaderBDS-CUI Resource Pack](https://github.com/OEOTYAN/LiteLoaderBDS-CUI/releases/tag/v1.1).

In world settings, activate the VBB behavior pack and enable cheats. VBB is
easiest to use on a peaceful, creative copy of a world. Activating VBB will
activate the LiteLoaderBDS-CUI resource pack as well.

Place an armor stand at the bottom-north-west corner of a village's AABB. Use a
nametag to name this armor stand "vbb". (The command
`/function vbb/mark_village` can be used to summon the armor stand for you.)

Use the command `/function vbb/toggle_on` to turn on the display of village
bounding boxes.

## Finding a village's AABB

A village's AABB can be found in-game using bad omen or out-of-game using an
NBT viewer like `rbedrock`.

### Using bad omen

Bad omen disappears when a player's **eyes** cross the bottom, northern, and
western bounds of the village's AABB. (On peaceful, bad omen will
disappear without starting a raid.) In creative you can give yourself bad omen
with the command `/effect @s bad_omen 9999 1 true`.

**Finding north.** Start 32+ blocks north of the village and after giving
  yourself bad omen, move horizontally one block at the time toward the village.
  Whenever bad omen disappears, the block you are standing on marks the
  northern boundary of the village. If bad omen never disappears then try
  moving towards the center of the village on the east-west and top-bottom axes.
  If bad omen disappears instantly, move further away from the village
  until it no longer disappears instantly.

**Finding west.** Use a similar strategy to find the western boundary of the
  village. 

**Finding the bottom.** Finding the bottom boundary is a bit harder because bad omen
will disappear when the player's eyes (and not feet) enters the village's AABB.
Stand on a block 14+ blocks below the village. Give yourself bad omen.
Jump (or fly up) one block and see if bad omen disappears. If it does not
disappear, place one block below your feet and try again. If it disappears,
place two blocks below your feet, and the top of the highest block marks the
bottom village boundary.

Once you find north, west, and bottom boundaries, put that information together
to find the block below the bottom-north-west corner of the village. On top of
this block, place a armor stand named "vbb" to mark the bottom-north-west
corner of the village.

### Using rbedrock

While bad omen can be used in game to find the bottom-north-west corner of
the village's AABB, it is slow and tedious. As an alternative,
[rbedrock](https://github.com/reedacartwright/rbedrock) can be used to find
the bottom-north-west corners of multiple villages in a batch operation.
Rbedrock is a package for the R programming language that provides read and
write access to Bedrock worlds. The following R code can be used to find the
coordinates of the bottom-north-west corner of every village.

```r
library(tidyverse)
library(rbedrock)
dbpath <- "WORLD_ID/OR/PATH" # use list_worlds() to find

# Open World DB.
# Make sure the world is not opened in Minecraft at the same time
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

### Verifying the AABB

Once the village has been marked, use the command `/function vbb/toggle_aabb` to
display the edge of the village's AABB using lavender lines. Give yourself
bad omen and approach the AABB from the north, west, and/or below. As soon
as the player's eyes cross the into the box from these directions (including the
edges), bad omen will disappear. If it disappears at some other boundary on the
north, west, or below, then the AABB is not in the right location.

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

Set the sim distance with out this set, the game will not display the activation
region.

### `vbb/toggle_zone_grid` and `vbb/toggle_sim_grid`

Toggle on or off the grid lines for the zone box and the sim box.

### `vbb/show_vbb`, `vbb/show_zone_grid`, and `vbb/show_sim_grid`

Functions that can be run from a command block to show bounding boxes without
using a marked armor stand.

## Village Mechanics

Below is a description of how villages work in Minecraft Bedrock. This
is intended to be a technical resource to help players understand the mechanics
behind villages in addition to understanding how to interpret the bounding boxes
displayed by VBB.

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
village mechanics in one way or another. The default and smallest size of a
village is 64.0m x 24.0m x 64.0m. We call villages with the default size
"normal", "standard", or "unstretched".

VBB displays villages' boundary AABBs using lavender edges
![](https://shields.io/badge/-8E65F3?style=flat).

#### Center point

The center of a village is a point in entity-coords. It is calculated as the
center of the village's AABB. In a standard village, the center point of a
village is located (+32.0m, +12.0m, +32.0m) from the bottom-north-west corner
of the AABB.

VBB displays center points using the red crosses ![](https://shields.io/badge/-FF3040?style=flat)
and a 2.0m x 2.0m x 2.0m blue box ![](https://shields.io/badge/-29ADFF?style=flat)
around the cross. The block positions that correspond to each center point
are indicated by a vertical green lines ![](https://shields.io/badge/-10E436?style=flat)
through the centers of the blocks.

#### Exclusivity zone

The exclusivity zone of a village is calculated by growing the village's AABB 
by 64.0m in all directions. A standard village has an exclusivity zone with
dimensions 192.0m x 152.0m x 192.0m. The exclusivity zone defines the region in
which an existing village can claim a newly discovered bed without creating
a new village. 

VBB displays exclusivity zones using teal edges ![](https://shields.io/badge/-07946e?style=flat).

A related concept in village mechanics is the POI assignment zone.

#### Activation region

A village will only be active if a player's position (i.e. eyes) is within the
activation region of the village. A village will not spawn golems or cats
unless it is active. The size of the activation region depends on sim distance.
The activation region is calculated by growing the village's AABB by 
sim-distance * 8.0m in all directions. On sim 4 the increase is +32.0m
in all directions, and on sim 6 it is +48.0m.

VBB displays activation regions using apricot edges ![](https://shields.io/badge/-FF7300?style=flat).

#### Spawning space

The spawning space for cats and iron golems is different than other village
bounding boxes, as it uses block positions instead of entity coordinates.
The spawning space is calculated based on the center point of the village. First
the center point is rounded down and converted to a block position. This
block is then used as a center of a 17b x 13b x 17b region of blocks. Golems
can spawn on the bottom-north-west corner of blocks in the region, and higher
blocks are preferred before lower blocks. There are additional conditions as
well.

VBB displays the spawning spaces using white edges ![](https://shields.io/badge/-FFFFFF?style=flat).

#### Emigration region

A villager, iron golem, or other village dweller can migrate to a new village
if it is far enough outside a village's AABB.  The emigration region is calculated
by growing a village's AABB by 10.0m in all directions. Any dweller outside this
boundary is in the emigration region and is able to migrate to a new village.

VBB does not currently display the emigration region.

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

Minecraft calculates a village's AABB so that it encompasses the locations of all
claimed POI. Here "location" is defined as the bottom-north-west corner of the
POI as an entity coordinate. Any coordinate that coincides with any edge
of the AABB is considered "inside" the AABB. The algorithm first constructs an
initial 64.0m x 24.0m x 64.0m AABB for the village and then stretches that AABB
as necessary to fit the locations of all claimed POI in the village inside of
it. The center of the initial AABB is the location of the first claimed POI
in the POI list. We call this coordinate the "origin" of the village. If
(1) every villager in the village has claimed a bed, and (2) the village does
is not stretched beyond the initial AABB, then the center of the village will
coincide with the origin of the village, which will also coincide with
the bottom-north-west corner of the pillow of the bed of one of the villagers.

However, an unordered map is, well, **unordered**. The C++ standard does not
define any requirements on the order of elements in the map. Therefore, different
C++ libraries are free to implement different orders in their unordered maps, and
Minecraft is free to ignore any efforts to preserve the order of elements in 
the map when loading and saving the POI list to disk. This means that the actual
order of elements in the POI list — in memory or on disk — will vary
between operating systems, platforms, and even different runs of the game.
And even if a player knows how all these things influence the order of elements
in the unordered map, they still cannot predict in game with 100% accuracy the
order of elements in the unordered map because it also depends on information
that the player does not have: the numeric IDs of villagers and the order they
were added to the village.

It is rather unfortunate that the algorithm that calculates the village's AABB
is order dependent, when the POI list itself has no defined order. Therefore,
once a village's AABB has been found, care must be taken to not cause it to be
recalculated. Otherwise, the AABB may change and VBB will show inaccurate
information unless the village marker is moved.

A village's AABB is recalculated whenever a POI is claimed by a villager in 
the village or the village detects that a POI currently claimed is no longer
valid. To avoid making the game recalculate a village's AABB, avoid adding
or removing POI from the village, including building a village where villagers
delink from their POI because they are unable to find a path to the POI.

### False bounding boxes

There are several regions in the game that do not truly exist in its internals
but appear because of how other mechanics interact with one of a
villages five bounding boxes. Most of these interactions are due to programming
mistakes or logic errors in the development of the game.

#### Raid triggering region

A player with bad omen triggers a raid when they enter a village's AABB.
However, the game rounds a player's position down to the nearest integer before
checking if the player is inside the village's AABB. Additionally, due to a
logic error, a position on the edge of the AABB is considered inside the AABB
regardless of which edge it is. As a consequence a player within 1 block to the
south, east, or top of the AABB can trigger a raid before the player physically
enters the village's AABB. This is why using bad omen to measure a village's
AABB is only accurate for the north, west, and bottom edges of the AABB.

#### POI assignment zone

When a game checks if a point-of-interest block (POI) is within the exclusivity
zone of a village, it converts the block's position to entity coordinates.
Therefore, a POI will be considered to be inside an exclusivity zone if its
bottom-north-west corner is inside the zone or on any edge of the zone. For
a standard village this means that there is a 65x25x65 volume of blocks
that are considered "inside" the exclusivity zone. Even if the POI is inside
the exclusivity zone, the game may still create a new village due to additional
conditions.

#### Extra iron-golem spawning space

Iron golems spawn at the bottom-north-west corner of a block in the spawning
space. Additionally iron golems need 2x3x2 blocks of space when spawning. If you
considered this extra space in addition to the 17x13x17 block spawning space,
the total room needed for golems to spawn would be 18x15x18 blocks and the 
spawning space would be extended 1 block north and west and 2 blocks up.

### Bugs affecting village mechanics

There are several programming mistakes and logic errors in the game that
impact village mechanics.

#### AABB::contains() uses double-closed intervals instead of half-open intervals

When the game checks if an AABB contains a point, it uses double-closed
intervals. This means that a point on the edge of an AABB is considered in 
the AABB regardless of which edge it is on. This is in contrast with the way
block positions work and the way the game checks if two AABBs intersect.

Consider a stone block at (0, 0, 0). An armor stand placed on top of the stone
block will have an entity position of (0.5m, 1.0m, 0.5m) and an AABB
of (0.25m, 1.0m, 0.25m) to (0.75m, 2.975m, 0.75m). 

Now consider the AABB of the stone block, which will be (0.0m, 0.0m, 0.0m) to
(1.0m, 1.0m, 1.0m). The top of the stone block's AABB touches the bottom of the
armor stand's AABB along the y = 1.0m plane. These two AABBs are considered
neighboring (not intersecting), and `AABB::intersects()` returns `false` here.
In contrast, both AABBs contain the point (0.5m, 1.0m, 0.5m) because
`AABB:contains()` returns `true` when both
AABBs are tested against this point. So according to the game, two AABBs
which don't intersect can contain the same point.

If `AABB::contains()` used half-open intervals, points along the south,
east, and upper boundaries of an AABB would not be considered "inside" the
AABB. Here, AABBs would have to intersect and not just be neighbors to share
points in common. 

This would be consistent with how block positions work in the game.
Every entity coordinate can be converted to a specific block position by
rounding the coordinates down to the nearest integer (flooring). No entity
coordinate can be converted to more than one block position, and any entity
coordinate that is on the boundary between two blocks is already an integer
and is converted to the higher block position.

This bug impacts both the raid triggering system and the creation of new villages.

#### Raid triggering system uses a player's block position instead of entity position

The function `RaidTriggerSystem::_doRaidTriggerSystem()` converts a player's
entity coordinates into a block position, converts it back to entity
coordinates, and then checks if a village's AABB contains the position. Due to
the previous bug where AABBs use double-closed intervals, this allows a raid to
be triggered before the player enters the village's AABB if the player is to
the south, east, or above the AABB.

If `_doRaidTriggerSystem()` never bothered to convert a player's entity
coordinates into a block position then the trigger system would behave as
expected.

#### A village's boundary is calculated in entity coordinates instead of block positions

A village's boundary (AABB) is calculated from the location of all the claimed
POI in the village. From a player's standpoint it is counter intuitive that
entity positions of POI are used and not their block positions.

Consider a village with a workstation at x = 0, and another workstation at
x = 64. Intuitively the west boundary of the village should align with the west
side of the workstation at x = 0 and the east boundary of the village should
align with the east boundary of the workstation at x = 64. However, because
only the bottom-north-west corner of the POI are considered when calculating the
village's boundary, the east boundary of the village is actually aligned with
the west side of the workstation at x = 64.

Fixing this is rather straightforward; ensure that a village's AABB
encompasses both the bottom-north-west and top-south-east corners of all
claimed POI blocks.

#### A village's boundary depends on the order of elements in the POI list

When a village's boundary (AABB) is calculated, its final value depends
on the order of the POI in the village's claimed POI list. Two villages created
using the same POI locations can have completely different AABBs due to the POI
order varying between them.

As an alternative to the current algorithm, a village's boundary can be
calculated without depending on the order of the POI. Below is an example 
using the x-axis, and other axes can be calculated similarly.
 - Find the midpoint of the village based on the western edge of the
   western-most claimed POI and the eastern edge of the eastern-most claimed
   POI.
 - Create an AABB centered on this midpoint that is 64.0m wide. Round the
   western edge down to the nearest integer (floor), and round the eastern edge
   up to the nearest integer (ceiling).
 - Increase the AABB west and/or east as necessary to include the western and
 eastern edges of all POI as necessary.
