# ==============================================================================
# Exploratory analysis: Mental Health and Lifestyle Dataset (Kaggle, CC0)
# Question: Do work, lifestyle or clinical variables differ by stress level?
# Run from the project root (open the .Rproj or use here::here()).
# Expected data file: MHL Dataset/Mental_Health_Lifestyle_Dataset.csv
# Outputs: output/test_results.csv and figures/*.png
# ==============================================================================

library(tidyverse)
library(here)

dir.create(here("figures"), showWarnings = FALSE)
dir.create(here("output"), showWarnings = FALSE)

# ------------------------------------------------------------------------------
# 1. Load and prepare data
# ------------------------------------------------------------------------------
# Set the ordering of the categorical variables once, so every table and plot
# uses Low -> Moderate -> High.
mhl <- read_csv(here("MHL Dataset", "Mental_Health_Lifestyle_Dataset.csv"),
                show_col_types = FALSE) %>%
  rename(
    country                 = Country,
    age                     = Age,
    gender                  = Gender,
    exercise_level          = `Exercise Level`,
    diet_type               = `Diet Type`,
    sleep_hours             = `Sleep Hours`,
    stress_level            = `Stress Level`,
    mental_health_condition = `Mental Health Condition`,
    work_hours              = `Work Hours per Week`,
    screen_time             = `Screen Time per Day (Hours)`,
    social_interaction      = `Social Interaction Score`,
    happiness               = `Happiness Score`
  ) %>%
  mutate(
    person_id      = paste0("PP", row_number()),  # the raw file has no ID column
    stress_level   = factor(stress_level, levels = c("Low", "Moderate", "High")),
    exercise_level = factor(exercise_level, levels = c("Low", "Moderate", "High")),
    # Binary flags used in the tests. Mood group = Depression, Anxiety, Bipolar
    # (PTSD and None are the other two of the five categories).
    junk_food      = diet_type == "Junk Food",
    mood_disorder  = mental_health_condition %in% c("Depression", "Anxiety", "Bipolar")
  ) %>%
  relocate(person_id)

# ------------------------------------------------------------------------------
# 2. Data checks
# ------------------------------------------------------------------------------
glimpse(mhl)
colSums(is.na(mhl))                       # missing values per column
count(mhl, stress_level)
count(mhl, diet_type)                     # confirms the junk-food flag covers all diets
count(mhl, mental_health_condition)

# ------------------------------------------------------------------------------
# 3. Tests of association with stress level
# ------------------------------------------------------------------------------
# Kruskal-Wallis for numeric variables (no normality assumption), with
# epsilon-squared as the effect size.
kruskal_row <- function(data, outcome, label) {
  kt <- kruskal.test(data[[outcome]] ~ data$stress_level)
  n  <- sum(!is.na(data[[outcome]]))
  tibble(comparison = label, test = "Kruskal-Wallis",
         statistic = unname(kt$statistic), df = unname(kt$parameter),
         p_value = kt$p.value,
         effect_size = unname(kt$statistic) / (n - 1), effect_type = "epsilon-squared")
}

# Chi-squared for categorical variables, with Cramer's V as the effect size.
chisq_row <- function(data, predictor, label) {
  tab <- table(data$stress_level, data[[predictor]])
  ct  <- chisq.test(tab)
  tibble(comparison = label, test = "Chi-squared",
         statistic = unname(ct$statistic), df = unname(ct$parameter),
         p_value = ct$p.value,
         effect_size = sqrt(unname(ct$statistic) / (sum(tab) * (min(dim(tab)) - 1))),
         effect_type = "Cramer's V")
}

# Pearson correlation, used for two sanity checks on variables that should be
# related in real data.
cor_row <- function(data, x, y, label) {
  ct <- cor.test(data[[x]], data[[y]])
  tibble(comparison = label, test = "Pearson correlation",
         statistic = unname(ct$statistic), df = unname(ct$parameter),
         p_value = ct$p.value,
         effect_size = unname(ct$estimate), effect_type = "r")
}

test_results <- bind_rows(
  kruskal_row(mhl, "work_hours",         "Work hours by stress level"),
  kruskal_row(mhl, "sleep_hours",        "Sleep hours by stress level"),
  kruskal_row(mhl, "social_interaction", "Social interaction by stress level"),
  kruskal_row(mhl, "happiness",          "Happiness by stress level"),
  kruskal_row(mhl, "screen_time",        "Screen time by stress level"),
  chisq_row(mhl, "exercise_level",       "Exercise level by stress level"),
  chisq_row(mhl, "junk_food",            "Junk-food diet by stress level"),
  chisq_row(mhl, "mood_disorder",        "Mood/anxiety diagnosis by stress level"),
  cor_row(mhl, "sleep_hours", "happiness",
          "Sanity check: sleep vs happiness"),
  cor_row(mhl, "social_interaction", "happiness",
          "Sanity check: social interaction vs happiness")
) %>%
  # Ten tests were run, so adjust p-values for multiple testing (Holm method).
  mutate(p_holm = p.adjust(p_value, method = "holm"))

print(test_results, width = Inf)
write_csv(test_results, here("output", "test_results.csv"))

# ------------------------------------------------------------------------------
# 4. Is the data consistent with synthetic generation?
# ------------------------------------------------------------------------------
# Equal-frequency tests for the categorical variables. A non-significant result
# means the categories are consistent with equal frequencies; it cannot prove
# the data were generated, since a balanced real sample would look the same.
chisq.test(table(mhl$diet_type))
chisq.test(table(mhl$mental_health_condition))

# ------------------------------------------------------------------------------
# 5. Figures
# ------------------------------------------------------------------------------
theme_set(theme_minimal(base_size = 12))

p_work <- ggplot(mhl, aes(stress_level, work_hours)) +
  geom_boxplot(fill = "grey85") +
  labs(title = "Weekly work hours by stress level",
       x = "Stress level", y = "Work hours per week")

p_exercise <- mhl %>%
  count(stress_level, exercise_level) %>%
  group_by(stress_level) %>%
  mutate(share = n / sum(n)) %>%
  ggplot(aes(stress_level, share, fill = exercise_level)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Exercise level within each stress level",
       x = "Stress level", y = "Share of group", fill = "Exercise level")

p_age <- ggplot(mhl, aes(age)) +
  geom_histogram(binwidth = 1, boundary = 0, fill = "grey60", colour = "white") +
  labs(title = "Age distribution", x = "Age (years)", y = "Count")

p_sleep <- ggplot(mhl, aes(sleep_hours)) +
  geom_histogram(binwidth = 0.5, fill = "grey60", colour = "white") +
  labs(title = "Sleep hours distribution", x = "Sleep hours", y = "Count")

ggsave(here("figures", "work_hours_by_stress.png"), p_work,     width = 6, height = 4, dpi = 300, bg = "white")
ggsave(here("figures", "exercise_by_stress.png"),   p_exercise, width = 6, height = 4, dpi = 300, bg = "white")
ggsave(here("figures", "age_distribution.png"),     p_age,      width = 6, height = 4, dpi = 300, bg = "white")
ggsave(here("figures", "sleep_distribution.png"),   p_sleep,    width = 6, height = 4, dpi = 300, bg = "white")
