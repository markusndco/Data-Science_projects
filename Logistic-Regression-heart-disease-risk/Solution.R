rm(list=ls())

# Load required libraries
library(ggplot2)
library(readr)
library(readxl)
library(rio)
library(moments)
library(lattice)
library(stargazer)
library(corrplot)
library(ellipse)
library(lme4)
library(dplyr) 
library(rdrobust)


# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Assignment 4/SAHD.xlsx") 
data <- read_excel(file_path, sheet = "Data")
summary(data)
str(data)

#3. Descriptive Analysis of Key Variables
summary(data %>% select(age, ldl, sbp, tobacco, adiposity, obesity, alcohol, typea, famhist, chd))
table(data$chd)

#4. Visualizations: Predictors vs Heart Disease
data$famhist <- as.factor(data$famhist)
data$chd <- as.factor(data$chd)

ggplot(data, aes(x = chd, y = age)) + geom_boxplot(fill = "skyblue") + ggtitle("Age vs CHD")
ggplot(data, aes(x = chd, y = ldl)) + geom_boxplot(fill = "salmon") + ggtitle("LDL vs CHD")
ggplot(data, aes(x = chd, y = sbp)) + geom_boxplot(fill = "lightgreen") + ggtitle("SBP vs CHD")

ggplot(data, aes(x = age, fill = chd)) + geom_density(alpha = 0.5) + ggtitle("Age Density by CHD Status")

#5. Observable Trends

numeric_vars <- data %>% select(-famhist, -chd)
corrplot(cor(numeric_vars), method = "circle")


#8. Logistic Regression Models

model1 <- glm(chd ~ age, data = data, family = binomial)
model2 <- glm(chd ~ ldl + sbp, data = data, family = binomial)

stargazer(model1, model2, type = "text", 
          title = "Logistic Regression Results",
          dep.var.labels = c("CHD"),
          column.labels = c("Age Only", "LDL + SBP"),
          covariate.labels = c("Age", "LDL", "SBP"),
          model.numbers = FALSE,
          no.space = TRUE,
          align = TRUE,
          single.row = TRUE)


#10. Model Fit and Evaluation
# Pseudo R-squared
pR2(model1)
pR2(model2)

# Hosmer-Lemeshow test
hoslem.test(data$chd, fitted(model1))
hoslem.test(data$chd, fitted(model2))
