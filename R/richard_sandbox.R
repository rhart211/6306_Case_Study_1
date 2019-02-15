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
par(mfrow=c(1,2))
plot1 <- ggplot(beers, aes(x= ABV)) + geom_bar(fill="steelblue")+xlab("Alcohol by Volume")+ylab("Number of Beers")+ggtitle("Distribution of ABV")
plot2 <- ggplot(beers, aes(x= IBU)) + geom_bar(fill="brown2")+xlab("International Bitterness Units")+ylab("Number of Beers")+ggtitle("Distribution of IBU")
plot_grid(plot1, plot2)