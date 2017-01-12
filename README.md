
Tracer 5i Report Generator

This simple tool lets you take the results.csv file from the Tracer 5i and process results based on application and time, as well as other variables. It will provide you a simple download of a table, as well as box plots and density plots of variables of your choosing. 


You can run this demo locally with:

```
if (!require(devtools))
  install.packages("devtools")
devtools::install_github("rstudio/leaflet")
shiny::runGitHub("leedrake5/congressImpact")
```

If you need to install packages to make it work, copy and paste the following script into your R console:

install.packages(c(“shiny”, “ggplot2”, “reshape2”, “pbapply”, “data.table”)

To test-run the data, I have included a sample example in /data/results.csv. You can load this, select Mudrock Major as the app, and proceed. 