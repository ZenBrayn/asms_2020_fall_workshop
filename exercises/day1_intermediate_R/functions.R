# Functions
# "Everything that happens is a function call"
x <- 2
y <- 3
x + y
# Same as:
`<-`(x, 2)
`<-`(y, 3)
`+`(x, y)
# How to define a function?
mean_nona = function(x) {
    mean(x, na.rm = TRUE)
}
# Elements of a function:
body(mean_nona)
formals(mean_nona)
environment(mean_nona)
# Primitive functions:
body(sum)
formals(sum)
environment(sum)
# Functions can be passed as an argument, returned from a function and assigned.
mean_nona(c(NA, 1:100))
y = mean_nona
y(1:10)
# Functionals
summary_nona = function(x, func) {
    func(x, na.rm = TRUE)
}
summary_nona(c(NA, 1:10), sd)
summary_nona(c(NA, 1:10), mean)
summary_nona(c(NA, 1:10), function(x, ...) min(x, ...))
# Dots parameter:
summary_nona = function(x, func, ...) {
    func(x, na.rm = TRUE, ...)
}
summary_nona(c(NA, 1:10), mean, trim = 0.1)
# Default parameters:
summary_nona = function(x, func = mean, ...) {
    func(x, na.rm = TRUE, ...)
}
summary_nona(c(NA, 1:10), trim = 0.1)
summary_nona(c(NA, 1:10))
# Missing parameters:
summary_nona_mis = function(x, func) {
    if(missing(func)) {
        func = mean
    }
    func(x, na.rm = TRUE)
}
summary_nona_mis(1:10, mean)
summary_nona_mis(1:10)
# Dot parameters
# ERROR: mean(1:10, ...)
just_show_dots = function(...) {
    dots = list(...)
    for(i in 1:length(dots)) {
        print(paste("Dots at", i, ":", dots[[i]]))
    }
}
just_show_dots(x = 1, y = 2, z = 3, u = "ABC")

three_datasets = list(runif(10), runif(10), runif(10))
summary_nona_list = function(l, func, ...) {
    lapply(l, function(x) func(x, na.rm = TRUE, ...)) # notice the anonymous function
}
summary_nona_list(three_datasets, mean)
summary_nona_list(three_datasets, function(x, ...) max(x, ...) - min(x, ...)) # ...: small hack, anonymous function again
# More: https://adv-r.hadley.nz/functionals.html
summaries = list(mean, sd, max)
summary_nona_list2 = function(l, functions_list, ...) {
    lapply(l,
           function(x)
               lapply(functions_list,
                      function(func)
                          func(x, na.rm = TRUE, ...)))
    # notice the anonymous function
}
summary_nona_list2(three_datasets, summaries)
summaries2 = list(mean = mean, sd = sd, max = max)
summary_nona_list2(three_datasets, summaries2)
# Curious:
summaries2 = list("mean" = mean, "sd" = sd, "max" = max)
# More: https://adv-r.hadley.nz/function-operators.html - function factories that take function as an argument
# Closures
## Typical example:
powers = function(exponent) {
    function(x) {
        x ^ exponent
    }
}
powers(1)
powers(1)(1:10)
square = powers(2)
square(4)
## Interesting example: https://github.com/StatsIMUWr/logreghd/blob/dev/R/estimate_functions.R#L114
## Other interesting examples: https://adv-r.hadley.nz/function-factories.html#stat-fact
## Beware! (Taken from: https://adv-r.hadley.nz/function-factories.html)
x <- 2
square <- powers(x)
x <- 3
square(2)
## How to solve this? What's the problem?
power2 <- function(exp) {
    force(exp)
    function(x) {
        x ^ exp
    }
}

x <- 2
square <- power2(x)
x <- 3
square(2)
# Let's go back to the basics: https://adv-r.hadley.nz/functions.html
# Functions have:
# - formals
# - body
# - environment (only printed when it's not the global environment)
# Primitive functions call C code:
sum
# How does R look for values of variables used in a function?
# Lexical scoping: searching based on function definition, not call
# Four rules: https://adv-r.hadley.nz/functions.html#lexical-scoping
# - Name masking
#   Names inside a function mask names outside of it
x = 1
(function(x) 2)(x)
(function(y) {x = 3; x})(x)
#   If the name isn't defined inside the function, R checks *one level-up* - this is how closures work
# - Functions versus variables
#   If a variable and a function share a name, variable is ignored when evaluating function calls
# - A fresh start
#   Values are not saved between function calls
# - Dynamic lookup
#   R looks for values when the function is run (not when it is created)
x = 1
(function() x)()
f1 = function() x
f1()
x = 2
f1()
(function() x)()
# Lazy evaluation: function arguments are only evaluated when they are actually used
return_1 = function(x) 1
return_1(x = x)
return_1(x = no_such_variable)
return_1(no_such_variable)
return_1(stop("AAAAA!!"))
# How is it possible? R uses *promises* to evaluate expressions
# Promise: expression + environment + value

# Apply functions
x <- list(1:3, 4:6, 7:9)
lapply(x, sum)
sapply(x, sum)
vapply(x, sum, numeric(1))
# *Apply functions + anonymous functions
lapply(x, function(x) median(x, na.rm = TRUE))

# BONUS: subsettings strings as vectors
# To understand computations in R, two slogans are helpful:
#
# Everything that exists is an object.
# Everything that happens is a function call.
#
# — John Chambers
"abcde"[1]
# 1. Define a new class
x = "abcde"
class(x) = c("my_string", class(x))
class(x)

`[.my_string` = function(x, position, ...) {
    substr(x, position, position)
}

"abcde"[1]
x[1] == "a"
