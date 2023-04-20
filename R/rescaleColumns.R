#' Rescales (minMax, z-score, rank) values per column in a dataframe.
#'
#' @param x A dataframe. Column 1 - statistical units (countries, regions, companies etc.).
#' Column 2 - time (year, or month, or day etc. - numeric).
#' Rest of columns - values for individual variables.
#' @param method Specifies the rescaling method: "minmax", "z-score", or "rank".
#' The default is "minmax". Equal ranks are averaged.
#' @param max Numeric. In case of method="minmax", specifies the value to be taken by the maximum value in a column.
#' The default is 100.
#' @param decim Numeric. Specifies the number of decimals to display. Default is 2.
#' @returns A matrix. The first two columns and the colnames are the same as those of x.
#' @references
#' For theoretical information on the three rescaling methods, check:
#' Nardo et al.(2008). Handbook on Constructing Composite Indicators and User Guide. Publisher: OECD; Editor: European Commission, Joint Research Centre and OECD.
#' @examples
#' dataTest_moreYears[c(1:5,27:32),1:5]
#' rescaleColumns(dataTest_moreYears)[c(1:5,27:32),1:5]
#' rescaleColumns(dataTest_moreYears, method="z-score", decim=3)[1:5,1:5]

rescaleColumns=function(x, method="minMax", max=100, decim=2)
{


  x_std=matrix("", nrow=nrow(x), ncol=ncol(x))
  colnames(x_std)=colnames(x)
  x_std[,1]=x[,1]
  x_std[,2]=x[,2]

  if(method=="minMax")
  {
    min_x=c()
    max_x=c()
    for (i in 3:(ncol(x)))
    {
      min_x[i]=min(x[,i], na.rm = TRUE)
      max_x[i]=max(x[,i], na.rm = TRUE)
    }

    for(i in 1:nrow(x_std))
    {
      for(j in 3:ncol(x_std))
      {
        x_std[i,j]=round((x[i,j]-min_x[j])/(max_x[j]-min_x[j])*max,decim)
      }
    }
  } else {
      if(method=="z-score")
      {
        sd.p=function(x){sd(x, na.rm=TRUE)*sqrt((length(x[!is.na(x)])-1)/length(x[!is.na(x)]))}
        mean_x=c()
        stdev_x=c()
        for (i in 3:(ncol(x)))
        {
          mean_x[i]=mean(x[,i], na.rm = TRUE)
          stdev_x[i]=sd.p(x[,i])
        }
        for(i in 1:nrow(x_std))
        {
          for(j in 3:ncol(x_std))
          {
            x_std[i,j]=round((x[i,j]-mean_x[j])/stdev_x[j], decim)
          }
        }
      } else {
        if(method=="rank")
        {
            for(j in 3:ncol(x_std))
            {
              x_std[,j]=round(rank(-x[,j], na.last="keep"), decim)
            }
        }
      }
  }
  x_std
}
