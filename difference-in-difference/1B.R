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
library(broom)


# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Assignment 1/healthcare_spending_policy.xlsx") 
data <- read_excel(file_path)
summary(data)
str(data)

df_annual <- data %>% 
  group_by(Year, State) %>% 
  summarise(Healthcare_Spending = mean(Healthcare_Spending, na.rm = TRUE), .groups = 'drop')

#parallel
ggplot(df_annual %>% filter(Year < 2015), aes(x = Year, y = Healthcare_Spending, color = State)) +
  geom_line() + geom_point() +
  geom_vline(xintercept = 2015, linetype = "dashed", color = "red") +
  ggtitle("Parallel Trends Check (2010-2014)") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))

# Estimate Pre-2015 Trends (Regression Analysis)
california_trend <- lm(Healthcare_Spending ~ Year, data = df_annual %>% filter(State == "California" & Year < 2015))
nevada_trend <- lm(Healthcare_Spending ~ Year, data = df_annual %>% filter(State == "Nevada" & Year < 2015))

print(tidy(california_trend))
print(tidy(nevada_trend))

# Difference-in-Differences Model
df_annual <- df_annual %>% 
  mutate(Treatment = ifelse(State == "California", 1, 0),
         Post = ifelse(Year >= 2015, 1, 0),
         DiD = Treatment * Post)

did_model <- lm(Healthcare_Spending ~ Treatment + Post + DiD, data = df_annual)
print(summary(did_model))
