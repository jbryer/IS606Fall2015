library(ggplot2)
library(gridExtra)
library(animation)

# Define our population
n <- 1e5
pop <- runif(n, 0, 1)
mean(pop)
hist(pop)

# Create an animation where we show the distribution of a sample on the top,
# and the sampling distribution on the bottom. Each new point added to the
# sampling distribution (i.e. the mean of the sample) is highlighted in blue.
wd <- getwd(); setwd('R/SamplingDistribution')
nFrames <- 500
saveHTML({
	sampDist <- c()
	pb <- txtProgressBar(style=3, min=1, max=nFrames)
	for(i in 1:nFrames) {
		samp <- sample(pop, size=30)
		sampDist <- c(sampDist, mean(samp))
		p1 <- ggplot(data.frame(x=samp), aes(x=x)) + 
			geom_dotplot(binwidth=1/40) + 
			geom_vline(xintercept=mean(samp), color='blue') +
			ggtitle('Distribution of Sample') + 
			xlim(c(0,1))
		p2 <- ggplot(data.frame(x=sampDist, color=c(rep('black', length(sampDist)-1), 'blue')), aes(x=x, fill=color)) + 
			geom_dotplot(binwidth=1/80, method='histodot', dotsize=.8) + 
			scale_fill_manual(values=c('black'='grey', 'blue'='blue')) +
			theme(legend.position='none') + 
			ggtitle('Sampling Distribution') + xlim(c(0,1))
			#xlim(c(0.3,0.8))
		grid.arrange(p1, p2, ncol=1)
		setTxtProgressBar(pb, i)
	}
	close(pb)
}, htmlfile='index.html', autoplay=FALSE)
setwd(wd)

