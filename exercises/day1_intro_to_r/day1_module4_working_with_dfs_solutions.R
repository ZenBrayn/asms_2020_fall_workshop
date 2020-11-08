# ASMS Fall Workshop -- R Fundamentals and Best Practices for Mass Spectrometry Data Analysis
# Day 1, Module 4: Working with Data Frames (tibbles)
#

# BE SURE TO LOAD THE TIDYVERSE LIBRARY
library(tidyverse)

# Exercise #1 -- Reading Data
# 
# 1.1 Example data from a proteomics experiment is located at the folllowing path:
#     iPRG2015-Skyline/Choi2017_DDA_Skyline_input.csv
#     What kind of file is this?  Read this data frame into a variable.
dat <- read_csv("iPRG2015-Skyline/Choi2017_DDA_Skyline_input.csv", guess_max = 10000)

# Exercise #2 -- Reviewing Data Frames
#
# 2.1 Review some basic properties of the data frame
#     - How many rows?  How many columns?
nrow(dat)
ncol(dat)

#     - How many rows & columns (use one expression)
dim(dat)

#     - What are the column names?
names(dat)

#     - What are the data types stored in each column?
# print out dat to the screen and you can see the column types
dat

#     - Use the View function to review the data in RStudio.
#       What kind of data is present?  What is the structure of the data?
#
#     - It appears that some of the data is duplicated across many rows?
#       Look at the data column by column and see if you can understand why.
View(dat)

# Exercise #3 -- Working with Data Frames
#
# 3.1 Retrieve the data from the column call "FileName"
#     How many values do you expect to get?  Write an
#     expression using the data you retrieved to see if
#     your guess is correct.
# you'd expect to have the same number of values are there is rows
length(dat$FileName)
nrow(dat)

# 3.2 How many unique values of the data from "FileName" are there?
#     What are these values and what do they correspond to?
unique(dat$FileName)

# 3.3 Using data frame indexing syntax, subset the data to rows
#     for the protein "sp|P33399|LHP1_YEAST"
dat[dat$ProteinName == "sp|P33399|LHP1_YEAST",]

# 3.4 How many unique peptides are present in the data for the
#     above protein?
# first store the subset in a variable
dat_subset <- dat[dat$ProteinName == "sp|P33399|LHP1_YEAST",]
# Now calculate the number of unique peptides
peptides <- dat_subset$PeptideSequence
unique_peptides <- unique(peptides)
length(unique_peptides)

# Or you can do it with one expression
length(unique(dat_subset$PeptideSequence))


