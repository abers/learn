library(car); library(ggplot2); library(pastecs); library(psych); library(Rcmdr)

setwd('E:\\Learning\\R\\Ch5')
dlf <- read.delim("DownloadFestival(No Outlier).dat",header=TRUE)

hist.day1 <- ggplot(dlf, aes(day1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on day 1", y = "Density")

hist.day1

hist.day1 <- ggplot(dlf, aes(day1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on day 1", y = "Density")
hist.day1 + stat_function(fun = dnorm, args = list(mean = mean(dlf$day1, na.rm = TRUE), sd = sd(dlf$day1, na.rm = TRUE)), colour = "black", size = 1)

hist.day2 <- ggplot(dlf, aes(day2)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on day 1", y = "Density")
hist.day2 + stat_function(fun = dnorm, args = list(mean = mean(dlf$day2, na.rm = TRUE), sd = sd(dlf$day2, na.rm = TRUE)), colour = "black", size = 1)

hist.day3 <- ggplot(dlf, aes(day3)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on day 1", y = "Density")
hist.day3 + stat_function(fun = dnorm, args = list(mean = mean(dlf$day3, na.rm = TRUE), sd = sd(dlf$day3, na.rm = TRUE)), colour = "black", size = 1)

qqplot.day1 <- qplot(sample = dlf$day1)
qqplot.day1

qqplot.day2 <- qplot(sample = dlf$day2)
qqplot.day2
qqplot.day3 <- qplot(sample = dlf$day3)
qqplot.day3

#5.5.2 Quantifying normality with numbers

describe(dlf$day1)
#Both do the same
stat.desc(cbind(dlf$day1, dlf$day2, dlf$day3), basic = FALSE, norm = TRUE)
stat.desc(dlf[, c("day1", "day2", "day3")], basic = FALSE, norm = TRUE)

#Rounding the figures makes the stats easier to read.
SkewKurtStats <- stat.desc(dlf[, c("day1", "day2", "day3")], basic = FALSE, norm = TRUE)
round(SkewKurtStats, digits =3)

#5.5.3. Exploring groups of data
rexam <- read.delim("rexam.dat", header=TRUE)

rexam$uni <- factor(rexam$uni, levels = c(0,1), labels = c("Duncetown University", "Sussex University"))
View(rexam)
library(utils)
edit(rexam)

rexam.exam <- ggplot(rexam, aes(exam)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Exam scores", y = "Density")
rexam.exam

rexam.computer <- ggplot(rexam, aes(computer)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Computer scores", y = "Density")
rexam.lectures<- ggplot(rexam, aes(lectures)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Lecture attendance scores", y = "Density")
rexam.numeracy <- ggplot(rexam, aes(numeracy)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Numeracy scores", y = "Density")


rexam.exam <- ggplot(rexam, aes(exam)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Exam scores", y = "Density") + stat_function(fun = dnorm, args = list(mean = mean(rexam$exam, na.rm = TRUE), sd = sd(rexam$exam, na.rm = TRUE)), colour = "black", size = 1)
rexam.computer <- ggplot(rexam, aes(computer)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Computer scores", y = "Density") + stat_function(fun = dnorm, args = list(mean = mean(rexam$computer, na.rm = TRUE), sd = sd(rexam$computer, na.rm = TRUE)), colour = "black", size = 1)
rexam.lectures <- ggplot(rexam, aes(lectures)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "lectures scores", y = "Density") + stat_function(fun = dnorm, args = list(mean = mean(rexam$lectures, na.rm = TRUE), sd = sd(rexam$lectures, na.rm = TRUE)), colour = "black", size = 1)
rexam.numeracy <- ggplot(rexam, aes(numeracy)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "numeracy scores", y = "Density") + stat_function(fun = dnorm, args = list(mean = mean(rexam$numeracy, na.rm = TRUE), sd = sd(rexam$numeracy, na.rm = TRUE)), colour = "black", size = 1)

rexam.exam
rexam.computer
rexam.lectures
rexam.numeracy

round(stat.desc(rexam[, c("exam", "computer", "lectures", "numeracy")], basic = FALSE, norm = TRUE), digits = 3)

#5.5.3.2. Running the analysis for different groups

by(data = rexam$exam, INDICES = rexam$uni, FUN = describe)
by(data = rexam$exam, INDICES = rexam$uni, FUN = stat.desc)
#can shorten if use the set order:
by(rexam$exam, rexam$uni, describe)
by(rexam$exam, rexam$uni, stat.desc)
#furthermore can add function specific arguments
by(rexam$exam, rexam$uni, stat.desc, basic = FALSE, norm = TRUE)

#adding cbinds:
by(cbind(data=rexam$exam, data=rexam$numeracy), rexam$uni, describe)
by(rexam[, c("exam", "numeracy")], rexam$uni, stat.desc, basic = FALSE, norm = TRUE)

#creating subsets
dunceData <- subset(rexam, rexam$uni=="Duncetown University")
sussexData <- subset(rexam, rexam$uni=="Sussex University")

hist.numeracy.duncetown <- ggplot(dunceData, aes(numeracy)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "Numeracy Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(dunceData$numeracy, na.rm = TRUE), sd = sd(dunceData$numeracy, na.rm = TRUE)), color = "pink", size=1)
hist.numeracy.duncetown

hist.numeracy.sussex <- ggplot(sussexData, aes(numeracy)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "Numeracy Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(sussexData$numeracy, na.rm = TRUE), sd = sd(sussexData$numeracy, na.rm = TRUE)), color = "pink", size=1)
hist.numeracy.sussex

hist.exam.duncetown <- ggplot(dunceData, aes(exam)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "exam Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(dunceData$exam, na.rm = TRUE), sd = sd(dunceData$exam, na.rm = TRUE)), color = "pink", size=1)
hist.exam.duncetown

hist.exam.sussex <- ggplot(sussexData, aes(exam)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "exam Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(sussexData$exam, na.rm = TRUE), sd = sd(sussexData$exam, na.rm = TRUE)), color = "pink", size=1)
hist.exam.sussex

hist.lectures.duncetown <- ggplot(dunceData, aes(lectures)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "lectures Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(dunceData$lectures, na.rm = TRUE), sd = sd(dunceData$lectures, na.rm = TRUE)), color = "pink", size=1)
hist.lectures.duncetown

hist.lectures.sussex <- ggplot(sussexData, aes(lectures)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "lectures Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(sussexData$lectures, na.rm = TRUE), sd = sd(sussexData$lectures, na.rm = TRUE)), color = "pink", size=1)
hist.lectures.sussex

hist.computer.duncetown <- ggplot(dunceData, aes(computer)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "computer Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(dunceData$computer, na.rm = TRUE), sd = sd(dunceData$computer, na.rm = TRUE)), color = "pink", size=1)
hist.computer.duncetown

hist.computer.sussex <- ggplot(sussexData, aes(computer)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), fill = "blue", colour = "black", binwidth = 1) + labs(x = "computer Score", y = "Density") + stat_function(fun=dnorm, args=list(mean = mean(sussexData$computer, na.rm = TRUE), sd = sd(sussexData$computer, na.rm = TRUE)), color = "pink", size=1)
hist.computer.sussex

#5.6. Testing whether a distribution is normal

shapiro.test(rexam$exam)
shapiro.test(rexam$numeracy)

by(rexam$exam, rexam$uni, shapiro.test)
by(rexam$numeracy, rexam$uni, shapiro.test)

qplot(sample = rexam$exam)
qplot(sample = rexam$numeracy)

#5.7.1. Levene's test

leveneTest(rexam$exam, rexam$uni)
leveneTest(rexam$exam, rexam$uni, center = mean)

#5.8.2.1. Transforming data

dlf$logday1 <- log(dlf$day1 + 1)
dlf$logday2 <- log(dlf$day2 + 1)
dlf$logday3 <- log(dlf$day3 + 1)

hist.logday1 <- ggplot(dlf, aes(logday1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on logday 1", y = "Density")
hist.logday1 + stat_function(fun = dnorm, args = list(mean = mean(dlf$logday1, na.rm = TRUE), sd = sd(dlf$logday1, na.rm = TRUE)), colour = "black", size = 1)

hist.logday2 <- ggplot(dlf, aes(logday2)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on logday 1", y = "Density")
hist.logday2 + stat_function(fun = dnorm, args = list(mean = mean(dlf$logday2, na.rm = TRUE), sd = sd(dlf$logday2, na.rm = TRUE)), colour = "black", size = 1)

hist.logday3 <- ggplot(dlf, aes(logday3)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on logday 1", y = "Density")
hist.logday3 + stat_function(fun = dnorm, args = list(mean = mean(dlf$logday3, na.rm = TRUE), sd = sd(dlf$logday3, na.rm = TRUE)), colour = "black", size = 1)

dlf$sqrtday1 <- sqrt(dlf$day1)
dlf$sqrtday2 <- sqrt(dlf$day2)
dlf$sqrtday3 <- sqrt(dlf$day3)

hist.sqrtday1 <- ggplot(dlf, aes(sqrtday1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on sqrtday 1", y = "Density")
hist.sqrtday1 + stat_function(fun = dnorm, args = list(mean = mean(dlf$sqrtday1, na.rm = TRUE), sd = sd(dlf$sqrtday1, na.rm = TRUE)), colour = "black", size = 1)

hist.sqrtday2 <- ggplot(dlf, aes(sqrtday2)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on sqrtday 1", y = "Density")
hist.sqrtday2 + stat_function(fun = dnorm, args = list(mean = mean(dlf$sqrtday2, na.rm = TRUE), sd = sd(dlf$sqrtday2, na.rm = TRUE)), colour = "black", size = 1)

hist.sqrtday3 <- ggplot(dlf, aes(sqrtday3)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on sqrtday 1", y = "Density")
hist.sqrtday3 + stat_function(fun = dnorm, args = list(mean = mean(dlf$sqrtday3, na.rm = TRUE), sd = sd(dlf$sqrtday3, na.rm = TRUE)), colour = "black", size = 1)

dlf$recday1 <- 1/(dlf$day1 + 1)
dlf$recday2 <- 1/(dlf$day2 + 1)
dlf$recday3 <- 1/(dlf$day3 + 1)

hist.recday1 <- ggplot(dlf, aes(recday1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on recday 1", y = "Density")
hist.recday1 + stat_function(fun = dnorm, args = list(mean = mean(dlf$recday1, na.rm = TRUE), sd = sd(dlf$recday1, na.rm = TRUE)), colour = "black", size = 1)

hist.recday2 <- ggplot(dlf, aes(recday2)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on recday 1", y = "Density")
hist.recday2 + stat_function(fun = dnorm, args = list(mean = mean(dlf$recday2, na.rm = TRUE), sd = sd(dlf$recday2, na.rm = TRUE)), colour = "black", size = 1)

hist.recday3 <- ggplot(dlf, aes(recday3)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "Hygiene score on recday 1", y = "Density")
hist.recday3 + stat_function(fun = dnorm, args = list(mean = mean(dlf$recday3, na.rm = TRUE), sd = sd(dlf$recday3, na.rm = TRUE)), colour = "black", size = 1)






