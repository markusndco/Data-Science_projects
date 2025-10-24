PeoplesAnalytics: Global Employment Prediction Using Logistic Regression

This project explores employability trends across over 70,000 global job applicants using logistic regression and causal modeling.
The analysis examines how technical skills, experience, education, and regional factors influence the probability of an applicant being hired by multinational companies (MNCs).
By leveraging data-driven insights, the project aims to understand which human and technical attributes most strongly impact hiring outcomes and to identify areas for improving workforce inclusivity.

📊 Dataset Source
Dataset: 70k+ Job Applicants Data (Human Resource)

Author: Ayush Tankha (Kaggle)
Records: 73,462 observations | Variables: 15

🎯 Objectives

Predict whether a job applicant will be employed by an MNC using logistic regression.

Identify which demographic, skill, and experience-based factors drive employability.

Explore regional hiring disparities by grouping countries into broader CountryGroup categories (North America, Europe, Asia, etc.).

Evaluate model performance using accuracy, recall, precision, F1-score, and AUC metrics.

🧠 Modeling Approach

Model 1: Logistic Regression with individual predictors

Model 2: Logistic Regression with interaction term (YearsCodePro × PreviousSalary)

Variables included: Gender, Employment, MentalHealth, MainBranch, YearsCodePro, PreviousSalary, ComputerSkills, and CountryGroup

Data split: 75% training | 25% testing

📈 Model Evaluation Metrics

Metric	Model 1	Model 2
Recall	0.769	0.770
Precision	0.772	0.771
F1 Score	0.770	0.771
AUC	0.785	0.785
🔍 Key Insights

Technical Skills & Experience: Applicants with higher coding experience and computer skills have the greatest odds of employment.

Regional Differences: Candidates from North America and Europe show 25–50% higher odds compared to other regions.

Gender Impact: Women exhibit slightly lower odds (≈10%) of employment, suggesting room for inclusivity improvements.

Model Performance: Both models perform strongly with AUC ≈ 0.78, indicating good predictive power.

Interaction Term: The YearsCodePro × PreviousSalary effect was statistically insignificant, suggesting independent contributions of experience and pay history.

🧮 Predictors Used
Predictor	Effect	Rationale
Gender	+/-	Gender may influence hiring due to industry bias.
Employment	+	Prior employment improves selection chances.
MentalHealth	-	Mental stress may reduce employability.
MainBranch	+/-	Developer vs. Non-developer roles differ in demand.
YearsCodePro	+	More professional coding experience increases odds.
PreviousSalary	+	Higher past salary implies greater skill level.
ComputerSkills	+	Strong computer proficiency boosts employability.
CountryGroup	+/-	Regional variations affect access to MNCs.
📊 Exploratory Analysis

Converted character variables (Gender, Employment, MentalHealth) into categorical factors.

Created CountryGroup column to cluster applicants by region.

Conducted correlation analysis on YearsCode, YearsCodePro, and PreviousSalary using vibrant visualizations.

Visualized global employment patterns by CountryGroup using ggplot2.

🧩 Tools & Libraries

R: ggplot2, dplyr, corrplot, caret, ROCR, stargazer, readxl, RColorBrewer
Excel: Data preprocessing and inspection
Visualization: Correlation heatmaps, bar charts, ROC curves

💡 Summary & Recommendations

The analysis reveals that employability in global MNCs is most influenced by technical ability, professional experience, and regional access.
Gender and mental health factors have moderate effects but are still notable in predicting outcomes.
It is recommended that organizations:

Prioritize skills-based hiring over demographic traits.

Invest in training programs for regions with lower employability rates.

Encourage gender inclusivity and mental health support initiatives to improve workforce diversity.

👤 Author

Aryan Sharma
People Analytics | Causal Modeling | Logistic Regression | R Programming

📘 License
This project is intended for academic and portfolio use. Attribution is appreciated if reused or referenced.
