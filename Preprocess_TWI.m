close all;
clear all;

files = ncinfo('D:\TWI\ga2.nc');
lat = ncread('D:\TWI\ga2.nc','lat');
lon = ncread('D:\TWI\ga2.nc','lon');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(site(:,1)));


    sitelat = plots(site,2);
    sitelon = plots(site,3);
    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));

    start = [lon_index lat_index];   % Start location along each coordinate
    count = [1 1];
    TWI = ncread('D:\TWI\ga2.nc','Band1',start,count);

    plots(site,4) = TWI;

end