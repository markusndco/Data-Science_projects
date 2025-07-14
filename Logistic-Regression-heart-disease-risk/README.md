# Logistic Regression on Heart Disease Risk

This project explores the relationship between key physiological variables and the likelihood of developing Coronary Heart Disease (CHD) using logistic regression. The analysis includes data cleaning, visualization, statistical modeling, and interpretation of predictors such as age, LDL cholesterol, and systolic blood pressure (SBP).

## Objective

To identify and evaluate significant predictors of CHD using logistic regression, and assess how well individual and combined health indicators explain variations in heart disease risk.

---

## Dataset

- Health-related dataset containing variables such as:
  - `age`
  - `ldl` (Low-Density Lipoprotein cholesterol)
  - `sbp` (Systolic Blood Pressure)
  - `tobacco`, `alcohol`, `obesity`, `typea`, `famhist`
- Binary outcome: Presence or absence of **Coronary Heart Disease (CHD)**

---

## Workflow

### 1. Data Cleaning and Preparation
- Imported and formatted date/measurement variables
- Dropped or excluded irrelevant or noisy predictors

### 2. Exploratory Data Analysis (EDA)
- Identified top predictors (age, LDL, SBP) using summary statistics and visualizations
- Observed high variance in lifestyle variables such as tobacco and alcohol

### 3. Visual Analysis
- Density plots and boxplots showed clear separation in CHD cases based on age, LDL, and SBP
- Confirmed trends supporting inclusion of these variables in predictive modeling

### 4. Statistical Inference Questions
- **Q1:** Does age predict CHD?
- **Q2:** Do LDL and SBP together predict CHD?

### 5. Logistic Regression Models
- **Model 1 (Age Only):**
  - β = 0.064, p < 0.01
  - Interpretation: Each additional year of age increases the odds of CHD by ~6.6%
- **Model 2 (LDL + SBP):**
  - LDL: β = 0.255, SBP: β = 0.017, p < 0.01
  - Interpretation: 1-unit increase in LDL raises CHD odds by ~29%; each mmHg of SBP raises odds by ~1.7%

### 6. Model Evaluation
- McFadden R²:
  - Age model: 0.118
  - LDL + SBP model: 0.072
- **Hosmer-Lemeshow Test** could not be applied due to format/binning issues

---

## Key Insights

- **Age** is the most significant standalone predictor of CHD risk.
- Combining **LDL** and **SBP** also yields strong predictive power, though not as strong as age alone in this dataset.
- Lifestyle variables had high noise and were excluded from final models.

---

## Technologies Used

- R Programming Language
- Libraries: `ggplot2`, `dplyr`, `glm()`, `broom`
- Logistic Regression for binary classification

---

## Author

Aryan Sharma  
Data scientist
