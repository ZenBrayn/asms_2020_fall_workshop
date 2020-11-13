####### install MSstats
####### This step is required, if you haven't installed MSstats in your local computer or laptop.

# install.packages("BiocManager")
# BiocManager::install("MSstats")

library(MSstats)

# First, get protein ID information
proteinGroups <- read.table("Choi2017_DDA_MaxQuant_proteinGroups.txt", sep = "\t", header = TRUE)

# Read in MaxQuant file: evidence.txt
evi <- read.table("Choi2017_DDA_MaxQuant_evidence.txt", sep="\t", header=TRUE)

# Read in annotation including condition and biological replicates: annotation.csv
annot.maxquant <- read.csv("Choi2017_DDA_MaxQuant_annotation.csv", header = TRUE)
annot.maxquant

?MaxQtoMSstatsFormat

# reformating and pre-processing for MaxQuant output.
# no protein with 1 peptide
input.maxquant <- MaxQtoMSstatsFormat(evidence=evi, 
                                      annotation=annot.maxquant,
                                      proteinGroups=proteinGroups,
                                      removeProtein_with1Peptide=TRUE)
head(input.maxquant)

#### Preliminary check
### Question 1: how many proteins are available in inptu.maxquant?


### Question 2 : how many NA intensities are in input.maxquant?


### Question 3 : how many intensities=0 are in input.mqxquant?


# save your work
#save(input.maxquant, file='answer/input.maxquant.rda')

### Question 4 : Please use dataProcess for input.maxquant for imputation and robust summarization
### Please use quantile normalization for dataProcess
### !! note : for maxquant, censored intensity should be 'NA' (not '0')


### Question 5 : Please generate QC plot to check normalization.


### Question 6 : Please generate profile plot for protein 'P55249'


# save your work
#save(quant.maxquant, file='answer/quant.maxquant.rda')


## inference

### Question 7 : Please generate contrast matrix for three comparisons : 
### 'Condition2 - Condition1', 'Condition3 - Condition2', 'Condition4 - Condition3' 
unique(quant.maxquant$ProcessedData$GROUP_ORIGINAL)


## next step, run groupComparison function
test.maxquant <- groupComparison(contrast.matrix=comparison, data=quant.maxquant)
MaxQuant.result <- test.maxquant$ComparisonResult

# save your work
#save(MaxQuant.result, file='answer/MaxQuant.result.rda')

### Question 8 : save MaxQuant.result as csv file.


### Question 9 : make volcano plot for MaxQuant.result


