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
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Assignment 3/chicago_crime-1.xlsx") 
data <- read_excel(file_path, sheet = "data")
summary(data)
str(data)

#asfactor
data$arrest = factor(data$arrest)

# Create new column 'date2' with Month-Year format
data$date2 <- format(data$date, "%b %Y")

#data Arrest
data_arrested <- subset(data, arrest == TRUE)
data$arrest <- as.logical(data$arrest)


#3. Descriptive Analysis
top_crimes <- sort(table(data$primary_type), decreasing = TRUE)[1:5]
barplot(top_crimes, main = "Top 5 Crime Types", col = "steelblue", ylim = c(0, 12000))
mean(data$arrest, na.rm = TRUE)

#4. Line Plot Over Time with Cutoff (Monthly Crime Counts)
data$date2 <- as.Date(paste0("01 ", data$date2), format = "%d %b %Y")
monthly_crime <- data %>%
  group_by(date2) %>%
  summarise(total_crimes = n())

ggplot(monthly_crime, aes(x = date2, y = total_crimes)) +
  geom_line(color = "darkred") +
  geom_vline(xintercept = as.Date("2020-03-21"), linetype = "dashed", color = "blue") +
  labs(title = "Crime Trend Over Time",
       x = "Month-Year", y = "Number of Crimes") +
  theme_minimal()

#5. Compare Pre/Post Cutoff
cutoff_date <- as.Date("2020-03-21")
pre_covid <- monthly_crime %>% filter(date2 < cutoff_date)
post_covid <- monthly_crime %>% filter(date2 >= cutoff_date)

cat("Mean crime incidents before COVID:", mean(pre_covid$total_crimes), "\n")
cat("Mean crime incidents after COVID:", mean(post_covid$total_crimes), "\n")

# 6. Top 5 Crime Types vs OTHERS, Pre/Post-COVID
top5_types <- names(top_crimes)
data$crime_group <- ifelse(data$primary_type %in% top5_types, data$primary_type, "OTHERS")
data$period <- ifelse(data$date2 < cutoff_date, "Before", "After")

crime_distribution <- data %>%
  group_by(period, crime_group) %>%
  summarise(count = n()) %>%
  group_by(period) %>%
  mutate(percent = round(100 * count / sum(count), 1))

# Plot Distribution
ggplot(crime_distribution, aes(x = crime_group, y = percent, fill = period)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Top 5 Crime Types vs Others: Before vs After COVID",
       x = "Crime Type", y = "Percentage of Crimes") +
  theme_minimal()

#7. Choose Dependent Variable for RDD (Example: BATTERY Arrests)
data$dv_battery <- ifelse(data$primary_type == "BATTERY" & data$arrest == TRUE, 1, 0)

#8. Create Running Variable (Months from Cutoff) and Treatment Indicator
months_diff <- function(d1, d2) {
  12 * (as.numeric(format(d1, "%Y")) - as.numeric(format(d2, "%Y"))) +
    (as.numeric(format(d1, "%m")) - as.numeric(format(d2, "%m")))
}

data$running_var <- months_diff(data$date2, cutoff_date)
data$treatment <- ifelse(data$running_var >= 0, 1, 0)

#9. Apply RDD Model
rdd_data <- data[!is.na(data$dv_battery), ]

rdd_result <- rdrobust(y = rdd_data$dv_battery, x = rdd_data$running_var, c = 0)
summary(rdd_result)

#Optional: Visualize Discontinuity
ggplot(rdd_data, aes(x = running_var, y = dv_battery)) +
  geom_point(alpha = 0.3, position = position_jitter(width = 0.3, height = 0.05)) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "RDD: Effect of COVID Cutoff (March 21, 2020) on Battery Arrests",
       x = "Months from Cutoff", y = "Battery Arrest (1 = Yes)")


