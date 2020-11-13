##############################
##############################
## ASMS Fall workshop 2020 - Day 3: basic statistics
## part 1
## Created by Meena Choi
##############################
##############################


#############################################
## 1. Create a new Rstudio project
#############################################

# From the menu, select **File > New Project...**, 
# then select **Existing Directory** and choose the directory where you downloaded this script and the example datasets for this tutorial. 
# All the output files we'll be creating in this tutorial will be saved in the 'working directory' that now has been set by Rstudio.

# Let's verify the working directory path with the get working directory command.
getwd()

#############################################
## 2. Reading in data
#############################################

iprg <- read.csv("iPRG_example_runsummary.csv")


#############################################
## 3. Data exploration
#############################################

#`class` shows the type of a variable, in this case a 'data.frame`.
class(iprg)

# `dim` shows the dimension of a data.frame, which are the number of rows and the number of columns
dim(iprg)

#`colnames` is short for column names. 
colnames(iprg)
rownames(iprg)
#`head` shows the first 6 rows of data. Try `tail` to show the last 6 rows of data.
head(iprg)
tail(iprg)
# Let's explore the type of every column/variable and a summary for the value range for every column.
summary(iprg)
str(iprg)

iprg[100, 2]
# Inspect the possible values for the `Conditions` and the `BioReplicate` (8th) column 
# using the named and numbered column selection syntax for data frames.
unique(iprg[, 'Condition'])
unique(iprg[, 4])

unique(iprg[, c('Condition', 'BioReplicate', 'Run')])
# Select subsets of rows from iprg dataset: 
# i.e we might be interested in working from here on only with the Condition1
# or all measurements on one particular MS run.

iprg.condition1 <- iprg[iprg$Condition == 'Condition1', ]
iprg.condition1.bio1 <- iprg[iprg$Condition == 'Condition1' & iprg$BioReplicate == '1', ]
nrow(iprg.condition1.bio1)

# wide format  vs long format
# change wide format to long format
library(tidyr)

## make wide format
?spread
wideiprg <- iprg %>% select('Protein', 'Run', 'Log2Intensity')
wideiprg <- iprg %>% select('Protein', 'Run', 'Log2Intensity') %>% 
  spread(Run, Log2Intensity)
head(wideiprg)

## make long format
longiprg <- wideiprg %>% gather(Run, Log2Intensity, -Protein)
head(longiprg)

## add annotation in new long format
annot <- read.csv("iPRG_example_annotation.csv")

library(dplyr)
newiprg <- left_join(longiprg, annot, by='Run')
head(newiprg)
## new iprg has the same number of rows.

#############################################
## 4. Summarizing and Visualizing data
#############################################

### review for day 2
### Boxplot
ggplot(data=iprg,
       mapping=aes(x=Run, y=Log2Intensity)) +
  geom_jitter(aes(color=Condition), size=0.1, alpha=0.1) +
  geom_boxplot(aes(fill=Condition)) +
  labs(x="MS run", y="Log2 Intensity",
       title="Distribution of log2-intensity by MS run") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))

#############################################
# 5. Randomization
#############################################

## 5.1 Random selection of samples from a larger set

# This particular dataset contains a total of 10 subjects across conditions. 
# Suppose we label them from 1 to 10 
# and randomly would like to select 3 subjects we can do this using the `sample` function. 
# When we run `sample` another time, different subjects will be selected. Try this a couple times.

sample(1000, 10)
sample(10, 3)

# Now suppose we would like to select the same randomly selected samples every time, 
# then we can use a random seed number.

set.seed(3728)
sample(10, 3)

set.seed(3728)
sample(10, 3)

group.member <- c('Meena', 'Olga', 'Ryan', 'Kylie', 'Melanie', 'Mateusz')
sample(group.member, 3)

## 5.2 Completely randomized order of MS runs 

# We can also create a random order using all elements of iPRG dataset. 
# Again, we can achieve this using `sample`, asking for exactly the amount of samples in the subset. 
# This time, each repetition gives us a different order of the complete set.

msrun <- unique(iprg$Run)
msrun

# randomize order among all 12 MS runs
sample(msrun, length(msrun))

# different order will be shown.
sample(msrun, length(msrun))


## 5.3 Randomized block design

## Allow to remove known sources of variability that you are not interested in.
## Group conditions into blocks such that the conditions in a block are as similar as possible.
## Randomly assign samples with a block.

# This particular dataset contains a total of 12 MS runs across 4 conditions, 
# 3 technical replicates per condition. Using the `block.random` function in the `psych` package, 
# we can achieve randomized block designs!

# use 'psych' package. Load the package first.
library(psych)

msrun <- unique(iprg[, c('Condition','Run')])
msrun

# 4 Conditions of 12 MS runs randomly ordered
?block.random
block.random(n=12, c(Group=4))

block.random(n=24,
             c(group=2, time=4, replicate=3))


#############################################
# 6. Basic statistical summaries in R
#############################################

## 6.1 Calculate simple statistics

# Let's start with one protein as an example 
# and calculate the mean, standard deviation, standard error of the mean across all replicates per condition. 
# We then store all the computed statistics into a single summary data frame for easy access.

# We can use the **aggregate** function to compute summary statistics

# check what proteins are in dataset, show all protein names
unique(iprg$Protein)

# Let's start with one protein, named "sp|P44015|VAC2_YEAST"
# there are two ways
oneproteindata <- iprg[iprg$Protein == "sp|P44015|VAC2_YEAST", ]

