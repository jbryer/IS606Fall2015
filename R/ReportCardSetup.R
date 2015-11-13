load('../Data/NYSReportCardCache.Rda')

# Change to create for another grade and subject
# subject can be 'Math' or 'ELA'
# grade can be between 3 and 8
subject <- 'Math'; grade <- 7


rc.2012 <- nysrc2012[[paste0(subject, grade, ' Subgroup Results')]]
rc.2013 <- nysrc2013[[2]]
rc.2013 <- rc.2013[which(rc.2013$ITEM.DESC == paste0('Grade ', grade, ' ', subject)),]
rc.2012 <- rc.2012[rc.2012$SUBGROUP.NAME == 'All Students',]
rc.2012 <- rc.2012[rc.2012$YEAR == 2012,]

rc.2012$ENTITY.CD <- format(rc.2012$ENTITY.CD, width=12, nsmall=0, zero.print='0', scientific=FALSE)
rc.2012$ENTITY.CD <- gsub(' ', '0', rc.2012$ENTITY.CD, fixed=TRUE)
rc.2012$charter <- substr(rc.2012$ENTITY.CD, 7, 8) == '86'

rc.2013$BEDSCODE <- format(rc.2013$BEDSCODE, width=12, nsmall=0, zero.print='0', scientific=FALSE)
rc.2013$BEDSCODE <- gsub(' ', '0', rc.2013$BEDSCODE, fixed=TRUE)
rc.2013$charter <- substr(rc.2013$BEDSCODE, 7, 8) == '86'

rc.2012 <- rc.2012[substr(rc.2012$ENTITY.CD, 9, 12) != '0000' & #Districts
				   	substr(rc.2012$ENTITY.CD, 1, 2) != '00' &    #Other aggregates
				   	substr(rc.2012$ENTITY.CD, 9, 12) != '0999',] #Out of district

rc.2013 <- rc.2013[substr(rc.2013$BEDSCODE, 9, 12) != '0000' & #Districts
				   	substr(rc.2013$BEDSCODE, 1, 2) != '00' &    #Other aggregates
				   	substr(rc.2013$BEDSCODE, 9, 12) != '0999',] #Out of district
for(i in 1:4) {
	rc.2012[,paste0('LEVEL', i, '..TESTED')] <- as.integer(rc.2012[,paste0('LEVEL', i, '..TESTED')])
	missingRows <- which(is.na(rc.2012[,paste0('LEVEL', i, '..TESTED')]))
	if(length(missingRows) > 0) {
		rc.2012[missingRows, paste0('LEVEL', i, '..TESTED')] <- 0
	}
	rc.2013[,paste0('P', i)] <- as.integer(rc.2013[,paste0('P', i)])
	missingRows <- which(is.na(rc.2013[,paste0('P', i)]))
	if(length(missingRows) > 0) {
		rc.2013[missingRows, paste0('P', i)] <- 0
	}
}

rc.2012$Pass2012 <- apply(rc.2012[,paste0('LEVEL', 3:4, '..TESTED')], 1, sum)
rc.2013$Pass2013 <- apply(rc.2013[,paste0('P', 3:4)], 1, sum)

rc.2012 <- rc.2012[,c('ENTITY.CD','ENTITY.NAME','NUM.TESTED','MEAN.SCORE','Pass2012','charter')]
rc.2013 <- rc.2013[,c('BEDSCODE','ITEM.DESC','COUNTY','BOCES.NAME','NTEST','NMEAN','Pass2013')]

names(rc.2012) <- c('BEDSCODE','School','NumTested2012','Mean2012','Pass2012','Charter')
names(rc.2013) <- c('BEDSCODE','GradeSubject','County','BOCES','NumTested2013','Mean2013','Pass2013')

reportCard <- merge(rc.2012, rc.2013, by='BEDSCODE')

reportCard$Mean2012 <- as.integer(reportCard$Mean2012)
reportCard$Mean2013 <- as.integer(reportCard$Mean2013)

save(reportCard, file=paste0('../Data/NYSReportCard-Grade', grade, subject, '.Rda'))
