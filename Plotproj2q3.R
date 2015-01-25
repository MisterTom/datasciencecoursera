NEI <- readRDS("summarySCC_PM25.rds") ## read in data 
SCC <- readRDS("Source_Classification_Code.rds") 

library (plyr)
toplot = ddply (NEI, .(year,fips,type),summarise, total = sum (Emissions))
## summarise data by year, type and fips code
toplot = toplot[toplot$fips=="24510",] ## only interested in Baltimore (24510)
as.factor(toplot$year)
## str (toplot)
library(ggplot2)

k = ggplot(data=toplot, aes(x=year, y=total, group=type, colour=type)) + geom_line() + geom_point() 
## line chart of particulate emissions for each type


k =k  + ggtitle ("Baltimore City particulate emissions by type, 1999-2008") 
k =k  +xlab ("Year")
k = k + ylab ("Emissions (tonnes)")

print (k) ## add titles and labels, and display the chart object k
ggsave (file ="plot3.png")
dev.off()