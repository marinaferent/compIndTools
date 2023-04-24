# compIndTools: Tools for computing and validating composite indicators across multiple years

*rescaleColumns()* - (preprocessing stage) Rescales columns using
min-max normalization, z-scoring, or ranking. (.csv export option)

*linearAggExc()* - Creates composite indicators for multiple years
returning scores and ranks for each statistical unit through linear
aggregation. Automatically computes alternative scores and ranks for
inclusion and exclusion of individual indicators.(.csv export option)

To display uncertainity analysis, the package offers functions:

*ranksCount()* - Counts the number (percent) of times a statistical unit
takes a given rank. (.csv export option)

*descStats_scores_ranks()* - Provides a table with the initial rank,
average and median rank taken accross simulations. Also computes
standard deviation and coefficient of variation. (.csv export option)

*ranksCount_colCode()* - Exports .xlsx tables with the frequencies of
each rank color coded for initial, median and modal rank.

*rankShift_avg()* - Computes the average shift in ranking (total, per
year, and per country and year).

*boxplotRanks()* - Create boxplots of ranks taken in different
simulations. (.png export option)

## Installation

``` r
library(devtools)
```
``` r
install_github("marinaferent/compIndTools")
```

## Usage

Some examples are provided below.

**rescaleColumns()** - Rescales (min -max, z-score, rank) values per
column in a dataframe.

``` r
library(compIndTools)

dataTest_moreYears[c(1:5,27:32),1:5]
```

    ##           country time fixedTerm fixedTermComp selfEmployment
    ## 1         Belgium 2001  243.0769     300.42918       485.8757
    ## 2        Bulgaria 2001  160.0000     145.92275             NA
    ## 3  Czech Republic 2001        NA            NA       146.8927
    ## 4         Denmark 2001  261.5385     163.09013       242.9379
    ## 5         Germany 2001  353.8462      55.79399       310.7345
    ## 27         Sweden 2001  449.2308     167.38197       214.6893
    ## 28 United Kingdom 2001  175.3846      72.96137       570.6215
    ## 29        Belgium 2002  206.1538     248.92704       485.8757
    ## 30       Bulgaria 2002  135.3846     141.63090             NA
    ## 31 Czech Republic 2002        NA            NA       146.8927
    ## 32        Denmark 2002  243.0769     154.50644       242.9379

``` r
rescaleColumns(dataTest_moreYears)[c(1:5,27:32),1:5]
```

    ##       country          time   fixedTerm fixedTermComp selfEmployment
    ##  [1,] "Belgium"        "2001" "25.16"   "29.44"       "48.59"       
    ##  [2,] "Bulgaria"       "2001" "16.56"   "13.85"       NA            
    ##  [3,] "Czech Republic" "2001" NA        NA            "14.69"       
    ##  [4,] "Denmark"        "2001" "27.07"   "15.58"       "24.29"       
    ##  [5,] "Germany"        "2001" "36.62"   "4.76"        "31.07"       
    ##  [6,] "Sweden"         "2001" "46.5"    "16.02"       "21.47"       
    ##  [7,] "United Kingdom" "2001" "18.15"   "6.49"        "57.06"       
    ##  [8,] "Belgium"        "2002" "21.34"   "24.24"       "48.59"       
    ##  [9,] "Bulgaria"       "2002" "14.01"   "13.42"       NA            
    ## [10,] "Czech Republic" "2002" NA        NA            "14.69"       
    ## [11,] "Denmark"        "2002" "25.16"   "14.72"       "24.29"

``` r
rescaleColumns(dataTest_moreYears, method="z-score", decim=3)[1:5,1:5]
```

    ##      country          time   fixedTerm fixedTermComp selfEmployment
    ## [1,] "Belgium"        "2001" "-0.258"  "0.373"       "0.373"       
    ## [2,] "Bulgaria"       "2001" "-0.679"  "-0.388"      NA            
    ## [3,] "Czech Republic" "2001" NA        NA            "-0.976"      
    ## [4,] "Denmark"        "2001" "-0.164"  "-0.303"      "-0.593"      
    ## [5,] "Germany"        "2001" "0.304"   "-0.831"      "-0.324"

