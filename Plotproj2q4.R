NEI <- readRDS("summarySCC_PM25.rds") ## read in data 
SCC <- readRDS("Source_Classification_Code.rds") 

library (plyr)

data = merge (NEI,SCC,by="SCC")
iscoal =grep(pattern="Coal", x =data$Short.Name) ## just want coal sources
coaldata = data [iscoal,1:6]

toplot = ddply (coaldata, "year",summarise, total = sum (Emissions))
as.factor(toplot$year)

png(filename = "plot4.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")

par(mfrow=c(1,1)) 
par(mar=c(4,4,2,2))

plot(x=toplot$year,y=toplot$total,xlab  = "year", main ="US particulate emissions by year (coal sources)", type="l",ylab="Total emissions (tonnes)")


dev.off()