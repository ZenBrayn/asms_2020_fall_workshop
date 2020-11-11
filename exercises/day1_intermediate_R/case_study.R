file_path = "./data/Choi2017_DDA_Skyline_input.csv"
remove_shared = TRUE
remove_single = TRUE
keep_top = FALSE
n_top = 3
normalize = FALSE
## Reading files
input = read.csv(file_path)
# input = input[input$ProteinName %in% unique(input$ProteinName)[1:100], ]
input = input[, c("ProteinName", "PeptideModifiedSequence", "PrecursorCharge",
                  "Condition", "BioReplicate", "FileName", "Area", "Truncated")]
input$Area = ifelse(input$Truncated == "True", NA, input$Area)
colnames(input)[colnames(input) == "PeptideModifiedSequence"] = "PeptideSequence"
colnames(input)[colnames(input) == "FileName"] = "Run"
colnames(input)[colnames(input) == "Area"] = "Intensity"
input$Intensity = as.numeric(input$Intensity)
# Aggregate isotopic peaks
annotation = unique(input[, c("Run", "Condition", "BioReplicate")])
aggregated = aggregate(Intensity ~ ProteinName + PeptideSequence + PrecursorCharge + Run,
                       data = input, FUN = function(x) sum(x, na.rm = TRUE))
input = merge(aggregated, annotation, by = "Run")
input$Abundance = log(ifelse(input$Intensity < 1, 1, input$Intensity), 2)
input$feature = paste(input$PeptideSequence, input$PrecursorCharge, sep = "_")
# Remove shared peptides
if(remove_shared){
counts = aggregate(. ~ PeptideSequence,
                       data=unique(input[, c("PeptideSequence", "ProteinName")]),
                       FUN=length)
counts = counts[counts$ProteinName > 1, ]
input = input[!(input$PeptideSequence %in% counts$PeptideSequence), ]
}
if(remove_single){
    # Remove proteins with a single feature
    counts = aggregate(. ~ ProteinName,
                       data = unique(input[, c("ProteinName", "feature")]),
                       FUN = length)
    counts = counts[counts$feature == 1, ]
    input = input[!(input$ProteinName %in% counts$ProteinName), ]
}
if(keep_top){
    aggregated = aggregate(Abundance ~ ProteinName + feature,
                           data = input,
                           FUN = function(x) mean(x, na.rm = TRUE))
    aggregated$ProteinName = factor(aggregated$ProteinName)
    aggregated$feature = factor(aggregated$feature)
    by_protein = split(aggregated, aggregated$ProteinName)
    by_protein = lapply(by_protein, function(x) {
        x$rank = rank(-x$Abundance)
        x[x$rank <= n_top, ]
    })
    filtered = do.call("rbind", by_protein)
    input = input[input$feature %in% filtered$feature, ]
}
# Normalize
if(normalize){
    run_median = aggregate(Abundance ~ Run, input,
                           function(x) median(x, na.rm = TRUE))
    for (run in unique(input$Run)) {
        input[input$Run == run, "Abundance"] = input[input$Run == run, "Abundance"] - run_median[run_median$Run == run, "Abundance"]
    }
}

# Summarize
proteins = unique(input$ProteinName)
results = list()
for (protein in proteins) {
    sub = input[input$ProteinName==protein, ]
    run_feature = sub[, c("Run","feature","Abundance")]
    run_feature = reshape2::dcast(run_feature, Run ~ feature,
                                  value.var = "Abundance")
    runs = run_feature$Run
    medp = medpolish(run_feature[, -1], na.rm=TRUE,trace.iter = FALSE)
    result = data.frame(ProteinName = protein,
                        Run = runs,
                        Abundance = medp$overall+medp$row)
    results = c(results, list(result))
}
summarized = do.call("rbind", results)


# loop_grow = function(x) {
#     l = list()
#     for (i in 1:x) {
#         l = c(l, list(i))
#     }
#     l
# }
#
# loop_no_grow = function(x) {
#     l = vector("list", x)
#     for (i in 1:x) {
#         l[[i]] = i
#     }
#     l
# }
#
# microbenchmark::microbenchmark(grow = loop_grow(1000),
#                                nogrow = loop_no_grow(1000))
