# Information ----
## Author:  Nicholas Poggioli (poggiolin@appstate.edu)
## Date:    June 2024
## Data:    USA Census Bureau Business Trends and Outlook Survey (BTOS) Data
## Data at: https://www.census.gov/data/experimental-data-products/business-trends-and-outlook-survey.html

# Set environment ----

# Import and clean data ----
library(readxl)
Top_25_MSA <- read_excel("~/Desktop/Top 25 MSA.xlsx",
                         sheet = "Response Estimates", col_types = c("text",
                                                                     "numeric", "text", "numeric", "text",
                                                                     "numeric", "numeric", "numeric",
                                                                     "numeric", "numeric", "numeric",
                                                                     "numeric", "numeric", "numeric", "numeric", "numeric",
                                                                     "numeric", "numeric", "numeric", "numeric", "numeric",
                                                                     "numeric", "numeric"))

# Keep yes answers to "In the last two weeks, did this business use Artificial Intelligence (AI) in producing goods or services? (Examples of AI: machine learning, natural language processing, virtual agents, voice recognition, etc.)"
used_AI <- Top_25_MSA[ which(Top_25_MSA$`Question ID`==6 & Top_25_MSA$`Answer ID`==1), ]

## Reshape data ----
#install.packages("reshape2", dependencies = TRUE)
library(reshape2)
used_AI_long <- melt(used_AI, id=c("MSA","Question ID","Question","Answer ID","Answer"))

## Fix date variable ----
# Convert vector to character
used_AI_long$date <- as.Date(used_AI_long$variable, "%m/%d/%y")

# Create factor date for plots
used_AI_long$datefactor <- as.factor(used_AI_long$date)

## Violin plots ----
# From http://www.sthda.com/english/wiki/ggplot2-violin-plot-quick-start-guide-r-software-and-data-visualization) 
library(ggplot2)

p <- ggplot(used_AI_long, aes(x=datefactor, y=value)) +
  xlab("Year and Month") +
  ylab("Percentage of Firms in MSA Answering \"Yes\"")
p + geom_violin()

# Add boxplot
p + geom_violin() + geom_boxplot(width = 0.1)

# Violin plot with data points
p + geom_violin() + 
  geom_dotplot(binaxis = 'y', stackdir = 'center', dotsize = 0.4)



# ---------------------------- STUCK HERE WITH DATA FORMATTING

# Line plots ----
p_line <- ggplot(data = used_AI_long, 
                 mapping = aes(x = date, y = value))

p_line + geom_line(aes(group = MSA, color = MSA)) +
  geom_smooth(size = 1.1, method = 'loess')


# Line plot, using https://r-graph-gallery.com/354-highlight-specific-elements-in-line-chart.html
library(ggplot2)

ggplot(used_AI_long) + 
  geom_line(aes(variable, value, color = "MSA"))
