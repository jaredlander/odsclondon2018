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
