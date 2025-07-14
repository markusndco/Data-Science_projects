# Causal Analysis of Police Interventions in Domestic Violence: An Instrumental Variable Approach

This project uses the Minneapolis Domestic Violence Experiment (MDVE) dataset to evaluate the causal impact of different police interventions—such as arrest, separation, and advice—on the likelihood of repeat domestic violence incidents. The analysis is grounded in causal inference theory and applies the Two-Stage Least Squares (2SLS) regression method using an instrumental variable framework.

---

## 📌 Objective

To determine whether randomized police interventions reduce the likelihood of repeat domestic violence incidents, and to estimate the causal impact of intervention types on reporting behavior.

---

## 🧾 Dataset

**Source**: MDVE (Minneapolis Domestic Violence Experiment)  
**Variables of Interest**:
- `T_RANDOM`: Random assignment of police response (Instrument)
- `T_FINAL`: Final police action taken (Treatment)
- `P_REPORT`: Whether the incident was reported (Outcome)
- Demographics: Victim/Suspect race, chemical use, weapons, relationship type, incident reason

---

## 🧪 Methodology

### 1. Data Preparation
- Loaded the dataset in R and cleaned variables
- Addressed missing values and removed irrelevant features
- Conducted exploratory correlation analysis and plotted distributions

### 2. Instrument Selection
- Chose `T_RANDOM` as the **instrumental variable** for `T_FINAL`
- Justification: `T_RANDOM` is exogenous and influences police response but not the outcome (reporting) directly

### 3. Descriptive Analysis
- Frequency tables and cross-tabs for repeat incidents (`T_FINAL`)
- Race-based comparisons across suspect/victim categories
- Time series plot of incident frequency by intervention group

### 4. Two-Stage Least Squares (2SLS) Regression
Used the `ivreg()` function to perform IV regression:

```r
model_2sls <- ivreg(
  P_REPORT ~ T_FINAL + V_RACE + S_RACE + V_CHEM + S_CHEM +
  S_DMNOR1 + S_DMNOR2 + WEAPON + GUNS + REASON1 + REASON2 +
  REASON3 + REASON4 + R_RELATE |
  T_RANDOM + V_RACE + S_RACE + V_CHEM + S_CHEM + S_DMNOR1 +
  S_DMNOR2 + WEAPON + GUNS + REASON1 + REASON2 + REASON3 +
  REASON4 + R_RELATE,
  data = data
)

Aryan Sharma
