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
library(knitr)
library(AER)

# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Mid Term/mdve.xlsx") 
data <- read_excel(file_path, sheet = "mdve")
summary(data)
str(data)

#correlation
correlation_matrix <- cor(data[c("T_RANDOM", "ID", "P_REPORT", "V_RACE", "T_FINAL")])
corrplot(correlation_matrix, method = "pie")
print(correlation_matrix)

#asfactor
data$T_RANDOM = factor(data$T_RANDOM)
data$P_REPORT = factor(data$P_REPORT)
data$V_RACE = factor(data$V_RACE)
data$S_RACE = factor(data$S_RACE)
data$V_CHEM = factor(data$V_CHEM)
data$S_CHEM = factor(data$S_CHEM)
data$S_DMNOR1 = factor(data$S_DMNOR1)
data$S_DMNOR2 = factor(data$S_DMNOR2)
data$S_GUNS = factor(data$GUNS)
data$REASON1 = factor(data$REASON1)
data$R_RELATE = factor(data$R_RELATE)

#concatenate month and year
data$MONTH_YEAR <- paste(data$MONTH, data$YEAR, sep = "-")

str(data)


#Part 3 - race based analysis 

table(data$T_FINAL)
table(data$P_REPORT)

# If T_FINAL looks like it reflects repeated offenses (e.g., >1, or coded as yes/no)
repeat_summary <- data %>%
  group_by(T_RANDOM, T_FINAL) %>%
  summarise(count = n()) %>%
  mutate(percentage = round(100 * count / sum(count), 1))

print(repeat_summary)

# Cross-tabs with race
repeat_vrace <- table(data$V_RACE, data$T_FINAL)
print(repeat_vrace)

repeat_srace <- table(data$S_RACE, data$T_FINAL)
print(repeat_srace)

#Part 4 - No. of incident over time line chart

data$MONTH_YEAR_FIXED <- paste(data$YEAR, data$MONTH, "01", sep = "-")
data$MONTH_YEAR_DATE <- as.Date(data$MONTH_YEAR_FIXED, format = "%Y-%m-%d")
incident_trend <- data %>%
  group_by(MONTH_YEAR_DATE, T_RANDOM) %>%
  summarise(incident_count = n())

# Plot line chart
ggplot(incident_trend, aes(x = MONTH_YEAR_DATE, y = incident_count, color = T_RANDOM, group = T_RANDOM)) +
  geom_line(size = 1) +
  geom_point() +
  labs(
    title = "Number of Incidents Over Time by Intervention Type",
    x = "Month-Year",
    y = "Number of Incidents",
    color = "Intervention Group"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Part 5

# Run 2SLS using ivreg

data$P_REPORT <- as.numeric(as.character(data$P_REPORT))

model_2sls <- ivreg(P_REPORT ~ T_FINAL  + V_RACE + S_RACE + 
                      V_CHEM + S_CHEM + S_DMNOR1 + S_DMNOR2 + WEAPON + GUNS + 
                      REASON1 + REASON2 + REASON3 + REASON4 + R_RELATE |
                      T_RANDOM  + V_RACE + S_RACE + 
                      V_CHEM + S_CHEM + S_DMNOR1 + S_DMNOR2 + WEAPON + GUNS + 
                      REASON1 + REASON2 + REASON3 + REASON4 + R_RELATE,
                    data = data)

summary(model_2sls)