**linearAggExc()**- Computes index scores and ranks using linear
aggregation for one or multiple time periods. Automatically computes
alternative scores and ranks for inclusion and exclusion of individual
indicators.

``` r
dataTest_oneYear[1:5,1:5]
```

    ##          country time fixedTerm fixedTermComp selfEmployment
    ## 1        Belgium 2002  206.1538      248.9270       485.8757
    ## 2       Bulgaria 2002  135.3846      141.6309             NA
    ## 3 Czech Republic 2002        NA            NA       146.8927
    ## 4        Denmark 2002  243.0769      154.5064       242.9379
    ## 5        Germany 2002  341.5385       47.2103       310.7345

``` r
direction=c(1, -1,  1,  -1, 1,  -1, 1,  -1, 1,  1,  1,  1,  1,  1,  1,  -1, -1)
weight=c(1/18, 1/18, 1/18, 1/18, 1/18, 1/18, 1/15, 1/15, 1/15, 1/75, 1/75, 1/75, 1/75, 1/75, 1/15, 1/6, 1/6)
a=linearAggExc(dataTest_oneYear, direction, weight)
#to also store the scores and ranks into 2 .csv files:
#a=linearAggExc(dataTest, direction, weight, path="E:/Sample folder")
a$scores[1:5,1:5]
```

    ##   Statistical unit Time         S0          S1         S2
    ## 1          Belgium 2002 -30.582826  -42.035818 -16.753546
    ## 2         Bulgaria 2002   9.376503    1.855135  17.244886
    ## 3   Czech Republic 2002  16.800431   16.800431  16.800431
    ## 4          Denmark 2002 -90.919783 -104.424056 -82.336092
    ## 5          Germany 2002   3.791631  -15.182728   6.414426

``` r
a$ranks[1:5,1:5]
```

    ##   Statistical unit Time S0 S1 S2
    ## 1          Belgium 2002 14 14 14
    ## 2         Bulgaria 2002  9  8  7
    ## 3   Czech Republic 2002  6  5  8
    ## 4          Denmark 2002 25 25 24
    ## 5          Germany 2002 11 11 12

``` r
#for multiple years data: for each year one scores and one ranks matrix will be stored as a .csv file in the path folder:
#linearAggExc(x=dataTest_moreYears, direction=direction, weight=weight, path="E:/Sample folder", year1=2001, yearT=2003)
```

**ranksCount()** - Computes number and percent of times that each rank
is taken by each statistical unit.

``` r
ranks2001[1:5,]
```

    ##   Statistical.unit Time S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15  S16 S17
    ## 1          Belgium 2001 14 15 14 18 16 16 10 19 14 14  14  14  14  14  14  12  10  19
    ## 2         Bulgaria 2001  8  7  8  6 10  6 13  8  9  6   8   8   7   7   8   6  20  15
    ## 3   Czech Republic 2001  5  4  6  5  5  5  6  5  6  8   6   6   5   6   5   8  17  10
    ## 4          Denmark 2001 25 25 25 25 25 23 24 25 25 25  25  25  25  24  24  26  27   3
    ## 5          Germany 2001 13 11 12 12  8 12  7 13 12 11  12  13  12  13  11  19  2   13  

``` r
a=ranksCount(ranks2001)
a$rankNb[1:5,]
```

    ##   Statistical unit Time R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R13 R14 R15 R16  R17 R18 R19 R20 R21 R22 R23 R24 R25 R26 R27 R28
    ## 1          Belgium 2001  0  0  0  0  0  0  0  0  0   2   0   1   0   9   1   2   0   1   2   0   0   0   0   0   0   0   0   0
    ## 2         Bulgaria 2001  0  0  0  0  0  4  3  6  1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   0   0   0   0
    ## 3   Czech Republic 2001  0  0  0  1  7  6  0  2  0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0
    ## 4          Denmark 2001  0  0  1  0  0  0  0  0  0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   3  11   1   1   0
    ## 5          Germany 2001  0  1  0  0  0  0  1  1  0   0   3   6   5   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0
 
 
