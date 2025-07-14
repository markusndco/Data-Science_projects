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
library(lmtest)
library(corrplot)
library(lme4)
library(dplyr) 
library(psych)
library(MASS)

# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Assignment 1/NHIS_2009.xlsx") 
data <- read_excel(file_path, sheet = "Data")
summary(data)
str(data)

#mutatung data
data <- data %>%
  mutate(
    sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female")),
    
    marstat = factor(marstat, levels = c(0, 10, 20, 30, 40, 50), 
                     labels = c("N/A", "Married, spouse present", "Married, spouse absent", 
                                "Separated", "Divorced", "Widowed")),
    
    racenew = factor(racenew, levels = c(10, 20, 30, 40, 50), 
                     labels = c("White", "Black or African American", 
                                "American Indian or Alaska Native", "Asian", "Other race")),
    
    empstat = factor(empstat, levels = c(0, 11, 12, 20, 30, 40), 
                     labels = c("Not in labor force or unemployed", "Employed full-time", 
                                "Employed part-time", "Unemployed", 
                                "Not in labor force (other)", "Not in labor force (disabled)")),
    
    uninsured = factor(uninsured, levels = c(1, 2), labels = c("Uninsured", "Insured")),
    
    hi = factor(hi, levels = c(0, 1), labels = c("Not High Income", "High Income")),
    
    empl = factor(empl, levels = c(0, 1), labels = c("Unemployed", "Employed")),
    
    fml = factor(fml, levels = c(0, 1), labels = c("Male", "Female")),
    
    nwhite = factor(nwhite, levels = c(0, 1), labels = c("White", "Non-White")),
    
    marradult = factor(marradult, levels = c(0, 1), labels = c("Not Married", "Married Adult"))
  )

str(data)
describe(data) 

#Correlation test
correlation_matrix <- cor(data[c("age","famsize","incmp")])
corrplot(correlation_matrix, method = "pie")
print(correlation_matrix)

#Uninsured distribution
ggplot(data, aes(x = uninsured)) + 
  geom_bar(fill = "steelblue") +
  ggtitle("Distribution of Health Insurance Status") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))

#t test 
t_test_result <- t.test(health ~ uninsured, data = data)
t_test_result

#models
model_1 <- lm(health ~ age + sex + marstat + racenew + yedu + log(incmp) + empstat + uninsured, data = data)
model_2 <- lm(health ~ age + sex + marstat + racenew + yedu + incmp + empstat + uninsured, data = data)

stargazer(model_1,model_2,
          type = "text", single.row=TRUE,
          title = "Comparison of OLS Models",
          align = TRUE)

  #Assumptions

#Line
plot(model_1$fitted.values, resid(model_1), 
     xlab = "Fitted Values", ylab = "Residuals", 
     main = "Residuals vs Fitted (Model 1)")
abline(h = 0, col = "red")

plot(model_2$fitted.values, resid(model_2), 
     xlab = "Fitted Values", ylab = "Residuals", 
     main = "Residuals vs Fitted (Model 2)")
abline(h = 0, col = "red")

#Independence
dwtest(model_1)
dwtest(model_2)

#Normality
qqnorm(resid(model_1), main = "Q-Q Plot ( Model1)")
qqline(resid(model_1), col = "red")

qqnorm(resid(model_2), main = "Q-Q Plot ( Model2)")
qqline(resid(model_2), col = "red")

#Homoscedasticity

plot(model_1$fitted.values, resid(model_1)^2, 
     xlab = "Fitted Values", ylab = "Squared Residuals", 
     main = "Homoscedasticity Check (Model1)")
abline(h = 0, col = "red")


plot(model_2$fitted.values, resid(model_2)^2, 
     xlab = "Fitted Values", ylab = "Squared Residuals", 
     main = "Homoscedasticity Check ( Model2)")
abline(h = 0, col = "red")

bptest(model_1) # Breusch-Pagan Test, p>0.05: Homoscedasticity is satisfied.p≤0.05: Evidence of heteroscedasticity.
bptest(model_2)

#Multicollinnearity
vif(model_1) #VIF<5: Multicollinearity is not a concern.VIF≥5: Evidence of multicollinear
vif(model_2)

