close all;
clear all;

%Read in precip spatial data
inpath = 'C:\PhyloTraitEst\GIS\';
infile = ncinfo(strcat(inpath,'precip.2017.nc'));
lat = ncread(strcat(inpath,'precip.2017.nc'),'lat');
lon = ncread(strcat(inpath,'precip.2017.nc'),'lon');
precip_17 = ncread(strcat(inpath,'precip.2017.nc'),'precip');
precip_18 = ncread(strcat(inpath,'precip.2018.nc'),'precip');
precip_19 = ncread(strcat(inpath,'precip.2019.nc'),'precip');
precip_20 = ncread(strcat(inpath,'precip.2020.nc'),'precip');
precip_21 = ncread(strcat(inpath,'precip.2021.nc'),'precip');
precip_22 = ncread(strcat(inpath,'precip.2022.nc'),'precip');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(plots(site,1)));

    %Extract precip TS
    sitelat = plots(site,2);
    sitelon = plots(site,3);

    [minValue,lat_index] = min(abs(transpose(lat) - sitelat));
	[minValue,lon_index] = min(abs(transpose(lon) - sitelon));
    
    if sitelon < 0
        [minValue,lon_index] = min(abs(transpose(lon) - (360+sitelon)));
    end
    precip_ts = [squeeze(precip_17(lon_index,lat_index,:)); 
                squeeze(precip_18(lon_index,lat_index,:));    
                squeeze(precip_19(lon_index,lat_index,:));
                squeeze(precip_20(lon_index,lat_index,:));
                squeeze(precip_21(lon_index,lat_index,:));
                squeeze(precip_22(lon_index,lat_index,:))];

    plots(site,4) = sum(precip_ts)/6;

end