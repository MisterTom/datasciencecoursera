NEI <- readRDS("summarySCC_PM25.rds") ## read in data 
SCC <- readRDS("Source_Classification_Code.rds") 

library (plyr)
toplot = ddply (NEI, "year",summarise, total = sum (Emissions))
as.factor(toplot$year)

png(filename = "plot1.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")

par(mfrow=c(1,1)) 
par(mar=c(4,4,2,2))

plot(x=toplot$year,y=toplot$total,xlab  = "year", main ="total US particulate emissions by year (as recorded by PM25.rds)", type="l",ylab="Total emissions (tonnes)")

dev.off()