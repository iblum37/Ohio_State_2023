library(tidyverse)
library(stringr)
library(readxl)
# Downloading all the savant data
SavantPitchingData22Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData22Reg.csv")
SavantPitchingData21Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData21Reg.csv")
SavantPitchingData19Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData19Reg.csv")
SavantPitchingData18Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData18Reg.csv")
SavantPitchingData17Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData17Reg.csv")
SavantPitchingData16Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData16Reg.csv")
SavantPitchingData15Reg <- read_csv("Baseball Stuff/Savant Pitching Data/SavantPitchingData15Reg.csv")
spin_direction_pitches_2022 <- read_csv("Baseball Stuff/Active Spin/spin-direction-pitches - 2022.csv")
spin_direction_pitches_2021 <- read_csv("Baseball Stuff/Active Spin/spin-direction-pitches - 2021.csv")
active_spin_2019 <- read_csv("Baseball Stuff/Active Spin/active-spin - 2019.csv")
active_spin_2018 <- read_csv("Baseball Stuff/Active Spin/active-spin - 2018.csv")
active_spin_2017 <- read_csv("Baseball Stuff/Active Spin/active-spin - 2017.csv")
# Player Registry
reg <- read_excel("Baseball Stuff/SFBB-Player-ID-Map (1).xlsx") %>%
  select(PLAYERNAME, MLBID)
colnames(reg)[1:2] <- c("name", "pitcher")

# Combining the data into one dataset
# Arranging the data for ease of finding pitch before and pitch after
count_order <- bind_rows(SavantPitchingData15Reg, SavantPitchingData16Reg, SavantPitchingData17Reg, SavantPitchingData18Reg, 
                         SavantPitchingData19Reg, SavantPitchingData21Reg, SavantPitchingData22Reg) %>%
  arrange(game_date, at_bat_number, pitcher, pitch_number)


# CSW%, Chase%, delta run expectancy (want it negative), delta home win expectancy

partner_pitch <- count_order %>%
  mutate(csw = ifelse(description %in% c("called_strike", "swinging_strike", "swinging_strike_blocked"), 1, 0)) %>%
  mutate(chase = ifelse(zone >= 11 & description %in% c("foul", "foul_tip", "hit_into_play", "swinging_strike", "swinging_strike_blocked"), 1, 0)) %>%
  mutate(run_exp = delta_run_exp) %>%
  mutate(year = substr(game_date, 1, 4)) %>%
  # cleanup for NA values that mess that future calculations
  filter(!is.na(release_extension))


# Used to find percentage of times a pitch is thrown
tot_pitches <- partner_pitch %>%
  group_by(player_name, year, pitcher) %>%
  summarize(num_pitches = n())

# Create summary statistics for each pitcher, pitch, and year
pitch_stats <- partner_pitch %>%
  group_by(player_name, pitch_type, year, pitcher) %>%
  summarize(count = n(), Velocity = mean(release_speed, na.rm = TRUE), H_Release_Pos = mean(release_pos_x, na.rm = TRUE), 
            V_Release_Pos_z = mean(release_pos_z, na.rm = TRUE), H_Break = mean(pfx_x, na.rm = TRUE), 
            V_Break = mean(pfx_z, na.rm = TRUE), VAA = mean(-atan((vz0 + (az * (((-sqrt(vy0^2 - (2 * ay * (50 - (17/12))))) - vy0) / ay)))/(-sqrt(vy0^2 - (2 * ay * (50 - (17/12)))))) * (180 / pi)),
            Spin_Rate = mean(release_spin_rate, na.rm = TRUE), Ext = mean(release_extension, na.rm = TRUE), Eff_Velocity = mean(effective_speed, na.rm = TRUE), 
            chase = mean(chase, na.rm = TRUE), csw = mean(csw, na.rm = TRUE)) %>%
  # Arbitrary pitch floor of 100
  filter(count >= 100) %>%
  left_join(tot_pitches, by = c("player_name", "year", "pitcher")) %>%
  # Filtering out NA's from data
  filter(!is.na(V_Break) & !is.na(VAA))

