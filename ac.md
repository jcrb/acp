Analyse des correspondances
========================================================
Tutoriel sur l'analyse des corrspondances (AC) en R avec une application pratique a l'archeologie.

source
------
http://cainarchaeology.weebly.com/


```
## Installing packages into '/home/bart-rescue/R/x86_64-redhat-linux-gnu-library/3.0'
## (as 'lib' is unspecified)
```

```
## Error: trying to use CRAN without setting a mirror
```



Aim of Correspondence Analysis
------------------------------

CA is a statistical exploratory tool whose popularity has steadily grown in the social sciences (see, e.g., the papers in Blasius, Greenacre 1998) as well as in archaeology. Even though in the latter field CA has been slow in gaining popularity, with the exception of early groundbreaking studies (Bølviken et al. 1982; Djindjian 1985; Madsen 1989; Gillis 1990), today it is used for many purposes, including intrasite activity areas research (Kuijt, Goodale 2009; Alberti 2012, 2013), burial assemblages analysis (Wallin 2010), on-site distribution of faunal remains (Potter 2000; Morris 2008), distribution of drinking pottery types in the context of cultures contact (Pitts 2005), stratigraphy and formation processes (Mameli et al. 2002; Pavùk 2010), seriation and chronology (Bellanger et al. 2008; Peeples, Schachner 2012).

CA represente graphiuememt les dependance entre les lignes et les colonnes d'une table de contingence. L.affichage visuel des donnees faciite l'interpretation et favorise l'emerence de motifs. La technique reduit le nombre de dimensions necessaires pour afficher les points en decomposant l'inertie totale (ie la variabilite) de la table et en definissant le nombre minimal de dimensions necessaires pour representer la variabilite des donnees.

The graphical output of CA is a scatterplot where rows and/or columns are represented as points in a sequence of low-dimensional spaces. These spaces have the properties to retain a decreasing amount of the total inertia. The first dimension will capture the highest amount, while the second will be associated with the second largest proportion, and so on. 

On the scatterplot, the distance between data points of the same type (i.e., row-to-row) is related to the degree to which the rows have similar profiles (i.e., relative frequencies of column categories). The same applies for the column-to-column distance. The more the points are close to one another, the more similar their profiles will be. The origin of the axes represents the centroid (i.e., the average profile), and can be conceptualized as the “place” where there is no difference between profiles or, more formally (and to recall the chi-square terminology), it represents the hypothesis of homogeneity of the profiles (Greenacre 2007, 32). The more different are the latter, the more the profile points will be spread on the plane away from the centroid. 

As for the relative distances between points of different type (i.e., row-to-column), it tells the analyst something about the “correspondence” between the categories that made up the table. In other words, the more a row point is close to a column point, the greater (i.e., the more distant from the average) is the proportion of that column category on the row profile. 

Outliers are row/column profiles that dramatically deviate from the others, for example, for having very small (or very large) frequencies and/or very few categories. These affect the graphical output of CA. As stressed by Baxter, Cool (2010, 220), these points will lie far away from the rest of the cloud of points, dominating the plot, and causing the other profile points to cluster together. It has to be stressed, however, that the problem is only a matter of graphical layout since it does not affect the determination of the CA dimensions as Greenacre (2007, 269-270; 2011) has demonstrated. It will be shown later on how the “correct” visualization (i.e., not influenced by outliers) and the interpretation of CA plots can be assured even in the presence of outlier profile points. This can be accomplished by using the Greenacre’s Standard Biplot (Greenacre 2007, 101-102; also called Contribution Biplot in Greenacre 2011, 9) that can be easily obtained by the package ‘ca’ via the R script here described.


```r
source("ac.R")
```

```
## -The input Table has 11 Rows and 7 Columns 
## -The Correlation Coefficient btw Rows and Columns is 0.57 
## -The total number of dimensions is 6 
## -The Average Rule indicates that the number of relevant dimensions is 2 
## -The Malinvaud's Test indicates that the number of relevant dimensions is 2 
## -The Malinvaud's Test details are the following: 
##      K Dimension Eigen value Chi-square df p value
## [1,] 0         1    0.185297    278.563 60  0.0000
## [2,] 1         2    0.100495    119.764 45  0.0000
## [3,] 2         3    0.021254     33.640 32  0.3879
## [4,] 3         4    0.011375     15.425 21  0.8010
## [5,] 4         5    0.005168      5.677 12  0.9315
## [6,] 5         6    0.001456      1.248  5  0.9402
## note: the analysis' output showing up on the console will be also saved as .txt file in this directory:  /home/bart-rescue/Documents/JCB/R/acp
```

