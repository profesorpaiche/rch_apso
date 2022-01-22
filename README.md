# rch-apso

Something related to the Southeastern Pacific Anticyclone.

For the moment, the repository will replicate the South Pacific High (SPH)
indexes from [Barrett
(2017)](https://journals.ametsoc.org/view/journals/clim/30/1/jcli-d-16-0019.1.xml),
which later can be used for something else.

## Data

Monthly averaged mean sea level pressure (MSLP) data from [NCEP-NCAR Reanalysis
1](http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.html) for
1980-2013 is used to replicate the results. In the future,
[ERA5](https://climate.copernicus.eu/climate-reanalysis) will be used.

## Index calculation

According to Barret, the SPH intensity can be calculated with the following equation:

![Equation 1](https://d3n9xgu0z4cjsp.cloudfront.net/view/journals/clim/30/1/jcli-d-16-0019.1-eq1.gif)

The latitude index can be calculated with this other equation (for longitude is the same, just changing the according variable):

![Equation 2](https://d3n9xgu0z4cjsp.cloudfront.net/view/journals/clim/30/1/jcli-d-16-0019.1-eq2.gif)

