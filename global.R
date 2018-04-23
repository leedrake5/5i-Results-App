#list.of.packages <- c("pbapply", "reshape2", "dplyr", "ggplot2", "shiny",  "data.table", "DT", "shinythemes",  "gridExtra", "dtplyr", "formattable")
#new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
#if(length(new.packages)) install.packages(new.packages)


library(pbapply)
library(reshape2)
library(dplyr)
library(ggplot2)
library(shiny)

dateSubset <- function(datemin,datemax, dataframe, datevector){
    dataframe[as.Date(dataframe[,datevector], format="%m-%d-%Y", na.rm=TRUE) >= as.Date(datemin, format="%m-%d-%Y", na.rm=TRUE) &
    as.Date(dataframe[,datevector], format="%m-%d-%Y", na.rm=TRUE) <= as.Date(datemax, format="%m-%d-%Y", na.rm=TRUE),]
}

extract.with.context <- function(x, rows, after = 0, before = 0) {
    
    match.idx  <- which(rownames(x) %in% rows)
    span       <- seq(from = -before, to = after)
    extend.idx <- c(outer(match.idx, span, `+`))
    extend.idx <- Filter(function(i) i > 0 & i <= nrow(x), extend.idx)
    extend.idx <- sort(unique(extend.idx))
    
    return(x[extend.idx, , drop = FALSE])
}


read_csv_filename_x <- function(filename){
    ret <- read.csv(file=filename, sep=",", header=FALSE)
    return.res <- as.numeric(as.vector(ret$V2[18]))/1000
    return.chan.counts <-as.numeric(as.vector(ret$V1[22:2069]))
    return.energy <- return.chan.counts*return.res
    return(return.energy)
}

read_csv_filename_y <- function(filename){
    ret <- read.csv(file=filename, sep=",", header=FALSE)
    return.live.time <- as.numeric(as.vector(ret$V2[10]))
    return.counts <- as.numeric(as.vector(ret$V2[22:2069]))
    return.cps <- return.counts/return.live.time
    return(return.cps)
}

file.0 <- function(file) {
    if (length(file) > 0)
    {
    return(file)
    }else{
        return(levels(file))
    }
}

is.0 <- function(cps, file) {
    file.0 <- function(file) {
        if (length(file) > 0)
        {
            return(file)
        }else{
            return(levels(file))
        }
    }
    if (length(cps) > 0)
    {
        hope <-data.frame(cps, file.0(file))
        return(hope)
    } else {
        empty <- rep(0, length(file.0(file)))
        framed <- data.frame(empty, file.0(file))
        return(framed)
    }
}

dt_options <- reactive({
    # dynamically create options for `aoColumns` depending on how many columns are selected.
    toggles <- lapply(1:length(input$show_vars), function(x) list(bSearchable = F))
    # for `species` columns
    toggles[[length(toggles) + 1]] <- list(bSearchable = T)
    
    list(
    aoColumns = toggles,
    bFilter = 1, bSortClasses = 1,
    aLengthMenu = list(c(10,25,50, -1), list('10','25', '50', 'Todas')),
    iDisplayLength = 10
    )
})

ifrm <- function(obj, env = globalenv()) {
    obj <- deparse(substitute(obj))
    if(exists(obj, envir = env)) {
        rm(list = obj, envir = env)
    }
}





#####Testing Code

#no_col <- max(count.fields(file="/Users/lee/GitHub/5i Results App/data/Results.csv", sep=","))

#data.frame.first <- read.table("/Users/lee/GitHub/5i Results App/data/Results.csv",sep=",", fill=TRUE, col.names=1:no_col, comment.char = "")


#data.frame <- read.csv("data/ceramics.csv", sep=",")

#names <- c("File", "DateTime", "Operator", "Name", "ID", "Field1", "Field2", "Application", "Method", "ElapsedTime", "Alloy 1", "Match Qual 1", "Alloy 2", "Match Qual 2", "Alloy 3", "Match Qual 3", "Cal Check")

#n <- length(data.frame.first[1,])


#data.frame <- as.data.frame(data.frame.first[2:n,])
#colnames(data.frame) <- names
#data.frame$Date <- substr(data.frame$DateTime, 1, 10)
#data.frame



