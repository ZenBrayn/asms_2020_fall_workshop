library(pryr)
library(profvis)
library(microbenchmark)
library(Rcpp)
library(data.table)
library(reshape2)

# Debugging ----
# Understanding the `traceback()`
f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) "a" + d
f(10)
traceback()

debug(i)
f(10)
undebug(i)

options(error=recover)
f(10)
options(error=NULL)
# Same can be achieved with browser()

# Memory allocation ----
x <- runif(10)
x[5] <- 10
x

x <- runif(10)
address(x)
x[5] <- 10
x
address(x)

x <- runif(1)
c(address(x), refs(x))
# [1] "0x103100060" "1"

y <- x
c(address(y), refs(y))
# [1] "0x103100060" "2"

x <- runif(10)
y <- x
c(address(x), address(y))
x[5] <- 6L
c(address(x), address(y))

x <- runif(10)
# Prints the current memory location of the object
tracemem(x)
# [1] "<0x7feeaaa1c6b8>"

x[5] <- 6L

y <- x
# Prints where it has moved from and to
x[5] <- 6L
# tracemem[0x7feeaaa1c6b8 -> 0x7feeaaa1c768]:

x <- runif(10)
c(address(x), refs(x))
# [1] "0x103100060" "1"

identity(x)

c(address(y), refs(y))
# [1] "0x103100060" "7"

# Data.frame and copies
x <- data.frame(matrix(runif(100 * 1e4), ncol = 100))
medians <- sapply(x, median)

tracemem(x)

for (i in seq_along(medians))
    x[,i] <- x[,i] - medians[i]

x$new_col = 1

y <- as.list(x)
tracemem(y)
for (i in seq_along(medians))
	y[[i]] <- y[[i]] - medians[i]

# It gets worse:
address(x)
colnames(x) = paste(colnames(x), "_new")
address(x)

# data.table is robust to some of these problems
x2 <- data.table(matrix(runif(100 * 1e4), ncol = 100))
medians <- sapply(x2, median)

tracemem(x)
head(x2[1:10, 1:10, with = FALSE])
for (i in seq_along(medians))
    x2[, colnames(x2)[i] := list(x2[[i]] - medians[i])]
head(x2[1:10, 1:10, with = FALSE])

x2[, new_col := "1"]

address(x2)
setnames(x2, "new_col", "newer_col")
address(x2)

input = fread("./data/Choi2017_DDA_Skyline_input.csv")
input = input[, list(Abundance = mean(log(ifelse(Area < 1, 1, Area), 2)), na.rm = TRUE),
      by = c("ProteinName", "PeptideSequence", "PrecursorCharge",
             "FileName", "BioReplicate", "Condition")]
input$feature = paste(input$PeptideSequence, input$PrecursorCharge, sep = "_")

input$feature
loop_function = function(input) {
    proteins = unique(input$ProteinName)
    results = list()
    for (protein in proteins) {
        sub = input[input$ProteinName == protein]
        run_feature = sub[, list(FileName, feature, Abundance)]
        runs = run_feature$FileName
        run_feature = reshape2::dcast(run_feature, FileName ~ feature,
                                      value.var = "Abundance")
        medp = medpolish(run_feature[, -1], na.rm = TRUE, trace.iter = FALSE)
        result = data.frame(ProteinName = protein,
                            Run = runs,
                            Abundance = medp$overall + medp$row)
        results = c(results, list(result))
    }
    do.call("rbind", results)
}

# Brainstorming:
## - problems with this function?
## profiling: what are the bottlenecks?
## what are alternative implementations?
## - can apply functions help?
## how to actually improve the speed?
# profvis::profvis(loop_function(input[ProteinName %in% unique(input$ProteinName)[1:100], ]))
