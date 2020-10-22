# ASMS Fall Workshop -- R Fundamentals and Best Practices for Mass Spectrometry Data Analysis
# Day 1, Module 2: First Steps with R
# 

# Exercise #1 -- Working with Variables
# 
# You are running an LC-MS experiment using a 60 min LC gradient
#
# 1.1 Create a variable called gradient_min to hold the length of the
#     gradient in minutes.


# 1.2 Using the gradient length variable you just created, convert
#     it to seconds and assign it to a new variable with a meaningful name.


# Exercise #2 -- Working with Vectors
#
# Continuing from Exercise #1...
#
# 2.1 Imagine you conducted additional experiments, one with a 15 minute
#     gradient and one with a 60 min gradient.  Create a vector to hold
#     all three gradient times in minutes, and assign it to a new variable.


# 2.2 Convert the vector of gradient times to seconds.  How does this
#     conversion compare to how you did the conversion in Exercise 1?


# Exercise #3 -- More Practice with Vectors
#
# 3.1 The following vector represents precursor m/z values for
#     detected features from your experiment:
prec_mz <- c(968.4759, 812.1599, 887.9829, 338.5294, 510.2720, 
             775.3455, 409.2369, 944.0385, 584.7687, 1041.9523)
#     - How many values are there?

#     - What is the minimum value?  The maximum?


# Exercise #4 -- Vectors and Conditional Expressions
#
# 4.1 Using the above vector of precursor values, write a
#     conditional expression to find the values with m/z < 600.
#     What is returned by this expression? A single value or
#     multiple values?  A number or something else?


# 4.2 Use this conditional expression to get the precursor values
#     with m/z < 600


# 4.3 Consider a new vector of data that contains the charge states of
#     the same detected features from above:
prec_z <- c(2, 4, 2, 3, 2, 2, 2, 2, 2, 2)
#     Write a conditional expression to find the detected features
#     that have a charge state of 2.


# 4.4 Write an expression to get the precursor m/z values for features 
#     having charge states of 2?



