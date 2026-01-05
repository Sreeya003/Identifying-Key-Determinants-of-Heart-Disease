🩺 **_Identifying Key Determinants of Heart Disease_**

📊**Project Overview**
This repository hosts a SAS-based clinical analytics pipeline designed to uncover the physiological drivers behind heart disease. Using the UCI Heart Disease dataset, this project bridges the gap between raw medical data and actionable clinical insights through rigorous statistical validation.

The pipeline achieves high diagnostic accuracy, specifically isolating high-signal predictors like thalassemia and vessel blockage.
___________________________________________________________________________________________________________________________________________
🚀**Key Features & Methodology**
🛠️ Data Engineering & EDA
    Cleaning: Processed and encoded mixed-type variables for seamless modeling.
    Analysis: Performed deep Exploratory Data Analysis (EDA) to validate distributions and ensure modeling readiness.

🧪 Inferential Screening
   To eliminate noise and focus on "true" predictors, I conducted:
   t-tests & ANOVA: For continuous physiological metrics (age, cholesterol, etc.).
   Chi-Square Tests: To find significant associations between categorical risks.
   Signal Capture: Only statistically significant variables were moved to the modeling phase.

🤖 Predictive Modeling
   Model: Stepwise Logistic Regression.
   Performance: 📈 ROC-AUC: 0.9365
🎯 Sensitivity: 87%
Clinical Insight: Isolated thalassemia and major vessel blockage as the most critical risk factors.
____________________________________________________________________________________________________________________
🛠️**Technical Stack**
-> Language: SAS (Base SAS, SAS/STAT)
-> Dataset: UCI Machine Learning Repository
-> Statistical Methods: Inferential Tests, Stepwise Selection, Logistic Regression

📂**Repository Structure**
scripts/: SAS programs for cleaning, testing, and modeling.
data/: Processed dataset (or link to UCI source).
output/: Statistical reports and ROC curve visualizations.
______________________________________________________________________________________________________________________
🏁**How to Run**
📥 Load the heart.csv into your SAS Environment.
⚙️ Run the preprocessing script to clean and encode variables.
🔬 Execute the inferential testing script to view p-values.
🏆 Run the logistic regression script to generate the final model and AUC metrics.
