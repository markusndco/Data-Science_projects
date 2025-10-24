## 🧭 PeoplesAnalytics – Global Employment Prediction

This project explores employability patterns across **70,000+ global job applicants** using **logistic regression** and **causal analysis** in R.  
It focuses on identifying how **skills, experience, gender, and regional factors** influence hiring outcomes in multinational companies (MNCs).

### 📊 Dataset Information
- **Source:** [70k+ Job Applicants Data (Human Resource) – Kaggle](https://www.kaggle.com/datasets/ayushtankha/70k-job-applicants-data-human-resource/data)  
- **Author:** Ayush Tankha  
- **Records:** 73,462 applicants  
- **Variables:** 15 (Age, Gender, MainBranch, YearsCode, YearsCodePro, PreviousSalary, ComputerSkills, etc.)  

### 🎯 Objectives
- Predict whether an applicant gets employed by a global MNC.  
- Identify which demographic and skill factors most strongly influence employability.  
- Group countries into broader **CountryGroup** regions (North America, Europe, Asia, etc.) to analyze global hiring trends.  
- Evaluate logistic regression performance using AUC, F1-Score, Recall, and Precision.

### 🧠 Modeling Approach
- **Model 1:** Logistic Regression using individual predictors.  
- **Model 2:** Logistic Regression with interaction term (*YearsCodePro × PreviousSalary*).  
- **Data Split:** 75% training / 25% testing.  
- **Evaluation Metrics:** Accuracy, Precision, Recall, F1, and AUC.  

| Metric | Model 1 | Model 2 |
|:--|:--:|:--:|
| Recall | 0.769 | 0.770 |
| Precision | 0.772 | 0.771 |
| F1-Score | 0.770 | 0.771 |
| AUC | 0.785 | 0.785 |

### 🔍 Key Insights
- **Technical Skills** and **Professional Experience** are the top predictors of employment success.  
- **Region:** Applicants from *North America* and *Europe* show higher hiring odds.  
- **Gender:** Women exhibit about 10% lower odds of employment.  
- **Interaction Term:** The YearsCodePro × PreviousSalary effect was negligible.  
- **Model Performance:** AUC ≈ 0.78 and F1 ≈ 0.77 indicate strong predictive capability.  

### 🧮 Predictors Used
| Predictor | Expected Effect | Rationale |
|:--|:--:|:--|
| Gender | +/- | Gender may influence hiring due to industry or regional bias. |
| Employment | + | Prior employment improves selection chances. |
| MentalHealth | - | Mental health factors can affect employability. |
| MainBranch | +/- | Developer vs. non-developer roles vary in demand. |
| YearsCodePro | + | More coding experience increases job likelihood. |
| PreviousSalary | + | Higher past salary suggests stronger expertise. |
| ComputerSkills | + | Better technical skills enhance employability. |
| CountryGroup | +/- | Regional economic differences affect outcomes. |

### 📊 Exploratory Analysis
- Converted character variables into factors for modeling.  
- Created a new **CountryGroup** variable to cluster applicants by region.  
- Performed correlation analysis between `YearsCode`, `YearsCodePro`, and `PreviousSalary`.  
- Visualized global employment distributions with `ggplot2` bar plots and heatmaps.  

### 🧩 Tools & Libraries
- **R Packages:** ggplot2, dplyr, corrplot, caret, ROCR, stargazer, readxl, RColorBrewer  
- **Data Prep:** Excel for initial cleaning and inspection  
- **Visualization:** Correlation heatmaps, ROC curves, bar charts  

### 💡 Summary & Recommendations
The study found that **technical expertise**, **coding experience**, and **region** are the strongest predictors of employment in global MNCs.  
Demographic and psychological factors such as gender and mental health play smaller yet notable roles.  

**Recommendations:**  
- Promote **skill-based hiring** and **regional inclusivity**.  
- Support **training programs** in underrepresented regions.  
- Encourage **gender diversity** and **mental health initiatives** in hiring processes.  

---
