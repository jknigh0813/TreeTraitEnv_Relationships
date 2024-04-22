close all;
clear all;

files = ncinfo('C:\PhyloTraitEst\GIS\202311719267222_BGIForestAgeMPIBGC1.0.0.nc');
lat = ncread('C:\PhyloTraitEst\GIS\202311719267222_BGIForestAgeMPIBGC1.0.0.nc','latitude');
lon = ncread('C:\PhyloTraitEst\GIS\202311719267222_BGIForestAgeMPIBGC1.0.0.nc','longitude');
Age = ncread('C:\PhyloTraitEst\GIS\202311719267222_BGIForestAgeMPIBGC1.0.0.nc','ForestAge_TC030');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(site(:,1)));
    sitelat = plots(site,2);
    sitelon = plots(site,3);
    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    plots(site,4) = Age(lon_index,lat_index);

end