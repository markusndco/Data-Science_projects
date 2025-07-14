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
library(gridExtra)

# Load data
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Final exam/Final Exam Dataset_MLDA.xlsx") 
data <- read_excel(file_path, sheet = "Data")
summary(data)
str(data)

# Create treatment variable: 1 if age >= 21, else 0 and Data Cleaning
df_clean <- data %>%
  filter(!is.na(all) & !is.na(internal) & !is.na(external) &
           !is.na(alcohol) & !is.na(homicide) & !is.na(suicide) &
           !is.na(mva) & !is.na(drugs) & !is.na(externalother))

# Create treatment variable: 1 if age ≥ 21, else 0
df_clean <- df_clean %>%
  mutate(treatment = ifelse(agecell >= 21, 1, 0))


#3. Summary Statistics
str(df_clean)
summary(select(df_clean, all, internal, external, alcohol,
               homicide, suicide, mva, drugs, externalother))

mortality_vars <- c("all", "internal", "external", "alcohol", 
                    "homicide", "suicide", "mva", "drugs", "externalother")

df_clean$all <- as.numeric(df_clean$all)
df_clean$internal <- as.numeric(df_clean$internal)
df_clean$external <- as.numeric(df_clean$external)
df_clean$alcohol <- as.numeric(df_clean$alcohol)
df_clean$homicide <- as.numeric(df_clean$homicide)
df_clean$suicide <- as.numeric(df_clean$suicide)
df_clean$mva <- as.numeric(df_clean$mva)
df_clean$drugs <- as.numeric(df_clean$drugs)
df_clean$externalother <- as.numeric(df_clean$externalother)
str(df_clean)

# Histogram for each mortality category
for (var in mortality_vars) {
  hist(df_clean[[var]], main = paste("Distribution of", var, "mortality rate"),
       xlab = paste(var, "rate"), col = "lightblue", border = "white")
}

#C. Visualisation

plots <- list()
for (var in mortality_vars) {
  p <- ggplot(df_clean, aes(x = agecell, y = .data[[var]])) +
    geom_point(color = "blue") +
    geom_smooth(method = "loess", se = FALSE, color = "darkorange") +
    geom_vline(xintercept = 21, linetype = "dashed", color = "red") +
    labs(title = paste("Mortality Rate by Age:", var),
         x = "Age", y = paste(var, "rate")) +
    theme_minimal()
  
  plots[[var]] <- p
}

#grid layout 3x3
grid.arrange(grobs = plots, ncol = 3, top = "Mortality Rates by Age with MLDA Cutoff at 21")


#D. RDD Model
# Store RD model results
rd_results <- data.frame(
  Category = character(),
  Intercept = numeric(),
  Treatment = numeric(),
  Age = numeric(),
  Interaction = numeric(),
  P_Treatment = numeric(),
  stringsAsFactors = FALSE
)

# Run RD model for each mortality category
for (var in mortality_vars) {
  formula_str <- as.formula(paste(var, "~ treatment + agecell + treatment:agecell"))
  model <- lm(formula_str, data = df_clean)
  summary_model <- summary(model)
  
  rd_results <- rbind(rd_results, data.frame(
    Category = var,
    Intercept = round(summary_model$coefficients[1, 1], 3),
    Treatment = round(summary_model$coefficients[2, 1], 3),
    Age = round(summary_model$coefficients[3, 1], 3),
    Interaction = round(summary_model$coefficients[4, 1], 3),
    P_Treatment = round(summary_model$coefficients[2, 4], 3)
  ))
}
print(rd_results)
