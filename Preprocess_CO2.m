close all;
clear all;

files = ncinfo('C:\PhyloTraitEst\GIS\CO2_1deg_month_1850-2013.nc');
lat = ncread('C:\PhyloTraitEst\GIS\CO2_1deg_month_1850-2013.nc','Latitude');
lon = ncread('C:\PhyloTraitEst\GIS\CO2_1deg_month_1850-2013.nc','Longitude');
times = ncread('C:\PhyloTraitEst\GIS\CO2_1deg_month_1850-2013.nc','Times');
CO2 = ncread('C:\PhyloTraitEst\GIS\CO2_1deg_month_1850-2013.nc','value');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(site(:,1)));
    sitelat = plots(site,2);
    sitelon = plots(site,3);
    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    plots(site,4) = mean(CO2(lon_index,lat_index,(1968-12*10):1968));

end