close all;
clear all;

threshold = 1; %mm

%Read in precip spatial data
inpath = 'C:\PhyloTraitEst\GIS\';
infile = ncinfo(strcat(inpath,'EURASIA_WTD_annualmean.nc'));
lat_Eurasia = ncread(strcat(inpath,'EURASIA_WTD_annualmean.nc'),'lat');
lon_Eurasia = ncread(strcat(inpath,'EURASIA_WTD_annualmean.nc'),'lon');
WTD_Eurasia = ncread(strcat(inpath,'EURASIA_WTD_annualmean.nc'),'WTD');

lat_Namerica = ncread(strcat(inpath,'NAMERICA_WTD_annualmean.nc'),'lat');
lon_Namerica = ncread(strcat(inpath,'NAMERICA_WTD_annualmean.nc'),'lon');
WTD_Namerica = ncread(strcat(inpath,'NAMERICA_WTD_annualmean.nc'),'WTD');

lat_Samerica = ncread(strcat(inpath,'SAMERICA_WTD_annualmean.nc'),'lat');
lon_Samerica = ncread(strcat(inpath,'SAMERICA_WTD_annualmean.nc'),'lon');
WTD_Samerica = ncread(strcat(inpath,'SAMERICA_WTD_annualmean.nc'),'WTD');

lat_Oceania = ncread(strcat(inpath,'OCEANIA_WTD_annualmean.nc'),'lat');
lon_Oceania = ncread(strcat(inpath,'OCEANIA_WTD_annualmean.nc'),'lon');
WTD_Oceania = ncread(strcat(inpath,'OCEANIA_WTD_annualmean.nc'),'WTD');

lat_Africa = ncread(strcat(inpath,'AFRICA_WTD_annualmean.nc'),'lat');
lon_Africa = ncread(strcat(inpath,'AFRICA_WTD_annualmean.nc'),'lon');
WTD_Africa = ncread(strcat(inpath,'AFRICA_WTD_annualmean.nc'),'WTD');

plots = dlmread('C:\PhyloTraitEst\sPlotOpen\ForestPlot_LatLon.csv');

for site = 1:length(plots(:,1))
    
    disp(num2str(plots(site,1)));

    sitelat = plots(site,2);
    sitelon = plots(site,3);

    [minlat,lat_index_e] = min(abs(transpose(lat_Eurasia) - sitelat));
	[minlon,lon_index_e] = min(abs(transpose(lon_Eurasia) - sitelon));
    dist_Eurasia = sqrt(minlat^2 + minlon^2);

    [minlat,lat_index_n] = min(abs(transpose(lat_Namerica) - sitelat));
	[minlon,lon_index_n] = min(abs(transpose(lon_Namerica) - sitelon));
    dist_Namerica = sqrt(minlat^2 + minlon^2);

    [minlat,lat_index_s] = min(abs(transpose(lat_Samerica) - sitelat));
	[minlon,lon_index_s] = min(abs(transpose(lon_Samerica) - sitelon));
    dist_Samerica = sqrt(minlat^2 + minlon^2);

    [minlat,lat_index_o] = min(abs(transpose(lat_Oceania) - sitelat));
	[minlon,lon_index_o] = min(abs(transpose(lon_Oceania) - sitelon));
    dist_Oceania = sqrt(minlat^2 + minlon^2);

    [minlat,lat_index_a] = min(abs(transpose(lat_Africa) - sitelat));
	[minlon,lon_index_a] = min(abs(transpose(lon_Africa) - sitelon));
    dist_Africa = sqrt(minlat^2 + minlon^2);

    glob_min = min([dist_Eurasia; dist_Namerica; dist_Samerica; dist_Oceania; dist_Africa]);

    if dist_Eurasia == glob_min
        WTD = WTD_Eurasia(lon_index_e,lat_index_e);
    end
    if dist_Namerica == glob_min
        WTD = WTD_Namerica(lon_index_n,lat_index_n);
    end
    if dist_Samerica == glob_min
        WTD = WTD_Samerica(lon_index_s,lat_index_s);
    end
    if dist_Oceania == glob_min
        WTD = WTD_Oceania(lon_index_o,lat_index_o);
    end
    if dist_Africa == glob_min
        WTD = WTD_Africa(lon_index_a,lat_index_a);
    end

    plots(site,4) = WTD;

end