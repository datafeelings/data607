# Generate data and store CSV

library(dplyr)
library(readr)
library(tidyr)

dat = rbind(c("","","Los Angeles", "Phoenix", "San Diego", "San Francisco", "Seattle"),
                c("ALASKA", "on time", "497","221","212","503","1841"),
                c("", "delayed", "62","12","20","102","305"),
                c("","","","","","",""),
                c("AM WEST", "on time", "694", "4840","383","320","201"),
                c("", "delayed", "117","415","65","129","61"))

write_csv(dat, "Week_5/flights_wide.csv")
rm(dat)
# Read the CSV

dat = read_csv("Week_5/flights_wide.csv",trim_ws = T)

# Fix header by taking the values from the first line, then drop the header row
names(dat) = unlist(append(c("airline", "status"),dat[1,3:7]))

dat = dat[-1,]

# Remove completely empty rows

dat = dat[rowSums(is.na(dat)) != ncol(dat),] # Source for this solution is provided at the bottom

# Fill the first column with the last non NA value. Using dplyr / tidyr I'm using
# the following hack. 
# Actually there is a handy function na.locf() from the zoo package that fills the last
# non-NA value.

dat = dat %>% 
  mutate(airline = ifelse(is.na(airline)==T & is.na(lag(airline))==F,lag(airline),airline)) 

# Gather observations into tidy format and fix the count variable

dat = dat %>% gather("airport", "flights", 3:7) %>% mutate(flights = as.integer(flights))

# Make a plot of flights per airport
library(plotly)
plot_ly(data = dat, x = airport, y = flights, group = airline, type = "bar") %>% 
  layout(title = "Total flights per airline")


# Make a plot of share of delays

dat = dat %>% 
  group_by(airline,airport) %>% 
  mutate(total_flights = sum(flights)) %>% 
  mutate(share = round(flights / total_flights,2)*100)

plot_ly(data = filter(dat, status == "delayed"), x = airport, y = share, 
        group = airline, 
        text = paste("Total flights:", total_flights, "<br>","Delayed:", share,"%" ),
        mode = "markers+lines", 
        marker=list(size = total_flights, sizeref = 90, symbol = "square" ) ) %>% 
  layout(title = "Share (%) of delayed flights per airline and destination")


# Sources

#http://stackoverflow.com/questions/6437164/removing-empty-rows-of-a-data-file-in-r