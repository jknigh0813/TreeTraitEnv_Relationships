#####################################################################
# The following code selects forested plots from sPlotOpen
# computes the min and max trait values in each plot
# computes the convex hull of traits defined 3 ways
#Created: James Knighton (7/25/2023)
#####################################################################
library(fundiversity)
library(Hmisc)
library(dplyr)

#Read in sPlotOpen
inpath = "C:/PhyloTraitEst/"
load(paste(inpath,"sPlotOpen/3474_76_sPlotOpen.RData",sep=""))
forests = header.oa[which(header.oa$is_forest == TRUE),]

#Read in global tree trait database
trees = read.csv(paste(inpath,"GlobalTraits/GlobalTrees_Traits_111023.csv",sep=""))

Output = matrix(nrow=length(forests$PlotObservationID),ncol = 20)
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
    plottraits = plottraits[!duplicated(plottraits[,c('spec.name')]),]
      
    #merge traits and sPlotOpen
    SplotTraits = unique(merge(common,plottraits,by="spec.name"))
    SplotTraits$weights = SplotTraits$Relative_cover/sum(SplotTraits$Relative_cover)
    
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
      
      Output[counter,9] = min(SplotTraits$gsmax)
      Output[counter,10] = min(SplotTraits$P12)
      Output[counter,11] = min(SplotTraits$P50)
      Output[counter,12] = min(SplotTraits$P88)
      Output[counter,13] = min(SplotTraits$rdmax)
      Output[counter,14] = min(SplotTraits$WUE)
      Output[counter,15] = min(SplotTraits$height)
      Output[counter,16] = min(SplotTraits$SLA)
      Output[counter,17] = min(SplotTraits$LeafN)
      
      Output[counter,9] = max(SplotTraits$gsmax)
      Output[counter,10] = max(SplotTraits$P12)
      Output[counter,11] = max(SplotTraits$P50)
      Output[counter,12] = max(SplotTraits$P88)
      Output[counter,13] = max(SplotTraits$rdmax)
      Output[counter,14] = max(SplotTraits$WUE)
      Output[counter,15] = max(SplotTraits$height)
      Output[counter,16] = max(SplotTraits$SLA)
      Output[counter,17] = max(SplotTraits$LeafN)
      
      traitmat = unique(SplotTraits)
      row.names(traitmat) <- traitmat$spec.name
      traitmat1 = traitmat[,c(6,8,10,11,12,14)]
      fric1 = fd_fric(traitmat1, stand = FALSE)

      traitmat2 = traitmat[,c(6,8,10,11)]
      fric2 = fd_fric(traitmat2, stand = FALSE)

      traitmat3 = traitmat[,c(12,13,14)]
      fric3 = fd_fric(traitmat3, stand = FALSE)
      
      Output[counter,18] = fric1$FRic
      Output[counter,19] = fric2$FRic
      Output[counter,20] = fric3$FRic
      
      counter = counter + 1      

    }
}

write.table(Output,paste(inpath,"sPlotOpen/ForestPlots_Traits_Limits_021424.csv",sep=""),sep=",",row.names = FALSE)
