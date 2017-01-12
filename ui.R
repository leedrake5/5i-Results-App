library(shiny)
library(dplyr)
library(DT)


# Define UI for application that draws a histogram
shinyUI(navbarPage("Data Selecter", id="nav",
tabPanel("Load Data",
titlePanel("Uploading Files"),
sidebarLayout(
sidebarPanel(
fileInput('file1', 'Choose file to upload',
accept = c('.csv')
),



uiOutput('inApp'),

tags$hr(),


uiOutput('inDateMin'),
uiOutput('inDateMax'),

tags$hr(),


uiOutput('inField1'),


uiOutput('inField2'),

downloadButton(outputId="downloadtable", label="Download")

),
mainPanel(
tabsetPanel(
tabPanel('Table',
tableOutput('metadataTable')),
tabPanel('Full Table',
tableOutput('fullTable'))
)
)
)
),


tabPanel("Plot Data",
titlePanel("Create Plots"),
sidebarLayout(
sidebarPanel(

uiOutput('inVar'),

#textInput(inputId="element", label="Element:", value="Enter element name..."),
#textInput(inputId="factor", label="Factor:", value="Enter column name..."),



downloadButton(outputId="downloadboxplot", label="Download Box Plot"),
downloadButton(outputId="downloaddesnityplot", label="Download Density Plot"),
downloadButton(outputId="downloadhistogram", label="Download Histogram")



),
mainPanel(
tabsetPanel(
tabPanel("Box Plots",
plotOutput("boxplot")),

tabPanel("Density Plots",
plotOutput("densityplot"))

))


)


)
))


