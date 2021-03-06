# In order to perform Correspondence Analysis, this script requires you to install 3 needed packages.
# If you are not familiar with R and yet want to install them, you can copy and paste the following 3 line code (without the initial "#" symbol) into the R console, and press return:
#install.packages("ca", dependencies=TRUE)
#install.packages("FactoMineR", dependencies=TRUE)
#install.packages("vcd", dependencies=TRUE)

## START OF THE SCRIPT ##

# initialize required packages
suppressPackageStartupMessages(library(ca))
suppressPackageStartupMessages(library(FactoMineR))
suppressPackageStartupMessages(library(vcd))

# get the working current directory
current.wd <- getwd()

# read data from choosen table
f<-"exemple1.csv"
#mydata <- read.table(file=file.choose(), header=TRUE, sep=",")
mydata <- read.table(file=f, header=TRUE, sep=",")
# retrecit le tableau pour eliminer les intitules lignes et colonne
mydata <- mydata[2:12,2:8]

# get some details about the input table
grandtotal <- sum(mydata)
nrows <- nrow(mydata)
ncols <- ncol(mydata)
numb.dim.cols<-ncol(mydata)-1
numb.dim.rows<-nrow(mydata)-1
a <- min(numb.dim.cols, numb.dim.rows) #dimensionality of the table
labs<-c(1:a) #set the numbers that will be used as x-axis' labels on the Malinvaud's test scatterplot

# contingency table as matrix
mydataasmatrix<-as.matrix(mydata)

# contingency table w/ row and columns profiles
data.w.rowsum<-addmargins(mydataasmatrix,1)
data.w.colsum<-addmargins(mydataasmatrix,2)

# Number of dimensions according to the average rule
c.dim<-round(100/(ncols-1), digits=1)
r.dim<-round(100/(nrows-1), digits=1)
thresh.sig.dim<-(max(c.dim, r.dim))
dataframe.after.ca<- summary(ca(mydata))
n.dim.average.rule <- length(which(dataframe.after.ca$scree[,3]>=thresh.sig.dim))

# Malinvaud's Test
malinv.ca<-CA(mydata, ncp=a, graph=FALSE)
malinv.test.rows <- a
malinv.test.cols <- 6
malinvt.output <-matrix(ncol= malinv.test.cols, nrow=malinv.test.rows)
colnames(malinvt.output) <- c("K", "Dimension", "Eigen value", "Chi-square", "df", "p value")
malinvt.output[,1] <- c(0:(a-1))
malinvt.output[,2] <- c(1:a)
for(i in 1:malinv.test.rows){
  k <- -1+i
  malinvt.output[i,3] <- malinv.ca$eig[i,1]
  malinvt.output[i,5] <- (nrows-k-1)*(ncols-k-1)
}
malinvt.output[,4] <- rev(cumsum(rev(malinvt.output[,3])))*grandtotal
malinvt.output[,6] <- round(pchisq(malinvt.output[,4], malinvt.output[,5], lower.tail=FALSE), digits=6)
optimal.dimensionality <- length(which(malinvt.output[,6]<=0.05))

# plot bar chart of correlation between rows and columns, and add reference line
dev.new()
perf.corr<-(1.0)
sqr.trace<-round(sqrt(sum(dataframe.after.ca$scree[,2])), digits=3)
barplot(c(perf.corr, sqr.trace), main="Correlation coefficient between rows & columns (=square root of the inertia)", sub="reference line: threshold of important correlation ", ylab="correlation coeff.", names.arg=c("correlation coeff. range", "correlation coeff. bt rows & cols"), cex.main=0.80, cex.sub=0.80, cex.lab=0.80)
abline(h=0.20)

# plot bar chart of inertia explained by the dimensions, and add reference line corresponding to the Average Rule threshold
barplot(dataframe.after.ca$scree[,3], xlab="Dimensions", ylab="% of Inertia", names.arg=dataframe.after.ca$scree[,1])
abline(h=thresh.sig.dim)
title (main="Percentage of inertia explained by the dimensions", sub="reference line: threshold of an optimal dimensionality of the solution, according to the average rule (see also the Malinvaud's test Plot)", cex.main=0.80, cex.sub=0.80)

