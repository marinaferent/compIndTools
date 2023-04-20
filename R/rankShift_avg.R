#' Computes the average shift in ranking.
#' The novelty of the function is that it extends the 1 period formula to encompass multiple time
#' periods. It returns three types of average shift in ranking - total, per year, and per country and year.
#'
#' @param rInit A dataframe. Column 1 - statistical units (countries, regions, companies etc.).
#' Rest of columns - initial ranks for each year.
#' @param rNb A list of dataframes (one dataframe per year - result of ranksCount()). Each dataframe contains the number of times
#' a statistical unit takes a certain rank. Column 1 - statistical units; column 2 - time; rest of columns - the number of times
#' the statistical unit takes rank 1, rank 2 and so on.
#' @returns A list with three objects: Total average shift in ranking ($RsTotal); Average shift in rakning for each year ($RsYear);
#' Total shift in ranking per country in each year ($RsCountry). Please read country=statistical unit; year=time period.
#' @examples
#' ranksInitial2001_2003[c(1:5,27:32),1:5]
#' names(ranksNb2001_2003)
#' a=rankShift_avg(ranksInitial2001_2003, ranksNb2001_2003)
#' a$RsTotal
#' a$RsYear
#' round(a$RsCountry[[1]],4)

rankShift_avg=function(rInit, rNb)
{
  RsCountry=list()
  length(RsCountry)=length(rNb)
  RsYear=c()
  RsTotal=c()
  for (year in 1:length(rNb))
  {
    ranksNb=rNb[[year]]
    for(country in 1:nrow(rInit))
    {
      sumAbsDif=0
      RankInitialCI=rInit[country,year+1]
      for(rankI in 3:ncol(ranksNb))
      {
        RankCI=rankI-1
        sumAbsDif=sumAbsDif+abs(RankInitialCI-RankCI)*ranksNb[country,rankI]
        RsCountry[[year]][country]=sumAbsDif/sum(ranksNb[country,2:ncol(ranksNb)])
      }
    }
    RsYear[year]=sum(RsCountry[[year]])/nrow(rInit)
  }
  RsTotal=sum(RsYear)/length(rNb)
  rs=list(RsTotal, RsYear, RsCountry)
  names(rs)=c("RsTotal", "RsYear", "RsCountry")
  return(rs)
}
