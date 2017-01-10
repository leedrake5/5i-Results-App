library(shiny)
library(dplyr)
library(DT)


# Define UI for application that draws a histogram
shinyUI(navbarPage("AES", id="nav",
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


uiOutput('inField2')

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

tabPanel("Source",
titlePanel("Run Models"),
sidebarLayout(
sidebarPanel(

fileInput('loadspectra', 'Load Spectra', multiple=TRUE,
accept = c('.csv')
),


tags$hr(),

actionButton('runsinglemodel', "Run Individual Model"),
actionButton('runfullmodel', "Run Full Model")),

mainPanel(
tabsetPanel(
tabPanel('By Artifact',
tableOutput('singlemodelresult')),
tabPanel('All Classes',
tableOutput('multiplemodelresult')))

)

)
)

))


