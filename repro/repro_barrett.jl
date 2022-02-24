# --------------------------------------------------------------------------- #
# Script to reproduce indeces proposed by Barrett 2017. 
# --------------------------------------------------------------------------- #

# =========================================================================== #
# LIBRARY
# =========================================================================== #

using NCDatasets
using DataFrames
using Dates
using CSV
# using UnicodePlots

# =========================================================================== #
# FUNCTIONS
# =========================================================================== #

"""
    SPHIndex(pressure::Array{Float32, 3}, lat::Vector{Float32}; reference_pressure::Float64)

Calculation of the South Pacific High (SPH) indeces according to Barret 2017.
Requires the `pressure` field as a 2D array, a vector `lat` with all the latitudes,
and optionally a `reference_pressure` that will be used to calculate the anomalies.

Note: Initially, the index was created to work at montly level.
"""

SPHIndex = function(pressure::Array{Float32, 3},
                    lon::Vector{Float32},
                    lat::Vector{Float32};
                    reference_pressure::Float64 = 1016.0)
    # Lon lat grid
    lon_size = size(lon, 1)
    lat_size = size(lat, 1)
    lon_grid = repeat(lon, inner = (1, lat_size))
    lat_grid = repeat(lat', inner = (lon_size, 1))
    lat_correction = cos.(lat_grid .* pi ./ 180)
    # Pressure calculations
    pressure_anomaly = pressure .- reference_pressure
    selected_grids = pressure_anomaly .> 0
    # Loop through time
    ntime = size(pressure, 3)
    pressure_index = zeros(ntime)
    latitude_index = zeros(ntime)
    longitude_index = zeros(ntime)
    for i in 1:ntime
        pressure_index[i] = sum(pressure_anomaly[:,:,i] .* lat_correction .* selected_grids[:,:,i]) / sum(lat_correction .* selected_grids[:,:,i])
        latitude_index[i] = sum(pressure_anomaly[:,:,i] .* lat_grid .* lat_correction .* selected_grids[:,:,i]) / sum(pressure_anomaly[:,:,i] .* lat_correction .* selected_grids[:,:,i])
        longitude_index[i] = sum(pressure_anomaly[:,:,i] .* lon_grid .* lat_correction .* selected_grids[:,:,i]) / sum(pressure_anomaly[:,:,i] .* lat_correction .* selected_grids[:,:,i])
    end
    # Return table
    sph_index = DataFrame(pressure = pressure_index, lon = longitude_index, lat = latitude_index)
    return sph_index
end

# =========================================================================== #
# PROCESS
# =========================================================================== #

# General parameters
area = (160, 290, -45, -10)

# Load the data
slp_file = NCDataset("data/ncep-ncar_mslp_1948-2021-mon.nc");
tim = slp_file["time"]
lon = slp_file["lon"]
lat = slp_file["lat"]
slp = slp_file["slp"]

# Select region
lon_sel = area[1] .<= lon .<= area[2]
lat_sel = area[3] .<= lat .<= area[4]
lat = lat[lat_sel]
lon = lon[lon_sel]
slp_crop = slp[lon_sel, lat_sel, :]

# Calculate the indeces
sph_index = SPHIndex(slp_crop, lon, lat)
sph_index.date = Date.(tim)
CSV.write("data/sph_index.csv", sph_index)