# Malinvaud's test Plot
plot(malinvt.output[,6], type="o", xaxt="n", xlim=c(1, a), xlab="Dimensions", ylab="p value")
axis(1, at=labs, labels=sprintf("%.0f",labs))
title(main="Malinvaud's test Plot", sub="dashed line: alpha 0.05 threshold", col.sub="RED", cex.sub=0.80)
abline(h=0.05, lty=2, col="RED")

# prompt to the user and selection of the number of dimensions to be plotted
cat(paste("-The input Table has", nrows, "Rows and", ncols, "Columns"))
cat(" \n")
cat(paste("-The Correlation Coefficient btw Rows and Columns is", sqr.trace))
cat(" \n")
cat(paste("-The total number of dimensions is", a))
cat(" \n")
cat(paste("-The Average Rule indicates that the number of relevant dimensions is", n.dim.average.rule))
cat(" \n")
cat(paste("-The Malinvaud's Test indicates that the number of relevant dimensions is", optimal.dimensionality))
cat(" \n")
cat("-The Malinvaud's Test details are the following:")
cat(" \n")
print(malinvt.output)
cat(paste("note: the analysis' output showing up on the console will be also saved as .txt file in this directory: ", current.wd))
cat(" \n")
# user.dimensionality <- as.numeric(readline(prompt="How many dimensions do you want to analyze (min=2)? "))
user.dimensionality <- 2
dims.to.be.plotted <- user.dimensionality 

# CA analysis by Greenacre's package to be used later on for the Standard Biplots
res.ca <- ca(mydata, nd=dims.to.be.plotted)

# CA output as dataframe to be used for the some graphs to come
cadataframe<-summary(ca(mydata, nd=dims.to.be.plotted))

# plot the quality of the display of categories on successive pairs of dimensions
#row categories
dev.new()
counter <- 1
for(i in seq(9, ncol(cadataframe$rows), 3)){	
  counter <- counter +1
  quality.rows <- (cadataframe$rows[,6]+cadataframe$rows[,i])/10
  barplot(quality.rows, ylim=c(0,100), xlab="Row categories", ylab=paste("Quality of the display (% of inertia) on Dim. 1+", counter), names.arg=cadataframe$rows[,1], cex.lab=0.80)
}

#column categories
dev.new()
counter <- 1
for(i in seq(9, ncol(cadataframe$columns), 3)){	
  counter <- counter +1
  quality.cols <- (cadataframe$columns[,6]+cadataframe$columns[,i])/10
  barplot(quality.cols, ylim=c(0,100), xlab="Column categories", ylab=paste("Quality of the display (% of inertia) on Dim. 1+", counter), names.arg=cadataframe$columns[,1], cex.lab=0.80)
}

# charts of categories contribution
# plot bar charts of contribution of row categories to the axes, and add a reference line
dev.new()
counter <- 0
for(i in seq(7, ncol(cadataframe$rows), 3)){	
  counter <- counter +1
  barplot(cadataframe$rows[,i], ylim=c(0,1000), xlab="Row categories", ylab=paste("Contribution to Dim. ",counter," (in permills)"), names.arg=cadataframe$rows[,1], cex.lab=0.80)
  abline(h=round(((100/nrows)*10), digits=0))
}

# plot bar charts of contribution of column categories to the axes, and add a reference line
dev.new()
counter <- 0
for(i in seq(7, ncol(cadataframe$columns), 3)){	
  counter <- counter +1
  barplot(cadataframe$columns[,i], ylim=c(0,1000), xlab="Column categories", ylab=paste("Contribution to Dim. ",counter," (in permills)"), names.arg=cadataframe$columns[,1], cex.lab=0.80)
  abline(h=round(((100/ncols)*10), digits=0))
}

# correlation of categories to dimensions
# row categories
dev.new()
counter <- 0
for(i in seq(6, ncol(cadataframe$rows), 3)){	
  counter <- counter +1
  correl.rows <- round(sqrt((cadataframe$rows[,i]/1000)), digits=3)
  barplot(correl.rows, ylim=c(0,1), xlab="Row categories", ylab=paste("Correlation with Dim. ", counter), names.arg=cadataframe$rows[,1], cex.lab=0.80)
}