``` r
a$rankPc[1:5,]
```

    ##   Statistical unit Time R1    R2    R3    R4     R5     R6     R7     R8    R9
    ## 1          Belgium 2001 0%    0%    0%    0%     0%     0%     0%     0%    0%
    ## 2         Bulgaria 2001 0%    0%    0%    0%     0% 22.22% 16.67% 33.33% 5.56%
    ## 3   Czech Republic 2001 0%    0%    0% 5.56% 38.89% 33.33%     0% 11.11%    0%
    ## 4          Denmark 2001 0%    0% 5.56%    0%     0%     0%     0%     0%    0%
    ## 5          Germany 2001 0% 5.56%    0%    0%     0%     0%  5.56%  5.56%    0%
    ##      R10    R11    R12    R13 R14   R15    R16   R17   R18    R19   R20 R21 R22
    ## 1 11.11%     0%  5.56%     0% 50% 5.56% 11.11%    0% 5.56% 11.11%    0%  0%  0%
    ## 2  5.56%     0%     0%  5.56%  0% 5.56%     0%    0%    0%     0% 5.56%  0%  0%
    ## 3  5.56%     0%     0%     0%  0%    0%     0% 5.56%    0%     0%    0%  0%  0%
    ## 4     0%     0%     0%     0%  0%    0%     0%    0%    0%     0%    0%  0%  0%
    ## 5     0% 16.67% 33.33% 27.78%  0%    0%     0%    0%    0%  5.56%    0%  0%  0%
    ##     R23    R24    R25   R26   R27 R28
    ## 1    0%     0%     0%    0%    0%  0%
    ## 2    0%     0%     0%    0%    0%  0%
    ## 3    0%     0%     0%    0%    0%  0%
    ## 4 5.56% 16.67% 61.11% 5.56% 5.56%  0%
    ## 5    0%     0%     0%    0%    0%  0%

``` r
###to automatically store the two .csv files in the desired folder, use path:
#ranksCount(ranks2001, decim=0, path="E:/Sample folder")
```

**descStats_scores_ranks()** - Computes average, median, stdev, and
coefficient of variation for ranks or scores from multiple simulations.
Returns master file with initial rank (score), followed by average and
median one for each statistical unit and each period.

*Example 1:* one-year data

``` r
ranks2001[1:5,1:5]
```

    ##   Statistical.unit Time S0 S1 S2
    ## 1          Belgium 2001 14 15 14
    ## 2         Bulgaria 2001  8  7  8
    ## 3   Czech Republic 2001  5  4  6
    ## 4          Denmark 2001 25 25 25
    ## 5          Germany 2001 13 11 12

``` r
dataTestList=list(ranks2001)
a=descStats_scores_ranks(dataTestList,
#path="E:/Sample folder"
)
a$masterFile
```

    ##                0                        
    ## Belgium        "14 (Avg=14.5; Me=14)"   
    ## Bulgaria       "8 (Avg=8.89; Me=8)"     
    ## Czech Republic "5 (Avg=6.56; Me=6)"     
    ## Denmark        "25 (Avg=23.67; Me=25)"  
    ## Germany        "13 (Avg=11.44; Me=12)"  
    ## Estonia        "7 (Avg=7.78; Me=7)"     
    ## Ireland        "12 (Avg=11.39; Me=12)"  
    ## Greece         "22 (Avg=21.72; Me=22)"  
    ## Spain          "6 (Avg=7.22; Me=6)"     
    ## France         "11 (Avg=10.83; Me=11)"  
    ## Croatia        "28 (Avg=28; Me=28)"     
    ## Italy          "16 (Avg=16.06; Me=16)"  
    ## Cyprus         "18 (Avg=17.39; Me=17.5)"
    ## Latvia         "21 (Avg=20.17; Me=21)"  
    ## Lithuania      "23 (Avg=23.06; Me=23)"  
    ## Luxembourg     "15 (Avg=15.78; Me=15.5)"
    ## Hungary        "26 (Avg=25.83; Me=26)"  
    ## Malta          "9 (Avg=9.44; Me=9.5)"   
    ## Netherlands    "20 (Avg=19.06; Me=20)"  
    ## Austria        "10 (Avg=10.11; Me=10)"  
    ## Poland         "17 (Avg=17.33; Me=17)"  
    ## Portugal       "3 (Avg=3.33; Me=3)"     
    ## Romania        "1 (Avg=1.06; Me=1)"     
    ## Slovenia       "19 (Avg=18.39; Me=19)"  
    ## Slovakia       "24 (Avg=23.94; Me=24)"  
    ## Finland        "4 (Avg=4.39; Me=4)"     
    ## Sweden         "27 (Avg=26.39; Me=27)"  
    ## United Kingdom "2 (Avg=2.28; Me=2)"

