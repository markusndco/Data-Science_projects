rm(list=ls())

# Load required libraries

library(readr)
library(readxl)
library(ggplot2)
library(rio)
library(moments)
library(lattice)
library(stargazer)
library(corrplot)
library(ellipse)
library(lme4)
library(dplyr) 
library(rdrobust)
library(lmtest)


# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Project/Dataset.xlsx") 
d <- read_excel(file_path, sheet = "Data")
summary(d)
str(d)
d$Qtr <- as.factor(d$Qtr)

# Convert date and create Time variable
d$Duration <- as.Date(d$Duration)
n <- nrow(d)
d$Time <- 1:n

# Linear Trend Model
m1 <- lm(Sales ~ Time, data = d)
m2 <- lm(Sales ~ Time + Qtr, data = d)
stargazer(m1, m2, type = "text", single.row = TRUE)


plot(Sales ~ Time, data = d, main = "Linear Trend")
abline(m1, col = "red")
plot(m1)

# Train-Test Split for RMSE
train <- d[1:40, ]
test  <- d[41:n, ]

m1a <- lm(Sales ~ Time, data = train)
m2a <- lm(Sales ~ Time + Qtr, data = train)

pred_test_m1a <- predict(m1a, newdata = test)
pred_test_m2a <- predict(m2a, newdata = test)

rmse_m1 <- sqrt(mean((test$Sales - pred_test_m1a)^2))
rmse_m2 <- sqrt(mean((test$Sales - pred_test_m2a)^2))

print(paste("RMSE Model 1:", round(rmse_m1, 2)))
print(paste("RMSE Model 2:", round(rmse_m2, 2)))

# Durbin-Watson Test
dwtest(m1)
dwtest(m2)

# ACF and PACF
acf(d$Sales, main = "ACF - Sales")
pacf(d$Sales, main = "PACF - Sales")

# Lag Models
d$SalesLag1 <- c(NA, head(d$Sales, -1))
d$SalesLag2 <- c(NA, NA, head(d$Sales, -2))
d$SalesLag3 <- c(NA, NA, NA, head(d$Sales, -3))

# Drop NA rows from lagging
d_lag <- na.omit(d)

train <- d_lag[1:40, ]
test  <- d_lag[41:nrow(d_lag), ]

m3 <- lm(Sales ~ Time + Qtr + SalesLag1, data = train)
summary(m3)

m4 <- lm(Sales ~ Time + Qtr + SalesLag1 + SalesLag2 + SalesLag3, data = train)
summary(m4)

# Compare all models
stargazer(m1, m2, m3, m4, type = "text", single.row = TRUE)

# RMSE for all models
rmse_m3 <- sqrt(mean((test$Sales - predict(m3, newdata = test))^2))
rmse_m4 <- sqrt(mean((test$Sales - predict(m4, newdata = test))^2))

print(paste("RMSE Model 3:", round(rmse_m3, 2)))
print(paste("RMSE Model 4:", round(rmse_m4, 2)))

library(forecast)
ts_data <- ts(d$Sales, start = c(2012, 4), frequency = 12)

# Check stationarity and difference if needed
adf.test(ts_data)

# Auto-fit ARIMA
fit <- auto.arima(ts_data)
summary(fit)
forecast_arima <- forecast(fit, h = 12)
plot(forecast_arima)



