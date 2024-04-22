library(h2o)

inpath = "C:/PhyloTraitEst/sPlotOpen/"
outpath = "C:/PhyloTraitEst/GlobalTraits/"

#select a forested plot trait to predict at the global scale
TraitName = "Hull3"

h2o.init(nthreads = 6, #Number of threads -1 means use all cores on your machine
         max_mem_size = "4G")  #max mem size is the maximum memory to allocate to H2O

#1. Import TRY trait data
TraitData <- paste(inpath,"ForestPlots_Traits_Limits_021424.csv",sep="")
data <- h2o.importFile(TraitData)
data$var = data[[TraitName]]
dim(data)

splits <- h2o.splitFrame(data = data, 
                         ratios = c(0.7, 0.15),  #partition data into 70%, 15%, 15% chunks
                         seed = 6)  #setting a seed will guarantee reproducibility
train <- splits[[1]]
valid <- splits[[2]]
test <- splits[[3]]

#2. Identify response and predictor variables
y <- "Hull3"
x <- setdiff(names(data),c(y,"lat","lon","Date","plotid","aspect","gsmax","P12","P50","P88","rdmax","WUE","height","SLA","LeafN","min_gsmax","min_P12","min_P50","min_P88","min_rdmax","min_WUE","min_height","min_SLA","min_leafN","max_gsmax","max_P12","max_P50","max_P88","max_rdmax","max_WUE","max_height","max_SLA","max_leafN","Hull1","Hull2","Hull3","var"))
print(x)

#3. Random Forest
RF <- h2o.randomForest(x = x,
                            y = y,
                            training_frame = train,
                            model_id = "RF_Trait",
                            nfolds = 8,
                            validation_frame = valid,  #only used if stopping_rounds > 0
                            ntrees = 200,
                            max_depth = 30,
                            stopping_rounds = 10,
                            stopping_tolerance = 1e-3,
                            stopping_metric = "MSE",
                            seed = 200)

#RF_perf <- h2o.performance(model = RF, newdata = test)
#RF_perf

#4. Random Forest Predictions
pred_train = h2o.predict(object=RF, newdata=train)
pred_valid = h2o.predict(object=RF, newdata=valid)
pred_test = h2o.predict(object=RF, newdata=test)

#Generate scatter plots of observed versus simulated
plotmin = 0
plotmax = 5e5

par(mfrow=c(1,3))
plot(c(plotmin,plotmax),c(plotmin,plotmax),type="l")
Output = as.data.frame(train$var)
Output[,2] = as.data.frame(pred_train)
points(Output$var,Output$predict,xlim=c(plotmin,plotmax),ylim=c(plotmin,plotmax))

plot(c(plotmin,plotmax),c(plotmin,plotmax),type="l")
Output_V = as.data.frame(valid$var)
Output_V[,2] = as.data.frame(pred_valid)
points(Output_V$var,Output_V$predict,xlim=c(plotmin,plotmax),ylim=c(plotmin,plotmax))

plot(c(plotmin,plotmax),c(plotmin,plotmax),type="l")
Output_T = as.data.frame(test$var)
Output_T[,2] = as.data.frame(pred_test)
points(Output_T$var,Output_T$predict,xlim=c(plotmin,plotmax),ylim=c(plotmin,plotmax))

#5. Write test dataset performance
write.table(Output_T,paste(outpath,"RF_sPlot_Predict_",TraitName,".csv",sep=""),row.names = FALSE,col.names = FALSE,sep=",")

vimp = h2o.varimp(RF)
write.table(vimp,paste(outpath,"RF_sPlot_Predict_",TraitName,"_VIMP.csv",sep=""),row.names = FALSE,col.names = FALSE,sep=",")