# Attaining the spin direction data for 2017-2019
spin_2017 <- active_spin_2017 %>%
  unite(name, first_name, last_name, sep = " ") %>%
  select(-c(2,7)) %>%
  mutate(year = '2017')
colnames(spin_2017)[2:7] <- c("FF", "SI", "FC", "CH", "SL", "CU")
new_spin_2017 <- gather(spin_2017, key = "pitch_type", value = "active_spin", 2:7)

spin_2018 <- active_spin_2018 %>%
  unite(name, first_name, last_name, sep = " ") %>%
  select(-c(2,7)) %>%
  mutate(year = '2018')
colnames(spin_2018)[2:7] <- c("FF", "SI", "FC", "CH", "SL", "CU")
new_spin_2018 <- gather(spin_2018, key = "pitch_type", value = "active_spin", 2:7)

spin_2019 <- active_spin_2019 %>%
  unite(name, first_name, last_name, sep = " ") %>%
  select(-c(2,7)) %>%
  mutate(year = '2019')
colnames(spin_2019)[2:7] <- c("FF", "SI", "FC", "CH", "SL", "CU")
new_spin_2019 <- gather(spin_2019, key = "pitch_type", value = "active_spin", 2:7)

# Combining data into one dataframe
spin_2017_9 <- bind_rows(new_spin_2017, new_spin_2018, new_spin_2019) %>%
  # Have to match ids to player registry data because dataframe is messed up
  left_join(reg, by = "name") %>%
  separate(name, c("first", "last"), sep = " ") %>%
  unite('player_name', last, first, sep = ", ")

# Attaining the spin direction data for 2021/2022
spin_2022 <- spin_direction_pitches_2022 %>%
  mutate(year = '2022') %>%
  select(c(1, 4, 6, 12:14))
colnames(spin_2022)[2] <- "pitcher"
colnames(spin_2022)[3] <- "pitch_type"

spin_2021 <- spin_direction_pitches_2021 %>%
  mutate(year = '2021') %>%
  select(c(1, 4, 6, 12:14))
colnames(spin_2021)[2] <- "pitcher"
colnames(spin_2021)[3] <- "pitch_type"

# Combining data into one dataframe
spin_2021_2 <- bind_rows(spin_2021, spin_2022)

pitch_stats <- pitch_stats %>%
  # KC are listed as CU in the active spin data
  mutate(pitch_type = ifelse(pitch_type == "KC" & player_name != "Darvish, Yu", "CU", pitch_type)) %>%
  left_join(spin_2021_2, by = c("pitcher", "pitch_type", "year")) %>%
  left_join(select(spin_2017_9, -(player_name)), by = c("pitcher", "pitch_type", "year")) %>%
  left_join(select(spin_2017_9, -(pitcher)), by = c("player_name", "pitch_type", "year")) %>%
  # Combine the two different active spin data into one col
  mutate(active_spin = coalesce(active_spin.x, (active_spin.y / 100), (active_spin / 100))) %>%
  select(-c("active_spin.x", "active_spin.y"))
            
# Establishing ranges for the different pitches for more accurate comparisons
pitch_stats_FF <- filter(pitch_stats, pitch_type == 'FF')
pitch_stats_FC <- filter(pitch_stats, pitch_type == 'FC')
pitch_stats_CH <- filter(pitch_stats, pitch_type == 'CH')
pitch_stats_CU <- filter(pitch_stats, pitch_type == 'CU')
pitch_stats_SI <- filter(pitch_stats, pitch_type == 'SI')
pitch_stats_SL <- filter(pitch_stats, pitch_type == 'SL')
pitch_stats_OT <- filter(pitch_stats, pitch_type != 'FF' & pitch_type != 'FC' & pitch_type != 'CH' &
                                      pitch_type != 'CU' & pitch_type != 'SI' & pitch_type != 'SL')

