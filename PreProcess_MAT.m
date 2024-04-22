close all;
clear all;

%Read in tmax spatial data
inpath = 'C:\PhyloTraitEst\GIS\';
infile = ncinfo(strcat(inpath,'tmax.2017.nc'));
lat = ncread(strcat(inpath,'tmax.2017.nc'),'lat');
lon = ncread(strcat(inpath,'tmax.2017.nc'),'lon');
tmax_17 = ncread(strcat(inpath,'tmax.2017.nc'),'tmax');
tmax_18 = ncread(strcat(inpath,'tmax.2018.nc'),'tmax');
tmax_19 = ncread(strcat(inpath,'tmax.2019.nc'),'tmax');
tmax_20 = ncread(strcat(inpath,'tmax.2020.nc'),'tmax');
tmax_21 = ncread(strcat(inpath,'tmax.2021.nc'),'tmax');
tmax_22 = ncread(strcat(inpath,'tmax.2022.nc'),'tmax');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(plots(site,1)));

    %Extract tmax TS
    sitelat = plots(site,2);
    sitelon = plots(site,3);

    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    
    if sitelon < 0
        [minValue,lon_index] = min(abs(transpose(lon) - (360+sitelon)));
    end
    tmax_ts = [squeeze(tmax_17(lon_index,lat_index,:)); 
                squeeze(tmax_18(lon_index,lat_index,:));    
                squeeze(tmax_19(lon_index,lat_index,:));
                squeeze(tmax_20(lon_index,lat_index,:));
                squeeze(tmax_21(lon_index,lat_index,:));
                squeeze(tmax_22(lon_index,lat_index,:))];

    plots(site,4) = mean(tmax_ts);

end