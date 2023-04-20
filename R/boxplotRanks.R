#' Creates a boxplot of ranks from simulations.
#'
#' @param x A list containing one or multiple dataframes (one for each year) with the ranks (scores) for different simulations.
#' The dataframes inside the list have to look like the ones returned by linearAggExc():
#' Column 1 - statistical units (countries, regions, companies etc.).
#' Column 2 - time (year, or month, or day etc. - numeric).
#' Rest of columns - ranks (scores) in simulations.
#' @param path Specifies the path to the folder where the returned .png file is saved.
#' @param statUnitsFullName Use in case the statistical units have a longer name in the dataframe and the user wishes to change it in the graph.
#' Character vector specifying the full name of the statistical units.
#' @param statUnitsIDs Use in case the statistical units have a longer name in the dataframe and the user wishes to change it in the graph.
#' Character vector specifying the new name given to the statistical units.
#' @returns A boxplot per year.
#' If path is specified, it also writes the boxplots as .png files in the path folder.
#' @examples
#' names(ranks2001_2003)
#' boxplotRanks(ranks2001_2003)
#' #if we want to use country codes instead, we could:
#' countryFullName=c("Belgium", "Bulgaria", "Czech Republic", "Denmark", "Germany", "Estonia", "Ireland", "Greece",
#' "Spain", "France", "Croatia", "Italy", "Cyprus", "Latvia", "Lithuania", "Luxembourg", "Hungary",
#' "Malta", "Netherlands", "Austria", "Poland", "Portugal", "Romania", "Slovenia", "Slovakia",
#' "Finland", "Sweden", "United Kingdom")
#' countryID=c("BE", "BG", "CZ", "DK", "DE", "EE", "IE", "GR", "ES", "FR", "HR", "IT", "CY", "LV", "LT", "LU", "HU",
#'             "MT", "NL", "AT", "PL", "PT", "RO", "SI", "SK", "FI", "SE", "UK")
#' boxplotRanks(ranks2001_2003, statUnitsFullName=countryFullName, statUnitsIDs=countryID)
#' #below we create 3 boxplots and store them in the path folder: 2001.png, 2002.png, and 2003.png
#' #boxplotRanks(ranks2001_2003, path="E:/Sample folder", statUnitsFullName=countryFullName, statUnitsIDs=countryID)




boxplotRanks=function(x, path, statUnitsFullName=c(""), statUnitsIDs=c(""))
{
require(plyr)
require(gsubfn)

  for(year in 1:length(x))
  {
    time=x[[year]][1,2]
    rankAll=x[[year]][,-c(2)]

    numberRanks=(nrow(t(rankAll))-2)*ncol(t(rankAll))

    boxplotData=matrix(NA, nrow=numberRanks, ncol=2)
    numberScenarios=ncol(rankAll)-2

    country=1
    rowCounter=(nrow(t(rankAll))-2)*(ncol(t(rankAll))-2)+1
    for (i in seq(1,rowCounter,(nrow(t(rankAll))-2)))
    {
      boxplotData[i:(i+numberScenarios-1),1]=t(rankAll)[1,country]
      boxplotData[i:(i+numberScenarios-1),2]=t(rankAll)[2:(numberScenarios+1),country]
      country=country+1
    }

    boxplotData=as.data.frame(boxplotData)
    if(missing(path))
    {
      if(missing(statUnitsFullName))
      {
        new_order= with(boxplotData, reorder(V1, as.numeric(V2), median , na.rm=T))
        par(mar=c(6,3,1,1))
        # Plot the chart.
        boxplot(as.numeric(boxplotData$V2) ~ new_order, las=2, xlab = "",
                ylab = "Ranks")
      } else {
        countryFullName=statUnitsFullName
        countryID=statUnitsIDs

        for (country in 1:length(countryFullName))
        {
          boxplotData[,1]=gsub(countryFullName[country], countryID[country], boxplotData[,1])
        }
        #write.csv(boxplotData, paste0("boxplotData", time, ".csv"))

        new_order= with(boxplotData, reorder(V1, as.numeric(V2), median , na.rm=T))
        par(mar=c(3,3,1,1))
        # Plot the chart.
        boxplot(as.numeric(boxplotData$V2) ~ new_order, las=2, xlab = "",
                ylab = "Ranks")
      }
    } else {
    if(missing(statUnitsFullName))
      {
        setwd(paste0(path))
        #write.csv(boxplotData, paste0("boxplotData", time, ".csv"))

        new_order= with(boxplotData, reorder(V1, as.numeric(V2), median , na.rm=T))
        png(file = paste0(time, ".png"))
        par(mar=c(6,3,1,1))
        # Plot the chart.
        boxplot(as.numeric(boxplotData$V2) ~ new_order, las=2, xlab = "",
              ylab = "Ranks")
        # Save the file.
        dev.off()
        par(mar=c(6,3,1,1))
        # Plot the chart.
        boxplot(as.numeric(boxplotData$V2) ~ new_order, las=2, xlab = "",
              ylab = "Ranks")
      } else {
        countryFullName=statUnitsFullName
        countryID=statUnitsIDs

        for (country in 1:length(countryFullName))
        {
          boxplotData[,1]=gsub(countryFullName[country], countryID[country], boxplotData[,1])
        }
        setwd(paste0(path))
        #write.csv(boxplotData, paste0("boxplotData", time, ".csv"))

        new_order= with(boxplotData, reorder(V1, as.numeric(V2), median , na.rm=T))
        png(file = paste0(time, ".png"))
        par(mar=c(3,3,1,1))
        # Plot the chart.
        boxplot(as.numeric(boxplotData$V2) ~ new_order, las=2, xlab = "",
              ylab = "Ranks")
        # Save the file.
        dev.off()
        par(mar=c(3,3,1,1))
        # Plot the chart.
        boxplot(as.numeric(boxplotData$V2) ~ new_order, las=2, xlab = "",
              ylab = "Ranks")
      }
    }
  }
}
