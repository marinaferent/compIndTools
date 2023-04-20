#' Returns a color coded table with frequency of each rank.
#' Initial, median and modal rank frequency cells are color-coded.
#'
#' @param x A dataframe containing the ranks for different simulations - such as returned by linearAggExc().
#' Column 1 - statistical units (countries, regions, companies etc.).
#' Column 2 - time (year, or month, or day etc. - numeric).
#' Rest of columns - ranks in simulations.
#' @param decim Numeric. Specifies the number of decimals to display. Default is 2.
#' @param path Specifies the path to the folder where the returned .xlsx file ("Color coded ranks frequency.xlsx") to be saved.
#' @param year Specifies the period in case the user wants the returned file to be saved as "Color coded ranks frequency year.xlsx".
#' @returns A table with: Column 1- statistical units; column 2- time; column 3- frequency of taking rank 1; and so on.
#' For each statistical unit:
#' The cell that shows the frequency of the initial rank is bordered in red.
#' The frequency of the median rank is bolded.
#' The frequency of the modal rank is written in blue.
#' If path is specified, it also writes a .xlsx file in the path folder.
#' The function was created haing in mind the .xlsx export.
#' @examples
#' ranks2001[1:5,1:5]
#' #ranksCount_colCode(ranks2001, decim=4, path="E:/Sample folder", year="2001")
#' a=ranksCount_colCode(ranks2001,decim=0)
#' a


ranksCount_colCode=function(x, decim=2, path, year="")
{
  require(plyr)
  require(basictabler)
  require(openxlsx)


  rankFr=as.data.frame(matrix(NA, nrow=nrow(x), ncol=(nrow(x)+2)))
  rankPc=as.data.frame(matrix(NA, nrow=nrow(x), ncol=(nrow(x)+2)))
  for(i in 1:nrow(x))
  {
    for(r in 1:nrow(x))
    {
      rankFr[i,r+2]=sum(x[i,] == r)
      rankPc[i,r+2]=paste0(round(sum(x[i,] == r)/(ncol(x)-2)*100, decim), "%", sep="")
    }
  }
  rankFr[,1]=x[,1]
  rankFr[,2]=x[,2]
  colnames(rankFr)[1]="Statistical unit"
  colnames(rankFr)[2]="Time"
  for(r in 1:nrow(x))
  {
    colnames(rankFr)[r+2]=paste0("R",r)
  }
  rankPc[,1]=x[,1]
  rankPc[,2]=x[,2]
  colnames(rankPc)=colnames(rankFr)
  x_nb=x
  table_x <- BasicTable$new()
  table_x$addData(rankPc)

  for (country in 1:nrow(x))
  {
    #r=x_nb[country,1]
    r=x_nb[country,3]
    me=median(t(x_nb[country,3:ncol(x_nb)]))
    mo=which(rankFr[country,3:ncol(rankFr)]==max(rankFr[country,3:ncol(rankFr)]))
    table_x$setStyling(rowNumbers=country+1, columnNumbers=r+2,
                        declarations=list("border"="1px solid red"), applyBorderToAdjacentCells=TRUE)
    table_x$setStyling(rowNumbers=country+1, columnNumbers=me+2, declarations=list("font-weight"="bold"))
    table_x$setStyling(rowNumbers=country+1, columnNumbers=mo+2,  declarations=list(color="blue"))
  }

  table_x$renderTable()

  wb <- createWorkbook(creator = Sys.getenv("USERNAME"))
  addWorksheet(wb, "Data")
  table_x$writeToExcelWorksheet(wb=wb, wsName="Data",
                                 topRowNumber=1, leftMostColumnNumber=1,
                                 applyStyles=TRUE, mapStylesFromCSS=TRUE)
  if(missing(path)){
    table_x$renderTable()
  } else {
    table_x$renderTable()
    saveWorkbook(wb, file=(paste0(path,"/Color coded ranks frequency ", year, ".xlsx")), overwrite = TRUE)
  }
}
