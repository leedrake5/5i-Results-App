library(shiny)
library(ggplot2)
library(reshape2)
library(pbapply)
library(TTR)
library(DT)
library(pvclust)
library(data.table)
library(pbapply)
library(R.utils)
library(R.oo)
library(Biobase)
library(plyr)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    


metadataTableRe <- reactive({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    #if (is.null(inFile)) {return(NULL)}


    no_col <- max(count.fields(file=inFile$datapath, sep=","))
    
    data.frame.first <- read.table(inFile$datapath,sep=",", fill=TRUE, col.names=1:no_col, comment.char = "")
    #data.frame <- read.csv("data/ceramics.csv", sep=",")
    
    names <- c("File", "DateTime", "Operator", "Name", "ID", "Field1", "Field2", "Application", "Method", "ElapsedTime", "Alloy 1", "Match Qual 1", "Alloy 2", "Match Qual 2", "Alloy 3", "Match Qual 3", "Cal Check")
    
    n <- length(data.frame.first[1,])
    
    
    data.frame <- as.data.frame(data.frame.first[2:n,])
    colnames(data.frame) <- names
    data.frame$Date <- substr(data.frame$DateTime, 1, 10)
    data.frame
})

#data.m <- metadataTableRe()

#if (is.null(data.m)){ data.m <- ceramics}












outApp <- reactive({
    metadata.dat <- metadataTableRe()
    
    apps <- unique(metadata.dat$Application)
    app.values <- as.vector(unique(apps))
    app.values <- c("Choose", app.values)
    
    app.values
    
    
})



outDateMin <- reactive({
    metadata.dat <- metadataTableRe()
    
    dates <- unique(metadata.dat$DateTime)
    
    dates <- substr(dates, 1, 10)
    
    dates <- subset(dates, !(dates=="DateTime"))


    dates <- subset(dates, !dates=="")
    
    dates <- as.Date(dates, format="%m-%d-%Y")
    
    date.values <- min(as.Date(dates))


    
    date.values
    
    
})


outDateMax <- reactive({
    metadata.dat <- metadataTableRe()
    
    dates <- unique(metadata.dat$DateTime)
    
    dates <- substr(dates, 1, 10)
    
    dates <- subset(dates, !(dates=="DateTime"))


    dates <- subset(dates, !dates=="")
    
    dates <- as.Date(dates, format="%m-%d-%Y")

    
    date.values <- max(as.Date(dates))
    
    
    
    date.values
    
    
})


outField1 <- reactive({
    metadata.dat <- metadataTableRe()
    
    field1 <- unique(metadata.dat$Field1)
    field1.values <- as.vector(field1)
    field1.values <- c("Choose", field1.values)
    
    field1.values
    
    
})


outField2 <- reactive({
    metadata.dat <- metadataTableRe()
    
    field2 <- as.vector(metadata.dat$Field2)
    field2.values <- as.vector(field2)
    field2.values <- c("Choose", field2.values)
    
    field2.values
    
    
})


outLimVal <- reactive({
    metadata.dat <- metadataTableRe()
    
    limit.dat <- as.vector(metadata.dat[, input$limits])
    
    limit.values <- as.vector(unique(limit.dat))
    
    limit.values
    
})

output$inApp <- renderUI({
    selectInput(inputId = "app", label = h4("Application"), choices =  outApp())
})

output$inDateMin <- renderUI({
    
    dateInput('datemin', label=h6("Date Min"),  value=outDateMin(),  width='40%', format="mm-dd-yyyy")
    
})



output$inDateMax <- renderUI({
    
    dateInput('datemax', label=h6("Date Max"),  value=outDateMax(),  width='40%', format="mm-dd-yyyy")
    
})



output$inField1 <- renderUI({
    selectInput(inputId = "field1", label = h4("Field 1"), choices =  outField1())
})

output$inField2 <- renderUI({
    selectInput(inputId = "field2", label = h4("Field 2"), choices =  outField2())
})




metadataForm <- reactive({
    data.m <- metadataTableRe()
    
    data.n <- subset(data.m, !(Date=="DateTime"))
    
    
    
    selection.app <-  as.vector(if (input$app=="Choose") {
        paste(unique(data.m$Application))
    } else {
        paste(input$app)
    })
    
    #selection.date <- subset(data.m, !(as.Date(data.m$Date) < as.Date(input$datemin) | as.Date(data.m$Date) > as.Date(input$datemax)))
    
    selection.field1 <-  as.vector(if (input$field1=="Choose") {
        paste(unique(data.m$Field1))
    } else {
        paste(input$field1)
    })
    
    selection.field2 <-  as.vector(if (input$field2=="Choose") {
        paste(all.field2 <- unique(data.m$Field2))
    } else {
        paste(input$field2)
    })
    
    rownumbers <- which(data.m$Application==selection.app)
    
    
    
    
    data.o <- subset(data.n, data.n$Application==selection.app)
    
    data.t <- t(data.m)
    
    names <- as.vector(data.t[,print(rownumbers[1]-1)])
    
    #file.min <- min(data.m$File)
    
    # data.m <- subset(data.m, data.m$DateTime==selection.date)
    #  data.m <- subset(data.m, data.m$Field1==selection.field1)
    #  data.m <- subset(data.m, data.m$Field2==selection.field2)
    
    #colnames(data.m) <-
    
    
    
    data.p <- dateSubset(datemin=input$datemin, datemax=input$datemax, dataframe=data.o, datevector="Date")
    
    colnames(data.p) <- names
    
    
    
    
    data.p

    
})



output$metadataTable <- renderTable({
    
    metadataForm()
    
    })

output$fullTable <- renderTable({
    data.m <- metadataTableRe()
    #data.m <- subset(data.m, !(Date=="DateTime"))

    data.m
})


output$downloadtable <- downloadHandler(
filename = function() { paste(input$dataset, '.csv', sep=',') },
content = function(file
) {
    write.csv(metadataForm(), file)
}
)




})

