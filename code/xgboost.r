library(useful)
library(coefplot)
library(xgboost)
library(magrittr)
library(dygraphs)

land_train <- readRDS('data/manhattan_Train.rds')
land_test <- readRDS('data/manhattan_Test.rds')
land_val <- readRDS('data/manhattan_Validate.rds')

set.seed(1123)

table(land_train$HistoricDistrict)
histFormula <- HistoricDistrict ~ FireService + 
    ZoneDist1 + ZoneDist2 + Class + LandUse + 
    OwnerType + LotArea + BldgArea + ComArea + 
    ResArea + OfficeArea + RetailArea + 
    GarageArea + FactryArea + NumBldgs + 
    NumFloors + UnitsRes + UnitsTotal + 
    LotFront + LotDepth + BldgFront + 
    BldgDepth + LotType + Landmark + BuiltFAR +
    Built + TotalValue - 1

landX_train <- build.x(histFormula, data=land_train,
                       contrasts=FALSE, sparse=TRUE)
landY_train <- build.y(histFormula, data=land_train) %>% 
    as.integer() - 1
head(landY_train, n=100)

landX_test <- build.x(histFormula, data=land_test,
                       contrasts=FALSE, sparse=TRUE)
landY_test <- build.y(histFormula, data=land_test) %>% 
    as.integer() - 1

landX_val <- build.x(histFormula, data=land_val,
                       contrasts=FALSE, sparse=TRUE)
landY_val <- build.y(histFormula, data=land_val) %>% 
    as.integer() - 1

xgTrain <- xgb.DMatrix(data=landX_train, label=landY_train)
xgVal <- xgb.DMatrix(data=landX_val, label=landY_val)

xg1 <- xgb.train(
    data=xgTrain,
    objective='binary:logistic',
    nrounds=1
)

xgb.plot.multi.trees(xg1, feature_names=colnames(landX_train))

xg2 <- xgb.train(
    data=xgTrain,
    objective='binary:logistic',
    nrounds=1,
    eval_metric='logloss',
    watchlist=list(train=xgTrain)
)

xg3 <- xgb.train(
    data=xgTrain,
    objective='binary:logistic',
    nrounds=100,
    eval_metric='logloss',
    watchlist=list(train=xgTrain)
)

xg4 <- xgb.train(
    data=xgTrain,
    objective='binary:logistic',
    nrounds=300,
    eval_metric='logloss',
    watchlist=list(train=xgTrain)
)

xg5 <- xgb.train(
    data=xgTrain,
    objective='binary:logistic',
    nrounds=300,
    eval_metric='logloss',
    watchlist=list(train=xgTrain, validate=xgVal)
)
