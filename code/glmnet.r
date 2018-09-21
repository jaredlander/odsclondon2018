library(glmnet)
library(useful)
library(coefplot)

land_train <- readRDS('data/manhattan_Train.rds')

View(land_train)

valueFormula <- TotalValue ~ FireService + 
    ZoneDist1 + ZoneDist2 + Class + LandUse + 
    OwnerType + LotArea + BldgArea + ComArea + 
    ResArea + OfficeArea + RetailArea + 
    GarageArea + FactryArea + NumBldgs + 
    NumFloors + UnitsRes + UnitsTotal + 
    LotFront + LotDepth + BldgFront + 
    BldgDepth + LotType + Landmark + BuiltFAR +
    Built + HistoricDistrict - 1

value1 <- lm(valueFormula, data=land_train)
value1
summary(value1)
coefplot(value1, sort='magnitude')

landX_train <- build.x(valueFormula, data=land_train,
                       contrasts=FALSE, sparse=TRUE)
landY_train <- build.y(valueFormula, data=land_train)

landX_train
head(as.matrix(landX_train))


value2 <- glmnet(x=landX_train, y=landY_train, family='gaussian')
value2
value2$beta
View(as.matrix(value2$beta))

plot(value2, xvar='lambda', label=TRUE)
coefpath(value2)

library(animation)
cv.ani(k=10)

value3 <- cv.glmnet(x=landX_train, y=landY_train,
                    family='gaussian',
                    nfolds=5)
plot(value3)
coefpath(value3)
coefplot(value3, sort='magnitude', lambda='lambda.1se')

value4 <- cv.glmnet(x=landX_train, y=landY_train,
                    family='gaussian',
                    alpha=0,
                    nfolds=5)
coefpath(value4)
coefplot(value4, sort='magnitude', lambda='lambda.1se')

value5 <- cv.glmnet(x=landX_train, y=landY_train,
                    family='gaussian',
                    alpha=0.6,
                    nfolds=5)
coefpath(value5)

land_test <- readRDS('data/manhattan_Test.rds')
landX_test <- build.x(valueFormula, data=land_test,
                      contrasts=FALSE, sparse=TRUE)

valuePredictions5 <- predict(value5, newx=landX_test, 
                             s='lambda.1se')
head(valuePredictions5)
