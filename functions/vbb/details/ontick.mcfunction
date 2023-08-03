# initialize the pack if needed
execute unless score initialized vbb_global matches 1.. run function vbb/details/setup

# increment the clock
scoreboard players add @e[name="vbb"] vbb_tick 1

# show the boxes on the correct tick
execute if score show_aabb   vbb_global matches 1 at @e[scores={vbb_tick=4}]  align xyz run function vbb/details/show_aabb
execute if score show_center vbb_global matches 1 at @e[scores={vbb_tick=8}]  align xyz run function vbb/details/show_center
execute if score show_spawn  vbb_global matches 1 at @e[scores={vbb_tick=12}] align xyz run function vbb/details/show_spawn
execute if score show_zone   vbb_global matches 1 at @e[scores={vbb_tick=16}] align xyz run function vbb/details/show_zone
execute if score show_sim    vbb_global matches 1 at @e[scores={vbb_tick=20}] align xyz run function vbb/details/show_sim

# show the grid on the correct tick
execute if score show_zone_grid vbb_global matches 1 at @e[scores={vbb_tick=21}] align xyz run function vbb/details/show_zone_grid_1
execute if score show_zone_grid vbb_global matches 1 at @e[scores={vbb_tick=22}] align xyz run function vbb/details/show_zone_grid_2
execute if score show_zone_grid vbb_global matches 1 at @e[scores={vbb_tick=23}] align xyz run function vbb/details/show_zone_grid_3
execute if score show_zone_grid vbb_global matches 1 at @e[scores={vbb_tick=24}] align xyz run function vbb/details/show_zone_grid_4
execute if score show_zone_grid vbb_global matches 1 at @e[scores={vbb_tick=25}] align xyz run function vbb/details/show_zone_grid_5

# show the grid on the correct tick
execute if score show_sim_grid vbb_global matches 1 at @e[scores={vbb_tick=26}] align xyz run function vbb/details/show_sim_grid_1
execute if score show_sim_grid vbb_global matches 1 at @e[scores={vbb_tick=27}] align xyz run function vbb/details/show_sim_grid_2
execute if score show_sim_grid vbb_global matches 1 at @e[scores={vbb_tick=28}] align xyz run function vbb/details/show_sim_grid_3
execute if score show_sim_grid vbb_global matches 1 at @e[scores={vbb_tick=29}] align xyz run function vbb/details/show_sim_grid_4
execute if score show_sim_grid vbb_global matches 1 at @e[scores={vbb_tick=30}] align xyz run function vbb/details/show_sim_grid_5

# cycle the clock ( = 36 )
scoreboard players operation @e[name="vbb"] vbb_tick %= clock vbb_global
