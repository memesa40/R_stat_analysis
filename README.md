## This small project explores the relationship between sleep duration and reaction time using simulated data based on statistics from *Ishaque et al. 2023* 

## In this analysis I have tried to:

1- simulate raw reaction time data for different sleep duration categories, randomly generate gender and age based on statistical data from the study\
2- explore the effect of age and gender on reaction time\
3- test if sleep duration is related to reaction time using permutation tests and regression models\
4- visualize data distributions and hypothesis testing results\

## keep in mind that:

1- data is simulated assuming normality and sample size large enough for Central Limit Theorem to apply\
2- reaction time is modeled based on average and standard deviation values reported in the source study\
3- gender (female/male) and age (20-25 years) are randomly generated based on percentages reported in the study\
4- permutation test used to evaluate the difference in reaction time in proportions between short (4-5 hours) and long (9-10 hours) sleep groups\
5- regression models evaluate the impact of sleep duration, age, and gender on reaction time\

## main findings:

1- age and gender do not significantly affect reaction time in this sample\
2- sleep duration categories show mixed effects on reaction time. *may be due to testing errors*\
3- the permutation test suggests the null hypothesis cannot be confidently rejected based on the simulated data\

## Requirements

- **R version:** 4.0.0 or higher  
- **Required R packages:**  
  dplyr\
  tidyverse\
  infer\
  ggplot2\
