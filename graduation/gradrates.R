# Explore graduation data
# on-time and diploma
# 2019-2021 only available years (as of 3/1/2023)

## VDOE Download Data from School Quality Profiles

### query parameters for "diplomas.csv"
# Reporting Level: "Division"
# Divisions: select each division
# Data Type: "college and career readiness" 
# Indicators: "diplomas and completion"
# School Year: "all years available"

### query parameters for "gradrate.csv"
# Reporting Level: "Division"
# Divisions: select each division
# Data Type: "college and career readiness" 
# Indicators: "on-time graduation rate"
# School Year: "all years available"


library(tidyverse)
library(janitor)
library(plotly)
library(kableExtra)

district_cohort <- read_csv("va-district-graduation/cohort_statistics.csv") %>% 
  clean_names()

# cohort ontime
## state-wide
state_grad <- district_cohort %>% 
  select(cohort_year, students_in_cohort, total_graduates) %>% 
  mutate(students_in_cohort = str_remove(students_in_cohort, ","),
         total_graduates = str_remove(total_graduates, ","),
         students_in_cohort = as.numeric(students_in_cohort),
         total_graduates = as.numeric(total_graduates)) %>% 
  group_by(cohort_year) %>% 
  summarize(total_graduates = sum(total_graduates, na.rm = TRUE),
            students_in_cohort = sum(students_in_cohort, na.rm = TRUE),
            division_name = "Virginia") %>% 
  mutate(grad_rate = round((total_graduates/students_in_cohort)* 100, 1)) 

## divisions
district_grad <- district_cohort %>% 
  select(cohort_year, division_name, students_in_cohort, total_graduates) %>% 
  mutate(students_in_cohort = str_remove(students_in_cohort, ","),
         total_graduates = str_remove(total_graduates, ","),
         students_in_cohort = as.numeric(students_in_cohort),
         total_graduates = as.numeric(total_graduates),
         grad_rate = round((total_graduates/students_in_cohort)*100,1)) 

target_div <- district_grad %>% filter(division_name == "Albemarle County") # choose target
target_div2 <- district_grad %>% filter(division_name == "Charlottesville City") # choose target

## graph
p_grad <- ggplot(district_grad, aes(x = cohort_year, 
                          y = grad_rate, 
                          group = division_name,
                          label = students_in_cohort)) +
  geom_line(color = "grey80") +
  geom_line(data = state_grad, aes(y = grad_rate), color = "black") +
  geom_line(data = target_div2, aes(y = grad_rate), color = "orange") +
  geom_line(data = target_div, aes(y = grad_rate), color = "firebrick") +
  scale_x_continuous(breaks = seq(2008, 2022, 2)) +
  labs(y = "On-Time Graduation Rate", x = "Year",
       caption = "Source: VDOE Cohort Graduation Build-A-Table\n (https://p1pe.doe.virginia.gov/buildatable/cohortgraduation)") +
  theme_minimal()

ggplotly(p_grad, tooltip = c("group", "x", "y", "label")) 

district_grad_all <- district_cohort %>% 
  select(cohort_year, division_name, students_in_cohort, total_graduates,
         dropouts, still_enrolled) %>% 
  mutate(students_in_cohort = str_remove(students_in_cohort, ","),
         total_graduates = str_remove(total_graduates, ","),
         dropouts = str_remove(dropouts, ","),
         still_enrolled = str_remove(still_enrolled, ","),
         students_in_cohort = as.numeric(students_in_cohort),
         total_graduates = as.numeric(total_graduates),
         dropouts = as.numeric(dropouts),
         still_enrolled = as.numeric(still_enrolled),
         grad_rate = round((total_graduates/students_in_cohort)*100,1)) 

district_grad_all %>% 
  filter(division_name == "Albemarle County") %>% 
  kbl() %>% 
  kable_material(c("striped", "hover"))

# advanced degree
## state-wide
state_adv <- district_cohort %>% 
  select(cohort_year, students_in_cohort, advanced_studies) %>% 
  mutate(students_in_cohort = str_remove(students_in_cohort, ","),
         advanced_studies = str_remove(advanced_studies, ","),
         students_in_cohort = as.numeric(students_in_cohort),
         advanced_studies = as.numeric(advanced_studies)) %>% 
  group_by(cohort_year) %>% 
  summarize(advanced_studies = sum(advanced_studies, na.rm = TRUE),
            students_in_cohort = sum(students_in_cohort, na.rm = TRUE),
            division_name = "Virginia") %>% 
  mutate(adv_rate = round((advanced_studies/students_in_cohort)* 100, 1)) 

## divisions
district_adv <- district_cohort %>% 
  select(cohort_year, division_name, students_in_cohort, advanced_studies) %>% 
  mutate(students_in_cohort = str_remove(students_in_cohort, ","),
         advanced_studies = str_remove(advanced_studies, ","),
         students_in_cohort = as.numeric(students_in_cohort),
         advanced_studies = as.numeric(advanced_studies),
         adv_rate = round((advanced_studies/students_in_cohort)*100,1)) 

target_div <- district_adv %>% filter(division_name == "Albemarle County") # choose target
target_div2 <- district_adv %>% filter(division_name == "Charlottesville City") # choose target

## graph
p_adv <- ggplot(district_adv, aes(x = cohort_year, 
                                    y = adv_rate, 
                                    group = division_name,
                                    label = students_in_cohort)) +
  geom_line(color = "grey80") +
  geom_line(data = state_adv, aes(y = adv_rate), color = "black") +
  geom_line(data = target_div2, aes(y = adv_rate), color = "orange") +
  geom_line(data = target_div, aes(y = adv_rate), color = "firebrick") +
  scale_x_continuous(breaks = seq(2008, 2022, 2)) +
  labs(y = "Advanced Studies Degree Rate", x = "Year",
       caption = "Source: VDOE Cohort Graduation Build-A-Table\n (https://p1pe.doe.virginia.gov/buildatable/cohortgraduation)") +
  theme_minimal()

ggplotly(p_adv, tooltip = c("group", "x", "y", "label")) 
