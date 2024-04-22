close all;
clear all;

files = ncinfo('C:\PhyloTraitEst\GIS\TerraClimate19812010_aet.nc');
lat = ncread('C:\PhyloTraitEst\GIS\TerraClimate19812010_aet.nc','lat');
lon = ncread('C:\PhyloTraitEst\GIS\TerraClimate19812010_aet.nc','lon');
AET = ncread('C:\PhyloTraitEst\GIS\TerraClimate19812010_aet.nc','aet');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\AllPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(site(:,1)));
    sitelat = plots(site,2);
    sitelon = plots(site,3);
    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    plots(site,4) = mean(AET(lon_index,lat_index,:));

end