```
##  Correspondence Analysis script by Gianmarco ALBERTI 
##     (gianmarcoalberti@tin.it)
##     (www.xoomer.alice.it/gianmarco.alberti)
##                                        
## script executed on Fri Nov  8 14:03:34 2013                                       
## number of dimensions to be analyzed selected by the user: 2                                       
##                                        
##  * Start of Correspondence Analysis output *
## ...................................................................
##                                        
## ================================================================
## Contingency Table
## ================================================================
##     Type.A Type.B Type.C Type.D Type.E Type.F Type.G Sum
## 2       28     31     16     19     12     30      2 138
## 3        5      1      3      6      3      7      3  28
## 4       15     16     13      9      9     14      2  78
## 5       15     23     42      5      5      2      1  93
## 6       21     24     12      9      1      9      2  78
## 7        5     10     11      1      6      3      8  44
## 8        2      5     17      0      8      2     13  47
## 9        2     21     26      0      5      3      2  59
## 10      10     23     24      9      6     21      0  93
## 11      24     30     17     14      9     30      0 124
## 12      11     25     21      5      7      6      0  75
## Sum    138    209    202     77     71    127     33 857
##                                         
## ================================================================
## Row profiles (%)
## ================================================================
##     Type.A Type.B Type.C Type.D Type.E Type.F Type.G
## 2    20.29  22.46  11.59  13.77   8.70  21.74   1.45
## 3    17.86   3.57  10.71  21.43  10.71  25.00  10.71
## 4    19.23  20.51  16.67  11.54  11.54  17.95   2.56
## 5    16.13  24.73  45.16   5.38   5.38   2.15   1.08
## 6    26.92  30.77  15.38  11.54   1.28  11.54   2.56
## 7    11.36  22.73  25.00   2.27  13.64   6.82  18.18
## 8     4.26  10.64  36.17   0.00  17.02   4.26  27.66
## 9     3.39  35.59  44.07   0.00   8.47   5.08   3.39
## 10   10.75  24.73  25.81   9.68   6.45  22.58   0.00
## 11   19.35  24.19  13.71  11.29   7.26  24.19   0.00
## 12   14.67  33.33  28.00   6.67   9.33   8.00   0.00
## Sum  16.10  24.39  23.57   8.98   8.28  14.82   3.85
##                                         
## ================================================================
## Column profiles (%)
## ================================================================
##    Type.A Type.B Type.C Type.D Type.E Type.F Type.G   Sum
## 2   20.29  14.83   7.92  24.68  16.90  23.62   6.06 16.10
## 3    3.62   0.48   1.49   7.79   4.23   5.51   9.09  3.27
## 4   10.87   7.66   6.44  11.69  12.68  11.02   6.06  9.10
## 5   10.87  11.00  20.79   6.49   7.04   1.57   3.03 10.85
## 6   15.22  11.48   5.94  11.69   1.41   7.09   6.06  9.10
## 7    3.62   4.78   5.45   1.30   8.45   2.36  24.24  5.13
## 8    1.45   2.39   8.42   0.00  11.27   1.57  39.39  5.48
## 9    1.45  10.05  12.87   0.00   7.04   2.36   6.06  6.88
## 10   7.25  11.00  11.88  11.69   8.45  16.54   0.00 10.85
## 11  17.39  14.35   8.42  18.18  12.68  23.62   0.00 14.47
## 12   7.97  11.96  10.40   6.49   9.86   4.72   0.00  8.75
##                                         
## ================================================================
## Association coefficients
## ================================================================
##                     X^2 df P(> X^2)
## Likelihood Ratio 259.62 60        0
## Pearson          278.56 60        0
## 
## Phi-Coefficient   : 0.57 
## Contingency Coeff.: 0.495 
## Cramer's V        : 0.233 
##                                         
## ================================================================
## Chi-square test
## ================================================================
```

