#!/usr/bin/env openroad
# OpenROAD script to convert ODB to GDS

# Read the OpenROAD database
read_db /workspace/test_chip_2/openlane/user_project_wb_wrapper/runs/RUN_2025-08-28_15-23-06/27-openroad-globalplacement/user_project_wb_wrapper.odb

# Write GDS
write_gds /workspace/test_chip_2/final_outputs/user_project_wb_wrapper.gds

exit