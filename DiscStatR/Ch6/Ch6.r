library(boot); library(ggm); library(ggplot2); library(Hmisc); library(polycor)
library(Rcmdr)

setwd("E:\\Learning\\R\\Ch6")
examData <- read.delim("exam.dat",header=TRUE)

#6.5.3. General procedure for correlations using R
View(examData)
cor(examData, use = "complete.obs", method = "pearson") # Doesn't work as not all data is numeric

cor(examData$Exam, examData$Anxiety, use = "complete.obs", method = "pearson")
cor(examData$Exam, examData$Anxiety, use = "complete.obs", method = "kendall")
cor(examData$Exam, examData$Anxiety, use = "pairwise.complete.obs", method = "kendall")

cor.test(examData$Exam, examData$Anxiety, method = "pearson")
cor.test(examData$Exam, examData$Anxiety, alternative = "less", method = "pearson")
cor.test(examData$Exam, examData$Anxiety, alternative = "less", method = "pearson", conf.level = 0.99)

examData2 <- examData[, c("Exam", "Anxiety", "Revise")]
cor(examData2)

cor(examData[, c("Exam", "Anxiety", "Revise")])

examMatrix <- as.matrix(examData[, c("Exam", "Anxiety", "Revise")])
rcorr(examMatrix)
rcorr(as.matrix(examData[, c("Exam", "Anxiety", "Revise")]))

cor.test(examData$Anxiety, examData$Exam)

#6.5.4.3. Using R^2 for interpretation

cor(examData2)^2
cor(examData2)^2 * 100 #For percentage

#6.5.5. Spearman's correlation coefficient

liarData = read.delim("The Biggest liar.dat", header = TRUE)

cor(liarData$Position, liarData$Creativity, method = "spearman")

liarMatrix <- as.matrix(liarData[, c("Position", "Creativity")])
rcorr(liarMatrix)

cor.test(liarData$Position, liarData$Creativity, alternative = "less", method = "spearman")

#6.5.6. Kendall's tau (non-parametric)

cor(liarData$Position, liarData$Creativity, method = "kendall")
cor.test(liarData$Position, liarData$Creativity, alternative = "less", method = "kendall")

catData = read.csv("pbcorr.csv", header = TRUE)

cor.test(catData$time, catData$gender)

catFrequencies <- table(catData$gender)
prop.table(catFrequencies)

