load('../Data/NYSReportCardCache.Rda')
source('../R/ReportCardFunction.R')

se <- function(x) { sqrt(var(x)/length(x)) }

# Create a table with results of each residual analysis
tabout <- data.frame()
for(subject in c('ELA','Math')) {
	for(grade in 3:8) {
		thedata <- reportCard(subject, grade)
		
		r <- cor(thedata[,'Pass2012'], thedata[,'Pass2013'])
		lm.out <- lm(Pass2013 ~ Pass2012, data=thedata, weights=thedata[,'TotalTested'])
		lm.sum <- summary(lm.out)
		thedata$resid <- resid(lm.out)
		t.out <- t.test(resid ~ Charter, data=thedata)
		lm2.out <- lm(Pass2013 ~ I(Pass2012 ^ 2), data=thedata, weights=thedata[,'TotalTested'])
		lm2.sum <- summary(lm2.out)
		thedata$resid2 <- resid(lm2.out)
		t2.out <- t.test(resid2 ~ Charter, data=thedata)
		
		tabout <- rbind(tabout, data.frame(
			subject=subject, 
			grade=grade, 
			r=r, 
			r.squared=lm.sum$r.squared,
			public.resid=unname(t.out$estimate['mean in group FALSE']),
			charter.resid=unname(t.out$estimate['mean in group TRUE']),
			diff=unname(diff(t.out$estimate)),
			p=t.out$p.value,
			r.squared.quad=lm2.sum$r.squared,
			public.resid.quad=unname(t2.out$estimate['mean in group FALSE']),
			charter.resid.quad=unname(t2.out$estimate['mean in group TRUE']),
			diff.quad=unname(diff(t2.out$estimate)),
			p.quad=t2.out$p.value,
			stringsAsFactors=FALSE))
	}
}

p.stars <- function(pvalue) {
	cut(pvalue, breaks=c(-Inf, 0.001, .01, .05, Inf),
		labels=c('***','**','*',''))
}

tabout$p.star <- p.stars(tabout$p)
tabout$p.quad.star <- p.stars(tabout$p.quad)

# Linear models
tabout[,c('subject','grade','r','r.squared','public.resid','charter.resid','diff','p', 'p.star')]

# Quadratic models
tabout[,c('subject','grade','r.squared.quad','public.resid.quad',
		  'charter.resid.quad','diff.quad','p.quad', 'p.quad.star')]

