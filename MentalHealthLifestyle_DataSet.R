# ==============================================================================
# Mental Health and Lifestyle Dataset from Atharva Soundankar on Kaggle 
# License: CC0 Public Domain
# Brief EDA to answer the question of what variable drives Stress Levels (Low->High)
# ANALYTICAL CONCLUSION:
# Systematic EDA across various variables (behavioural, lifestyle, clinical
# domains) failed to reveal a statistically significant link in relation to
# stress levels. Across all subcategories, probability distributions stayed a
# uniform number between 30-40%. 
# Deduction: High probability of synthetic/randomly generated data noise.
# ==============================================================================

#LOAD LIBRARIES
library(tidyverse)
library(here)
#LOAD DATA
MHL<-read_csv(here("MHL Dataset","Mental_Health_Lifestyle_Dataset.csv"))
#CHECK HOW THE DATA LOOKS LIKE
glimpse(MHL)
# NROW=3,000
# COL = 12
# Q. DOES STRESS LEVELS CORRELATE WITH INCREASED WORK HOURS PER WEEK?
# Q. OR // DO PEOPLE WHO WORK LONG HOURS REPORT HIGHER STRESS LEVELS?
# LET'S SAY: HOURS EQUAL TO AND ABOVE 39 PER WEEK SHOULD BE CHECKED FOR (39 = MEDIAN)
# BECAUSE: MEAN WORK HOUR = 39.46633, MEDIAN39 MOST PPL WORK ON AVERAGE 39 HR/WK
# -------------------------------------------------------
# OG DATASET HAD NO SUBJECT ASSIGNMENT. ASSIGN AN IDENTIFIER FIRST.
MHL1<- MHL %>%
  mutate(Person_ID=paste0("PP",row_number())) %>%
  relocate (Person_ID, .before=1)
# CHECK DATASET
glimpse(MHL1)
#SEPARATED TWO NEEDED VARIABLES FROM THE LARGER DATASET (HR/WK AND STRESS LEVEL)
WorkStress <-MHL1 %>%
  select(Person_ID, WorkHours=`Work Hours per Week`, StressLevel=`Stress Level`)
#CHECK DATASET
print(WorkStress)
#ISOLATE ONLY THE ROWS WHERE WORK HR/WK IS EQUAL TO OR EXCEEDS 39
High<- WorkStress %>%
  filter(WorkHours>=39)
# -----------------------------------------------------
#GET A SUMMARY STATISTICS TABLE TO CHECK FOR ANY OBVIOUS CORRELATION/LINK
HSum <- High %>%
  group_by(StressLevel) %>%
  summarize(
    count=n(),
    mean_work=mean(WorkHours, na.rm=TRUE),
    median_work=median(WorkHours, na.rm=TRUE),
    sd_work=sd(WorkHours, na.rm=TRUE)
  ) %>%
  mutate(StressLevel=factor(StressLevel, levels=c("Low","Moderate","High"))) %>%
  arrange (StressLevel) # RE-ARRANGE THE LEVELS SO IT GOES LOW->MODERATE->HIGH
#INITIAL EDA SHOWED VIRTUALLY NO CORRELATION BETWEEN HIGH WORK HOURS AND HIGH
#STRESS. BASED ON THE MEDIAN, THE LOW GROUP WORKED 50 HOURS ON AVG, MODERATE
#GROUP 49 AND HIGH GROUP ALSO 49. THIS INDICATED WORK HOURS ARE NOT WHAT CORRELATES
#WITH HIGH STRESS.
# -----------------------------------------------------------------
# WHAT IS CORRELATED WITH STRESS THEN?
#AGGREGATE OTHER POSSIBLE RELEVANT VARIABLES.
Correlations<- MHL1 %>%
  group_by(`Stress Level`) %>%
  summarize(
    sleep=mean(`Sleep Hours`,na.rm=TRUE),
    social_int=mean(`Social Interaction Score`,na.rm=TRUE),
    happiness=mean(`Happiness Score`,na.rm=TRUE),
    screen_time=mean(`Screen Time per Day (Hours)`,na.rm=TRUE)
  )
#RE-ARRANGE THE LEVELS
Correlations1<- Correlations %>%
  mutate(`Stress Level`=factor(`Stress Level`,levels=c("Low","Moderate","High"))) %>%
  arrange(`Stress Level`)
#ALL VALUES ARE VERY CLOSE TOGETHER, INDICATING VIRTUALLY ZERO RELEVANT CORRELATION
#THEN I'LL TRY THE CHARACTER/TEXT VALUES INDIVIDUALLY TO SEE, STARTING FROM EXERCISE
ExerciseText<- MHL1 %>%
  group_by(`Stress Level`,`Exercise Level`) %>% #JUST TAKE EXERCISE LEVEL
  summarize(total=n(),.groups="drop_last") %>% #COUNT THE ROWS IN EACH GROUP WITH N() & REMOVE LAST GROUPING LAYER TO KEEP OUTPUT CLEAN
  mutate(percentage=(total/sum(total))*100) #A NEW COLUMN WITH THE *100 PERCENTAGES CALCULATED FOR EASE OF UNDERSTANDING
print(ExerciseText)
#-------------------------------------
# JUST HIGH EXERCISE LEVEL
# ISOLATE ONLY HIGH EXERCISE ACROSS ALL STRESS LEVELS
HighEx<- MHL1 %>%
  group_by(`Stress Level`) %>%
  summarize(
    high_ex=mean(`Exercise Level`=="High", na.rm=TRUE)*100 #PERCENTAGE
  ) %>%
  mutate(`Stress Level`=factor(`Stress Level`,levels=c("Low","Moderate","High"))) %>%
  arrange(`Stress Level`)
print (HighEx)
#VIRTUALLY NO EFFECT.
#DIET_TYPE NEXT
Diet_Simplified <- MHL1 %>%
  mutate(Diet_Quality = case_when(
    `Diet Type` %in% c("Balanced", "Vegan", "Vegetarian", "Keto") ~ "Healthy/Structured",
    `Diet Type` == "Junk Food" ~ "Junk Food"
  )) %>%
  group_by(`Stress Level`) %>%
  summarize(
    pct_junk_food = mean(Diet_Quality == "Junk Food", na.rm = TRUE) * 100
  ) %>%
  mutate(`Stress Level`=factor(`Stress Level`,levels=c("Low","Moderate","High"))) %>%
  arrange(`Stress Level`)
print (Diet_Simplified)
#ALSO LITTLE TO NO LINK
#LASTLY TO CHECK MENTAL HEALTH CONDITION
Mood_Disorders<- MHL1 %>%
  group_by(`Stress Level`) %>%
  summarize(
    mood_disorders=mean(`Mental Health Condition` %in% c("Depression","Anxiety"),na.rm=TRUE)*100 #USE OF %IN% TO ONLY CHECK FOR DEPRESSION AND ANXIETY WITHIN THE LARGER SET
  ) %>%
  mutate(`Stress Level`=factor(`Stress Level`,levels=c("Low","Moderate","High"))) %>%
  arrange(`Stress Level`)
print(Mood_Disorders)
#NO STATISTICALLY SIGNIFICANT LINK
#HIGH PROBABILITY THAT THE DATA IS A SYNTHETIC DATASET