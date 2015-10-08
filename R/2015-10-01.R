df <- data.frame(i = 1:1000, r=rep(NA, 10000))
for(i in 1:nrow(df)) {
	set.seed(df[i,]$i)
	df[i,]$r <- sample(100, 1)
}
plot(df$i, df$r, type='l')

set.seed(1); sample(100, 1)
set.seed(2); sample(100, 1)

?rnorm

sam <- rnorm(1000, mean=100, sd=15)
hist(sam)
plot(density(sam))

library(IS606)
search()
ls('package:IS606')
?normalPlot

normalPlot(mean=100, sd=15)
normalPlot(mean=100, sd=15, bounds=c(85, 115))
normalPlot(mean=100, sd=15, bounds=c(70, 130))
