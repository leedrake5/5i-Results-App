library(shiny)
library(shinythemes)
library(DT)
library(data.table)


# Define UI for application that draws a histogram
shinyUI(navbarPage("Data Selecter", id="nav", theme=shinytheme("sandstone"),
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


uiOutput('inName'),



downloadButton(outputId="downloadtable", label="Download")

),
mainPanel(
tabsetPanel(
tabPanel('Table',
dataTableOutput('metadataTable')),
tabPanel('Full Table',
dataTableOutput('fullTable'))
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
downloadButton(outputId="downloaddensityplot", label="Download Density Plot")



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


