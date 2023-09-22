# You can install using the pacman package using the following code:
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
#pacman::p_load_current_gh("BillPetti/baseballr")

library(baseballr)
library(tidyverse)

#2022
date <- as.Date("2022-04-07")
SavantData22 <- baseballr::scrape_statcast_savant(start_date = as.character(date),
                                                         end_date = as.character(date), player_type = 'pitcher')
date = date + 1

while (date <= as.Date("2022-10-05")) {
   pitch <- baseballr::scrape_statcast_savant(start_date = as.character(date),
                                                 end_date = as.character(date+2), player_type = 'pitcher')
   SavantData22 <- rbind(SavantData22, pitch)
   date = date + 3
}
# screwup
SavantData22 <- filter(SavantData22, game_date < "2022-10-06")

write.csv(SavantData22,"SavantPitchingData22Reg.csv", row.names = F)

datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2022-10-07',
                                                 end_date = '2022-11-03', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData22Playoff.csv", row.names = F)


#2021

date401407 = baseballr::scrape_statcast_savant(start_date = '2021-04-01',
                                               end_date = '2021-04-07', player_type = 'pitcher')
date408414 = baseballr::scrape_statcast_savant(start_date = '2021-04-08',
                                               end_date = '2021-04-14', player_type = 'pitcher')
date415421 = baseballr::scrape_statcast_savant(start_date = '2021-04-15',
                                               end_date = '2021-04-21', player_type = 'pitcher')
date422428 = baseballr::scrape_statcast_savant(start_date = '2021-04-22',
                                               end_date = '2021-04-28', player_type = 'pitcher')
date429505 = baseballr::scrape_statcast_savant(start_date = '2021-04-29',
                                               end_date = '2021-05-05', player_type = 'pitcher')
date506512 = baseballr::scrape_statcast_savant(start_date = '2021-05-06',
                                               end_date = '2021-05-12', player_type = 'pitcher')
date513519 = baseballr::scrape_statcast_savant(start_date = '2021-05-13',
                                               end_date = '2021-05-19', player_type = 'pitcher')
date520526 = baseballr::scrape_statcast_savant(start_date = '2021-05-20',
                                               end_date = '2021-05-26', player_type = 'pitcher')
date527602 = baseballr::scrape_statcast_savant(start_date = '2021-05-27',
                                               end_date = '2021-06-02', player_type = 'pitcher')
date603609 = baseballr::scrape_statcast_savant(start_date = '2021-06-03',
                                               end_date = '2021-06-09', player_type = 'pitcher')
date610616 = baseballr::scrape_statcast_savant(start_date = '2021-06-10',
                                               end_date = '2021-06-16', player_type = 'pitcher')
date617623 = baseballr::scrape_statcast_savant(start_date = '2021-06-17',
                                               end_date = '2021-06-23', player_type = 'pitcher')
date624630 = baseballr::scrape_statcast_savant(start_date = '2021-06-24',
                                               end_date = '2021-06-30', player_type = 'pitcher')
date701707 = baseballr::scrape_statcast_savant(start_date = '2021-07-01',
                                               end_date = '2021-07-07', player_type = 'pitcher')
date708714 = baseballr::scrape_statcast_savant(start_date = '2021-07-08',
                                               end_date = '2021-07-14', player_type = 'pitcher')
date715721 = baseballr::scrape_statcast_savant(start_date = '2021-07-15',
                                               end_date = '2021-07-21', player_type = 'pitcher')
date722728 = baseballr::scrape_statcast_savant(start_date = '2021-07-22',
                                               end_date = '2021-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2021-07-29',
                                               end_date = '2021-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2021-08-05',
                                               end_date = '2021-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2021-08-12',
                                               end_date = '2021-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2021-08-19',
                                               end_date = '2021-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2021-08-26',
                                               end_date = '2021-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2021-09-02',
                                               end_date = '2021-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2021-09-09',
                                               end_date = '2021-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2021-09-16',
                                               end_date = '2021-09-22', player_type = 'pitcher')
date923929 = baseballr::scrape_statcast_savant(start_date = '2021-09-23',
                                               end_date = '2021-09-29', player_type = 'pitcher')