#column categories
dev.new()
counter <- 0
for(i in seq(6, ncol(cadataframe$columns), 3)){	
  counter <- counter +1
  correl.cols <- round(sqrt((cadataframe$columns[,i]/1000)), digits=3)
  barplot(correl.cols, ylim=c(0,1), xlab="Column categories", ylab=paste("Correlation with Dim. ", counter), names.arg=cadataframe$columns[,1], cex.lab=0.80)
}

## CA graphical outputs ##:
# symmetric plots from FactoMineR package
dev.new()
counter <- 1
for(i in 2:dims.to.be.plotted){	
  counter <- counter +1
  plot(malinv.ca, axes=c(1,i), shadow=TRUE, cex=0.80, invisible="none", title = paste("Correspondence Analysis-symmetric map: Dim. 1 +", counter))
  plot(malinv.ca, axes=c(1,i), shadow=TRUE, cex=0.80, invisible="col", title = paste("Correspondence Analysis-symmetric rows map: Dim. 1 +", counter))
  plot(malinv.ca, axes=c(1,i), shadow=TRUE, cex=0.80, invisible="row", title = paste("Correspondence Analysis-symmetric cols map: Dim. 1 +", counter))
}

# asymmetric biplots (Standard Biplots) from Greenacre's package: rows in principal coordinates and columns in standard coordinates times square root of the mass (Greenacre 2007, pp. 102, 234, 268, 270). NOTE: The lenght of each arrow joining the column points to the origin is proportional to the contribution that each column category makes to the principal axes; colour intensity proportional to the absolute contribution to the total inertia
dev.new()
counter <- 1
for(i in 2:dims.to.be.plotted){	
  counter <- counter +1
  plot(res.ca, mass = FALSE, dim=c(1,i), contrib = "none", col=c("black", "red"), map ="rowgreen", arrows = c(FALSE, TRUE), main = paste("Correspondence Analysis-standard biplot: Dim. 1 +", counter))
  plot(res.ca, mass = FALSE, dim=c(1,i), contrib = "none", col=c("black", "red"), map ="colgreen", arrows = c(TRUE, FALSE), main = paste("Correspondence Analysis-standard biplot: Dim. 1 +", counter))
  plot(res.ca, mass = FALSE, dim=c(1,i), contrib = "absolute", col=c("black", "red"), map ="rowgreen", arrows = c(FALSE, TRUE), main = paste("Correspondence Analysis-standard biplot: Dim. 1 +", counter), sub="colour intensity proportional to the absolute contribution to the inertia", cex.sub=0.70)
  plot(res.ca, mass = FALSE, dim=c(1,i), contrib = "absolute", col=c("black", "red"), map ="colgreen", arrows = c(TRUE, FALSE), main = paste("Correspondence Analysis-standard biplot: Dim. 1 +", counter), sub="colour intensity proportional to the absolute contribution to the inertia", cex.sub=0.70)
}

## clustering after FactoMiner package:
ca.factom <- CA(mydata, ncp=dims.to.be.plotted, graph= FALSE)
resclust.rows<-HCPC(ca.factom, nb.clust=-1, metric="euclidean", method="ward", order=TRUE, graph.scale="inertia", graph=FALSE, cluster.CA="rows")
resclust.cols<-HCPC(ca.factom, nb.clust=-1, metric="euclidean", method="ward", order=TRUE, graph.scale="inertia", graph=FALSE, cluster.CA="columns")

# plots for row clusters
#2D scatterplots
for(i in 2:dims.to.be.plotted){	
  plot(resclust.rows, axes=c(1,i), choice="map", draw.tree=FALSE, ind.names=TRUE, new.plot=TRUE)
}
#3D scatterplots
for(i in 2:dims.to.be.plotted){	
  plot(resclust.rows, axes=c(1,i), choice="3D.map", draw.tree=TRUE, ind.names=TRUE, new.plot=TRUE)
}
#clusters tree
plot(resclust.rows, choice="tree", rect=TRUE, new.plot=TRUE)

# plots for column clusters
#2D scatterplots
for(i in 2:dims.to.be.plotted){	
  plot(resclust.cols, axes=c(1,i), choice="map", draw.tree=FALSE, ind.names=TRUE, new.plot=TRUE)
}
#3D scatterplots
for(i in 2:dims.to.be.plotted){
  plot(resclust.cols, axes=c(1,i), choice="3D.map", draw.tree=TRUE, ind.names=TRUE, new.plot=TRUE)
}
#clusters tree
plot(resclust.cols, choice="tree", rect=TRUE, new.plot=TRUE)