# Creating ranges for each of the features
for(x in c(6:13, 18:20)){
  pitch_stats_FF[paste(names(pitch_stats_FF[x]), "_range", sep = "")] = diff(range(pitch_stats_FF[x], na.rm = TRUE))
  pitch_stats_FC[paste(names(pitch_stats_FC[x]), "_range", sep = "")] = diff(range(pitch_stats_FC[x], na.rm = TRUE))
  pitch_stats_CH[paste(names(pitch_stats_CH[x]), "_range", sep = "")] = diff(range(pitch_stats_CH[x], na.rm = TRUE))
  pitch_stats_CU[paste(names(pitch_stats_CU[x]), "_range", sep = "")] = diff(range(pitch_stats_CU[x], na.rm = TRUE))
  pitch_stats_SI[paste(names(pitch_stats_SI[x]), "_range", sep = "")] = diff(range(pitch_stats_SI[x], na.rm = TRUE))
  pitch_stats_SL[paste(names(pitch_stats_SL[x]), "_range", sep = "")] = diff(range(pitch_stats_SL[x], na.rm = TRUE))
  pitch_stats_OT[paste(names(pitch_stats_OT[x]), "_range", sep = "")] = diff(range(pitch_stats_OT[x], na.rm = TRUE))
}

# New dataframe that is same as old one except with ranges for each individual pitch
new_pitch_stats <- bind_rows(pitch_stats_FF, pitch_stats_FC, pitch_stats_CH, pitch_stats_CU,
                         pitch_stats_SI, pitch_stats_SL, pitch_stats_OT)

# Data frames that will contain indices and quantile differences of 5 closest pitches
diff_all = data.frame(player = new_pitch_stats$pitcher, pitch_type = new_pitch_stats$pitch_type, year = new_pitch_stats$year,
                  first = 0, second = 0, third = 0, fourth = 0, fifth = 0, first_perc = 0, second_perc = 0, third_perc = 0, fourth_perc = 0, fifth_perc = 0)

diff_2022 = data.frame(player = new_pitch_stats$pitcher, pitch_type = new_pitch_stats$pitch_type, year = new_pitch_stats$year,
                       first = 0, second = 0, third = 0, fourth = 0, fifth = 0, first_perc = 0, second_perc = 0, third_perc = 0, fourth_perc = 0, fifth_perc = 0)