date9301003 = baseballr::scrape_statcast_savant(start_date = '2021-09-30',
                                                end_date = '2021-10-03', player_type = 'pitcher')

SavantData21 = rbind(date401407, date408414, date415421, date422428, date429505,
                     date506512, date513519, date520526, date527602, date603609,
                     date610616, date617623, date624630, date701707, date708714,
                     date715721, date722728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923929, date9301003)


write.csv(SavantData21,"SavantPitchingData21Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2021-10-05',
                                                 end_date = '2021-11-02', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData21Playoff.csv", row.names = F)





#2020

date723728 = baseballr::scrape_statcast_savant(start_date = '2020-07-23',
                                               end_date = '2020-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2020-07-29',
                                               end_date = '2020-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2020-08-05',
                                               end_date = '2020-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2020-08-12',
                                               end_date = '2020-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2020-08-19',
                                               end_date = '2020-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2020-08-26',
                                               end_date = '2020-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2020-09-02',
                                               end_date = '2020-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2020-09-09',
                                               end_date = '2020-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2020-09-16',
                                               end_date = '2020-09-22', player_type = 'pitcher')
date923927 = baseballr::scrape_statcast_savant(start_date = '2020-09-23',
                                               end_date = '2020-09-27', player_type = 'pitcher')

SavantData20 = rbind(date723728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923927)


write.csv(SavantData20,"SavantPitchingData20Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2020-09-29',
                                                 end_date = '2020-10-27', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData20Playoff.csv", row.names = F)







#2019

date320407 = baseballr::scrape_statcast_savant(start_date = '2019-03-20',
                                               end_date = '2019-04-07', player_type = 'pitcher')
date408414 = baseballr::scrape_statcast_savant(start_date = '2019-04-08',
                                               end_date = '2019-04-14', player_type = 'pitcher')
date415421 = baseballr::scrape_statcast_savant(start_date = '2019-04-15',
                                               end_date = '2019-04-21', player_type = 'pitcher')
date422428 = baseballr::scrape_statcast_savant(start_date = '2019-04-22',
                                               end_date = '2019-04-28', player_type = 'pitcher')
date429505 = baseballr::scrape_statcast_savant(start_date = '2019-04-29',
                                               end_date = '2019-05-05', player_type = 'pitcher')
date506512 = baseballr::scrape_statcast_savant(start_date = '2019-05-06',
                                               end_date = '2019-05-12', player_type = 'pitcher')
date513519 = baseballr::scrape_statcast_savant(start_date = '2019-05-13',
                                               end_date = '2019-05-19', player_type = 'pitcher')
date520526 = baseballr::scrape_statcast_savant(start_date = '2019-05-20',
                                               end_date = '2019-05-26', player_type = 'pitcher')
date527602 = baseballr::scrape_statcast_savant(start_date = '2019-05-27',
                                               end_date = '2019-06-02', player_type = 'pitcher')
date603609 = baseballr::scrape_statcast_savant(start_date = '2019-06-03',
                                               end_date = '2019-06-09', player_type = 'pitcher')
date610616 = baseballr::scrape_statcast_savant(start_date = '2019-06-10',
                                               end_date = '2019-06-16', player_type = 'pitcher')
date617623 = baseballr::scrape_statcast_savant(start_date = '2019-06-17',
                                               end_date = '2019-06-23', player_type = 'pitcher')
date624630 = baseballr::scrape_statcast_savant(start_date = '2019-06-24',
                                               end_date = '2019-06-30', player_type = 'pitcher')
date701707 = baseballr::scrape_statcast_savant(start_date = '2019-07-01',
                                               end_date = '2019-07-07', player_type = 'pitcher')
date708714 = baseballr::scrape_statcast_savant(start_date = '2019-07-08',
                                               end_date = '2019-07-14', player_type = 'pitcher')
date715721 = baseballr::scrape_statcast_savant(start_date = '2019-07-15',
                                               end_date = '2019-07-21', player_type = 'pitcher')
date722728 = baseballr::scrape_statcast_savant(start_date = '2019-07-22',
                                               end_date = '2019-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2019-07-29',
                                               end_date = '2019-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2019-08-05',
                                               end_date = '2019-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2019-08-12',
                                               end_date = '2019-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2019-08-19',
                                               end_date = '2019-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2019-08-26',
                                               end_date = '2019-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2019-09-02',
                                               end_date = '2019-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2019-09-09',
                                               end_date = '2019-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2019-09-16',
                                               end_date = '2019-09-22', player_type = 'pitcher')
date923929 = baseballr::scrape_statcast_savant(start_date = '2019-09-23',
                                               end_date = '2019-09-29', player_type = 'pitcher')

SavantData19 = rbind(date320407, date408414, date415421, date422428, date429505,
                     date506512, date513519, date520526, date527602, date603609,
                     date610616, date617623, date624630, date701707, date708714,
                     date715721, date722728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923929)

write.csv(SavantData19,"SavantPitchingData19Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2019-10-01',
                                                 end_date = '2019-10-30', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData19Playoff.csv", row.names = F)




#2018

date329407 = baseballr::scrape_statcast_savant(start_date = '2018-03-29',
                                               end_date = '2018-04-07', player_type = 'pitcher')
date408414 = baseballr::scrape_statcast_savant(start_date = '2018-04-08',
                                               end_date = '2018-04-14', player_type = 'pitcher')
date415421 = baseballr::scrape_statcast_savant(start_date = '2018-04-15',
                                               end_date = '2018-04-21', player_type = 'pitcher')
date422428 = baseballr::scrape_statcast_savant(start_date = '2018-04-22',
                                               end_date = '2018-04-28', player_type = 'pitcher')
date429505 = baseballr::scrape_statcast_savant(start_date = '2018-04-29',
                                               end_date = '2018-05-05', player_type = 'pitcher')
date506512 = baseballr::scrape_statcast_savant(start_date = '2018-05-06',
                                               end_date = '2018-05-12', player_type = 'pitcher')
date513519 = baseballr::scrape_statcast_savant(start_date = '2018-05-13',
                                               end_date = '2018-05-19', player_type = 'pitcher')
date520526 = baseballr::scrape_statcast_savant(start_date = '2018-05-20',
                                               end_date = '2018-05-26', player_type = 'pitcher')
date527602 = baseballr::scrape_statcast_savant(start_date = '2018-05-27',
                                               end_date = '2018-06-02', player_type = 'pitcher')
date603609 = baseballr::scrape_statcast_savant(start_date = '2018-06-03',
                                               end_date = '2018-06-09', player_type = 'pitcher')
date610616 = baseballr::scrape_statcast_savant(start_date = '2018-06-10',
                                               end_date = '2018-06-16', player_type = 'pitcher')
date617623 = baseballr::scrape_statcast_savant(start_date = '2018-06-17',
                                               end_date = '2018-06-23', player_type = 'pitcher')
date624630 = baseballr::scrape_statcast_savant(start_date = '2018-06-24',
                                               end_date = '2018-06-30', player_type = 'pitcher')
date701707 = baseballr::scrape_statcast_savant(start_date = '2018-07-01',
                                               end_date = '2018-07-07', player_type = 'pitcher')
date708714 = baseballr::scrape_statcast_savant(start_date = '2018-07-08',
                                               end_date = '2018-07-14', player_type = 'pitcher')
date715721 = baseballr::scrape_statcast_savant(start_date = '2018-07-15',
                                               end_date = '2018-07-21', player_type = 'pitcher')
date722728 = baseballr::scrape_statcast_savant(start_date = '2018-07-22',
                                               end_date = '2018-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2018-07-29',
                                               end_date = '2018-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2018-08-05',
                                               end_date = '2018-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2018-08-12',
                                               end_date = '2018-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2018-08-19',
                                               end_date = '2018-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2018-08-26',
                                               end_date = '2018-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2018-09-02',
                                               end_date = '2018-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2018-09-09',
                                               end_date = '2018-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2018-09-16',
                                               end_date = '2018-09-22', player_type = 'pitcher')
date923929 = baseballr::scrape_statcast_savant(start_date = '2018-09-23',
                                               end_date = '2018-09-29', player_type = 'pitcher')
date9301001 = baseballr::scrape_statcast_savant(start_date = '2018-09-30',
                                                end_date = '2018-10-01', player_type = 'pitcher')

SavantData18 = rbind(date329407, date408414, date415421, date422428, date429505,
                     date506512, date513519, date520526, date527602, date603609,
                     date610616, date617623, date624630, date701707, date708714,
                     date715721, date722728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923929, date9301001)

write.csv(SavantData18,"SavantPitchingData18Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2018-10-02',
                                                 end_date = '2018-10-28', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData18Playoff.csv", row.names = F)





#2017

date402407 = baseballr::scrape_statcast_savant(start_date = '2017-04-02',
                                               end_date = '2017-04-07', player_type = 'pitcher')
date408414 = baseballr::scrape_statcast_savant(start_date = '2017-04-08',
                                               end_date = '2017-04-14', player_type = 'pitcher')
date415421 = baseballr::scrape_statcast_savant(start_date = '2017-04-15',
                                               end_date = '2017-04-21', player_type = 'pitcher')
date422428 = baseballr::scrape_statcast_savant(start_date = '2017-04-22',
                                               end_date = '2017-04-28', player_type = 'pitcher')
date429505 = baseballr::scrape_statcast_savant(start_date = '2017-04-29',
                                               end_date = '2017-05-05', player_type = 'pitcher')
date506512 = baseballr::scrape_statcast_savant(start_date = '2017-05-06',
                                               end_date = '2017-05-12', player_type = 'pitcher')
date513519 = baseballr::scrape_statcast_savant(start_date = '2017-05-13',
                                               end_date = '2017-05-19', player_type = 'pitcher')
date520526 = baseballr::scrape_statcast_savant(start_date = '2017-05-20',
                                               end_date = '2017-05-26', player_type = 'pitcher')
date527602 = baseballr::scrape_statcast_savant(start_date = '2017-05-27',
                                               end_date = '2017-06-02', player_type = 'pitcher')
date603609 = baseballr::scrape_statcast_savant(start_date = '2017-06-03',
                                               end_date = '2017-06-09', player_type = 'pitcher')
date610616 = baseballr::scrape_statcast_savant(start_date = '2017-06-10',
                                               end_date = '2017-06-16', player_type = 'pitcher')
date617623 = baseballr::scrape_statcast_savant(start_date = '2017-06-17',
                                               end_date = '2017-06-23', player_type = 'pitcher')
date624630 = baseballr::scrape_statcast_savant(start_date = '2017-06-24',
                                               end_date = '2017-06-30', player_type = 'pitcher')
date701707 = baseballr::scrape_statcast_savant(start_date = '2017-07-01',
                                               end_date = '2017-07-07', player_type = 'pitcher')
date708714 = baseballr::scrape_statcast_savant(start_date = '2017-07-08',
                                               end_date = '2017-07-14', player_type = 'pitcher')
date715721 = baseballr::scrape_statcast_savant(start_date = '2017-07-15',
                                               end_date = '2017-07-21', player_type = 'pitcher')
date722728 = baseballr::scrape_statcast_savant(start_date = '2017-07-22',
                                               end_date = '2017-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2017-07-29',
                                               end_date = '2017-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2017-08-05',
                                               end_date = '2017-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2017-08-12',
                                               end_date = '2017-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2017-08-19',
                                               end_date = '2017-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2017-08-26',
                                               end_date = '2017-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2017-09-02',
                                               end_date = '2017-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2017-09-09',
                                               end_date = '2017-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2017-09-16',
                                               end_date = '2017-09-22', player_type = 'pitcher')
date923929 = baseballr::scrape_statcast_savant(start_date = '2017-09-23',
                                               end_date = '2017-09-29', player_type = 'pitcher')
date9301001 = baseballr::scrape_statcast_savant(start_date = '2017-09-30',
                                                end_date = '2017-10-01', player_type = 'pitcher')

SavantData17 = rbind(date402407, date408414, date415421, date422428, date429505,
                     date506512, date513519, date520526, date527602, date603609,
                     date610616, date617623, date624630, date701707, date708714,
                     date715721, date722728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923929, date9301001)

write.csv(SavantData17,"SavantPitchingData17Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2017-10-03',
                                                 end_date = '2017-11-01', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData17Playoff.csv", row.names = F)



#2016

date403407 = baseballr::scrape_statcast_savant(start_date = '2016-04-03',
                                               end_date = '2016-04-07', player_type = 'pitcher')
date408414 = baseballr::scrape_statcast_savant(start_date = '2016-04-08',
                                               end_date = '2016-04-14', player_type = 'pitcher')
date415421 = baseballr::scrape_statcast_savant(start_date = '2016-04-15',
                                               end_date = '2016-04-21', player_type = 'pitcher')
date422428 = baseballr::scrape_statcast_savant(start_date = '2016-04-22',
                                               end_date = '2016-04-28', player_type = 'pitcher')
date429505 = baseballr::scrape_statcast_savant(start_date = '2016-04-29',
                                               end_date = '2016-05-05', player_type = 'pitcher')
date506512 = baseballr::scrape_statcast_savant(start_date = '2016-05-06',
                                               end_date = '2016-05-12', player_type = 'pitcher')
date513519 = baseballr::scrape_statcast_savant(start_date = '2016-05-13',
                                               end_date = '2016-05-19', player_type = 'pitcher')
date520526 = baseballr::scrape_statcast_savant(start_date = '2016-05-20',
                                               end_date = '2016-05-26', player_type = 'pitcher')
date527602 = baseballr::scrape_statcast_savant(start_date = '2016-05-27',
                                               end_date = '2016-06-02', player_type = 'pitcher')
date603609 = baseballr::scrape_statcast_savant(start_date = '2016-06-03',
                                               end_date = '2016-06-09', player_type = 'pitcher')
date610616 = baseballr::scrape_statcast_savant(start_date = '2016-06-10',
                                               end_date = '2016-06-16', player_type = 'pitcher')
date617623 = baseballr::scrape_statcast_savant(start_date = '2016-06-17',
                                               end_date = '2016-06-23', player_type = 'pitcher')
date624630 = baseballr::scrape_statcast_savant(start_date = '2016-06-24',
                                               end_date = '2016-06-30', player_type = 'pitcher')
date701707 = baseballr::scrape_statcast_savant(start_date = '2016-07-01',
                                               end_date = '2016-07-07', player_type = 'pitcher')
date708714 = baseballr::scrape_statcast_savant(start_date = '2016-07-08',
                                               end_date = '2016-07-14', player_type = 'pitcher')
date715721 = baseballr::scrape_statcast_savant(start_date = '2016-07-15',
                                               end_date = '2016-07-21', player_type = 'pitcher')
date722728 = baseballr::scrape_statcast_savant(start_date = '2016-07-22',
                                               end_date = '2016-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2016-07-29',
                                               end_date = '2016-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2016-08-05',
                                               end_date = '2016-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2016-08-12',
                                               end_date = '2016-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2016-08-19',
                                               end_date = '2016-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2016-08-26',
                                               end_date = '2016-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2016-09-02',
                                               end_date = '2016-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2016-09-09',
                                               end_date = '2016-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2016-09-16',
                                               end_date = '2016-09-22', player_type = 'pitcher')
date923929 = baseballr::scrape_statcast_savant(start_date = '2016-09-23',
                                               end_date = '2016-09-29', player_type = 'pitcher')
date9301002 = baseballr::scrape_statcast_savant(start_date = '2016-09-30',
                                                end_date = '2016-10-02', player_type = 'pitcher')

SavantData16 = rbind(date403407, date408414, date415421, date422428, date429505,
                     date506512, date513519, date520526, date527602, date603609,
                     date610616, date617623, date624630, date701707, date708714,
                     date715721, date722728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923929, date9301002)

write.csv(SavantData16,"SavantPitchingData16Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2016-10-04',
                                                 end_date = '2016-11-02', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData16Playoff.csv", row.names = F)





#2015

date405407 = baseballr::scrape_statcast_savant(start_date = '2015-04-05',
                                               end_date = '2015-04-07', player_type = 'pitcher')
date408414 = baseballr::scrape_statcast_savant(start_date = '2015-04-08',
                                               end_date = '2015-04-14', player_type = 'pitcher')
date415421 = baseballr::scrape_statcast_savant(start_date = '2015-04-15',
                                               end_date = '2015-04-21', player_type = 'pitcher')
date422428 = baseballr::scrape_statcast_savant(start_date = '2015-04-22',
                                               end_date = '2015-04-28', player_type = 'pitcher')
date429505 = baseballr::scrape_statcast_savant(start_date = '2015-04-29',
                                               end_date = '2015-05-05', player_type = 'pitcher')
date506512 = baseballr::scrape_statcast_savant(start_date = '2015-05-06',
                                               end_date = '2015-05-12', player_type = 'pitcher')
date513519 = baseballr::scrape_statcast_savant(start_date = '2015-05-13',
                                               end_date = '2015-05-19', player_type = 'pitcher')
date520526 = baseballr::scrape_statcast_savant(start_date = '2015-05-20',
                                               end_date = '2015-05-26', player_type = 'pitcher')
date527602 = baseballr::scrape_statcast_savant(start_date = '2015-05-27',
                                               end_date = '2015-06-02', player_type = 'pitcher')
date603609 = baseballr::scrape_statcast_savant(start_date = '2015-06-03',
                                               end_date = '2015-06-09', player_type = 'pitcher')
date610616 = baseballr::scrape_statcast_savant(start_date = '2015-06-10',
                                               end_date = '2015-06-16', player_type = 'pitcher')
date617623 = baseballr::scrape_statcast_savant(start_date = '2015-06-17',
                                               end_date = '2015-06-23', player_type = 'pitcher')
date624630 = baseballr::scrape_statcast_savant(start_date = '2015-06-24',
                                               end_date = '2015-06-30', player_type = 'pitcher')
date701707 = baseballr::scrape_statcast_savant(start_date = '2015-07-01',
                                               end_date = '2015-07-07', player_type = 'pitcher')
date708714 = baseballr::scrape_statcast_savant(start_date = '2015-07-08',
                                               end_date = '2015-07-14', player_type = 'pitcher')
date715721 = baseballr::scrape_statcast_savant(start_date = '2015-07-15',
                                               end_date = '2015-07-21', player_type = 'pitcher')
date722728 = baseballr::scrape_statcast_savant(start_date = '2015-07-22',
                                               end_date = '2015-07-28', player_type = 'pitcher')
date729804 = baseballr::scrape_statcast_savant(start_date = '2015-07-29',
                                               end_date = '2015-08-04', player_type = 'pitcher')
date805811 = baseballr::scrape_statcast_savant(start_date = '2015-08-05',
                                               end_date = '2015-08-11', player_type = 'pitcher')
date812818 = baseballr::scrape_statcast_savant(start_date = '2015-08-12',
                                               end_date = '2015-08-18', player_type = 'pitcher')
date819825 = baseballr::scrape_statcast_savant(start_date = '2015-08-19',
                                               end_date = '2015-08-25', player_type = 'pitcher')
date826901 = baseballr::scrape_statcast_savant(start_date = '2015-08-26',
                                               end_date = '2015-09-01', player_type = 'pitcher')
date902908 = baseballr::scrape_statcast_savant(start_date = '2015-09-02',
                                               end_date = '2015-09-08', player_type = 'pitcher')
date909915 = baseballr::scrape_statcast_savant(start_date = '2015-09-09',
                                               end_date = '2015-09-15', player_type = 'pitcher')
date916922 = baseballr::scrape_statcast_savant(start_date = '2015-09-16',
                                               end_date = '2015-09-22', player_type = 'pitcher')
date923929 = baseballr::scrape_statcast_savant(start_date = '2015-09-23',
                                               end_date = '2015-09-29', player_type = 'pitcher')
date9301004 = baseballr::scrape_statcast_savant(start_date = '2015-09-30',
                                                end_date = '2015-10-04', player_type = 'pitcher')

SavantData15 = rbind(date405407, date408414, date415421, date422428, date429505,
                     date506512, date513519, date520526, date527602, date603609,
                     date610616, date617623, date624630, date701707, date708714,
                     date715721, date722728, date729804, date805811, date812818,
                     date819825, date826901, date902908, date909915, date916922,
                     date923929, date9301004)

write.csv(SavantData15,"SavantPitchingData15Reg.csv", row.names = F)


datePlayoff1 = baseballr::scrape_statcast_savant(start_date = '2015-10-06',
                                                 end_date = '2015-11-01', player_type = 'pitcher')
write.csv(datePlayoff1,"SavantPitchingData15Playoff.csv", row.names = F)

