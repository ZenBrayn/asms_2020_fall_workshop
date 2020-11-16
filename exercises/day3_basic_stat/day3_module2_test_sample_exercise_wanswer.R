##############################
##############################
## ASMS Fall workshop 2020 - Day 3: basic statistics
## part 2
## Created by Meena Choi
##############################
##############################

# start with 'iprg'
head(iprg)
prolist <- unique(iprg$Protein)

# 1. Please t-test between condition3 and condition4, for all proteins

allresult <- data.frame(Protein = NULL,
                        tstat = NULL,
                        pvalue = NULL)

for(i in 1:length(prolist)){
    
    sub <- iprg %>% filter(Protein %in% prolist[i]) %>%
        filter(Condition %in% c('Condition3', 'Condition4')) %>%
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

# 2. Please adjust pvalue by BH method
allresult$adj.pvalue <- p.adjust(allresult$pvalue, method="BH")

# 3. Please draw volcano plot for comparison between condition 3 and 4
# x-axis : log 2 fold change estimate,
# y-axis : -log10(adj.pvalue)
# add horizontal line at -log10(0.1)
# add vertical line at fold change = 1.5
# fix the range of x-axis : -8 to 8
# add title 'Comparison between condition3 and condition4'
# add protein name to dots, if proteins are significantly different between two groups
# change dot colot : red if significance, otherwise grey

p <- allresult %>%
    mutate(Significance=ifelse(adj.pvalue < 0.05, "P < .05", "P ≥ .05")) %>%
    ggplot(aes(x=log2fc, y=-log10(adj.pvalue))) +
    geom_point(aes(color=Significance)) +
    geom_hline(yintercept=-log10(0.1), linetype="dotted") +
    geom_vline(xintercept=c(-log2(1.5), log2(1.5)), linetype="dotted") +
    xlim(-8, 8)+
    labs(x=expression(log[2]~fold-change),
         y=expression(-log[10]~adjusted~p-value),
         title="Comparison between condition3 and condition4") +
    theme_minimal()+
    geom_text(data=filter(allresult, adj.pvalue < .05),
              mapping=aes(label=Protein))+
    scale_color_manual(values = c('red', 'grey'))

p

# 4. save volcaoplot as pdf
pdf('Volcanoplot_C3_vs_v4.pdf')
print(p)
dev.off()
