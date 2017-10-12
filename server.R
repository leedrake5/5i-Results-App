library(shiny)
library(ggplot2)
library(reshape2)
library(pbapply)
library(data.table)
library(DT)

options(warn=-1)
assign("last.warning", NULL, envir = baseenv())

options(shiny.error = function() {stop("")})

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    

####Import and Format results.csv file from the Tracer 5i, stored in BRUKER folder on instrument, or on USB flash drive

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
    
    
    data.frame <- as.data.frame(data.frame.first[1:n])
    colnames(data.frame) <- names
    data.frame$Date <- substr(data.frame$DateTime, 1, 10)
    data.frame
})

#data.m <- metadataTableRe()

#if (is.null(data.m)){ data.m <- ceramics}











#Create Interface
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


outName <- reactive({
    metadata.dat <- metadataTableRe()
    
    field1 <- unique(metadata.dat$Name)
    field1.values <- as.vector(field1)
    field1.values <- c("Choose", field1.values)
    
    field1.values
    
    
})





outLimVal <- reactive({
    metadata.dat <- metadataTableRe()
    
    limit.dat <- as.vector(metadata.dat[, input$limits])
    
    limit.values <- as.vector(unique(limit.dat))
    
    limit.values
    
})

output$inApp <- renderUI({
    selectInput(inputId = "app", label = h4("Application"), choices =  outApp(), selected="Choose")
})

output$inDateMin <- renderUI({
    
    dateInput('datemin', label=h6("Date Min"),  value=outDateMin(),  width='40%', format="mm-dd-yyyy")
    
})



output$inDateMax <- renderUI({
    
    dateInput('datemax', label=h6("Date Max"),  value=outDateMax(),  width='40%', format="mm-dd-yyyy")
    
})



output$inName <- renderUI({
    selectInput(inputId = "name", label = h4("Name"), choices =  outName(), selected="Choose")
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
    
    selection.name <-  as.vector(if (input$name=="Choose") {
        paste(unique(data.m$Name))
    } else {
        paste(input$name)
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
    
    data.r <- subset(data.p, data.p$Name==selection.name)
    
    
    
    
    data.r

    
})



output$metadataTable <- renderDataTable({
    
    data.table(metadataForm())
    
    })

output$fullTable <- renderDataTable({
    data.m <- metadataTableRe()
    #data.m <- subset(data.m, !(Date=="DateTime"))

    data.table(data.m)
})


output$downloadtable <- downloadHandler(
filename = function() { paste(input$name, "_", input$app, ".csv", sep="") },
content = function(file
) {
    write.csv(metadataForm(), file)
}
)

selectElements <- reactive({
    
    the.data <- metadataForm()
    
    the.names <- as.vector(colnames(the.data))
    
    element.names <- the.names[! the.names %in% c("File #", "DateTime", "DateTime.1", "Operator", "Name", "ID", "Field1", "Field2", "Application", "Method", "ElapsedTime", "Alloy 1", "Match Qual 1", "Alloy 2", "Match Qual 2", "Alloy 3", "Match Qual 3", "Cal Check", "Date", "X",  "X.1", "X.2", "X.3", "X.4", "X.5", "X.6", "X.7", "X.8", "X.9", "X.10", "X.11", "X.12", "X.13", "X.14", "X.15", "X.16", "X.17", "X.18", "X.19", "X.20", "X.21", "X.22", "X.23", "X.24", "X.25", "X.26", "X.27", "X.28", "X.29", "X.30", "X.31", "X.32", "X.33", "X.34", "X.35", "X.36", "X.37", "X.38", "X.39", "X.40", " ", "")]
    element.names <- as.vector(element.names)
    element.names
    #the.names
})


output$inVar <- renderUI({
    selectInput(inputId = "elements", label = h4("Elements"), choices =  selectElements(), selected=selectElements()[1], multiple=TRUE)
})


theBoxPlot <- reactive({
    the.data <- metadataForm()
    

    short.frame <- the.data[c("Application", input$elements)]
    short.melt <- melt(short.frame, id="Application")
    
    box.plot <- ggplot(short.melt) +
    geom_boxplot(aes(x=as.character(variable), y=as.numeric(value), colour=as.character(variable), fill=as.character(variable)), alpha=0.5) +
    scale_fill_discrete("Element") +
    scale_colour_discrete("Element") +
    scale_x_discrete("") +
    scale_y_continuous("Concentration (%)") +
    theme_light()
    
    box.plot
    
})



output$boxplot <- renderPlot({
    print(theBoxPlot())
    
})


output$downloadboxplot <- downloadHandler(
filename = function() { paste(input$name, "_", input$app, "-", "BoxPlot", ".png", sep="") },
content = function(file) {
    ggsave(file,theBoxPlot(), width=10, height=7)
}
)



theDensityPlot <- reactive({
    the.data <- metadataForm()
    
    
    short.frame <- the.data[c("Application", input$elements)]
    short.melt <- melt(short.frame, id="Application")
    
    density.plot <- ggplot(short.melt) +
    geom_density(aes(x=as.numeric(value), colour=as.character(variable), fill=as.character(variable)), alpha=0.5) +
    scale_fill_discrete("Element") +
    scale_colour_discrete("Element") +
    scale_y_continuous("Density") +
    scale_x_continuous("Concentration (%)") +
    theme_light()

    density.plot
    
})



output$densityplot <- renderPlot({
    print(theDensityPlot())
    
})


output$downloaddensityplot <- downloadHandler(
filename = function() { paste(input$name, "_", input$app, "-", "Density", ".png", sep="") },
content = function(file) {
    ggsave(file,theDensityPlot(), width=10, height=7)
}
)






})

