# Regression Discontinuity Analysis of Crime Trends in Chicago During COVID-19

This project explores the impact of the COVID-19 pandemic on crime incidents in Chicago, with a focus on both descriptive trends and causal inference using Regression Discontinuity Design (RDD).

## Objective

To determine whether the COVID-19 lockdown policy implemented on **March 21, 2020** led to a statistically significant change in crime rates in Chicago.

---

## Dataset

- **Source:** `chicago_crime-1.xlsx`
- **Observations:** Crime incidents with variables like `primary_type`, `arrest`, and timestamps
- **Period Covered:** January 2019 to mid-2021

---

## Key Steps

### 1. Data Cleaning and Preprocessing
- Converted date fields to proper `Date` format.
- Aggregated data by month for analysis.
- Classified crime types into top 5 and "OTHERS".

### 2. Exploratory Data Analysis
- Identified **Top 5 crime categories**: Theft, Battery, Assault, Criminal Damage, Deceptive Practice.
- Calculated the arrest rate (~18.8%).
- Visualized crime trends over time using a line graph with a COVID cutoff reference.

### 3. Crime Trend Analysis
- Crime incidents declined significantly after March 21, 2020.
  - **Before COVID:** Mean monthly crimes = 2220
  - **After COVID:** Mean = 1855.56
- Theft was an exception with a relative increase post-COVID.

### 4. Regression Discontinuity Design (RDD)
- **Dependent Variable (DV):** Monthly crime totals / Battery arrests.
- **Running Variable:** Time (months from cutoff)
- **Cutoff:** March 21, 2020

#### RDD Findings:
- No statistically significant discontinuity observed at the cutoff.
- Small, positive coefficient, but wide confidence intervals suggest no causal effect of COVID on crime.

---

## Conclusion

While descriptive analysis shows a drop in crime after the COVID-19 lockdown, RDD analysis does not support a strong causal relationship. This suggests that the observed change may reflect general time trends or unmeasured confounders rather than direct effects of policy.

---

## Tools Used

- R
- ggplot2
- dplyr
- rdrobust

---

## Author

Aryan Sharma  
Data Scientist
