# Richard's Sandbox for saving R commands/history

# Create Data Frames from CSV files
beers <- read.csv(file="data/Beers.csv", header = TRUE, sep = ",")
breweries <- read.csv(file = "data/Breweries.csv", header = TRUE, sep = ",")

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