# 10 minute for loop
for (i in 1:nrow(new_pitch_stats)){
  # cur_player_id = what row i refers to
  cur_player_id = as.numeric(new_pitch_stats[i,4])
  # temp = row i's ranges minus all other rows ranges for the first 8 features
  temp <- (abs(rep(new_pitch_stats[i,c(6:13, 20)]) - new_pitch_stats[1:nrow(new_pitch_stats), c(6:13, 20)])) / new_pitch_stats[1:nrow(new_pitch_stats), c(21:28, 31)]
  temp <- mutate(temp, index = 1:nrow(temp))
  # temp2 = row i's ranges minus all other rows ranges for the clock features
  temp2 <- abs(rep(new_pitch_stats[i, 18:19]) - new_pitch_stats[1:nrow(new_pitch_stats), 18:19])
  temp2 <- mutate(temp2, hawkeye_measured = ifelse(hawkeye_measured > 180, 360 - hawkeye_measured, hawkeye_measured))
  temp2 <- mutate(temp2, movement_inferred = ifelse(movement_inferred > 180, 360 - movement_inferred, movement_inferred))
  temp2 <- mutate(temp2, hawkeye_measured = hawkeye_measured  / 360)
  temp2 <- mutate(temp2, movement_inferred = movement_inferred  / 360)
  temp2 <- mutate(temp2, index = 1:nrow(temp2))
  
  # Combine temp2 into temp
  temp <- left_join(temp, temp2, by = c("index"))
  temp <- select(temp, -"index")
  
  # Data Manipulation to avoid infinity errors
  temp <- mutate(temp, active_spin = ifelse(Velocity == 0 & H_Release_Pos == 0, 0, active_spin))
  temp <- mutate(temp, hawkeye_measured = ifelse(Velocity == 0 & H_Release_Pos == 0, 0, hawkeye_measured))
  temp <- mutate(temp, movement_inferred = ifelse(Velocity == 0 & H_Release_Pos == 0, 0, movement_inferred))
  
  # Various max_diff's to use as denominator (Formula: percentage similarity = sum / max_diff)
  max_diff_all <- sum(apply(temp, 2, max, na.rm = TRUE))
  max_diff_no_clock <- sum(apply(temp[c(1:9)], 2, max, na.rm = TRUE))
  max_diff_no_spin <- sum(apply(temp[c(1:8)], 2, max, na.rm = TRUE))
  
  # Create a column 'sum' to add up the differences of ranges
  temp['sum'] <-  rowSums(temp, na.rm = TRUE)
  # Finally create the percentage similarity
  temp <- mutate(temp, perc = ifelse(is.na(active_spin), ((max_diff_no_spin - temp$sum) / max_diff_no_spin * 100), 
                                     ifelse(is.na(hawkeye_measured), ((max_diff_no_clock - temp$sum) / max_diff_no_clock * 100), 
                                            ((max_diff_all - temp$sum) / max_diff_all * 100))))
  
  # short_temp elims unnecessary cols, adds an index, elims same player, and arranges by highest percentage
  short_temp <- temp %>%
    select(perc) %>%
    mutate(index = 1:nrow(temp)) %>%
    mutate(pitcher_id = new_pitch_stats$pitcher) %>%
    mutate(year = new_pitch_stats$year) %>%
    filter(perc != 100) %>%
    filter(pitcher_id != cur_player_id) %>%
    arrange(desc(perc))
  
  # elims a pitcher being in top 5 matches more than once
  all <- short_temp[match(unique(short_temp$pitcher_id), short_temp$pitcher_id),]
  
  # Separate data frame for only having 2022 pitches in result
  just_2022 <- filter(short_temp, year == 2022)
  
  # Input the highest percentage values into the diff_all dataframe
  diff_all[i,4:8] <- all[1:5,2]
  diff_all[i,9:13] <- all[1:5,1]
  # Input the highest percentage values into the diff_2022 dataframe
  diff_2022[i,4:8] <- just_2022[1:5,2]
  diff_2022[i,9:13] <- just_2022[1:5,1]
  
  # Keep track of how far along the for loop is - get to 12104
  print(i)
}

new_pitch_stats$id <- as.character(1:nrow(new_pitch_stats))

new_diff_all <- diff_all %>%
  unite("first", c("first", "first_perc"), sep = " ") %>%
  unite("second", c("second", "second_perc"), sep = " ") %>%
  unite("third", c("third", "third_perc"), sep = " ") %>%
  unite("fourth", c("fourth", "fourth_perc"), sep = " ") %>%
  unite("fifth", c("fifth", "fifth_perc"), sep = " ") %>%
  gather("rank", "id_perc", 4:8) %>%
  separate(id_perc, c("id", "perc"), sep = " ") %>%
  filter(id != "NA") %>%
  left_join(select(new_pitch_stats, c(2,4,32)), by = "id") %>%
  select(c(1:4,6,8:10))
colnames(new_diff_all)[8] = 'sim_player'
colnames(new_diff_all)[2] = 'pitch_type'
colnames(new_diff_all)[3] = 'year'
colnames(new_diff_all)[6] = 'sim_year'
colnames(new_diff_all)[7] = 'sim_pitch_type'


new_diff_2022 <- diff_2022 %>%
  unite("first", c("first", "first_perc"), sep = " ") %>%
  unite("second", c("second", "second_perc"), sep = " ") %>%
  unite("third", c("third", "third_perc"), sep = " ") %>%
  unite("fourth", c("fourth", "fourth_perc"), sep = " ") %>%
  unite("fifth", c("fifth", "fifth_perc"), sep = " ") %>%
  gather("rank", "id_perc", 4:8) %>%
  separate(id_perc, c("id", "perc"), sep = " ") %>%
  filter(id != "NA") %>%
  left_join(select(new_pitch_stats, c(2,4,32)), by = "id") %>%
  select(c(1:4,6,8:10))
