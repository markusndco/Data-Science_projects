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
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Assignment 2/banks-1.xlsx") 
data <- read_excel(file_path, sheet = "banks")
summary(data)
str(data)

data <- data %>%
  mutate(
    day = as.character(day),
    month = as.character(month),
    year = as.character(year),
    Date = as.Date(paste(year, month, day, sep = "-"), format = "%Y-%m-%d")
  )

# new variable to indicator for policy intervention
data <- data %>%
  mutate(after_policy = ifelse((year > 1930) | (year == 1930 & month >= 11), 1, 0))

data_long <- data %>%
  select(Date, after_policy, district6, district8) %>%
  pivot_longer(cols = c(district6, district8),
               names_to = "district",
               values_to = "banks") %>%
  mutate(district = ifelse(district == "district6", 6, 8))

# Descriptive statistics before and after policy intervention
summary_stats <- data_long %>%
  group_by(district, after_policy) %>%
  summarise(
    mean_banks = mean(banks, na.rm = TRUE),
    median_banks = median(banks, na.rm = TRUE),
    sd_banks = sd(banks, na.rm = TRUE),
    min_banks = min(banks, na.rm = TRUE),
    max_banks = max(banks, na.rm = TRUE),
    .groups = "drop"
  )

print(summary_stats)

# Create Line Plot Showing Bank Counts Over Time with Policy Marker
ggplot(data_long, aes(x = Date, y = banks, color = as.factor(district))) +
  geom_line() +
  geom_vline(xintercept = as.Date("1930-11-01"), linetype = "dashed", color = "red") +
  labs(title = "Number of Banks Over Time by District",
       x = "Date",
       y = "Number of Banks",
       color = "District") +
  theme_minimal()

mutate(district = ifelse(district == "district6", 6, 8))

data_long <- data %>%
  select(Date, after_policy, district6, district8) %>%  # Select relevant columns
  pivot_longer(cols = c(district6, district8),
               names_to = "district",
               values_to = "banks") %>%  # 'banks' is the new Y-variable
  mutate(district = ifelse(district == "district6", 6, 8))

#did 
did_model <- lm(banks ~ after_policy * district, data = data_long)
summary(did_model)
