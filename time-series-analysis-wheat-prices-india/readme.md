# Forecasting Wheat Prices in India with MSP Influence (2012–2024)

This project analyzes the relationship between government-announced Minimum Support Prices (MSP) and actual market prices of wheat in India over a 12-year period. Using time-series forecasting models and statistical diagnostics, it evaluates whether MSP provides effective price support for farmers—especially in the context of ongoing policy debates and farmer protests.

---

## 🔍 Objective

To assess the effectiveness of MSP as a price floor and to forecast future wheat prices by:
- Modeling market price behavior using time-based trends and autoregressive patterns.
- Comparing actual market prices with MSP.
- Evaluating model accuracy and performance.
- Providing evidence for or against a legally guaranteed MSP.

---

## 📊 Dataset Overview

| Variable      | Description                                 |
|---------------|---------------------------------------------|
| Sales         | Monthly average market price per quintal    |
| MSP           | Minimum Support Price (INR/quintal)         |
| Duration      | April 2012 – 2024 (monthly)                 |
| Qtr           | Calendar quarter (Q1–Q4)                    |
| Wheat Atta    | Parallel retail price metric (not modeled)  |

---

## 📈 Methodology & Models

### Time-Series Models Tested:
1. **Linear Trend Model**
2. **Trend + Quarterly Seasonality**
3. **Trend + Seasonality + Lag 1 (Best model)**
4. **Trend + Seasonality + Lags 1–3**

### Forecast Model: **ARIMA(2,1,0)(1,0,0)[12] with drift**

### Diagnostics Used:
- Durbin-Watson test
- RMSE (Root Mean Squared Error)
- ACF/PACF plots for lag structure
- Model comparison based on out-of-sample forecasting accuracy

---

## ✅ Key Results

- **Model 3** showed the best balance of accuracy and simplicity:
  - Adjusted R² = 0.835
  - RMSE (Test) = 109.33
- **ARIMA** offered robust short-term forecasting with:
  - RMSE = 23.47 (Train), MAPE = 1.12%
  - Very low autocorrelation in residuals

---

## 💡 Insights & Conclusions

- MSP behaves as a **policy-driven staircase function** while market prices fluctuate with trends and seasonality.
- Autoregressive models significantly improve predictive accuracy.
- The gap between MSP and market price often narrows, indicating **MSP may act as a price floor**, but not consistently.
- Results support the need for a **data-driven review of MSP effectiveness** in real-world markets.

---

## 🛠 Tools Used

- R (Time series modeling, ARIMA, diagnostics)
- `forecast`, `ggplot2`, `tseries`, `dplyr` packages

---

## 📌 Author

**Aryan Sharma**  
Data Scientist

---

## 📂 Files Included

- `Wheat_Price_Analysis_Final_Report.pdf`
- `Project_proposal.pdf`
- Time-series scripts (R)
- Forecast plots and model comparisons

---

## 📘 Citation

If using this analysis in policy briefs or academic work, please cite:

> Aryan Sharma (2024). *Forecasting Wheat Price in India with MSP Influence*. University of South Florida.
