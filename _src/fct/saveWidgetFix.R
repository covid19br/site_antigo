## A wrapper to saveWidget which compensates for arguable BUG in saveWidget
## which requires `file` to be in current working directory.
# source: https://stackoverflow.com/questions/48690837/saving-interactive-plotly-graph-to-a-path-using-htmlwidget
saveWidgetFix <- function (widget, file, ...) {
    wd<-getwd()
    on.exit(setwd(wd))
    outDir<-dirname(file)
    file<-basename(file)
    setwd(outDir);
    saveWidget(widget,file=file, ...)
}
