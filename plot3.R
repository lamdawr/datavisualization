# Load RDS
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#coerce type and year as factors
NEI$type <- as.factor(NEI$type)
NEI$year <- as.factor(NEI$year)


#grab only Baltimore City data
sub <- NEI[NEI$fips == "24510",]
#produce final data frame
result <- aggregate(Emissions ~ year + type, data = sub, FUN = sum)


png(filename="plot3b.png")
myplot<-qplot(x = year, y = Emissions, data = result,geom = , fill = type)
dev.off()






#Create ggplot 
#Uses type as a facet to separate different types
#png(filename = "plot3.png")
#myplot <- ggplot(result, aes(x = year, y = Emissions, fill = year)) + geom_bar(stat = "identity") + facet_wrap(~type) +
#    ggtitle(expression("Total PM2.5 Emissions in Baltimore by Type")) + ylab(expression("Emissions PM2.5 (tons)")) + 
#    xlab(expression("Year"))
#print(myplot)
#dev.off()