oneproteindata <- iprg %>% filter(Protein == "sp|P44015|VAC2_YEAST")

# If you want to see more details, 
?aggregate

### 6.1.1 Calculate mean per groups
# splits 'oneproteindata' into subsets by 'Condition', 
# then, compute 'FUN=mean' of 'log2Int'
sub.mean <- aggregate(Log2Intensity ~ Condition, data=oneproteindata, FUN=mean)
sub.mean

### 6.1.2 Calculate SD(standard deviation) per groups
# The same as mean calculation above. 'FUN' is changed to 'sd'.
sub.sd <- aggregate(Log2Intensity ~ Condition, data=oneproteindata, FUN=sd)
sub.sd

### 6.1.3 Count the number of observation per groups
# The same as mean calculation. 'FUN' is changed 'length'.
sub.len <- aggregate(Log2Intensity ~ Condition, data=oneproteindata, FUN=length)
sub.len

### 6.1.4 Calculate SE(standard error of mean) per groups
# SE = sqrt(s^2 / n)
sub.se <- sqrt(sub.sd$Log2Intensity^2/sub.len$Log2Intensity)
sub.se

# make the summary table including the results above (mean, sd, se and length).
summaryresult <- data.frame(Group=c("Condition1", "Condition2", "Condition3", "Condition4"),
                            mean=sub.mean$Log2Intensity,
                            sd=sub.sd$Log2Intensity, 
                            se=sub.se, 
                            length=sub.len$Log2Intensity)
summaryresult

### 6.1.2 Calculate mean per groups
summaryresult <- oneproteindata %>%
  group_by(Condition) %>%
  summarise(mean=mean(Log2Intensity),
            sd=sd(Log2Intensity),
            len=n())

summaryresult <- mutate(summaryresult,
                        se=sqrt(sd^2/len))

# oneproteindata %>%
#   group_by(Condition) %>%
#   summarise(mean=mean(Log2Intensity),
#             sd=sd(Log2Intensity),
#             lenght=n()) %>%
#   mutate(se=sqrt(sd^2/len))

## 6.2 Visualization with error bars for descriptive purpose
#‘error bars’ can have a variety of meanings or conclusions if what they represent is not precisely specified. 
# Below we provide some examples of which types of error bars are common. 
# We're using the summary of protein `sp|P44015|VAC2_YEAST` from the previous section and the `ggplot2` package as it provides a convenient way to make easily adaptable plots.

# Let's draw plots with mean and error bars

# means without any errorbar
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summaryresult)+
  geom_point(size=3)

# Let's change a number of visual properties to make the plot more atttractive
# Let's change the labels of x-axis and y-axis and title: 
# add labs(title="Mean", x="Condition", y='Log2(Intensity)')
# Let's change background color for white : add theme_bw()
# Let's change size or color of labels of axes and title, text of x-axis : in theme
# Let's change the position of legend :'none' remove the legend
# Let's make the box for legend
# Let's remove the box for legend key.

ggplot(aes(x=Condition, y=mean, colour=Condition), data=summaryresult)+
  geom_point(size=3)+
  labs(title="Mean", x="Group", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white'))

# Very similar but now as a bar plot.
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summaryresult)+
  geom_bar(position=position_dodge(), stat='identity')+
  scale_x_discrete('Condition')+
  labs(title="Mean", x="Group", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white'))

# For the sake of this tutorial, we'll continue adding error bars for different statistics with the point plots. 
# We'll leave it as an exercise to add error bars to the barplots. 
# Let's first add the standard deviation, then the standard error of the mean. Which one is smaller?

# mean with SD
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summaryresult)+
  geom_point(size=3)+
  geom_errorbar(aes(ymax = mean + sd, ymin=mean - sd), width=0.3)+
  scale_x_discrete('Group')+
  labs(title="Mean with SD", x="Group", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white'))

# mean with SE
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summaryresult)+
  geom_point(size=3)+
  geom_errorbar(aes(ymax = mean + se, ymin=mean - se), width=0.1)+
  labs(title="Mean with SE", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white'))

# The SE is narrow than the SD!

## 6.3 Calculate the confidence interval

# Now that we've covered the standard error of the mean and the standard deviation, 
# let's investigate how we can add custom confidence intervals (CI) for our measurement of the mean. 
# We'll add these CI's to the summary results we previously stored for protein `sp|P44015|VAC2_YEAST`

# Confidence interval : mean + or - (SE * alpha /2 { quantile of t distribution})$

# 95% confident interval
# Be careful for setting quantile for two-sided. need to divide by two for error.
# For example, 95% confidence interval, right tail is 2.5% and left tail is 2.5%.

summaryresult$ciw.lower.95 <- summaryresult$mean - qt(0.975,summaryresult$len-1)*summaryresult$se
summaryresult$ciw.upper.95 <- summaryresult$mean + qt(0.975,summaryresult$len-1)*summaryresult$se
summaryresult

# summaryresult <- summaryresult %>% mutate(ciw.lower.95 = mean - qt(0.975, len-1)*se,
#                                           ciw.upper.95 = mean + qt(0.975, len-1)*se)

# mean with 95% two-sided confidence interval
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summaryresult)+
  geom_point(size=3)+
  geom_errorbar(aes(ymax = ciw.upper.95, ymin=ciw.lower.95), width=0.1)+
  labs(title="Mean with 95% confidence interval", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white'))


#############################################
# 7. exercise!!
#############################################
