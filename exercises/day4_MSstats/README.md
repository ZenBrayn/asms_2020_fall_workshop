# Instructions for Working with Day 4 - MSstats Exercises

Before you start working on the exercises, you need to make sure that:

1. R is installed ([https://cloud.r-project.org](https://cloud.r-project.org))
2. RStudio is installed ([https://rstudio.com/products/rstudio/download/](https://rstudio.com/products/rstudio/download/))
3. The following R packages are installed from Bioconductor -- execute the code below in the R console
```
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("MSstats")
```


## 

1. Download the workshop repository (or clone if you know Git): [https://github.com/ZenBrayn/asms_2020_fall_workshop/archive/main.zip](https://github.com/ZenBrayn/asms_2020_fall_workshop/archive/main.zip)
2. Unzip the downloaded file if needed
3. The data required for the exercises is located in the folder you just downloaded under `data/iPRG2015-Skyline.zip` and `data/iPRG2015_MaxQuant.zip`. 
    1. Copy both zip files to the exercises folder`exercises/day4_MSstats`
    2. Unzip the files
    3. You should now have two folders called `iPRG2015-Skyline` and `iPRG2015_MaxQuant` inside the `exercises/day4_MSstats` folder
4. The exercises are located in the folder `exercises/day4_MSstats`
5. Double click the `day4_MSstats.Rproj` file to open the RStudio project
6. Open the .R files and execute the code for the examples and exercises covered in the workshop
