#!/usr/bin/env magic -dnull -noconsole
# Magic script to convert DEF to GDS

# Load the technology file
tech load /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/magic/sky130A.tech

# Read the LEF files
lef read /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

# Read the DEF file
def read /workspace/test_chip_2/openlane/user_project_wb_wrapper/runs/RUN_2025-08-28_15-23-06/27-openroad-globalplacement/user_project_wb_wrapper.def

# Load the design
load user_project_wb_wrapper

# Write GDS
gds write /workspace/test_chip_2/user_project_wb_wrapper.gds

# Quit
quit -noprompt