## create the output .txt file with some of the analysis' results ##
sink("output_CorrespondenceAnalysis.txt", split=TRUE)
cat(" Correspondence Analysis script by Gianmarco ALBERTI 
    (gianmarcoalberti@tin.it)
    (www.xoomer.alice.it/gianmarco.alberti)\n")
cat("                                       \n")
cat(paste("script executed on", date()))
cat("                                       \n")
cat(paste("number of dimensions to be analyzed selected by the user:", dims.to.be.plotted))
cat("                                       \n")
cat("                                       \n")
cat(" * Start of Correspondence Analysis output *\n")
cat("...................................................................\n")
cat("                                       \n")

cat("================================================================\n")
cat("Contingency Table\n")
cat("================================================================\n")
print(addmargins(mydataasmatrix))

cat("                                        \n")
cat("================================================================\n")
cat("Row profiles (%)\n")
cat("================================================================\n")
data.w.rowsum<-addmargins(mydataasmatrix,1)
print(round(prop.table(data.w.rowsum,1), digits=4)*100)

cat("                                        \n")
cat("================================================================\n")
cat("Column profiles (%)\n")
cat("================================================================\n")
data.w.colsum<-addmargins(mydataasmatrix,2)
print(round(prop.table(data.w.colsum,2), digits=4)*100)

cat("                                        \n")
cat("================================================================\n")
cat("Association coefficients\n")
cat("================================================================\n")
print(assocstats(mydataasmatrix))

cat("                                        \n")
cat("================================================================\n")
cat("Chi-square test\n")
cat("================================================================\n")
print(chisq.test(mydata))

cat("                                        \n")
cat("================================================================\n")
cat("Association between rows and columns\n")
cat("================================================================\n")
cat("                                        \n")
cat("Total Inertia:\n")
print(sum(cadataframe$scree[,2]))
cat("                                        \n")
cat("Square root of the Total Inertia:\n")
print(sqr.trace)
cat("                                        \n")
cat("note: 
    The square root of the Total Inertia may be interpreted as a correlation coefficient (phi) between the rows and columns. 
    Any value greater 0.20 indicates important dependency (see also the bar chart provided).\n")

cat("                                        \n")
cat("================================================================\n")
cat("Correspondence Analysis summary\n")
cat("================================================================\n")
print(cadataframe)

cat("                                        \n")
cat("================================================================\n")
cat("Guide to the number of Dimensions to take into account\n")
cat("================================================================\n")
cat("                                        \n")
cat("Any axis contributing more than the following percentage should be regarded as important for the interpretation:\n")
print(thresh.sig.dim)
cat("                                        \n")
cat("note: 
    For comparison, see the % provided in the Correspondence Analysis summary (above) as well as the bar chart provided.
    Besides this rule (i.e. the average rule) see also the Malinvaud's Test table (below) and plot\n")

cat("                                        \n")
cat("================================================================\n")
cat("Malinvaud's Test table\n")
cat("================================================================\n")
print(malinvt.output)

cat("                                        \n")
cat("                                        \n")
cat("================================================================\n")
cat("Dimensionality of the solution. Average rule vs Malinvaud's test:\n")
cat("================================================================\n")
cat(paste("The Average rule suggests an optimal dimensionality equal to", n.dim.average.rule, "dimensions"))
cat("                                        \n")
cat(paste("The Malinvaud's test suggests an optimal dimensionality equal to", optimal.dimensionality, "dimensions"))

cat("                                        \n")
cat("                                        \n")
cat("                                        \n")
cat("================================================================\n")
cat("Major contributors to the definition of dimensions\n")
cat("================================================================\n")
cat("                                        \n")
cat("Any category whose contribution is greater than the following figures (in permills) contributes to the definition of the principal axes:\n")
cat("                                        \n")
cat("Rows contribution threshold\n")
print(round(((100/nrows)*10), digits=0))
cat("                                        \n")
cat("Columns contribution threshold\n")
print(round(((100/ncols)*10), digits=0))
cat("                                        \n")
cat("note:\n")
cat("You have to decide whether interpreting row categories in columns space, or viceversa. 
    Then, according to your decision, see which row or column categories have major contribution to the definition of the axes by locating the ones whose contribution is greater than the above threshold. 
    For categories' contribution, see: (a) the figures provided in the Correspondence Analysis summary (above) under the label 'ctr'; (b) the charts provided.
    Besides, take into account the sign of the coordinates of the category points (under the 'k' label in the CA summary above) to understand which pole (positive and negative) of the axes the categories are actually determining.
    Further, after having 'given names' to the axes according to the (row or column) categories relevant to their definition, take a look at the correlation bar chart (provided) in order to understand with which dimension the categories have strong correlation (see Greenacre 2007, p. 86).\n")

cat("                                        \n")
cat("================================================================\n")
cat("Clusters description (after FactoMineR)\n")
cat("================================================================\n")
cat("                                        \n")
cat("Row clusters\n")
cat("____________\n")
print(resclust.rows$data.clust)
cat("                                        \n")
cat("Column clusters\n")
cat("_______________\n")
print(resclust.cols$data.clust)


# print the list of the charts provided
cat("                                        \n")
cat("                                        \n")
cat("                                        \n")
cat("***************************************************************\n")
cat("*             List of the Plots provided by this Script       *\n")
cat("***************************************************************\n")
cat("Window 1: -Bar chart of the strenght of the correlation between rows and columns of the input crosstab
    -Bar chart of the percentage of Inertia explained by the dimensions
    -Malinvaud Test Plot
    (note: the Script will plot only the Dimensions that are significant according to the Malinvaud Test)
    
    Window 2: -Bar charts of the Quality of the diplay of Row categories on pairs of successive dimensions
    
    Window 3: -Bar charts of the Quality of the diplay of Column categories on pairs of successive dimensions
    
    Window 4: -Bar charts of the Contribution of Row categories to the Dimensions
    
    Window 5: -Bar charts of the Contribution of Column categories to the Dimensions
    
    Window 6: -Bar charts of the Correlation of Row categories with the Dimensions
    
    Window 7: -Bar charts of the Correlation of Column categories with the Dimensions
    
    Window 8: -CA symmetric Map displaying both Row and Column points
    -CA symmetric Map for Rows only
    -CA symmetric Map for Columns only
    (note: the total number of charts in this Windows depends on the number of Dimensions that have been plotted)
    
    Window 9: -CA Standard Biplots
    
    Windows from 10 onward: -2D CA Maps with clustering (for Rows)
    -3D CA Map with clustering (for Rows)
    -Clusters Tree with indication of group membership (for Rows)
    -2D CA Maps with clustering (for Columns)
    -3D CA Map with clustering (for Columns)
    -Clusters Tree with indication of group membership (for Columns)
    (note: the total number of 2D and 3D charts depends on the number of Dimensions that have been plotted)
    \n")

cat("                                        \n")
# print some note on Standard Biplot
cat("                                        \n")
cat("                                        \n")
cat("***************************************************************\n")
cat("*                 Note on the Standard Biplot                 *\n")
cat("***************************************************************\n")
cat("                                        \n")
cat("Rows in principal coordinates and columns in standard coordinates times square root of the mass. (Greenacre 2007, pp. 102, 234, 268, 270). 
    The lenght of each arrow joining the column points to the origin is proportional to the contribution that each column category makes to the principal axes; colour intensity proportional to the absolute contribution to the total inertia.
    
    See: Greenacre 2007, pp. 101-103, 234, 268, 270; Greenacre 2010, pp. 87-88; Greenacre 2013 \n")
cat("                                        \n")
cat("Reference:\n")
cat("Greenacre 2007: Greenacre M., 'Correspondence Analysis in Practice'. Second Edition. Boca Raton-London-New York, Chapman&Hall/CRC
    Greenacre 2010: Greenacre M., 'Biplots in Practice', Fundacion BBVA
    Greenacre 2013: Greenacre M., 'Contribution Biplots', Journal of Computational and Graphical Statistics 22(1)\n")
#print end of CA output
cat("                                     \n")

cat("...................................................................\n")
cat(" * End of Correspondence Analysis output *\n")

sink()
dev.off()

## END OF THE SCRIPT ##