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
median_abv <- tapply(beers_brews$ABV, beers_brews$State, median, na.rm = T)
med_abv_df <- data.frame(template=names(median_abv), median=median_abv, stringsAsFactors = FALSE)
colnames(med_abv_df) <- (c("State", "ABV"))
median_ibu <- tapply(beers_brews$IBU, beers_brews$State, median, na.rm = T)
med_ibu_df <- data.frame(template=names(median_ibu), median=median_ibu, stringsAsFactors = FALSE)
colnames(med_ibu_df) <- (c("State", "IBU"))
# Merge the two together
abv_ibu <- merge(med_abv_df, med_ibu_df, by="State")


library(cowplot)
plot1 <- ggplot(abv_ibu, aes(x = State, y = ABV)) + 
  geom_bar(stat = "identity", fill="steelblue") +
  coord_flip() +
  xlab("State") + ylab("Median Alcohol By Volume") + 
  ggtitle("Distribution of Median ABV by State") +
  theme(axis.text.y = element_text(size = 5))
plot2 <- ggplot(abv_ibu, aes(x = State, y = IBU)) + 
  geom_bar(stat = "identity", fill="brown2") + 
  coord_flip() +
  xlab("State") + ylab("Median International Bitterness Units") + 
  ggtitle("Distribution of Median IBU by State") + 
  theme(axis.text.y = element_text(size = 5))
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

# Presentation Statistics
local_beers <- subset (beers_brews, State == c(' TX', ' OK', ' LA', ' OR', ' CO'), 
                        select = c('Brewery_id', 'Beer_name', 'Beer_ID', 'ABV', 'IBU', 'Style', 
                                   'Ounces', 'Brewery_name', 'City', 'State'))

# ABV and IBU for local area 
local_abv <- tapply(local_beers$ABV, local_beers$Brewery_name, median, na.rm = T)
local_abv_df <- data.frame(template=names(local_abv), median=local_abv, stringsAsFactors = FALSE)
colnames(local_abv_df) <- (c("Brewery_name", "ABV"))
local_abv_df <- na.omit(local_abv_df)
local_ibu <- tapply(local_beers$IBU, local_beers$Brewery_name, median, na.rm = T)
local_ibu_df <- data.frame(template=names(local_ibu), median=local_ibu, stringsAsFactors = FALSE)
colnames(local_ibu_df) <- (c("Brewery_name", "IBU"))
local_ibu_df <- na.omit(local_ibu_df)
# Merge the two together
local_abv_ibu <- merge(local_abv_df, local_ibu_df, by="Brewery_name")

# Top 10 Breweries by IBU
head(local_abv_ibu[order(local_abv_ibu$IBU, decreasing = T), ], 10)

# TOp 10 Breweries by ABV
head(local_abv_ibu[order(local_abv_ibu$IBU, decreasing = T), ], 10)