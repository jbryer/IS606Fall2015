install.packages('devtools')
devtools::install_github('jbryer/IS606')

library(IS606)
getwd()
getLabs()
vignette(package='IS606')
vignette('os3')
viewLab('Lab0')
startLab('Lab0')

# startLab('Lab1', dest_dir='Users/tjd/Documents/R', file.prefix = 'tjd')
