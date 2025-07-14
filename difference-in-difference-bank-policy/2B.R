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
file_path <- ("C:/Users/91884/Desktop/BAIS/Advance data science/Assignment 2/groupon.xlsx") 
data <- read_excel(file_path, sheet = "groupon")
summary(data)
str(data)

# Visualisation distribution treatment and control 


# Histogram for Revenue by Treatment
ggplot(data, aes(x = revenue, fill = treatment)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
  facet_wrap(~ treatment, scales = "free_y") +
  labs(title = "Distribution of Revenue by Treatment Group",
       x = "Revenue", y = "Count") +
  theme_minimal()

# Histogram for Facebook Likes by Treatment
ggplot(data, aes(x = fb_likes, fill = treatment)) +
  geom_histogram(bins = 30, alpha = 0.7, position = "identity") +
  facet_wrap(~ treatment, scales = "free_y") +
  labs(title = "Distribution of Facebook Likes by Treatment Group",
       x = "Facebook Likes", y = "Count") +
  theme_minimal()

# Boxplot for Revenue by Treatment
ggplot(data, aes(x = treatment, y = revenue, fill = treatment)) +
  geom_boxplot() +
  labs(title = "Boxplot of Revenue by Treatment Group",
       x = "Treatment", y = "Revenue") +
  theme_minimal()

# Boxplot for Facebook Likes by Treatment
ggplot(data, aes(x = treatment, y = fb_likes, fill = treatment)) +
  geom_boxplot() +
  labs(title = "Boxplot of Facebook Likes by Treatment Group",
       x = "Treatment", y = "Facebook Likes") +
  theme_minimal()

# Density Plot for Revenue by Treatment
ggplot(data, aes(x = revenue, color = treatment, fill = treatment)) +
  geom_density(alpha = 0.4) +
  labs(title = "Density Plot of Revenue by Treatment Group",
       x = "Revenue", y = "Density") +
  theme_minimal()

# Density Plot for Facebook Likes by Treatment
ggplot(data, aes(x = fb_likes, color = treatment, fill = treatment)) +
  geom_density(alpha = 0.4) +
  labs(title = "Density Plot of Facebook Likes by Treatment Group",
       x = "Facebook Likes", y = "Density") +
  theme_minimal()

#regression Model
propensity_model1 <- glm(treatment ~ prom_length + price + discount_pct + 
                          coupon_duration + featured + limited_supply + 
                          fb_likes + quantity_sold,
                        family = binomial(link = "logit"), data = data)
propensity_model2 <- glm(treatment ~ prom_length + min_req + price + discount_pct + 
                           coupon_duration + featured + limited_supply + 
                           fb_likes + quantity_sold,
                         family = binomial(link = "logit"), data = data)

stargazer(propensity_model1,propensity_model2,
          type = "text", single.row=TRUE,
          title = "Comparison of Models",
          align = TRUE)

data$propensity_score <- predict(propensity_model, type = "response")
head(data)

#t test
t_test_revenue <- t.test(revenue ~ treatment, data = data)
t_test_fb_likes <- t.test(fb_likes ~ treatment, data = data)

# Print results
cat("Two-Sample t-test Results for Revenue:\n")
print(t_test_revenue)

cat("\n\nTwo-Sample t-test Results for Facebook Likes:\n")
print(t_test_fb_likes)

# Generate propensity scores from both models
data$propensity_score1 <- predict(propensity_model1, type = "response")
data$propensity_score2 <- predict(propensity_model2, type = "response")

# Explore the distribution of propensity scores
ggplot(data, aes(x = propensity_score1, fill = as.factor(treatment))) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribution of Propensity Scores (Model 1)",
       x = "Propensity Score", fill = "Treatment Group")

ggplot(data, aes(x = propensity_score2, fill = as.factor(treatment))) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribution of Propensity Scores (Model 2)",
       x = "Propensity Score", fill = "Treatment Group")

# Compare propensity scores from both models
ggplot(data, aes(x = propensity_score1, y = propensity_score2, color = as.factor(treatment))) +
  geom_point(alpha = 0.5) +
  labs(title = "Comparison of Propensity Scores (Model 1 vs Model 2)",
       x = "Propensity Score - Model 1", y = "Propensity Score - Model 2")

# Generate a stargazer summary for both models
stargazer(propensity_model1, propensity_model2,
          title = "Logistic Regression Results for Propensity Score Calculation",
          type = "text", out = "propensity_models_summary.txt")
