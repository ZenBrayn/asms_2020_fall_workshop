##############################
##############################
## ASMS Fall workshop 2020 - Day 4: Cardinal Exercises
## Created by Melanie Foell
##############################
##############################

#### Questions for Part I ####
##############################

## Q1: Answer the following questions about the pig206 dataset: 
# Q1a: How many spectra?
# Q1b: How many features?
# Q1c: Which m/z range?
# Q1d: Profile or centroided spectra? 

## Q2: Answer the following questions about the subsetted intensity matrix (iData(pig206)[1:15,1:15])
# Q2a: Which row -column  pair has the highest intensity in this data subset?
# Q2b: which mz and coordinates do they correspond to?

## Q3: Plot more visualizations
# Q3a: Choose one random mz value by zooming into the average spectrum and plot the ion images for it
# Q3b: Explore the fine tuning options for the ion images (?Cardinal::image), choose different plotting settings to smooth the image, enhance the contrast, change m/z window range etc. 

#### Questions for Part II ####
###############################

## Q4: Pre-processing parameters and visualizations
# Q4a: Plot the number of peaks per spectrum after pre-processing into a x-y coordinate grid
# Q4b: In the peakpicking method, set SNR to 5, how many m/z peaks will be picked? 

#### Questions for Part III ####
################################

## Q5: Find the classes that correspond to brain and liver, find their top m/z feature and plot their ion images
