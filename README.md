# ☕ Coffee Acidity Determinants
### A Data Analytics Study Using Sensory Scores, Altitude, and Processing Methods

---

## 📖 Overview

This repository contains a data analytics project that examines the main factors influencing **coffee acidity**, with a focus on **sensory characteristics**, **altitude**, and **coffee processing methods**.

The analysis combines **exploratory data analysis (EDA)** with **regression modeling using heteroskedasticity-robust standard errors**. A **forward selection approach** is used to build regression models in a transparent and interpretable manner.

This project was developed as part of an academic course in **Data Analytics for Economics and Business** and is suitable for instructional, analytical, and portfolio purposes.

---

## 🎯 Objectives & Research Questions

The main objectives of this project are to:

1. Identify which **sensory attributes** are most strongly associated with coffee acidity  
2. Evaluate whether **altitude** affects acidity after controlling for sensory quality  
3. Compare acidity levels across different **coffee processing methods**  
4. Determine the **best-performing regression specification** using forward selection  
5. Assess the robustness and stability of the regression results  

---

## 📊 Data Source

- **Source:** Kaggle  
- **Dataset:** Coffee Quality Dataset (specialty coffee evaluations)  
- **Unit of observation:** Individual coffee samples  

### Key Variables

| Variable | Description |
|--------|------------|
| `Acidity` | Overall acidity score (dependent variable) |
| `Flavor` | Flavor sensory score |
| `Aftertaste` | Aftertaste sensory score |
| `Body` | Body sensory score |
| `Balance` | Balance sensory score |
| `Altitude` | Growing altitude (originally reported as ranges) |
| `Processing` | Coffee processing method |

---

## 🧹 Data Cleaning & Preparation

The following preprocessing steps were applied:

- Selection of relevant variables  
- Conversion of altitude ranges into **numeric midpoints**  
- Removal of missing values and duplicate observations  
- Filtering of unrealistic values:  
  - Acidity outside the \[5, 10\] range  
  - Altitude outside the \[500, 2500\] meter range  
- Log transformation of altitude to reduce skewness  
- Conversion of processing method into a categorical variable  

### Reference Category Choice

- **Reference group:** *Washed / Wet*  
- **Reason:** This category contains the **largest number of observations**, improving estimation stability and interpretability in regression analysis  

---

## 🔍 Exploratory Data Analysis (EDA)

The EDA phase includes:

- Distribution of acidity scores  
- Scatterplots of acidity vs altitude (raw and log-transformed)  
- Relationships between acidity and individual sensory attributes  
- Violin plots comparing acidity distributions across processing methods  

These visualizations provide insight into trends, dispersion, and potential non-linear relationships prior to modeling.

---

## 📈 Methodology

### Modeling Approach

- **Method:** Ordinary Least Squares (OLS)  
- **Standard Errors:** Heteroskedasticity-robust (HC1)  
- **Model Selection:** Forward selection  

### Forward Selection Strategy

1. Begin with a simple specification  
2. Sequentially add explanatory variables  
3. Retain variables that improve explanatory power and statistical significance  

This strategy allows for clear interpretation of each variable’s **incremental contribution** to explaining coffee acidity.

### Model Specifications

1. **Simple Model**  
   - Acidity ~ Flavor  

2. **Sensory Model**  
   - Acidity ~ Flavor + Aftertaste + Body + Balance  

3. **Sensory + Altitude Model**  
   - Adds log-transformed altitude  

4. **Full Model**  
   - Includes sensory attributes, altitude, and processing method  

Models are compared to evaluate improvements in fit and explanatory power.

---

## 🧪 Diagnostics & Validation

To assess model reliability, the following diagnostics are performed:

- Residuals vs fitted values plots  
- Residual distribution analysis  
- Multicollinearity checks using **Variance Inflation Factors (VIF)**  

These diagnostics support the robustness and interpretability of the regression results.

---

## 🧰 Tools & Libraries

- **R**  
- `tidyverse`  
- `estimatr`  
- `modelsummary`  
- `car`  

---

## 📁 Repository Structure

```text
coffee-acidity-determinants/
│
├── data/
│   └── merged_data_cleaned.csv
│
├── scripts/
│   └── 01_acidity_analysis.R
│
├── outputs/
│   ├── figures/
│   └── tables/
│
├── README.md
└── .gitignore


## 👤 Author
**Robel Yohannes Wolie**  
Bachelor’s student in Digital Economics & Business  
Università Politecnica delle Marche




