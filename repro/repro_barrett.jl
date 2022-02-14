# --------------------------------------------------------------------------- #
# Script to reproduce part of the research of Barrett 2017. 
# Here only the pressure indexes are calculated to check if the results are
# the same as on the reference.
# --------------------------------------------------------------------------- #

# =========================================================================== #
# LIBRARY
# =========================================================================== #

using NCDatasets
using Plots

# =========================================================================== #
# FUNCTIONS
# =========================================================================== #

"""
Calculation of the pressure index according to Barret 2017.
"""
pressureIndex = function(pressure, lat, lon_size; reference_pressure = 1016.0)
    lat_grid = repeat(lat', inner = (lon_size, 1))
    lat_correction = cos.(lat_grid)
    pressure_anomaly = pressure .- reference_pressure
    selected_grids = pressure_anomaly .> 0
    pressure_index = sum(pressure_anomaly .* lat_correction .* selected_grids) / sum(lat_correction .* selected_grids)
    return pressure_index
end

# =========================================================================== #
# PROCESS
# =========================================================================== #

# General parameters
area = (160, 290, -45, -10)

# Load the data
slp_file = NCDataset("data/ncep-ncar_mslp_1948-2021-mon.nc");
lon = slp_file["lon"]
lat = slp_file["lat"] # -> this shit is reveser order
slp = slp_file["slp"]

# Select region
lon_sel = area[1] .<= lon .<= area[2]
lat_sel = area[3] .<= lat .<= area[4]
lat = lat[lat_sel]
lon = lon[lon_sel]
slp_crop = slp[lon_sel, lat_sel, :]

# Calculate the pressure index
pressure_index = pressureIndex(slp_crop[:,:,1], lat, size(lon, 1))
