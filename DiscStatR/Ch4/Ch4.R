# Graphs

# First
facebookData <- read.delim("FacebookNarcissism.dat", header =TRUE)
facebookData
graph <- ggplot(facebookData, aes(NPQC_R_Total, Rating))
graph + geom_point()
graph + geom_point(shape = 17)
graph + geom_point(size = 6)
graph + geom_point(aes(colour = Rating_Type))
graph + geom_point(aes(colour = Rating_Type), position = "jitter")
graph + geom_point(size = 4, aes(colour = Rating_Type), position = "jitter")

#4.5.2
examData <- read.delim("Exam Anxiety.dat", header = TRUE)
View(examData, "Exam Data")
scatter <- ggplot(examData, aes(Anxiety, Exam))
scatter + geom_point()
scatter + geom_point() + labs(x = "Exam Anxiety", y = "Exam Performance %")
scatter + geom_point() + geom_smooth() + labs(x = "Exam Anxiety", y = "Exam Performance %")
scatter + geom_point() + geom_smooth(method = "lm") + labs(x = "Exam Anxiety", y = "Exam Performance %")
scatter + geom_point() + geom_smooth(method = "lm", colour = "Red") + labs(x = "Exam Anxiety", y = "Exam Performance %")
scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", se = F) + labs(x = "Exam Anxiety", y = "Exam Performance %")
scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", alpha = 0.1, fill = "Blue") + labs(x = "Exam Anxiety", y = "Exam Performance %")

#4.5.3
scatter <- ggplot(examData, aes(Anxiety, Exam, colour = Gender))
scatter + geom_point() + geom_smooth(method = "lm")
scatter + geom_point() + geom_smooth(method = "lm", aes(fill = Gender), alpha = 0.1)
scatter + geom_point() + geom_smooth(method = "lm", aes(fill = Gender), alpha = 0.1) + labs(x = "Exam Aniexty", y = "Exam Performance %", colour = "Gender")

#Self-test
graph + geom_point(size = 4, aes(colour = Rating_Type), position = "jitter") + geom_smooth(method = "lm")
graph + geom_point(size = 4, aes(colour = Rating_Type), position = "jitter") + geom_smooth(method = "lm", aes(fill = Rating_Type), alpha = 0.1) + aes(colour = Rating_Type) + labs(x = "Rating",y = "NPQRC R Total", colour = "Rating_Type")

#4.6
festivalData <- read.delim("DownloadFestival.dat", header = TRUE)
festivalHistogram <- ggplot(festivalData, aes(day1)) + theme(legend.position ="none") #opts() as used in book has been depreciated in favour of theme()
festivalHistogram + geom_histogram()
festivalHistogram + geom_histogram(binwidth = 0.4)
festivalHistogram + geom_histogram(binwidth = 0.4) + labs(x = "Hygiene (Day 1 of Festival)", y = "Frequency")

install.packages("DSUR")
library(DSUR)

setwd('E:\\Learning\\R\\Ch4')
festivalData <- read.delim("DownloadFestival.dat",header=TRUE)
View(festivalData)
library(ggplot2)
festivalData<-festivalData[order(festivalData$day1),]
View(festivalData[])
festivalData<-festivalData[-c(810),]
festivalData<-festivalData[order(festivalData$day1),]
festivalData<-festivalData[c(611,4157,"Female",2.02,2.44,NA)]
festivalData
festivalData[c(810),]
festivalData[810,3]<-2.02

festivalBoxplot <- ggplot(festivalData, aes(gender, day1))
festivalBoxplot	+ geom_boxplot() + labs(x = "Gender", y = "Hygiene (Day 1 of Festival)")

festivalBoxplot2 <- ggplot(festivalData, aes(gender, day2))
festivalBoxplot2 + geom_boxplot() + labs(x = "Gender", y = "Hygiene (Day 2 of Festival)")
festivalBoxplot3 <- ggplot(festivalData, aes(gender, day3))
festivalBoxplot3	+ geom_boxplot() + labs(x = "Gender", y = "Hygiene (Day 3 of Festival)")

#4.8 Density plots

density <- ggplot(festivalData, aes(day1))
density + geom_density() + labs(x = "Hygiene (Day 1 of Festival", y = "Density Estimate")

#4.9 Graphing means

chickFlick <- read.delim("ChickFlick.dat", header=TRUE)
View(chickFlick)
bar <- ggplot(chickFlick, aes(film, arousal))
bar + stat_summary(fun.y = mean, geom = "bar", fill = "Blue", colour = "Red") + stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + labs(x = "Film", y = "Mean Arousal")
library(Hmisc)
install.packages("Hmisc")

bar <- ggplot(chickFlick, aes(film, arousal, fill = gender))
bar + stat_summary(fun.y = mean, geom = "bar", position = "dodge") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width=0.90), width = 0.2) + labs(x = "Film", y = "Mean Arousal", fill = "Gender")

bar <- ggplot(chickFlick, aes(film, arousal, fill = film))
bar + stat_summary(fun.y = mean, geom = "bar") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2) + facet_wrap( ~ gender) + labs(x = "Film", y = "Mean Arousal") + theme(legend.position	= "none")

#4.9.2 Line graphs 
#4.9.2.1 Line graphs of a single independent variable

hiccupsData <- read.delim("Hiccups.dat", header = TRUE)
View(hiccupsData)
hiccups <- stack(hiccupsData)
names(hiccups)<-c("Hiccups","Intervention")
View(hiccups)

hiccups$Intervention_Factor<-factor(hiccups$Intervention, levels(hiccups$Intervention)[c(1, 4, 2, 3)])
line <- ggplot(hiccups, aes(Intervention_Factor, Hiccups))
line + stat_summary(fun.y = mean, geom = "point") + stat_summary(fun.y = mean, geom = "line", aes(group = 1), colour = "Blue", linetype = "dashed") + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2, colour = "Red") + labs(x = "Intervention", y = "Mean Number of Hiccups")

#4.9.2.2 Line graphs for several independent vaariables

textData <- read.delim("TextMessages.dat", header = TRUE)
View(textData)

library(reshape)
textMessages<-melt(textData, id = c("Group"), measured = c("Baseline", "Six_months"))
names(textMessages)<-c("Group","Time","Grammar_Score")
textMessages$Time <- factor(textMessages$Time, levels = c("Baseline","Six_months"), labels = c("Baseline","6 Months"))
View(textMessages)
line <- ggplot(textMessages, aes(Time, Grammar_Score, colour = Group))
line + stat_summary(fun.y= mean, geom = "point", shape ="Group") + stat_summary(fun.y = mean, geom = "line", aes(group = Group)) + stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2) + labs(x = "Time", y = "Mean Grammar Score", colour = "Group")