*Example 2:* multiple years data

``` r
names(ranks2001_2003)
```

    ## [1] "ranks2001" "ranks2002" "ranks2003"

``` r
a=descStats_scores_ranks(ranks2001_2003, time=c(2001, 2002, 2003), decim=4)
a$masterFile[1:5,]
```

    ##                2001                      2002                     
    ## Belgium        "14 (Avg=14.5; Me=14)"    "14 (Avg=14.1111; Me=14)"
    ## Bulgaria       "8 (Avg=8.8889; Me=8)"    "9 (Avg=9.3889; Me=8)"   
    ## Czech Republic "5 (Avg=6.5556; Me=6)"    "6 (Avg=7.6111; Me=6.5)" 
    ## Denmark        "25 (Avg=23.6667; Me=25)" "25 (Avg=23.7222; Me=25)"
    ## Germany        "13 (Avg=11.4444; Me=12)" "11 (Avg=10.4444; Me=11)"
    ##                2003                     
    ## Belgium        "14 (Avg=14.1667; Me=14)"
    ## Bulgaria       "9 (Avg=9.7222; Me=8)"   
    ## Czech Republic "6 (Avg=6.9444; Me=6)"   
    ## Denmark        "24 (Avg=22.6667; Me=24)"
    ## Germany        "12 (Avg=11.3889; Me=12)"

``` r
a$x_stdev[1:5,]
```

    ##                2001     2002     2003    
    ## Belgium        "2.5029" "2.2981" "2.0934"
    ## Bulgaria       "3.6604" "3.9279" "3.7386"
    ## Czech Republic "2.9748" "3.0705" "3.0577"
    ## Denmark        "5.2244" "4.9918" "4.9705"
    ## Germany        "3.3646" "2.8947" "2.9732"

**ranksCount_colCode()** - Returns a color coded table with frequency of
each rank. Initial, median and modal rank frequency cells are
color-coded.

``` r
ranks2001[1:5,1:5]
```

    ##   Statistical.unit Time S0 S1 S2
    ## 1          Belgium 2001 14 15 14
    ## 2         Bulgaria 2001  8  7  8
    ## 3   Czech Republic 2001  5  4  6
    ## 4          Denmark 2001 25 25 25
    ## 5          Germany 2001 13 11 12

``` r
#' #ranksCount_colCode(ranks2001, decim=4, path="E:/Sample folder", year="2001")
a=ranksCount_colCode(ranks2001,decim=0)
```

**rankShift_avg()** - Computes the average shift in ranking. The novelty
of the function is that it extends the 1 period formula to encompass
multiple time periods. It returns three types of average shift in
ranking - total, per year, and per country and year.

``` r
ranksInitial2001_2003[1:5,]
```

    ##          Country X2001 X2002 X2003
    ## 1        Belgium    14    14    14
    ## 2       Bulgaria     8     9     9
    ## 3 Czech Republic     5     6     6
    ## 4        Denmark    25    25    24
    ## 5        Germany    13    11    12

