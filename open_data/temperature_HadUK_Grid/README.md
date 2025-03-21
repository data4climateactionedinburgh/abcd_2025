# README documentation 

## Temperature data files #

The 2024 monthly temperature data files were downloaded from the Met Office Hadley 
Centre HadUK-Grid in February 2025 (Hollis et al. 2019). They were made 
available from the Hadley Centre under an Open Government Licence (OGL).  

These files contain provisional measurements of average air temperature (the 
'tas' field) for the 1km grid. Confirmed measurements are not yet available. 
Twelve files were downloaded, one for each month of 2024. They are named with 
the final two digits of the filename giving the number of the month, eg March 
2024 ends in '03', April ends in '04' etc: 

tas_hadukgrid_uk_1km_mon_202403.nc 

The 2023 annual data file for tas the mean temperature was downloaded from the
CEDA archive. CEDA released the data under an OGL. 

tas_hadukgrid_uk_1km_ann_202301-202312.nc

Analysis - use CRAN packages - netcdf is a binary file format of course. 
https://cran.r-project.org/web/packages/ncdf4/index.html
https://cran.r-project.org/web/packages/ncdf4.helpers/index.html 

## Approach

https://ropensci.org/blog/2019/11/05/tidync/

## References ## 
Hollis, D, McCarthy, M, Kendon, M, Legg, T and Simpson, I (2019), HadUK-Grid - 
A new UK dataset of gridded climate observations, Geosci. Data J., 6(2), 151-159.

Provisional monthly 2024 data: 
https://www.metoffice.gov.uk/hadobs/hadukgrid/

The HadUK grid
https://www.metoffice.gov.uk/research/climate/maps-and-data/data/haduk-grid/haduk-grid 

Open Government Licence v3 The National Archives 
https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/