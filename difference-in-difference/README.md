# Difference-in-Differences Analysis on Healthcare Policy and Health Outcomes

This project investigates the effect of health insurance status on self-reported health outcomes and evaluates the impact of a 2015 healthcare policy in California using the Difference-in-Differences (DiD) method.

## Project Overview

The analysis is divided into two main parts:

### Part 1: Health Insurance and Health Status (NHIS 2009)

Using the 2009 National Health Interview Survey (NHIS), we perform:
- Exploratory Data Analysis (EDA)
- T-tests between insured and uninsured groups
- Linear regression modeling with transformed variables
- Residual analysis to test classical assumptions
- Interpretation of regression results to assess the impact of insurance on self-reported health

**Key Tools**:  
- R (`lm`, `corrplot`, `ggplot2`)  
- Data: `NHIS_2009.xlsx`

**Conclusion**:  
Insurance status alone is not a strong predictor of health. Income, education, and employment status have more significant effects. The analysis is observational and not sufficient to claim causality.

---

### Part 2: Policy Evaluation via Difference-in-Differences

California implemented a healthcare cost reduction policy in 2015. We use annual per capita spending data from California and Nevada (control state) to estimate the policy's impact.

**Steps:**
- Verify parallel trends assumption
- Apply DiD modeling using interaction terms
- Interpret the causal effect of the policy

**Key Tools**:  
- R (`dplyr`, `lm`, `ggplot2`)  
- Data: `healthcare_spending_policy.xlsx`

**Conclusion**:  
The DiD estimate suggests that the policy reduced healthcare spending in California by approximately \$817.92 per capita. However, since Nevada did not follow a parallel trend pre-policy, the causal inference should be interpreted with caution.

---

## Files Included

- `1A.R`, `1B.R`: R scripts used for regression and DiD modeling
- `NHIS_2009.xlsx`: National Health Interview Survey data
- `healthcare_spending_policy.xlsx`: State-wise healthcare spending data
- `Difference_in_Difference_Solution.pdf`: Complete write-up and output
- `Problem Statement.pdf`: Assignment problem description
- `placeholder.txt`: Temporary file for GitHub folder creation

---

## Author

Aryan Sharma  
Data Scientist
