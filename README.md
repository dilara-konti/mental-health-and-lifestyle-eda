# Exploratory Data Analysis (EDA): Mental Health & Lifestyle Dataset
## 📌 Executive Summary:
The current repository contains a structured R pipeline for an EDA on the Mental Health and Lifestyle Dataset from [Kaggle](https://www.kaggle.com/datasets/atharvasoundankar/mental-health-and-lifestyle-habits-2019-2024/data) (CC0 Public Domain).

My main objective was to identify any behavioural, lifestyle, or diagnostic predictors of **Stress Levels** across various cohorts (Low, Moderate, High). I began with the question of **Do Stress Levels correlate with high work hours per week? And do people who work long hours report higher levels of stress?**, but diverted to analyse other indicators too along the way.

### 📊 Key Findings (Spoiler: Synthetic Data??? 🤔):
Across all analysed domains, I found that conditional probability distributions remained uniformly flat. For specificity, they fluctuated between ~30-40% across all sub-categories. Below are the categories that I investigated:
* **Work Hours:** Median and above (`>= 39`) work hours showed no variance across Low, Moderate, and High stress groups.
* **Lifestyle & Diet:** Exercise frequency and diet quality (Junk Food vs Healthy/Structured) showed uniform splits across all categories.
* **Clinical Diagnosis:** Mood & Anxiety disorders (Depression, Bipolar Disorder & Anxiety) maintained a constant around ~60% prevalence regardless of stress level, confirming no clinical differentiation.

  * *(P.S. A flat ~60% across all levels is clinically impossible. Perceived stress is a primary trigger for mood & anxiety disorders, and living with these disorders inherently elevates chronic stress. On real-world data, I would expect to see a clear gradient: Low Stress-> Low Clinical Prevalence & High Stress->High Clinical Prevalence.)*

### 💻 Diagnostic Takeaway:
The dataset demonstrated strong characteristics of synthetic noise/having been randomly generated. There is a high probability that a real-world behavioural dataset would not be uniform across all metrics, as human behaviour is complex and messy. Either way, this project served as an excellent exercise in `tidyverse` data wrangling and pipeline construction. Mission accomplished! 😊

## 📍 Repository Structure:
* **MentalHealthLifestyle_DataSet.R:** Clean, fully annotated R pipeline using standard 'tidyverse' and 'here' workflows.
* **README.md:** Clear, detailed documentation and findings summary.

### 🤖 Tech & Packages Used:
* **Language:** R (v4.x)
* **Packages:** `tidyverse` (`dplyr`, `readr`), `here`

## 🚀 How to run the script: 
1. Clone this repository directly into your terminal/command line:

```bash
git clone https://github.com/dilara-konti/mental-health-and-lifestyle-eda.git
```

2. Grab the dataset **`Mental_Health_Lifestyle_Dataset.csv`** from the [Kaggle](https://www.kaggle.com/datasets/atharvasoundankar/mental-health-and-lifestyle-habits-2019-2024/data) link. Place the file in a folder named **`MHL Dataset`** inside the cloned project directory.

3. All set! 😎

    * Open the project and execute `MentalHealthLifestyle_DataSet.R` without issue. 