``` r
names(ranksNb2001_2003)
```

    ## [1] "ranksNb2001" "ranksNb2002" "ranksNb2003"

``` r
a=rankShift_avg(ranksInitial2001_2003, ranksNb2001_2003)
a$RsTotal
```

    ## [1] 0.01544084

``` r
a$RsYear
```

    ## [1] 0.01553103 0.01531117 0.01548031

``` r
round(a$RsCountry[[1]],4)
```

    ##  [1] 0.0203 0.0208 0.0228 0.0188 0.0168 0.0198 0.0134 0.0114 0.0218 0.0134
    ## [11] 0.0089 0.0154 0.0154 0.0163 0.0114 0.0248 0.0094 0.0198 0.0213 0.0139
    ## [21] 0.0139 0.0119 0.0094 0.0173 0.0104 0.0124 0.0124 0.0114

**boxplotRanks()** - Creates a boxplot of ranks from simulations.

``` r
names(ranks2001_2003)
```

    ## [1] "ranks2001" "ranks2002" "ranks2003"

``` r
boxplotRanks(ranks2001_2003)
```

![](README_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->![](README_files/figure-gfm/unnamed-chunk-9-2.png)<!-- -->![](README_files/figure-gfm/unnamed-chunk-9-3.png)<!-- -->

If we want to use country codes instead, we could:

``` r
countryFullName=c("Belgium", "Bulgaria", "Czech Republic", "Denmark", "Germany", "Estonia", "Ireland", "Greece",
"Spain", "France", "Croatia", "Italy", "Cyprus", "Latvia", "Lithuania", "Luxembourg", "Hungary",
"Malta", "Netherlands", "Austria", "Poland", "Portugal", "Romania", "Slovenia", "Slovakia",
"Finland", "Sweden", "United Kingdom")
countryID=c("BE", "BG", "CZ", "DK", "DE", "EE", "IE", "GR", "ES", "FR", "HR", "IT", "CY", "LV", "LT", "LU", "HU",
            "MT", "NL", "AT", "PL", "PT", "RO", "SI", "SK", "FI", "SE", "UK")
boxplotRanks(ranks2001_2003, statUnitsFullName=countryFullName, statUnitsIDs=countryID)
```

![](README_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->![](README_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->![](README_files/figure-gfm/unnamed-chunk-10-3.png)<!-- -->

Below we create 3 boxplots and store them in the path folder: (2001.png,
2002.png, and 2003.png)

``` r
#boxplotRanks(ranks2001_2003, path="E:/Sample folder", statUnitsFullName=countryFullName, statUnitsIDs=countryID)
```

## References

For theoretical explanation on steps in constructing a composite
indicator, please refer to the books and articles listed below. To be
mentioned, the references only refer to one-year composite indicators.
Present package took the liberty to extend the knowledge to multiple
years.

— Nardo, M., Saisana, M., Saltelli, A., Tarantola, S., Hoffmann, A., &
Giovannini, E. (2008). Handbook on constructing composite indicators:
methodology and user guide. OECD Publishing. Retrieved from
<https://www.oecd.org/els/soc/handbookonconstructingcompositeindicatorsmethodologyanduserguide.htm>

— Saisana, M., & Saltelli, A. (2006). Sensitive Issues in the
Development of Composite Indicators for PolicyMaking. Conference:
Simulation in Industry and Services. Brussels, Belgium.

— Saisana, M., Saltelli, A., & Stefano , T. (2005). Uncertainty and
sensitivity analysis techniques as tools for the quality assessment of
composite indicators. Journal of the Royal Statistical Society: Series A
(Statistics in Society), 168(2), 307-323.

— Manca, A. R., Governatori, M., & Mascherini, M. (2010). Towards a set
of composite indicators on flexicurity: A comprehensive approach.
Luxembourg: Publications Office of the European Union. Retrieved from
<https://publications.jrc.ec.europa.eu/repository/handle/JRC58069>
