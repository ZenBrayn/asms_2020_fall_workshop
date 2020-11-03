
#### Part I exploring data ####

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("CardinalWorkflows")

library(CardinalWorkflows)

data("pig206", package="CardinalWorkflows")

rm(pig206.peaklist)
rm(pig206.peaks)
gc()

pig206

pig206 = as(pig206, 'MSImagingExperiment')

pig206
## Question 1

writeImzML(pig206, "pig206")

# m/z 
featureData(pig206)
fData(pig206)
mz(pig206)
class(mz(pig206))
length(mz(pig206))
range(mz(pig206))

# pixels/spectra
pixelData(pig206)
pData(pig206)
head(run(pig206))
head(coord(pig206))

# intensities
imageData(pig206)
iData(pig206)[1:15,1:15]
## Question 2

# visualizations

image(pig206, mz=222, plusminus=0.2)

plot(pig206, pixel=10)
plot(pig206, pixel=10, xlim=c(220, 230))
plot(pig206, xlim=c(220,230))
abline(v=221.5, col="green")
abline(v=227.5, col="orange")

image(pig206, mz=221.5, plusminus=0.2)
image(pig206, mz=227.5, plusminus = 0.2)

## Question 3

# special ion images

pig206_tic = summarizePixels(pig206, "sum")
image(pig206_tic)

# special spectra

pig206_mean = summarizeFeatures(pig206, "mean")
plot(pig206_mean)

#### Part II: pre-processing #### 

# generation of mz peak list

pig206_ref <- peakPick(pig206_mean, SNR=3)
pig206_ref
pig206_ref <- peakAlign(pig206_ref, ref="mean", tolerance=0.5, units="mz")
pig206_ref <- peakFilter(pig206_ref, freq.min = 0.01, rm.zero = TRUE)
pig206_ref <- process(pig206_ref)

plot(pig206_ref)
pig206_ref

# normalization
pig206_normalized <- normalize(pig206, method = "rms")
pig206_normalized <- process(pig206_normalized)

# peak integration

pig206_peaks <- peakBin(pig206_normalized, ref=mz(pig206_ref), tolerance = 0.5, units = "mz")
pig206_peaks <- process(pig206_peaks)

pig206_peaks
plot(pig206_peaks)

# Question 4

#### PART III: segmentation ####

set.seed(1)
pig206_ssc <- spatialShrunkenCentroids(pig206_peaks, method="adaptive", r=2, 
                                       s=c(0,5,10,15,20,25), k=10)

summary(pig206_ssc)

image(pig206_ssc, model=list(s=c(0,10,20)))
image(pig206_ssc, model=list(s=20))

plot(pig206_ssc, model=list(s=20))

plot(pig206_ssc, model=list(s=20), values="statistic", lwd=2)

# heart
topFeatures(pig206_ssc, model=list(s=20), class==6)
image(pig206, mz=187.3, plusminus=0.2)

## Question 5





