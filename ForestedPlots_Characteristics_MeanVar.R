#####################################################################
# The following code selects forested plots from sPlotOpen
# and computes the weighted trait average and variance
# Created: James Knighton (7/25/2023)
#####################################################################

library(Hmisc)
library(dplyr)

#Read in sPlotOpen
inpath = "C:/PhyloTraitEst/"
load(paste(inpath,"sPlotOpen/3474_76_sPlotOpen.RData",sep=""))
forests = header.oa[which(header.oa$is_forest == TRUE),] #assuming this flag is more correct

#Read in global tree trait database
trees = read.csv(paste(inpath,"GlobalTraits/GlobalTrees_Traits_111023.csv",sep=""))

Output = matrix(nrow=length(forests$PlotObservationID),ncol = 26)
counter = 1
for (plot in 1:length(forests$PlotObservationID))
{
    print(plot)
    plotid = forests$PlotObservationID[plot]
    plotspecies = DT2.oa[which(DT2.oa$PlotObservationID == plotid),]
    
    #Find sPlotOpen tree species that are in global trait database
    common = plotspecies[which(plotspecies$Species %in% trees$spec.name),]
    common <- common %>% group_by(common$Species) %>% summarize(Relative_cover = sum(Relative_cover)) #group duplicates in sPlotOpen data
    colnames(common) <- c('spec.name','Relative_cover')
    plottraits = trees[which(trees$spec.name %in% plotspecies$Species),]
    
    #merge global traits database and sPlotOpen
    SplotTraits = merge(common,plottraits,by="spec.name")
    SplotTraits$weights = SplotTraits$Relative_cover/sum(SplotTraits$Relative_cover)
    
	#Compute only when there are at least 2 species
    if (length(common$spec.name) > 1)
    {
      Output[counter,1] = forests$PlotObservationID[plot]
      Output[counter,2] = forests$Latitude[plot]
      Output[counter,3] = forests$Longitude[plot]
      Output[counter,4] = forests$Elevation[plot]
      Output[counter,5] = forests$Aspect[plot]
      Output[counter,6] = forests$Slope[plot]
      Output[counter,7] = length(common$spec.name)
      Output[counter,8] = sum(common$Relative_cover)
      
      Output[counter,9] = weighted.mean(SplotTraits$gsmax, SplotTraits$weights)
      Output[counter,10] = weighted.mean(SplotTraits$P12, SplotTraits$weights)
      Output[counter,11] = weighted.mean(SplotTraits$P50, SplotTraits$weights)
      Output[counter,12] = weighted.mean(SplotTraits$P88, SplotTraits$weights)
      Output[counter,13] = weighted.mean(SplotTraits$rdmax, SplotTraits$weights)
      Output[counter,14] = weighted.mean(SplotTraits$WUE, SplotTraits$weights)
      Output[counter,15] = weighted.mean(SplotTraits$height, SplotTraits$weights)
      Output[counter,16] = weighted.mean(SplotTraits$SLA, SplotTraits$weights)
      Output[counter,17] = weighted.mean(SplotTraits$LeafN, SplotTraits$weights)
      
      V1 = sum(SplotTraits$weights)
      V2= sum(SplotTraits$weights^2)
      Output[counter,18] <- sqrt(sum((SplotTraits$gsmax - Output[counter,9])^2)/(V1 - V2/V1))
      Output[counter,19] <- sqrt(sum((SplotTraits$P12 - Output[counter,10])^2)/(V1 - V2/V1))
      Output[counter,20] <- sqrt(sum((SplotTraits$P50 - Output[counter,11])^2)/(V1 - V2/V1))
      Output[counter,21] <- sqrt(sum((SplotTraits$P88 - Output[counter,12])^2)/(V1 - V2/V1))
      Output[counter,22] <- sqrt(sum((SplotTraits$rdmax - Output[counter,13])^2)/(V1 - V2/V1))
      Output[counter,23] <- sqrt(sum((SplotTraits$WUE - Output[counter,14])^2)/(V1 - V2/V1))
      Output[counter,24] <- sqrt(sum((SplotTraits$height - Output[counter,15])^2)/(V1 - V2/V1))
      Output[counter,25] <- sqrt(sum((SplotTraits$SLA - Output[counter,16])^2)/(V1 - V2/V1))
      Output[counter,26] <- sqrt(sum((SplotTraits$LeafN - Output[counter,17])^2)/(V1 - V2/V1))
      
      counter = counter + 1      

    }
}

write.table(Output,paste(inpath,"sPlotOpen/ForestPlots_Traits_111923.csv",sep=""),sep=",",row.names = FALSE)
