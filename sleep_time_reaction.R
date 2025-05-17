#packages
install.packages("dplyr")
install.packages("tidyverse")
install.packages("infer")
install.packages("ggplot2")

#libraries
library(dplyr)
library(tidyverse)
library(infer)
library(ggplot2)

# imported data from Ishaque et al. 2023
sleep_data <- data.frame(
  hours_slept = c("4-5", "6-7", "7-8", "8-9", "9-10"),
  avg_reaction_time = c(243.65, 232.02, 250.04, 266.51, 215.30),
  sd_reaction_time = c(26.45, 19.38, 18.61, 28.03, 17.65)
)

# The Central Limit Theorem states that the distribution of the sample mean approaches a normal distribution
# I will assume the original sample data was large enough for the CLT to be true
# assuming normality, I will generate samples of raw data for 50 participants

set.seed(1)  

sleep_data_raw <- data.frame(
  hours_slept = rep(c("4-5", "6-7", "7-8", "8-9", "9-10"), each = 50),  
  reaction_time = c(
    rnorm(50, mean = 243.65, sd = 26.45),
    rnorm(50, mean = 232.02, sd = 19.38),
    rnorm(50, mean = 250.04, sd = 18.61),
    rnorm(50, mean = 266.51, sd = 28.03),
    rnorm(50, mean = 215.30, sd = 17.65)
  )
)

#total number of participants in the new generated data 

n <- nrow(sleep_data_raw)

# generate genders( female = 1, male = 0) and ages based on data from the primary study

gender_sampling <- sample(c("female","male"), n, replace = TRUE, prob = c(0.55,0.45))
gender_in_numbers <- sample(c(1,0), n, replace = TRUE, prob = c(0.55,0.45))
age_sampling <- sample(20:25, n, replace = TRUE)

# add to data frame

sleep_data_raw $ gender <- gender_sampling
sleep_data_raw $ age <- age_sampling
sleep_data_raw $ gender_num <- gender_in_numbers

# review head of table 

head(sleep_data_raw)

# plot relations

sleep_data_raw %>%
  ggplot(aes(reaction_time, age, color = gender)) +
  geom_point()

sleep_data_raw %>%
  ggplot(aes(hours_slept, reaction_time, color = gender)) +
  geom_point()

# creating regression models for each
regression_age <- lm(reaction_time ~ age, data = sleep_data_raw)
summary(regression_age)

regression_gender <- lm(reaction_time ~ gender_num, data = sleep_data_raw)
summary(regression_gender)

# age & gender do not affect the reaction time significantly in this sample

#### Is sleep time related to reaction time ?

#creating categorial_reaction_time_rate
mean_rt <- median(sleep_data_raw$reaction_time)


#create two groups

sleep_data_two_groups <- sleep_data_raw %>%
filter(hours_slept %in% c("4-5", "9-10"))%>%
  mutate(reaction_time_categ = ifelse(reaction_time < median_rt, "fast", "slow"))


#finding the observed difference in my generated data 

obs_diff <- sleep_data_two_groups %>%
  group_by(hours_slept)%>%
  summarize(prop_time = mean(reaction_time_categ == "fast")) %>%
  summarize(stat = diff(prop_time)) %>%
  pull()
obs_diff

#creating null hypothesis 

null_dist <- sleep_data_two_groups %>%
  specify(reaction_time_categ ~ hours_slept, success = "fast") %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "diff in props", order = c("4-5", "9-10"))  

#plotting the null hypothesis against the observed difference in data

null_dist %>%
  ggplot(aes(x = stat)) +
  geom_histogram(fill = "blue") +
  geom_vline(xintercept = obs_diff, color = "red")+
  labs(x = "Difference in Means", y = "Frequency")

# calculating p-value
p_value <- null_dist %>%
  filter(stat <= obs_diff) %>% 
  nrow() / nrow(null_dist)

p_value
# it would seem from the graph & the p-value that the observed difference is consistent with the null hypothesis
# measuring quantiles

null_dist %>% 
  summarize(q.05 = quantile(stat, p = 0.05),
  q.95 = quantile(stat, p = 0.95))

# regression model with multiple variations

multiple_regressions <- lm(reaction_time ~ hours_slept + age + gender_num , data = sleep_data_raw)
summary(multiple_regressions)

#hours_slept categories seem to have mixed effects: might indicate false measurements.
#age and gender do not significantly predict reaction time.
#residual sd 21.45 = typical deviation from the predicted values.
