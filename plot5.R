#read in data
require(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#coerce to character
SCC$EI.Sector <- as.character(SCC$EI.Sector)


SCC.car <- SCC[grep("Mobile.*On-Road", SCC$EI.Sector),]

#coerce to character, get the correct SCC codes, and then subset based on Baltimore City and proper codes
SCC.car$SCC <- as.character(SCC.car$SCC)
codes <- SCC.car$SCC
NEI.Bmore <- NEI[NEI$fips == "24510",]
NEI.Bmore.MV <- subset(NEI.Bmore, NEI.Bmore$SCC %in% codes) #1119 observations

#produce final data frame summing emissions and grouping by year
result <- aggregate(NEI.Bmore.MV$Emissions, by = list(NEI.Bmore.MV$year), FUN = sum)

colnames(result) <- c("Year", "Total")
result$Year <- factor(result$Year)

#Construct plot. 
png(filename = "plot5.png")
myplot <- ggplot(result, aes(x = Year, y = Total)) +
    geom_bar(stat = "identity", aes(fill = Year)) +
    geom_text(aes(label = round(Total, 2), size = 1, hjust = 0.5, vjust = 2)) +
    ggtitle(expression("Emissions from Motor Vehicles in Baltimore from 1999 to 2008")) +
    xlab(expression("Year")) + ylab(expression("PM2.5 Emissions from Motor Vehicles (tons)"))
print(myplot)
dev.off()