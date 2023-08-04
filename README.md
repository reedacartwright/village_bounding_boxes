# VBB: Village Bounding Boxes

Visualize bounding boxes that are important for village mechanics.

## Summary

VBB is a behavior pack for Minecraft Bedrock that provides functions for
visualizing bounding boxes that control village mechanics. It can show a
village's axis-aligned bounding box (AABB), exclusivity zone, spawning box,
center, and activation box. Functions are provided that can toggle specific
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
