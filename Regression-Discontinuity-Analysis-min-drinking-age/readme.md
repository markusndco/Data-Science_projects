# Causal Impact of Minimum Legal Drinking Age on Mortality: A Regression Discontinuity Analysis

This project estimates the causal effect of the Minimum Legal Drinking Age (MLDA) on various categories of youth mortality using a Regression Discontinuity Design (RDD). By exploiting the policy cutoff at age 21, the analysis isolates the impact of legal access to alcohol on deaths caused by external and internal factors, including alcohol-related incidents, motor vehicle accidents, and homicides.

---

## 📌 Objective

To evaluate whether granting legal access to alcohol at age 21 leads to statistically significant increases in mortality rates among young adults, particularly from external causes like accidents and violence.

---

## 📊 Dataset

- **Source**: MLDA Final Exam Dataset  
- **Observations**: Young adults aged 19–22  
- **Variables**:
  - `agecell`: Age (with decimals)
  - `all`, `internal`, `external`, `alcohol`, `homicide`, `suicide`, `mva`, `drugs`, `externalother`: Mortality rates per 100,000 population
  - `*_fitted`: Smoothed mortality rate estimates for trend visualization

---

## 🧪 Methodology

### 1. Data Cleaning
- Removed rows with missing mortality values (~4% of data)
- Converted character columns to numeric
- Created a binary `treatment` variable: `1` if age ≥ 21, `0` otherwise

### 2. Exploratory Data Analysis
- Summarized distribution and variance of mortality categories
- Found that external causes (esp. alcohol and MVA) showed spikes around age 21

### 3. Visualizations
- Generated scatter and smoothed line plots for each mortality type
- Overlaid vertical line at cutoff age (21) to visually assess discontinuities

### 4. Regression Discontinuity Modeling
- Fitted linear models of the form:
- Estimated the treatment effect (`β_treatment`) for each mortality type

---

## ✅ Key Findings

| Category           | Treatment Effect | Significance       | Interpretation                                |
|--------------------|------------------|--------------------|-----------------------------------------------|
| Alcohol            | +6.24            | **Significant**    | 500% increase at age 21                       |
| MVA (Accidents)    | +28.95           | **Significant**    | 34.5% increase in motor vehicle deaths        |
| External Causes    | +82.17           | **Significant**    | Strong jump in risk-driven deaths             |
| Homicide           | +2.41            | **Significant**    | Alcohol may contribute to violent outcomes    |
| Internal Causes    | +1.15            | Not significant    | No effect — confirms non-behavioral origins   |
| Drug-related       | +0.80            | Not significant    | Trends with age, not policy                   |

---

## 🔍 Interpretation

- There is clear **evidence of a causal jump in mortality at age 21**, particularly from alcohol-related and behavior-driven causes.
- **Internal and drug-related deaths** remain stable, reinforcing the specificity of the MLDA's effect on alcohol-accessible behaviors.
- These results support the **public health rationale** behind setting 21 as the legal drinking age in the U.S.

---

## 🛠 Tools Used

- R
- `ggplot2`, `dplyr`, `readxl`, `lm()` for RDD estimation

---

## 👤 Author

Aryan Sharma  
Data Scientist
