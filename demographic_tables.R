library(tidyverse)
library(janitor)
library(DT)

# data from VDOE Fall Membership Build-a-Table
# https://p1pe.doe.virginia.gov/apex_captcha/home.do?apexTypeId=304
# Query parameters: 2023_fall_membership_race.csv
#   school years = 2019-2020, 2020-2021, 2021-2022, 2022-2023 
#   report level = school
#   divisions = charlottesville, albemarle
#   schools = all schools
#   race = [all individual races, but didn't include non-hispanic or unknown]
#   grades = all grades (aggregated, not individual grades)
#   [everything else] = all students
#   
# Query parameters: 2023_fall_membership_disadvantaged.csv
#   school years = 2019-2020, 2020-2021, 2021-2022, 2022-2023 
#   report level = school
#   divisions = charlottesville, albemarle
#   schools = all schools
#   race = all races (aggregated, not individual categories)
#   grades = all grades (aggregated, not individual grades)
#   disadvantaged = yes, no
#   [everything else] = all students

# read data ----
race_ethn <- read_csv("2023_fall_membership_race.csv") %>% 
  clean_names()
disadvant <- read_csv("2023_fall_membership_disadvantaged.csv") %>% 
  clean_names()
  
# what schools
race_ethn %>% filter(school_year == "2019-2020") %>% 
  distinct(school_name)
disadvant %>% filter(school_year == "2019-2020") %>% 
  distinct(school_name)

race_ethn %>% filter(school_year == "2020-2021") %>% 
  distinct(school_name)
disadvant %>% filter(school_year == "2020-2021") %>% 
  distinct(school_name)
# Albemarle County community public charter gone

race_ethn %>% filter(school_year == "2021-2022") %>% 
  distinct(school_name)
disadvant %>% filter(school_year == "2021-2022") %>% 
    distinct(school_name)
# sutherland becomes lakeside; 
# community lab school added, murray subtracted (community lab is formerly murray)

race_ethn %>% filter(school_year == "2022-2023") %>% 
    distinct(school_name)
disadvant %>% filter(school_year == "2022-2023") %>% 
    distinct(school_name)

# jack jouett becomes journey


# tables ----
# separately by year

# fall 2022

race2023 <- race_ethn %>% filter(school_year == "2022-2023") %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades)) %>% 
  rename(count = total_count) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = race, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

colnames(race2023)

names(race2023) <- c("year", "division", "school", "students",
                     "count_asian", "count_black",
                     "count_latinx", "count_white",
                     "count_aian", "count_nhpi", "perc_asian", 
                     "perc_black", "perc_latinx",
                     "perc_white", "perc_aian", "perc_nhpi" )

dis2023 <- disadvant %>% filter(school_year == "2022-2023") %>% 
  mutate(count = if_else(total_count == "<", "9", total_count), # based on total students in race2022
         count = str_remove(count, ","),
         count = as.integer(count)) %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades, total_count)) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = disadvantaged, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

colnames(dis2023)
names(dis2023) <- c("year", "division", "school", "students", 
                    "count_adv", "count_disadv", "perc_adv", "perc_disadv")


# fall 2021

race2022 <- race_ethn %>% filter(school_year == "2021-2022") %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades)) %>% 
  rename(count = total_count) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = race, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

colnames(race2022)

names(race2022) <- c("year", "division", "school", "students",
                     "count_asian", "count_black",
                     "count_latinx", "count_white",
                     "count_aian", "count_nhpi", "perc_asian", 
                     "perc_black", "perc_latinx",
                     "perc_white", "perc_aian", "perc_nhpi" )

dis2022 <- disadvant %>% filter(school_year == "2021-2022") %>% 
  mutate(count = if_else(total_count == "<", "9", total_count), # based on total students in race2022
         count = str_remove(count, ","),
         count = as.integer(count)) %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades, total_count)) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = disadvantaged, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

colnames(dis2022)
names(dis2022) <- c("year", "division", "school", "students", 
                    "count_adv", "count_disadv", "perc_adv", "perc_disadv")

#fall 2020
race2021 <- race_ethn %>% filter(school_year == "2020-2021") %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades)) %>% 
  rename(count = total_count) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = race, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

colnames(race2021)
names(race2021) <- c("year", "division", "school", "students", "count_asian", "count_black",
                     "count_latinx", "count_nhpi", "count_white", "count_aian",
                      "perc_asian", "perc_black", "perc_latinx", "perc_nhpi",
                     "perc_white", "perc_aian")

dis2021 <- disadvant %>% filter(school_year == "2020-2021") %>% 
  mutate(count = str_remove(total_count, ","),
         count = as.integer(count)) %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades, total_count)) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = disadvantaged, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0))) 

colnames(dis2021)
names(dis2021) <- c("year", "division", "school", "students", 
                    "count_adv", "count_disadv", "perc_adv", "perc_disadv")

# fall 2019 
race2020 <- race_ethn %>% filter(school_year == "2019-2020") %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades)) %>% 
  rename(count = total_count) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = race, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0)))

colnames(race2020)
names(race2020) <- c("year", "division", "school", "students",
                    "count_asian", "count_black",
                    "count_latinx", "count_nhpi", "count_white",
                    "count_aian", "perc_asian", "perc_black", 
                    "perc_latinx", "perc_nhpi",
                     "perc_white", "perc_aian")

dis2020 <- disadvant %>% filter(school_year == "2019-2020") %>% 
  mutate(count = str_remove(total_count, ","),
         count = as.integer(count)) %>% 
  select(-c(division_number, school_number, full_time_count_all_grades, part_time_count_all_grades, total_count)) %>% 
  group_by(school_name) %>% 
  mutate(num_students = sum(count, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(percent = (count/num_students)*100,
         percent = round(percent, 1)) %>% 
  pivot_wider(names_from = disadvantaged, values_from = c(count, percent)) %>% 
  mutate(across(where(is.numeric), ~replace(., is.na(.), 0))) 

colnames(dis2020)
names(dis2020) <- c("year", "division", "school", "students", 
                    "count_adv", "count_disadv", "perc_adv", "perc_disadv")

# combine tables and save
students2023 <- left_join(race2023, dis2023, by = c("year", "division", "school")) %>% select(-"students.y", students = "students.x")
students2022 <- left_join(race2022, dis2022, by = c("year", "division", "school")) %>% select(-"students.y", students = "students.x")
students2021 <- left_join(race2021, dis2021, by = c("year", "division", "school")) %>% select(-"students.y", students = "students.x")
students2020 <- left_join(race2020, dis2020, by = c("year", "division", "school")) %>% select(-"students.y", students = "students.x")

save(students2023, students2020, students2021, students2022, file = "newstudents.Rdata")


# # Colors
install.packages('ghibli')
library(ghibli)
library(scales)
# show_col(ghibli_palettes$TotoroLight)
# show_col(ghibli_palettes$KikiLight)
# show_col(ghibli_palettes$SpiritedLight)
# show_col(ghibli_palettes$MononokeLight)
# show_col(ghibli_palettes$PonyoLight)