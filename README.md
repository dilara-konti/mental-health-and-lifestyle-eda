# Exploratory analysis: stress, lifestyle and clinical variables

An R analysis of the [Mental Health and Lifestyle Dataset](https://www.kaggle.com/datasets/atharvasoundankar/mental-health-and-lifestyle-habits-2019-2024/data) (Kaggle, CC0; 3,000 rows, 12 variables). The question was whether work, lifestyle or clinical variables differ by self-reported stress level (Low, Moderate, High). It started as a check on whether long work hours go with higher stress, and widened to other variables when that showed nothing.

## Summary of findings

- None of the variables differed meaningfully by stress level (ten tests; none significant after Holm correction).
- Effect sizes are negligible. For example, exercise level vs stress has Cramér's V = 0.03.
- With 3,000 observations, these tests have enough power to detect small associations, so the result is "no meaningful relationship in this dataset", not just "not detected".
- Several features are consistent with synthetic (generated) data. See below. This is a hypothesis, not a proven fact.

## Results

| Comparison | Test | Statistic | p | Effect size |
|---|---|---|---|---|
| Work hours by stress | Kruskal-Wallis | H(2) = 2.53 | .283 | ε² < .001 |
| Sleep hours by stress | Kruskal-Wallis | H(2) = 0.93 | .629 | ε² < .001 |
| Social interaction by stress | Kruskal-Wallis | H(2) = 1.33 | .515 | ε² < .001 |
| Happiness by stress | Kruskal-Wallis | H(2) = 0.84 | .657 | ε² < .001 |
| Screen time by stress | Kruskal-Wallis | H(2) = 1.81 | .405 | ε² < .001 |
| Exercise level by stress | Chi-squared | χ²(4) = 5.26 | .262 | V = 0.03 |
| Junk-food diet by stress | Chi-squared | χ²(2) = 1.36 | .507 | V = 0.02 |
| Mood/anxiety diagnosis by stress | Chi-squared | χ²(2) = 1.43 | .490 | V = 0.02 |
| Sanity check: sleep vs happiness | Pearson | r = .017 | .341 | |
| Sanity check: social interaction vs happiness | Pearson | r = -.040 | .028 | |

Full output, including Holm-adjusted p-values and all effect sizes, is written to `output/test_results.csv` when the script runs.

One correlation (social interaction vs happiness, r = -.04, p = .028) is nominally significant. I don't treat it as a finding: it is tiny (about 0.16% of variance), it points in the opposite direction to what you would expect, and it does not survive correction for ten tests (Holm-adjusted p = .275).

## Is the dataset synthetic?

The pattern below is consistent with generated data, though none of it proves it:

- Variables that should be related are not. Sleep and happiness correlate at r = .017, and nothing predicts stress.
- Categorical variables are consistent with equal frequencies (diet, p = .21; mental health condition, p = .38). The flat ~60% "mood or anxiety diagnosis" rate across stress levels follows from this: three of five roughly equal categories give 60%.
- The three stress levels are almost exactly equal in size (1,008 Low, 990 Moderate, 1,002 High).
- Age is roughly uniform from 18 to 64, while sleep is approximately normal.

A balanced real sample could look similar on the categorical variables, so I describe this as "consistent with synthetic data".

## Figures

Created in `figures/`: weekly work hours by stress level, exercise level within each stress level, and the age and sleep distributions.

## Limitations

- Stress level is a three-category self-report, so subtle relationships with continuous variables may be lost.
- The analysis is cross-sectional and exploratory. No causal claims are made.
- The data source is unverified, so the results describe this file and may not generalise.

## Repository contents

- `MentalHealthLifestyle_DataSet.R`: the full analysis script
- `output/test_results.csv`: results of all tests (created on run)
- `figures/`: plots (created on run)

## How to run

1. Clone the repository: `git clone https://github.com/dilara-konti/mental-health-and-lifestyle-eda.git`
2. Download `Mental_Health_Lifestyle_Dataset.csv` from the Kaggle link above and put it in a folder named `MHL Dataset` in the project root.
3. Open the project in RStudio and run `MentalHealthLifestyle_DataSet.R`.

* Requires R 4.x with the `tidyverse` and `here` packages.

2. Grab the dataset **`Mental_Health_Lifestyle_Dataset.csv`** from the [Kaggle](https://www.kaggle.com/datasets/atharvasoundankar/mental-health-and-lifestyle-habits-2019-2024/data) link. Place the file in a folder named **`MHL Dataset`** inside the cloned project directory.

3. All set! 😎

    * Open the project and execute `MentalHealthLifestyle_DataSet.R` without issue. 
