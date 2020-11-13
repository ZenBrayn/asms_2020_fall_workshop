##############################
##############################
## ASMS Fall workshop 2020 - Day 3: basic statistics
## part 2
## Created by Meena Choi
##############################
##############################


#library(tidyverse)

#iprg <- read.csv("iPRG_example_runsummary.csv")

#############################################
# 7. Statistical hypothesis test in R
## Two sample t-test for one protein with one feature
#############################################

# Next, we'll perform a t-test whether protein `sp|P44015|VAC2_YEAST` has a change in abundance 
# between Condition 1 and Condition 2.

# First, get two conditions only, because t.test only works for two groups (conditions).
sub <- oneproteindata[which(oneproteindata$Condition %in% 
                              c('Condition1', 'Condition2')), ]

sub <- oneproteindata %>% filter(Condition %in% c('Condition1', 'Condition2'))

sub <- oneproteindata %>% filter(Condition =='Condition1' | Condition ==  'Condition2')

unique(sub$Condition)
unique(oneproteindata$Condition)

# t test for different abundance (log2Int) between Groups (Condition)
# If you want to see more details, 
?t.test

sub

result <- t.test(Log2Intensity ~ Condition, data=sub,
                 var.equal=FALSE)

# show the summary of t-test including confidence interval level with 0.95
result

# We can redo the t-test and change the confidence interval level for the log2 fold change.
result.ci90 <- t.test(Log2Intensity ~ Condition, data=sub,
                      var.equal=FALSE, 
                      conf.level=0.9)
result.ci90

# Let's have a more detailed look at what information we can learn from the results our t-test. 

# name of output
names(result)

# mean for each group
result$estimate 

# log2 transformed fold change between groups : Condition1 - Condition2
result$estimate[1]-result$estimate[2]

# test statistic value, T value
result$statistic 

# standard error
(result$estimate[1]-result$estimate[2])/result$statistic

# degree of freedom
result$parameter 

# p value for two-sides testing
result$p.value 

# 95% confidence interval for log2 fold change
result$conf.int 

# p value calculation for one side
1-pt(result$statistic, result$parameter)

# p value for two sides, which is the same as pvalue from t test (result$p.value)
2*(1-pt(result$statistic, result$parameter))

# We can also manually compute our t-test statistic using the formulas we described above and 
# compare it with the `summaryresult` 

summaryresult

summaryresult12 <- summaryresult[c(1,2), ]

# test statistic, It is the same as 'result$statistic' above.
diff(summaryresult12$mean) # same as result$estimate[1]-result$estimate[2]
sqrt(sum(summaryresult12$sd^2/summaryresult12$len)) # same as stand error

diff(summaryresult12$mean)/sqrt(sum(summaryresult12$sd^2/summaryresult12$len))

###### Let's try for all proteins!
## calculate summaries for 'all' proteins
summaryall <- iprg %>%
  group_by(Protein, Condition) %>%
  summarise(mean = mean(Log2Intensity),
            sd = sd(Log2Intensity),
            len = n())
summaryall

summaryall <- mutate(summaryall,
                     se = sqrt(sd^2/len),
                     lower = mean - qt(0.975, len-1)*se,
                     upper = mean + qt(0.975, len-1)*se)

summaryall


## plot for each protein

## How the loop works
for(i in 1:10){
  print(i)
  i <- i+1
}

pdf('iprg_10protein_errorbar.pdf', width = 6, height=5)
for(i in 1:10){
  
  sub <- summaryall %>% filter(Protein == unique(summaryall$Protein)[i])
  
  p <- ggplot(data= sub,
            aes(x=Condition, y=mean, colour=Condition)) + 
    geom_point() + 
    labs(title = unique(sub$Protein),
         y = 'mean of Log2(Intensity)') + 
    theme_bw() +
    theme(
      legend.position = 'bottom',
      legend.background = element_rect(colour = 'black'),
      legend.key = element_rect(colour='white')
      )
  
  p <- p + geom_errorbar(aes(ymax= upper, ymin= lower), 
                         width=0.1)
  print(p)
  
}
dev.off()


