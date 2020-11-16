##############################
##############################
## ASMS Fall workshop 2020 - Day 3: basic statistics
## Created by Meena Choi
##############################
##############################

# start with 'iprg'
# 1. generate new data.frame, called, 'secondprotein', including the protein 'sp|P55249|ZRT4_YEAST'
# either ways
secondprotein <- iprg[iprg$Protein == "sp|P55249|ZRT4_YEAST", ]

secondprotein <- iprg %>% filter(Protein == "sp|P55249|ZRT4_YEAST")


# 2. Generate dot plot (mean for each group) with error bar (99% confidence interval)
# feel free to change labels (x-axis, y-axis, title)
# make the summary table including the results above (mean, sd, se and length).
summary <- secondprotein %>%
  group_by(Condition) %>%
  summarise(mean=mean(Log2Intensity),
            sd=sd(Log2Intensity),
            len=n()) %>%
  mutate(se=sqrt(sd^2/len)) %>% 
  mutate(ciw.lower.99 = mean - qt(0.995, len-1)*se,
         ciw.upper.99 = mean + qt(0.995, len-1)*se)

summary

ggplot(aes(x=Condition, y=mean, colour=Condition), data=summary)+
  geom_point(size=3)+
  geom_errorbar(aes(ymax = ciw.upper.99, ymin=ciw.lower.99), width=0.1)+
  labs(title="Mean with 99% confidence interval", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white'))

# 3. Change the color of dots and error bars
# Please check day 2a=ggplot2 section.
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summary)+
  geom_point(size=3)+
  geom_errorbar(aes(ymax = ciw.upper.99, ymin=ciw.lower.99), width=0.1)+
  labs(title="Mean with 99% confidence interval", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white')) +
  scale_colour_brewer(palette="Dark2") ## here is change

# 4. Change the range of y-axis, from 10 to 30
ggplot(aes(x=Condition, y=mean, colour=Condition), data=summary)+
  geom_point(size=3)+
  geom_errorbar(aes(ymax = ciw.upper.99, ymin=ciw.lower.99), width=0.1)+
  labs(title="Mean with 99% confidence interval", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white')) +
  scale_colour_brewer(palette="Dark2")+ 
  ylim(10, 30) ## here is change

# 5. Chage dot plot to barplot
ggplot(aes(x=Condition, y=mean, fill=Condition), data=summary)+ ## here is change, 'fill' should be added, remove 'colour'
  geom_bar(position=position_dodge(), stat='identity')+
  geom_errorbar(aes(ymax = ciw.upper.99, ymin=ciw.lower.99), width=0.1)+
  labs(title="Mean with 99% confidence interval", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white')) +
  scale_fill_brewer(palette="Dark2") ## here is change

# 6. save this plot as pdf'
pdf('barplot_P55249.pdf', width=7, height=5)
ggplot(aes(x=Condition, y=mean, fill=Condition), data=summary)+ ## here is change, 'fill' should be added, remove 'colour'
  geom_bar(position=position_dodge(), stat='identity')+
  geom_errorbar(aes(ymax = ciw.upper.99, ymin=ciw.lower.99), width=0.1)+
  labs(title="Mean with 99% confidence interval", x="Condition", y='Log2(Intensity)')+
  theme_bw()+
  theme(plot.title = element_text(size=25, colour="darkblue"),
        axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        axis.text.x = element_text(size=13),
        legend.position = 'bottom',
        legend.background = element_rect(colour='black'),
        legend.key = element_rect(colour='white')) +
  scale_fill_brewer(palette="Dark2") ## here is change
dev.off()

