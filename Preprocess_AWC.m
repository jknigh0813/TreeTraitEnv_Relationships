close all;
clear all;

files = ncinfo('C:\PhyloTraitEst\GIS\cwdx80.nc');
lat = ncread('C:\PhyloTraitEst\GIS\cwdx80.nc','lat');
lon = ncread('C:\PhyloTraitEst\GIS\cwdx80.nc','lon');
AWC = ncread('C:\PhyloTraitEst\GIS\cwdx80.nc','cwdx80');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    %Extract precip TS
    sitelat = plots(site,2);
    sitelon = plots(site,3);
    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    plots(site,4) = AWC(lon_index,lat_index,:);

end