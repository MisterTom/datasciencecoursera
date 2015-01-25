NEI <- readRDS("summarySCC_PM25.rds") ## read in data 
SCC <- readRDS("Source_Classification_Code.rds") 

library (plyr)

data = merge (NEI,SCC,by="SCC")
motordata = data[ grep(pattern="[Vv]eh", x =data$SCC.Level.Two),1:6] ## just want vehicle sources
motordata = motordata [motordata$fips =="24510",] ## and just for baltimore
toplot = ddply (motordata, "year",summarise, total = sum (Emissions))
as.factor(toplot$year)
## str (toplot)
library(ggplot2)

k = ggplot(data=toplot, aes(x=year, y=total)) + geom_line() + geom_point() 
## line chart of particulate emissions from Baltimore

k =k  + ggtitle ("Baltimore City vehicle particulate emissions, 1999-2008") 
k =k  +xlab ("Year")
k = k + ylab ("Emissions (tonnes)")

print (k) ## add titles and labels, and display the chart object k
ggsave (file ="plot5.png")
dev.off()