# User interface
ui <- fluidPage(
  navbarPage("Interactive Map",
             tabPanel("Generation",
                      sidebarLayout(
                        sidebarPanel("This tab shows the hourly generation by resource type across all
                                     the zones assumed in a production cost model.",
                          selectInput("category", "Select category", choices = resource.type, multiple = T),
                          selectInput("type", "Chart type", choices = c("bar","pie", "polar-area", "polar-radius")),
                          checkboxInput("labels", "Show values")
                          ),
                        mainPanel(
                                   leafletOutput("map1"),
                                   plotlyOutput("graph1")
                          )
                        )
                      ),
             tabPanel("Transmission",
                      sidebarLayout(
                        sidebarPanel("This tab shows the hourly energy flow of the interfaces assumed in
                                     a production cost model."
                                     ),
                      mainPanel(
                        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                        leafletOutput("map2"),
                        plotlyOutput("graph2")
                      )
                  )
             )

  )
)
