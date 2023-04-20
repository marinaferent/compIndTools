#' Computes average, median, stdev, and coefficient of variation for ranks or scores from multiple simulations.
#' Returns master file with initial rank (score), followed by average and median one for each statistical unit and each period.
#'
#' @param x A list containing one or multiple dataframes (one for each year) with the ranks (scores) for different simulations.
#' The dataframes inside the list have to look like the ones returned by linearAggExc():
#' Column 1 - statistical units (countries, regions, companies etc.).
#' Column 2 - time (year, or month, or day etc. - numeric).
#' Rest of columns - ranks (scores) in simulations.
#' @param path Specifies the path to the folder where the returned .csv files ("Master file", "Average", "Median", "Stdev", "CV") are to be saved.
#' @param time A vector of the time periods for each dataframe in list x. Default is c(0).
#' @param decim Numeric. Specifies the number of decimals to display. Default is 2.
#' @returns If path is missing, it returns a list of five data frames (masterFile, x_average, x_median, x_stdev, x_CV).
#' If path is specified, it also writes five .csv files ("Master file", "Average", "Median", "Stdev", "CV") in the path folder.
#' Countries are written in column 1. Time is written as colnames.
#' @examples
#' ###example for one year
#' ranks2001[1:5,1:5]
#' dataTestList=list(ranks2001)
#' a=descStats_scores_ranks(dataTestList,
#' #path="E:/Sample folder"
#' )
#' a$masterFile
#' ###example for multiple years
#' names(ranks2001_2003)
#' a=descStats_scores_ranks(ranks2001_2003, time=c(2001, 2002, 2003), decim=4)
#' a$masterFile[1:5,]
#' a$x_stdev[1:5,]
descStats_scores_ranks=function(x, path, time=c(0), decim=2)
{
  year=time
  x_average=matrix("", nrow=nrow(x[[1]]), ncol=length(x))
  rownames(x_average)=x[[1]][,1]
  colnames(x_average)=year

  x_median=matrix("", nrow=nrow(x[[1]]), ncol=length(x))
  rownames(x_median)=x[[1]][,1]
  colnames(x_median)=year

  x_stdev=matrix("", nrow=nrow(x[[1]]), ncol=length(x))
  rownames(x_stdev)=x[[1]][,1]
  colnames(x_stdev)=year

  x_CV=matrix("", nrow=nrow(x[[1]]), ncol=length(x))
  rownames(x_CV)=x[[1]][,1]
  colnames(x_CV)=year

  masterFile=matrix("", nrow=nrow(x[[1]]), ncol=length(x))
  rownames(masterFile)=x[[1]][,1]
  colnames(masterFile)=year

  for(year in 1:length(x))
  {
    for(country in 1:28)
    {
      x_year=x[[year]][country,3:ncol(x[[year]])]
      avg=mean(as.numeric(x_year))
      me=median(as.numeric(x_year))
      stdev=sd(as.numeric(x_year))
      cv=stdev/avg*100
      initial=as.numeric(x[[year]][country,3])
      x_average[country,year]=round(avg,decim)
      x_median[country,year]=round(me,decim)
      x_stdev[country,year]=round(stdev,decim)
      x_CV[country,year]=round(cv,decim)
      masterFile[country,year]=paste0(round(initial,decim), " (Avg=", round(avg,decim), "; Me=", round(me,decim) ,")")
    }
  }
  if(missing(path))
  {
    results_list=list(masterFile, x_average, x_median, x_stdev, x_CV)
    names(results_list)=c("masterFile", "x_average", "x_median", "x_stdev", "x_CV")
    return(results_list)
  } else {
    write.csv(x_average, paste0(path, "/Average.csv"))
    write.csv(x_median, paste0(path, "/Median.csv"))
    write.csv(x_stdev, paste0(path, "/Stdev.csv"))
    write.csv(x_CV, paste0(path, "/CV.csv"))
    write.csv(masterFile, paste0(path, "/masterFile.csv"))
    results_list=list(masterFile, x_average, x_median, x_stdev, x_CV)
    names(results_list)=c("masterFile", "x_average", "x_median", "x_stdev", "x_CV")
    return(results_list)
  }
}
