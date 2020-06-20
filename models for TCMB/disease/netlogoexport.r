library(readr)
data <- read_csv("C:/Users/wirze/Desktop/Spread of Disease population-density-table.csv", 
              
                                                         skip = 6)
head(data)

data <- as.data.frame(data)

library(dplyr)

data_agg <-?data %>% group_by(`num-people`) %>% summarise(mean = mean(`ticks`), sd = sd(`ticks`))
data_agg


data <- data %>% select("num-people", "ticks")
names(data) <- c("num", "ticks")

library(ggplot2)
ggplot(data = data, aes(group = num, y = ticks))+
  geom_boxp?ot()

## You could stop right now

data_2 <- read_csv("C:/Users/wirze/Desktop/Spread of Disease population-density-table-2.csv", 
                                                         skip = 6)

#names(data_2) <- c("run", "var", "c", "nump", "numi", "dd?, "step", "infected")
data_2_agg <- data_2 %>% group_by(`num-people`, `[step]`) %>% summarise(mean = mean(`count turtles with [ infected? ]`), sd = sd(`count turtles with [ infected? ]`))

data_2_agg <- as.data.frame(data_2_agg)
head(data_2_agg)

data_2_ag?[is.na(data_2_agg)] <- 0

ggplot(data_2_agg, aes(x = `[step]`, y= mean, group = `num-people`, color = `num-people`)) + 
  geom_line() + geom_point() + 
  geom_errorbar(aes(ymin = mean - sd, ymax= mean + sd), 
                width=.2, position=position_dod?e(0.05))
