close all;
clear all;

files = ncinfo('C:\PhyloTraitEst\GIS\TerraClimate19912020_srad.nc');
lat = ncread('C:\PhyloTraitEst\GIS\TerraClimate19912020_srad.nc','lat');
lon = ncread('C:\PhyloTraitEst\GIS\TerraClimate19912020_srad.nc','lon');
sRad = ncread('C:\PhyloTraitEst\GIS\TerraClimate19912020_srad.nc','srad');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(site(:,1)));
    sitelat = plots(site,2);
    sitelon = plots(site,3);
    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    plots(site,4) = mean(sRad(lon_index,lat_index,:));

end