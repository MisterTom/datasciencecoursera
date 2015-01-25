NEI <- readRDS("summarySCC_PM25.rds") ## read in data 
SCC <- readRDS("Source_Classification_Code.rds") 

library (plyr)

data = merge (NEI,SCC,by="SCC")
motordata = data[ grep(pattern="[Vv]eh", x =data$SCC.Level.Two),1:6] ## just want vehicle sources
motordata = motordata [motordata$fips =="24510" | motordata$fips =="06037",] ## and just for baltimore and LA
toplot = ddply (motordata, .(year,fips),summarise, total = sum (Emissions)) ## get totals by year, area
as.factor(toplot$year)
for (i in 1:nrow(toplot))
       if (toplot [i,2]== "24510") (toplot [i,2] <- "Baltimore")
for (i in 1:nrow(toplot))
      if (toplot [i,2]== "06037") (toplot [i,2] <- "Los Angeles")
names (toplot) <- c ("Year","Area","Total")
library(ggplot2)
windows()
k6 = ggplot(data=toplot, aes(x=Year, y=Total, group=Area, colour=Area)) + geom_line() + geom_point() 
## line chart of particulate emissions from Baltimore

k6 =k6  + ggtitle ("Baltimore City and Los Angeles vehicle emissions") 
k6 =k6  +xlab ("Year")
k6 = k6 + ylab ("Total particulate emissions (tonnes)")

print (k6) ## add titles and labels, and display the chart object k
ggsave (file ="plot6.png")
dev.off()