colnames(new_diff_2022)[8] = 'sim_player'
colnames(new_diff_2022)[2] = 'pitch_type'
colnames(new_diff_2022)[3] = 'year'
colnames(new_diff_2022)[6] = 'sim_year'
colnames(new_diff_2022)[7] = 'sim_pitch_type'

options <- select(pitch_stats, c(1,2,3,4)) %>%
  left_join(reg, by = "pitcher") %>%
  separate(name, into = c("first", "last"), sep = "^\\S*\\K\\s+", remove = FALSE) %>%
  unite("new_name", last, first, sep = ", ") %>%
  mutate(name = ifelse(is.na(name), player_name, new_name)) %>%
  select(-6)
  

write.csv(options, "Baseball Stuff/options.csv", fileEncoding = "UTF-8")

# Easier way to add correct names to dataframes
all_players <- options %>%
  ungroup() %>%
  select(pitcher, name) %>%
  unique

# Create summary statistics for each pitcher, pitch, and year
database_to_draw <- partner_pitch %>%
  mutate(num_outside = ifelse(zone >= 11, 1, 0)) %>%
  group_by(player_name, pitch_type, year, pitcher) %>%
  summarize(count = n(), Velocity = mean(release_speed, na.rm = TRUE), H_Release_Pos = mean(release_pos_x, na.rm = TRUE), 
            V_Release_Pos_z = mean(release_pos_z, na.rm = TRUE), H_Break = mean(pfx_x, na.rm = TRUE), 
            V_Break = mean(pfx_z, na.rm = TRUE), VAA = mean(-atan((vz0 + (az * (((-sqrt(vy0^2 - (2 * ay * (50 - (17/12))))) - vy0) / ay)))/(-sqrt(vy0^2 - (2 * ay * (50 - (17/12)))))) * (180 / pi)),
            Spin_Rate = mean(release_spin_rate, na.rm = TRUE), Ext = mean(release_extension, na.rm = TRUE), Eff_Velocity = mean(effective_speed, na.rm = TRUE), 
            chase = sum(chase, na.rm = TRUE), num_outside = sum(num_outside, na.rm = TRUE), csw = mean(csw, na.rm = TRUE)) %>%
  mutate(H_Break = H_Break * 12,
         V_Break = V_Break * 12,
         chase = chase * 100 / num_outside,
         csw = csw * 100) %>%
  left_join(tot_pitches, by = c("player_name", "year", "pitcher")) %>%
  # Finding percent time pitch is thrown
  mutate(perc_thrown = 100 * count / num_pitches) %>%
  left_join(all_players, by = "pitcher") %>%
  select(-c(1, 16))
  


location_data <- select(partner_pitch, c("pitcher", "pitch_type", "player_name", "game_year", "plate_x", "plate_z")) %>%
  left_join(all_players, by = "pitcher") %>%
  select(-3)
  
write.csv(location_data, "Baseball Stuff/location_data.csv", fileEncoding = "UTF-8")

write.csv(database_to_draw, "Baseball Stuff/database_to_draw.csv", fileEncoding = "UTF-8")



new_diff_all_edit <- new_diff_all %>%
  left_join(all_players, by = c("player" = "pitcher")) %>%
  select(-1)

new_diff_2022_edit <- new_diff_2022 %>%
  left_join(all_players, by = c("player" = "pitcher")) %>%
  select(-1)

write.csv(new_diff_all_edit, "Baseball Stuff/new_diff_all_edit.csv", fileEncoding = "UTF-8")
write.csv(new_diff_2022_edit, "Baseball Stuff/new_diff_2022_edit.csv", fileEncoding = "UTF-8")






  

