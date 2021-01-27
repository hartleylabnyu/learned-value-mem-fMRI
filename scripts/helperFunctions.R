# load libraries
library(tidyverse)

#Add age group variable to data frame with raw ages
addAgeGroup <- function(df, ageColumn){
  ageColumn <- enquo(ageColumn)
  df %>% mutate(ageGroup = case_when((!! ageColumn) < 13 ~ "Children",
                                             (!! ageColumn) > 12 & (!! ageColumn) < 18 ~ "Adolescents",
                                             (!! ageColumn) >= 18 ~ "Adults"), 
                ageGroup = factor(ageGroup, levels = c("Children", "Adolescents", "Adults")))
  
}

# Create ggplot theme
kate.theme <- theme(panel.background = element_rect(fill='transparent'),
                    axis.line = element_line(color='black'),
                    panel.grid.minor = element_line(color='transparent'),
                    axis.title.x = element_text(size=16, vjust=-.25),
                    axis.title.y = element_text(size=16, vjust=1),
                    axis.text.x = element_text(size=12, colour="black"),
                    axis.text.y = element_text(size=12, colour="black"),
                    panel.spacing.x = unit(2, "lines"),
                    legend.text=element_text(size=12),
                    legend.title = element_text(size = 14),
                    plot.title = element_text(size=16, face = "bold", hjust = .5), strip.text.x = element_text(size=12), strip.text.y = element_text(size=12, face="bold"), strip.background = element_rect(colour= "black", fill = "transparent"))

#Define 3 theme colors to use
color1 = "#749dae" #"#78C2C3"
color2 = "#5445b1" #"#3F6699" 
color3 = "#5c1a33" #"#0D1B4C"

#scale function
scale_this <- function(x){
  (x - mean(x, na.rm=TRUE)) / sd(x, na.rm=TRUE)
}

#standard error function
se <- function(x) sqrt(var(x)/length(x))
