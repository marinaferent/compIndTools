#' Computes number and percent of times that each rank is taken by each statistical unit.
#'
#' @param x A dataframe containing the ranks for different simulations - such as returned by linearAggExc().
#' Column 1 - statistical units (countries, regions, companies etc.).
#' Column 2 - time (year, or month, or day etc. - numeric).
#' Rest of columns - ranks in simulations.
#' @param decim Numeric. Specifies the number of decimals to display in case of percent. Default is 2.
#' @param path Specifies the path to the folder where the returned .csv files of ranksNb and ranksPc are to be saved.
#' @param year Specifies the period in case the user wants the retrned files to be saved as "RanksNb year.csv" and "RanksPc year.csv"
#' @returns If path is missing, it returns a list of two data frames (ranksNb and ranksPc).
#' If path is specified, it also writes two .csv files (RanksNb and RanksPc) in the path folder.
#' Countries and time are written in column 1 and 2, respectively.
#' @examples
#' ranks2001[1:5,]
#' a=ranksCount(ranks2001)
#' a$rankNb[1:5,]
#' a$rankPc[1:5,]
#' ###to automatically store the two .csv files in the desired folder, use path:
#' #ranksCount(ranks2001, decim=0, path="E:/Sample folder")



ranksCount=function(x, decim=2, path, year="")
{
  rankNb=as.data.frame(matrix(NA, nrow=nrow(x), ncol=(nrow(x)+2)))
  rankPc=as.data.frame(matrix(NA, nrow=nrow(x), ncol=(nrow(x)+2)))
  for(i in 1:nrow(x))
  {
    for(r in 1:nrow(x))
    {
      rankNb[i,r+2]=sum(x[i,] == r)
      rankPc[i,r+2]=paste0(round(sum(x[i,] == r)/(ncol(x)-2)*100, decim), "%", sep="")
    }
  }
  rankNb[,1]=x[,1]
  rankNb[,2]=x[,2]
  colnames(rankNb)[1]="Statistical unit"
  colnames(rankNb)[2]="Time"
  for(r in 1:nrow(x))
  {
    colnames(rankNb)[r+2]=paste0("R",r)
  }
  rankPc[,1]=x[,1]
  rankPc[,2]=x[,2]
  colnames(rankPc)=colnames(rankNb)
  if(missing(path)){
    rankList=list(rankNb, rankPc)
    names(rankList)=c("rankNb", "rankPc")
    return(rankList)
  } else {
    write.csv(rankNb, paste0(path, "/RanksNb", year, ".csv"), row.names = FALSE)
    write.csv(rankPc, paste0(path, "/RanksPc", year, ".csv"), row.names = FALSE)
    rankList=list(rankNb, rankPc)
    names(rankList)=c("rankNb", "rankPc")
    return(rankList)
  }
}