## t.test for each protein
## all proteins
prolist <- unique(iprg$Protein)

## if we use 'for' function for looping

# first, set up the table to record the results
allresult <- data.frame(Protein = NULL,
                        tstat = NULL,
                        pvalue = NULL)

for(i in 1:length(prolist)){

  sub <- iprg %>% filter(Protein %in% prolist[i]) %>%
    filter(Condition %in% c('Condition1', 'Condition2')) %>%
    filter(!is.na(Log2Intensity))
  
  ## t.test
  result <- t.test(Log2Intensity ~ Condition,
                   data = sub)
  
  tmp <- data.frame(Protein =unique(sub$Protein),
                    log2fc = result$estimate[1]-result$estimate[2],
                    tstat = result$statistic,
                    pvalue = result$p.value)
  
  allresult <- rbind(allresult, 
                     tmp)
  print(i)
}

head(allresult)


## adjust p value
allresult$adj.pvalue <- p.adjust(allresult$pvalue, method="BH")


## Volcano plot
allresult %>%
  mutate(Significance=ifelse(adj.pvalue < 0.05, "P < .05", "P ≥ .05")) %>%
  ggplot(aes(x=log2fc, y=-log10(adj.pvalue))) +
  geom_point(aes(color=Significance)) +
  geom_hline(yintercept=-log10(0.05), linetype="dotted") +
  geom_vline(xintercept=c(-1, 1), linetype="dotted") +
  labs(x=expression(log[2]~fold-change),
       y=expression(-log[10]~adjusted~p-value),
       title="Volcano plot with reference lines") +
  theme_minimal()

allresult %>%
  mutate(Significance=ifelse(adj.pvalue < 0.05, "P < .05", "P ≥ .05")) %>%
  ggplot(aes(x=log2fc, y=-log10(adj.pvalue))) +
  geom_text(data=filter(allresult, adj.pvalue < .05),
            mapping=aes(label=Protein)) +
  geom_point(aes(color=Significance)) +
  labs(x=expression(log[2]~fold-change),
       y=expression(-log[10]~adjusted~p-value),
       title="Volcano plot with labeled points") +
  theme_minimal()


## heatmap
## make wide format, first
?spread
wideiprg <- iprg %>% select('Protein', 'Run', 'Log2Intensity')
wideiprg <- iprg %>% select('Protein', 'Run', 'Log2Intensity') %>% 
  spread(Run, Log2Intensity)
head(wideiprg)

crc <- t(as.matrix(wideiprg[,-1]))
crc[1:10, 1:10]
colnames(crc) <- wideiprg$Protein
crc[1:10, 1:10]
sum(is.na(crc))


## fill in NA values
crc <- apply(crc, 2, function(x) ifelse(is.na(x), median(x, na.rm=TRUE), x))

heatmap(crc)

wideiprg.sub <- wideiprg %>% filter(Protein %in% c('sp|P44015|VAC2_YEAST',
                                         'sp|P55249|ZRT4_YEAST',
                                         'sp|P44374|SFG2_YEAST',
                                         'sp|P44983|UTR6_YEAST',
                                         'sp|P44683|PGA4_YEAST',
                                         'sp|P55249|ZRT4_YEAST',
                                         'sp|D6VTK4|STE2_YEAST',
                                         'sp|Q08746|RRS1_YEAST',
                                         'sp|Q08742|RDL2_YEAST',
                                         'sp|Q04322|GYL1_YEAST'))

crc.sub <- t(as.matrix(wideiprg.sub[,-1]))
crc.sub
colnames(crc.sub) <- wideiprg.sub$Protein
crc.sub

heatmap(crc.sub)

condition <- substr(rownames(crc.sub), start=13, stop=19)
condition.color <- as.character(factor(condition, labels = c('red', 'blue', 'yellow', 'green')))

heatmap(crc.sub, RowSideColors=condition.color)

library("RColorBrewer")
col <- colorRampPalette(brewer.pal(10, "RdYlBu"))(256)
heatmap(crc.sub, 
        col =  col,
        #scale = 'col',
        RowSideColors=condition.color)
        






