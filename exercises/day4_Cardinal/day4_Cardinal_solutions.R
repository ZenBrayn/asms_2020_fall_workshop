##############################
##############################
## ASMS Fall workshop 2020 - Day 4: Cardinal Solutions
## Created by Melanie Foell
##############################
##############################

##### SOLUTIONS ######

## Q1: entering "pig206" contains all the information; other ways are possible as well:
# Q1a: 4959 spectra
# Q1b: 10200 mz features
# Q1c: 150.0833 to 1000.000 mz range
# Q1d: profile spectra mode

## Q2: object of interest: "iData(pig206)[1:15,1:15]"  
# Q2a: manually OR which(iData(pig206)[1:15,1:15] == max(iData(pig206)[1:15,1:15]),arr.ind=TRUE)## 14, 12
# Q2b: m/z feature: mz(pig206)[14] OR featureData(pig206)[14,]
#      pixel coordinates: pixelData(pig206)[12,] OR coord(pig206)[12,]

#Q3a: 
# plot(pig206, xlim=c(810,820)) # xlim can be any mz range, pick an m/z value from the x-axis at a position of a peaks maximum
# image(pig206, mz=812.5, plusminus=0.2) # mz can be any mz
#Q3b:
# change mz range that is plotted with different values for "plusminus"
# add to image function: ",contrast.enhance = "histogram" OR "suppression"
# add to image function: ",smooth.image = "gaussian" OR "adaptive"


#Q4a: # Peaks per spectrum corresponds to counting how often intensity > 0 per column
#     count_peaks = summarizePixels(pig206_peaks, function(c)sum(c>0)) ## count how many m/z per spectrum (column) are >0
#     image(count_peaks)
#Q4b: 57 m/z

#Q5: 
# the number of the class may be different for everyone, the topfeatures should be the same if set.seed(1) had been used

# brain - in the left part of the image
# topFeatures(pig206_ssc, model=list(s=20), class==4)
# image(pig206, mz=885.55, plusminus=0.2)

# liver - large oval-shaped area towards rigt of the image
# topFeatures(pig206_ssc, model=list(s=20), class==2)
# image(pig206, mz=536.9, plusminus=0.2)




