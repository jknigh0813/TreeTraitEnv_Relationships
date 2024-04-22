close all;
clear all;

threshold = 1; %mm

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

temp_17 = ncread(strcat(inpath,'tmax.2017.nc'),'tmax');
temp_18 = ncread(strcat(inpath,'tmax.2018.nc'),'tmax');
temp_19 = ncread(strcat(inpath,'tmax.2019.nc'),'tmax');
temp_20 = ncread(strcat(inpath,'tmax.2020.nc'),'tmax');
temp_21 = ncread(strcat(inpath,'tmax.2021.nc'),'tmax');
temp_22 = ncread(strcat(inpath,'tmax.2022.nc'),'tmax');

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
    temp_ts = [squeeze(temp_17(lon_index,lat_index,:)); 
                squeeze(temp_18(lon_index,lat_index,:));    
                squeeze(temp_19(lon_index,lat_index,:));
                squeeze(temp_20(lon_index,lat_index,:));
                squeeze(temp_21(lon_index,lat_index,:));
                squeeze(temp_22(lon_index,lat_index,:))];
        
    dates = datenum(2017,1,1):1:datenum(2022,12,31);
    datepart = datevec(dates);
    counter = 1;
    for year = 2017:2022
        for month = 1:12
            met_month(counter,1) = sum(precip_ts(datepart(:,1) == year & datepart(:,2) == month));
            met_month(counter,2) = sum(temp_ts(datepart(:,1) == year & datepart(:,2) == month));
            counter = counter + 1;
        end
    end

    %Compute deltapstar from Berghuijs and Woods (2015)
    %MET = A*sin(B(x + C)) + D
    %x - monthly dates as decimal years
    %C - phase shift as decimal years
    %deltapstar = Cprecip - Ctemp
    
    %fit precip sin curve
    x = (1:1:72)./12; 
    A_best = 0;
    C_precip = 0;
    D_best = 0;
    MAE_best = 1000;
    for i = 1:10000
        A = unifrnd(0,max(met_month(:,1)) - min(met_month(:,1)));
        B = 2*pi();
        C = unifrnd(0,1);
        D = unifrnd(0,5*mean(met_month(:,1)));
        precip_curve = A*sin(B*(x + C)) + D;
        MAE = mean(abs(met_month(:,1) - transpose(precip_curve)));
        if (MAE  < MAE_best)
            A_best = A;
            C_precip = C;
            D_best = D;
            MAE_best = MAE;
        end
    end    

    %fit temp sin curve
    x = (1:1:72)./12;
    A_best = 0;
    C_temp = 0;
    D_best = 0;
    MAE_best = 1000;
    for i = 1:10000
        A = unifrnd(0,max(met_month(:,2)) - min(met_month(:,2)));
        B = 2*pi();
        C = unifrnd(0,1);
        D = unifrnd(0,5*mean(met_month(:,2)));
        precip_curve = A*sin(B*(x + C)) + D;
        MAE = mean(abs(met_month(:,2) - transpose(precip_curve)));
        if (MAE  < MAE_best)
            A_best = A;
            C_temp = C;
            D_best = D;
            MAE_best = MAE;
        end
    end    

    deltapstar = C_precip - C_temp;
    if (C_precip - C_temp) > 0.5
        deltapstar = -1 + (C_precip - C_temp);
    end
    if (C_precip - C_temp) < -0.5
        deltapstar = 1 + (C_precip - C_temp);
    end
    
    plots(site,4) = deltapstar;

end