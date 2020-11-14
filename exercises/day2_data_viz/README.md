# Instructions for Working with Day 2 Exercises

Before you start working on the exercises, you need to make sure that:

1. R is installed ([https://cloud.r-project.org](https://cloud.r-project.org))
2. RStudio is installed ([https://rstudio.com/products/rstudio/download/](https://rstudio.com/products/rstudio/download/))
3. The following R packages are installed:
    * `tidyverse`
    * `rmarkdown`
    * `datasauRus`
    * `dendextend`
    * `Rtsne`
    * `gplots`
    * `eulerr`
    * `UpSetR`
4. These packages can be installed by:
    1. Launch RStudio
    2. In the application menu, choose: *Tools -> Install Packages...*
    3. In the *Packages* field, enter the package names above (separated with spaces or commas)
    4. Click the *Install* button.
    5. Note: this could take a few minutes
5. These additional R packages are installed from [Bioconductor](http://bioconductor.org).  Execute the following code inside the RStudio console:

```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("MSstats")
BiocManager::install("MSstatsBioData")
```

## 

1. Download the workshop repository (or clone if you know Git): [https://github.com/ZenBrayn/asms_2020_fall_workshop/archive/main.zip](https://github.com/ZenBrayn/asms_2020_fall_workshop/archive/main.zip)
2. Unzip the downloaded file if needed
3. The data required for the exercises is located in the folder you just downloaded under `data/iPRG2015-Skyline.zip`. 
    1. Copy the data folder to the exercises folder`exercises/day2_data_viz`
    2. Unzip the file `data/iPRG2015-Skyline.zip`
    3. You should now have folder(s) called `data/iPRG2015-Skyline` inside the `exercises/day2_data_viz` folder
4. Double click the `day2_data_viz.Rproj` file to open the RStudio project
5. Follow along with the hands-on lecture using the files
	- `exercises/day2_data_viz/day2a-ggplot2.Rmd`
	- `exercises/day2_data_viz/day2b-msplots.Rmd`
6. You can "compile" the RMarkdown (.Rmd) file by clicking the *Knit* button towards the top left of the RStudio interface (it's small, look for the icon that looks like a ball of yarn and a needle).  This will create an HTML output of the document that you can view in your web browser.
6. Based on the code in the lectures, complete the exercises:
	- `exercises/day2_data_viz/day2-exercises.Rmd`
	- Ask for help if you need it!
