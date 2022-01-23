#! /bin/bash

# ------------------------------------------------------------------------------
# This script set up the project creating the necessary directories and 
# downloading the data if needed. Many of the directories and files created here
# are not visible on the main repository (because files are too heavy).
#
# Author: Arapaima gigas
# Date: 2022-01-22
# ------------------------------------------------------------------------------

# Creating necessary directories
mkdir data
mkdir img

# Download required data
wget https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis.derived/surface/slp.mon.mean.nc -O data/ncep-ncar_mslp_1948-2021-mon.nc
