NEI <- readRDS("summarySCC_PM25.rds") ## read in data 
SCC <- readRDS("Source_Classification_Code.rds") 

library (plyr)
toplot = ddply (NEI, .(year,fips),summarise, total = sum (Emissions))
## summarise data by year and fips code
toplot = toplot[toplot$fips=="24510",] ## only interested in Baltimore (24510)
as.factor(toplot$year)

png(filename = "plot2.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")

par(mfrow=c(1,1)) 
par(mar=c(4,4,2,2))

plot(x=toplot$year,y=toplot$total,xlab  = "year", main ="Baltimore City PM2.5 emissions by year (recorded by PM25.rds)", type="l",ylab="Total emissions (tonnes)")

dev.off()