```
## Warning: Chi-squared approximation may be incorrect
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  mydata
## X-squared = 278.6, df = 60, p-value < 2.2e-16
## 
##                                         
## ================================================================
## Association between rows and columns
## ================================================================
##                                         
## Total Inertia:
## [1] 0.325
##                                         
## Square root of the Total Inertia:
## [1] 0.57
##                                         
## note: 
##     The square root of the Total Inertia may be interpreted as a correlation coefficient (phi) between the rows and columns. 
##     Any value greater 0.20 indicates important dependency (see also the bar chart provided).
##                                         
## ================================================================
## Correspondence Analysis summary
## ================================================================
## 
## Principal inertias (eigenvalues):
## 
##  dim    value      %   cum%   scree plot               
##  1      0.185297  57.0  57.0  *************************
##  2      0.100495  30.9  87.9  *************            
##  3      0.021254   6.5  94.5  ***                      
##  4      0.011375   3.5  98.0  *                        
##  5      0.005168   1.6  99.6  *                        
##  6      0.001456   0.4 100.0                           
##         -------- -----                                 
##  Total: 0.325045 100.0                                 
## 
## 
## Rows:
##      name   mass  qlt  inr    k=1 cor ctr    k=2 cor ctr  
## 1  |    2 |  161  990   72 | -315 681  86 |  213 309  72 |
## 2  |    3 |   33  827   62 |  -27   1   0 |  716 825 167 |
## 3  |    4 |   91  731   18 | -149 352  11 |  155 378  22 |
## 4  |    5 |  109  849  117 |  197 111  23 | -509 738 280 |
## 5  |    6 |   91  269   55 | -229 268  26 |   -7   0   0 |
## 6  |    7 |   51  953  107 |  755 841 158 |  275 111  39 |
## 7  |    8 |   55  999  331 | 1327 898 521 |  446 101 108 |
## 8  |    9 |   69  914  103 |  386 308  55 | -542 605 201 |
## 9  |   10 |  109  386   35 | -184 325  20 |  -79  60   7 |
## 10 |   11 |  145  937   68 | -357 833  99 |  126 105  23 |
## 11 |   12 |   88  789   32 |  -21   4   0 | -306 785  82 |
## 
## Columns:
##     name   mass  qlt  inr    k=1 cor ctr    k=2 cor ctr  
## 1 | TypA |  161  568   75 | -278 509  67 |   94  59  14 |
## 2 | TypB |  244  655   58 |  -70  64   6 | -214 592 111 |
## 3 | TypC |  236  938  187 |  327 414 136 | -368 524 318 |
## 4 | TypD |   90  886   85 | -440 626  94 |  284 260  72 |
## 5 | TypE |   83  601   48 |  267 381  32 |  203 220  34 |
## 6 | TypF |  148  833  145 | -403 512 130 |  319 322 150 |
## 7 | TypG |   39  990  402 | 1604 759 535 |  886 231 301 |
## 
##                                         
## ================================================================
## Guide to the number of Dimensions to take into account
## ================================================================
##                                         
## Any axis contributing more than the following percentage should be regarded as important for the interpretation:
## [1] 16.7
##                                         
## note: 
##     For comparison, see the % provided in the Correspondence Analysis summary (above) as well as the bar chart provided.
##     Besides this rule (i.e. the average rule) see also the Malinvaud's Test table (below) and plot
##                                         
## ================================================================
## Malinvaud's Test table
## ================================================================
##      K Dimension Eigen value Chi-square df p value
## [1,] 0         1    0.185297    278.563 60  0.0000
## [2,] 1         2    0.100495    119.764 45  0.0000
## [3,] 2         3    0.021254     33.640 32  0.3879
## [4,] 3         4    0.011375     15.425 21  0.8010
## [5,] 4         5    0.005168      5.677 12  0.9315
## [6,] 5         6    0.001456      1.248  5  0.9402
##                                         
##                                         
## ================================================================
## Dimensionality of the solution. Average rule vs Malinvaud's test:
## ================================================================
## The Average rule suggests an optimal dimensionality equal to 2 dimensions                                        
## The Malinvaud's test suggests an optimal dimensionality equal to 2 dimensions                                        
##                                         
##                                         
## ================================================================
## Major contributors to the definition of dimensions
## ================================================================
##                                         
## Any category whose contribution is greater than the following figures (in permills) contributes to the definition of the principal axes:
##                                         
## Rows contribution threshold
## [1] 91
##                                         
## Columns contribution threshold
## [1] 143
##                                         
## note:
## You have to decide whether interpreting row categories in columns space, or viceversa. 
##     Then, according to your decision, see which row or column categories have major contribution to the definition of the axes by locating the ones whose contribution is greater than the above threshold. 
##     For categories' contribution, see: (a) the figures provided in the Correspondence Analysis summary (above) under the label 'ctr'; (b) the charts provided.
##     Besides, take into account the sign of the coordinates of the category points (under the 'k' label in the CA summary above) to understand which pole (positive and negative) of the axes the categories are actually determining.
##     Further, after having 'given names' to the axes according to the (row or column) categories relevant to their definition, take a look at the correlation bar chart (provided) in order to understand with which dimension the categories have strong correlation (see Greenacre 2007, p. 86).
##                                         
## ================================================================
## Clusters description (after FactoMineR)
## ================================================================
##                                         
## Row clusters
## ____________
##       Dim 1     Dim 2 clust
## 11 -0.35678  0.126378     1
## 2  -0.31548  0.212527     1
## 6  -0.22922 -0.006764     1
## 10 -0.18365 -0.079141     1
## 4  -0.14947  0.154850     1
## 3  -0.02658  0.716218     1
## 12 -0.02118 -0.306425     2
## 5   0.19734 -0.508983     2
## 9   0.38641 -0.541571     2
## 7   0.75490  0.274552     3
## 8   1.32684  0.445649     3
##                                         
## Column clusters
## _______________
##           Dim 1   Dim 2 clust
## Type.D -0.43970  0.2836     1
## Type.F -0.40281  0.3194     1
## Type.A -0.27765  0.0944     1
## Type.B -0.07024 -0.2140     2
## Type.E  0.26705  0.2027     2
## Type.C  0.32726 -0.3680     2
## Type.G  1.60435  0.8859     3
##                                         
##                                         
##                                         
## ***************************************************************
## *             List of the Plots provided by this Script       *
## ***************************************************************
## Window 1: -Bar chart of the strenght of the correlation between rows and columns of the input crosstab
##     -Bar chart of the percentage of Inertia explained by the dimensions
##     -Malinvaud Test Plot
##     (note: the Script will plot only the Dimensions that are significant according to the Malinvaud Test)
##     
##     Window 2: -Bar charts of the Quality of the diplay of Row categories on pairs of successive dimensions
##     
##     Window 3: -Bar charts of the Quality of the diplay of Column categories on pairs of successive dimensions
##     
##     Window 4: -Bar charts of the Contribution of Row categories to the Dimensions
##     
##     Window 5: -Bar charts of the Contribution of Column categories to the Dimensions
##     
##     Window 6: -Bar charts of the Correlation of Row categories with the Dimensions
##     
##     Window 7: -Bar charts of the Correlation of Column categories with the Dimensions
##     
##     Window 8: -CA symmetric Map displaying both Row and Column points
##     -CA symmetric Map for Rows only
##     -CA symmetric Map for Columns only
##     (note: the total number of charts in this Windows depends on the number of Dimensions that have been plotted)
##     
##     Window 9: -CA Standard Biplots
##     
##     Windows from 10 onward: -2D CA Maps with clustering (for Rows)
##     -3D CA Map with clustering (for Rows)
##     -Clusters Tree with indication of group membership (for Rows)
##     -2D CA Maps with clustering (for Columns)
##     -3D CA Map with clustering (for Columns)
##     -Clusters Tree with indication of group membership (for Columns)
##     (note: the total number of 2D and 3D charts depends on the number of Dimensions that have been plotted)
##     
##                                         
##                                         
##                                         
## ***************************************************************
## *                 Note on the Standard Biplot                 *
## ***************************************************************
##                                         
## Rows in principal coordinates and columns in standard coordinates times square root of the mass. (Greenacre 2007, pp. 102, 234, 268, 270). 
##     The lenght of each arrow joining the column points to the origin is proportional to the contribution that each column category makes to the principal axes; colour intensity proportional to the absolute contribution to the total inertia.
##     
##     See: Greenacre 2007, pp. 101-103, 234, 268, 270; Greenacre 2010, pp. 87-88; Greenacre 2013 
##                                         
## Reference:
## Greenacre 2007: Greenacre M., 'Correspondence Analysis in Practice'. Second Edition. Boca Raton-London-New York, Chapman&Hall/CRC
##     Greenacre 2010: Greenacre M., 'Biplots in Practice', Fundacion BBVA
##     Greenacre 2013: Greenacre M., 'Contribution Biplots', Journal of Computational and Graphical Statistics 22(1)
##                                      
## ...................................................................
##  * End of Correspondence Analysis output *
```


