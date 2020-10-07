# Server function
function(input, output, session) {
    # Plot graphs
    df1 <- generation
    df1$Total <- rowSums(df1[5:13])/1000
    output$graph1 <- renderPlotly({
        p1 <- ggplot(df1, aes(x = Datetime, y = Total, group = Zone)) +
            geom_point(aes(color = Zone)) +
            geom_line(aes(color = Zone)) +
            ggtitle("Hourly Generation by Zone") +
            ylab("Generation (GWh)") +
            theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())
        ggplotly(p1)
    })

    df2 <- interface.flow
    output$graph2 <- renderPlotly({
        p2 <- ggplot(df2, aes(x = Datetime, y = Value, group = Interface)) +
            geom_point(aes(color = Interface)) +
            geom_line(aes(color = Interface)) +
            ggtitle("Interface Flow by Hour") +
            ylab("Energy Flow (MWh)") +
            theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())
        ggplotly(p2)
    })

    # Initialize maps
    output$map1 <- renderLeaflet({
        basemap %>%
            addMinicharts(
                generation$Lon, generation$Lat,
                layerId = generation$Zone,
                width = 45, height = 45
                )
        })
    output$map2 <- renderLeaflet({
        basemap %>%
        addFlows(
            interface.flow$Lon0, interface.flow$Lat0, interface.flow$Lon1, interface.flow$Lat1,
            flow = interface.flow$Value,
            time = interface.flow$Datetime
            )
        })
    output$map3 <- renderLeaflet({
        basemap %>%
            addMinicharts(
                generation$Lon, generation$Lat,
                layerId = generation$Zone,
                width = 45, height = 45
            ) %>%
            addFlows(
                interface.flow$Lon0, interface.flow$Lat0, interface.flow$Lon1, interface.flow$Lat1,
                flow = interface.flow$Value,
                time = interface.flow$Datetime
            )
        })

    # Update charts each time input value changes
    observe({
        if (length(input$category) == 0) {
            data <- 1
        } else {
            data <- generation[, input$category]
        }
        maxValue <- max(as.matrix(data))

        leafletProxy("map1", session) %>%
            updateMinicharts(
                generation$Zone,
                chartdata = data,
                maxValues = maxValue,
                time = generation$Datetime,
                type = ifelse(length(input$category) < 2, "polar-area", input$type),
                showLabels = input$labels
            )
    })
}
