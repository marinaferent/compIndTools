#' Computes index scores and ranks using linear aggregation for one or multiple time periods.
#' Automatically computes alternative scores and ranks for inclusion and exclusion of individual indicators.
#'
#' @param x A dataframe. Column 1 - statistical units (countries, regions, companies etc.).
#' Column 2 - time (year, or month, or day etc. - numeric).
#' Rest of columns - values for individual variables.
#' The pre-processing (e.g. standardization, winsoriztion) has to be done by the researcher before using this function.
#' For standardization, one may use the rescaleColumns() function of this package.
#' @param direction A vector. Specifies the direction (as 1 or -1) for each individual variable in the index.
#' @param weight A vector. Specifies the weight assigned to each individual variable.
#' @param path Specifies the path to the folder where the returned .csv files of scores and ranks are to be saved.
#' @param year1 Numeric. Use for multiple years (time periods). Specifies the first year (period) in x.
#' @param yearT Numeric. Use for multiple years (time periods). Specifies the last year (period) in x.
#' @returns Writes two .csv files per year - Index scores and Ranks - in the path folder.
#' Both index scores and ranks are computed using all individual variables (column 3)
#' and when alternatively dropping one individual variable (columns 4 to last).
#' Countries and time are written in column 1 and 2, respectively.
#' In case of one year data (x), the function returns two dataframes - scores and ranks.
#' @references
#' For theoretical information on the linear aggregation method and on the inclusion-exclusion of individual indicators:
#' Nardo et al.(2008). Handbook on Constructing Composite Indicators and User Guide. Publisher: OECD; Editor: European Commission, Joint Research Centre and OECD.
#' @examples
#' dataTest_oneYear[1:5,1:5]
#' direction=c(1, -1,	1,	-1,	1,	-1,	1,	-1,	1,	1,	1,	1,	1,	1,	1,	-1,	-1)
#' weight=c(1/18, 1/18, 1/18, 1/18, 1/18, 1/18, 1/15, 1/15, 1/15, 1/75, 1/75, 1/75, 1/75, 1/75, 1/15, 1/6, 1/6)
#' a=linearAggExc(dataTest_oneYear, direction, weight)
#' #to also store the scores and ranks into 2 .csv files:
#' #a=linearAggExc(dataTest, direction, weight, path="E:/Sample folder")
#' a$scores[1:5,1:5]
#' a$ranks[1:5,1:5]
#' direction=c(1, -1,	1,	-1,	1,	-1,	1,	-1,	1,	1,	1,	1,	1,	1,	1,	-1,	-1)
#' weight=c(1/18, 1/18, 1/18, 1/18, 1/18, 1/18, 1/15, 1/15, 1/15, 1/75, 1/75, 1/75, 1/75, 1/75, 1/15, 1/6, 1/6)
#' #linearAggExc(x=dataTest_moreYears, direction=direction, weight=weight, path="E:/Sample folder", year1=2001, yearT=2003)


linearAggExc=function(x, direction, weight, path, year1, yearT)
{
  if(missing(year1) || missing(yearT)){
    scores=as.data.frame(matrix(NA, nrow=nrow(x), ncol=(ncol(x)+1)))
    ranks=as.data.frame(matrix(NA,nrow=nrow(x), ncol=(ncol(x)+1)))
    countries=x[,1]
    time=x[,2]
    x=x[,3:ncol(x)]
    x[is.na(x)]=0
    for (j in 1:nrow(x))
    {
      index=sum(direction*weight*x[j,])
      scores[j,3]=index
    }
    rank_index=rank(-scores[,3], na.last="keep")
    ranks[,3]=rank_index

    for(i in 1:length(weight))
    {
      weight_new=weight
      weight_new[i]=0
      for (j in 1:nrow(x))
      {
        index=sum(direction*weight_new*x[j,])
        scores[j,3+i]=index
      }
      rank_index=rank(-scores[,3+i], na.last="keep")
      ranks[,3+i]=rank_index
    }

    scores[,1]=countries
    colnames(scores)[1]="Statistical unit"
    scores[,2]=time
    colnames(scores)[2]="Time"
    for(s in 1:(ncol(x)+1))
    {
      colnames(scores)[s+2]=paste0("S",s-1)
    }
    ranks[,1]=countries
    ranks[,2]=time
    colnames(ranks)=colnames(scores)
    if(missing(path))
    {
      resultsList=list(scores,ranks)
      names(resultsList)=c("scores", "ranks")
      return(resultsList)
    } else {
      write.csv(scores, paste0(path, "/Index scores.csv"), row.names = FALSE)
      write.csv(ranks, paste0(path, "/Ranks.csv"), row.names = FALSE)
      resultsList=list(scores,ranks)
      names(resultsList)=c("scores", "ranks")
      return(resultsList)
    }
  } else {
    x=x[order(x[,2]),]
    scoresList=list()
    ranksList=list()
    control=1
    for(year in year1:yearT)
    {
      z=x[control:((year-year1+1)*length(unique(x[,1]))),]
      scores=as.data.frame(matrix(NA, nrow=nrow(z), ncol=(ncol(z)+1)))
      ranks=as.data.frame(matrix(NA,nrow=nrow(z), ncol=(ncol(z)+1)))
      countries=z[,1]
      time=z[,2]
      z=z[,3:ncol(z)]
      z[is.na(z)]=0
      for (j in 1:nrow(z))
      {
        index=sum(direction*weight*z[j,])
        scores[j,3]=index
      }
      rank_index=rank(-scores[,3], na.last="keep")
      ranks[,3]=rank_index

      for(i in 1:length(weight))
      {
        weight_new=weight
        weight_new[i]=0
        for (j in 1:nrow(z))
        {
          index=sum(direction*weight_new*z[j,])
          scores[j,3+i]=index
        }
        rank_index=rank(-scores[,3+i], na.last="keep")
        ranks[,3+i]=rank_index
      }
      scores[,1]=countries
      colnames(scores)[1]="Statistical unit"
      scores[,2]=time
      colnames(scores)[2]="Time"
      for(s in 1:(ncol(x)-1))
      {
        colnames(scores)[s+2]=paste0("S",s-1)
      }
      ranks[,1]=countries
      ranks[,2]=time
      colnames(ranks)=colnames(scores)
      write.csv(scores, paste0(path, "/Index scores ", year, ".csv"), row.names = FALSE)
      write.csv(ranks, paste0(path, "/Ranks ", year, ".csv"), row.names = FALSE)
      control=control+length(unique(x[,1]))
    }
  }
}
