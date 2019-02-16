# Richard's Sandbox for saving R commands/history

# Load Libraries
library(plyr)
library(ggplot2)

# Create Data Frames from CSV files
beers <- read.csv(file="data/Beers.csv", stringsAsFactors=FALSE, header = TRUE, sep = ",")
breweries <- read.csv(file = "data/Breweries.csv", stringsAsFactors=FALSE, header = TRUE, sep = ",")

# Check the Class of each 
class(beers)
class(breweries)

# Check the structure of data frame
str(beers)
str(breweries)

# Change Brew_ID to Brewery_id so that both data frames have the same
# column name for Brewery ID
names(breweries)[1] <- "Brewery_id"

# Change Name in both data frame to a more descriptive column name
names(breweries)[2] <- "Brewery_name"
names(beers)[1] <- "Beer_name"


# Question 1: number of breweries in each state
state_beers <- table(breweries$State)
state_beers

# Question 2
# Merge Dataset together to be used to answer questions
beers_brews <- merge(beers, breweries, by="Brewery_id", all=TRUE)
head(beers_brews, 6)

# Question 3 Report the number of NAs in each column
colSums(is.na(beers_brews))

# Question 4 Compute the median alcohol content and international 
# bitterness unit for each state. Plot a bar chart to compare.
median_abv <- median(beers_brews$ABV, na.rm = TRUE)
median_ibu <- median(beers_brews$IBU, na.rm = TRUE)

library(cowplot)
plot1 <- ggplot(beers, aes(x= ABV)) + geom_bar(fill="steelblue")+xlab("Alcohol by Volume")+ylab("Number of Beers")+ggtitle("Distribution of ABV")
plot2 <- ggplot(beers, aes(x= IBU)) + geom_bar(fill="brown2")+xlab("International Bitterness Units")+ylab("Number of Beers")+ggtitle("Distribution of IBU")
plot_grid(plot1, plot2)
detach("package:cowplot", unload = TRUE)

# Question 5 State with the most ABV and which with the most IBU
# State with the Highest ABV -- all infomation
  beers_brews[which.max(beers_brews$ABV), ]
  #only state abbreviation
  beers_brews[which.max(beers_brews$ABV), ]$State
# State with the Highest IBU -- all infomation
  beers_brews[which.max(beers_brews$IBU), ]
  #only state abbreviation
  beers_brews[which.max(beers_brews$IBU), ]$State

# Question 6 Summary Statistics of ABV Variable
summary(na.omit(beers$ABV))

# Question 7 relationship between the IBU and ABV, scatter plot

  #Pretty Plot
pp<- ggplot(beers, aes(x=ABV, y=IBU)) +
  geom_point(aes(col=IBU, size=ABV)) +
  geom_smooth(method="loess", se=F) +
  xlim(c(0, 0.14)) + ylim(c(0, 140)) +
  labs(y = "International Bitterness Units",
       x = "Alcohol by Volume") +
  ggtitle("Relationship between International Bitterness Unit and Alcohol by Volume") +
  theme(plot.title = element_text(hjust=0.5)) +
  theme_gray()
plot(pp)

