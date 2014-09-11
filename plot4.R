#read data
require(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#make appropriate columns characters
SCC$EI.Sector <- as.character(SCC$EI.Sector)
SCC$Short.Name <- as.character(SCC$Short.Name)


SCC.comb <- SCC[grep("Fuel Comb", SCC$EI.Sector),] #530 observations
SCC.coal <- SCC.comb[grep("Coal", SCC.comb$Short.Name),] #91 observations
SCC.coal2 <- SCC[grep("Coal", SCC$EI.Sector),] #99 observations
res <- rbind(SCC.coal, SCC.coal2)
res <- unique(res) ##103 observations

#use the SCC values obtained above to get the NEI data that are from coal combustion sources
res$SCC <- as.character(res$SCC)
codes <- res$SCC
sub <- subset(NEI, NEI$SCC %in% codes)

#produce final data frame summing emissions and grouping by year
result <- aggregate(sub$Emissions, by = list(sub$year), FUN = sum)
colnames(result) <- c("Year", "Total")
result$Year <- factor(result$Year)


#construct barplot using ggplot. Note the use of stat = identity and filling results by year.
#I've also included the actual values as a geom_text variable to make things easier to see.
png(filename = "plot4.png")
myplot <- ggplot(result, aes(x = Year, y = Total)) + 
    geom_bar(stat = "identity", aes(fill = Year)) + 
    geom_text(aes(label = round(Total, 2), hjust = 0.5, vjust = 2)) +
    ggtitle(expression("Emissions from Coal Combustion Sources in US from 1999 to 2008")) +
    xlab(expression("Year")) + ylab(expression("PM2.5 Emissions from Coal Combustion (tons)"))
print(myplot)
dev.off()