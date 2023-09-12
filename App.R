library(shinydashboard)
library(rsconnect)
library(shiny)
library(shinythemes)
library(shinyjs)
library(tidyverse)
library(remotes)
library(scatterplot3d)
library(FactoClass)
library(DT)
#install_github("BillPetti/baseballr")
#install_github("bayesball/CalledStrike")
#library(CalledStrike)

# Filtering to just 2022 for speed
options <- read_csv("options.csv")
location_data <- read_csv("location_data.csv") 
database_to_draw <- read_csv("database_to_draw.csv")
rnk <- read_csv("rnk.csv")
#database_to_draw[16] <- paste0(as.matrix(database_to_draw[16]), '%')
#database_to_draw[17] <- paste0(as.matrix(database_to_draw[17]), '%')
new_diff_all <- read_csv("new_diff_all_edit.csv")
new_diff_2022 <- read_csv("new_diff_2022_edit.csv")

ui <- fluidPage(
  
  
  titlePanel("Pitch Comparison Tool (PCT)"),
  theme = shinythemes::shinytheme("journal"),
  
  
  
  
  
  
  
  
  sidebarLayout(
    sidebarPanel(width = 3,
                 selectInput('name',
                             '*Select Pitcher:',
                             choices = c(unique(options$name))),
                 selectInput('pitch_type',
                             'Select Pitch Type:',
                             choices = c(unique(options$pitch_type))),
                 checkboxInput('check2022', '**Show only 2022 results', FALSE),
                 h6(" "),
                 h6("*Only pitches from 2022 with >100 thrown are available"),
                 h6("**The top 5 similar pitches will only be from 2022")
    ),
    
    
    
    mainPanel(width = 9,
              h1(strong(textOutput("og_title")), align = "center", style = "font-family: 'Times', serif;
    font-weight: 500px; font-size: 40px; line-height: 1; color:black;"),
              fluidRow(
                column(4, align = "center",
                       plotOutput("og_zone", height = 300, width = 250)
                ),
                column(4, align = "center",
                       plotOutput("og_perc", height = 275, width = 300)
                ),
                column(4, align = "center",
                       plotOutput("og_arsen", height = 300, width = 300
                )
              ),
              fluidRow(
                column(10, align = "center", offset = 1,
                       DTOutput("og_table")
                )
              ),
              fluidRow(
                       tags$br()
              ),
              tags$style(HTML("
    .tabbable > .nav > li > a {background-color:whitesmoke;  color:black; width: 225PX;}
  ")),
              tabsetPanel(
                tabPanel("First",
                         h1(strong(textOutput("first_title")), align = "center", style = "font-family: 'Times', serif;
    font-weight: 500px; font-size: 30px; line-height: 1; color:black;"),
                         fluidRow(
                           column(4, align = "center",
                                  plotOutput("first_zone", height = 300, width = 250)
                           ),
                           column(4, align = "center",
                                  plotOutput("first_perc", height = 275, width = 300)
                           ),
                           column(4, align = "center",
                                  plotOutput("first_arsen", height = 300, width = 300)
                           )
                         ),
                         fluidRow(
                           column(10, align = "center", offset = 1,
                                  DTOutput("first_table")
                           )
                         )
                ),         
                tabPanel("Second",
                         h1(strong(textOutput("second_title")), align = "center", style = "font-family: 'Times', serif;
    font-weight: 500px; font-size: 30px; line-height: 1; color:black;"),
                         fluidRow(
                           column(4, align = "center",
                                  plotOutput("second_zone", height = 300, width = 250)
                           ),
                           column(4, align = "center",
                                  plotOutput("second_perc", height = 275, width = 300)
                           ),
                           column(4, align = "center",
                                  plotOutput("second_arsen", height = 300, width = 300)
                           )
                         ),
                         fluidRow(
                           column(10, align = "center", offset = 1,
                                  DTOutput("second_table")
                           )
                         )
                ), 
                tabPanel("Third",
                         h1(strong(textOutput("third_title")), align = "center", style = "font-family: 'Times', serif;
    font-weight: 500px; font-size: 30px; line-height: 1; color:black;"),
                         fluidRow(
                           column(4, align = "center",
                                  plotOutput("third_zone", height = 300, width = 250)
                           ),
                           column(4, align = "center",
                                  plotOutput("third_perc", height = 275, width = 300)
                           ),
                           column(4, align = "center",
                                  plotOutput("third_arsen", height = 300, width = 300)
                           )
                         ),
                         fluidRow(
                           column(10, align = "center", offset = 1,
                                  DTOutput("third_table")
                           )
                         )
                ), 
                tabPanel("Fourth",
                         h1(strong(textOutput("fourth_title")), align = "center", style = "font-family: 'Times', serif;
    font-weight: 500px; font-size: 30px; line-height: 1; color:black;"),
                         fluidRow(
                           column(4, align = "center",
                                  plotOutput("fourth_zone", height = 300, width = 250)
                           ),
                           column(4, align = "center",
                                  plotOutput("fourth_perc", height = 275, width = 300)
                           ),
                           column(4, align = "center",
                                  plotOutput("fourth_arsen", height = 300, width = 300)
                           )
                         ),
                         fluidRow(
                           column(10, align = "center", offset = 1,
                                  DTOutput("fourth_table")
                           )
                         )
                ), 
                tabPanel("Fifth",
                         h1(strong(textOutput("fifth_title")), align = "center", style = "font-family: 'Times', serif;
    font-weight: 500px; font-size: 30px; line-height: 1; color:black;"),
                         fluidRow(
                           column(4, align = "center",
                                  plotOutput("fifth_zone", height = 300, width = 250)
                           ),
                           column(4, align = "center",
                                  plotOutput("fifth_perc", height = 275, width = 300)
                           ),
                           column(4, align = "center",
                                  plotOutput("fifth_arsen", height = 300, width = 300)
                           )
                         ),
                         fluidRow(
                           column(10, align = "center", offset = 1,
                                  DTOutput("fifth_table")
                           )
                         )
                ) 
              )
    )
  )
))



server <- function(input, output, session) {
  
  observe({
    x <- input$name
    new_options <- filter(options, name == x)
    
    updateSelectInput(session, "pitch_type",
                      choices = new_options$pitch_type
    )
    
  })
  
  
  output$og_title = renderText(paste0(input$name, " 2022 (", input$pitch_type, ")"))
  
  first_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'first') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'first') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    data
  })
  
  output$first_title = renderText(paste0(first_data()$name, " ", first_data()$sim_year[1], " (", first_data()$sim_pitch_type, ") - ", first_data()$perc, "%"))
  
  second_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'second') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'second') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    data
  })
  
  output$second_title = renderText(paste0(second_data()$name, " ", second_data()$sim_year[1], " (", second_data()$sim_pitch_type, ") - ", second_data()$perc, "%"))
  
  third_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'third') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'third') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    data
  })
  
  output$third_title = renderText(paste0(third_data()$name, " ", third_data()$sim_year[1], " (", third_data()$sim_pitch_type, ") - ", third_data()$perc, "%"))
  
  fourth_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'fourth') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'fourth') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    data
  })
  
  output$fourth_title = renderText(paste0(fourth_data()$name, " ", fourth_data()$sim_year[1], " (", fourth_data()$sim_pitch_type, ") - ", fourth_data()$perc, "%"))
  
  fifth_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'fifth') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name &
                 pitch_type == input$pitch_type &
                 year == 2022 &
                 rank == 'fifth') %>%
        select(-9) %>%
        left_join(database_to_draw, by = c("sim_player" = "pitcher", "sim_pitch_type" = "pitch_type", "sim_year" = "year")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    data
  })
  
  output$fifth_title = renderText(paste0(fifth_data()$name, " ", fifth_data()$sim_year[1], " (", fifth_data()$sim_pitch_type, ") - ", fifth_data()$perc, "%"))
  
  
  
  
  
  og_all_data = reactive({
    dat <- database_to_draw %>%
      filter(name == input$name, pitch_type == input$pitch_type,  year == 2022) %>%
      bind_rows(arrange(filter(database_to_draw, name == input$name, pitch_type != input$pitch_type, year == 2022))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "Run Value", "% Thrown", "count"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  output$og_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    ggplot(filter(location_data, pitch_type == input$pitch_type & 
                    name == input$name, game_year == 2022), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(title = "Pitch Location") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black"))
  })
  
  
  
  
  first_location_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name &
               pitch_type == input$pitch_type &
               year == 2022 &
               rank == 'first')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name &
               pitch_type == input$pitch_type &
               year == 2022 &
               rank == 'first')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    filter(location_data, pitcher == id & game_year == sim_year)
  })
  
  second_location_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'second')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'second')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    filter(location_data, pitcher == id & game_year == sim_year)
  })
  
  third_location_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'third')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'third')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    filter(location_data, pitcher == id & game_year == sim_year)
  })
  
  fourth_location_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fourth')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fourth')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    filter(location_data, pitcher == id & game_year == sim_year)
  })
  
  fifth_location_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fifth')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fifth')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    filter(location_data, pitcher == id & game_year == sim_year)
  })
  
  
  output$first_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    
    ggplot(filter(first_location_data(), pitch_type == first_data()$sim_pitch_type), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(title = "Pitch Location") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black"))
  })
  
  output$second_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    
    ggplot(filter(second_location_data(), pitch_type == second_data()$sim_pitch_type), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(title = "Pitch Location") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black"))
  })
  
  output$third_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    
    ggplot(filter(third_location_data(), pitch_type == third_data()$sim_pitch_type), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(title = "Pitch Location") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black"))
  })
  
  output$fourth_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    
    ggplot(filter(fourth_location_data(), pitch_type == fourth_data()$sim_pitch_type), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(title = "Pitch Location") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black"))
  })
  
  output$fifth_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    
    ggplot(filter(fifth_location_data(), pitch_type == fifth_data()$sim_pitch_type), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(title = "Pitch Location") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black"))
  })
  
  
  
  
  
  output$og_perc = renderPlot({
    r <- arrange(filter(rnk, name == input$name, year == 2022), pitch_type)
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(r$pitch_type, pot_colors)]
    
    ggplot(data = r, aes(pitch_type, percentile, fill = pitch_type)) +
      geom_col() + 
      scale_fill_manual(values = this_colors) +
      xlab("Pitch Type") +
      ylab("Percentile") +
      theme_classic() +
      labs(title = "Arsenal League Percentiles", subtitle = "(Based on CSW%, Chase%, and RV)\n(>100 Pitches)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black")) +
      theme(axis.title.x = element_text(colour = "gray10")) +
      theme(axis.title.y = element_text(colour = "gray10")) +
      theme(axis.title.x = element_text(face = "bold")) +
      ylim(0,100) +
      guides(fill=guide_legend(title="Pitch Type"))
  })
  
  output$first_perc = renderPlot({
    n <- first_data()$name[1]
    y <- first_data()$sim_year[1]
    r <- arrange(filter(rnk, name == n, year == y), pitch_type)
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(r$pitch_type, pot_colors)]
    
    ggplot(data = r, aes(pitch_type, percentile, fill = pitch_type)) +
      geom_col() + 
      scale_fill_manual(values = this_colors) +
      xlab("Pitch Type") +
      ylab("Percentile") +
      theme_classic() +
      labs(title = "Arsenal League Percentiles", subtitle = "(Based on CSW%, Chase%, and RV)\n(>100 Pitches)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black")) +
      theme(axis.title.x = element_text(colour = "gray10")) +
      theme(axis.title.y = element_text(colour = "gray10")) +
      theme(axis.title.x = element_text(face = "bold")) +
      ylim(0,100) +
      guides(fill=guide_legend(title="Pitch Type"))
  })
  
  output$second_perc = renderPlot({
    n <- second_data()$name[1]
    y <- second_data()$sim_year[1]
    r <- arrange(filter(rnk, name == n, year == y), pitch_type)
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(r$pitch_type, pot_colors)]
    
    ggplot(data = r, aes(pitch_type, percentile, fill = pitch_type)) +
      geom_col() + 
      scale_fill_manual(values = this_colors) +
      xlab("Pitch Type") +
      ylab("Percentile") +
      theme_classic() +
      labs(title = "Arsenal League Percentiles", subtitle = "(Based on CSW%, Chase%, and RV)\n(>100 Pitches)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black")) +
      theme(axis.title.x = element_text(colour = "gray10")) +
      theme(axis.title.y = element_text(colour = "gray10")) +
      theme(axis.title.x = element_text(face = "bold")) +
      ylim(0,100) +
      guides(fill=guide_legend(title="Pitch Type"))
  })
  
  output$third_perc = renderPlot({
    n <- third_data()$name[1]
    y <- third_data()$sim_year[1]
    r <- arrange(filter(rnk, name == n, year == y), pitch_type)
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(r$pitch_type, pot_colors)]
    
    ggplot(data = r, aes(pitch_type, percentile, fill = pitch_type)) +
      geom_col() + 
      scale_fill_manual(values = this_colors) +
      xlab("Pitch Type") +
      ylab("Percentile") +
      theme_classic() +
      labs(title = "Arsenal League Percentiles", subtitle = "(Based on CSW%, Chase%, and RV)\n(>100 Pitches)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black")) +
      theme(axis.title.x = element_text(colour = "gray10")) +
      theme(axis.title.y = element_text(colour = "gray10")) +
      theme(axis.title.x = element_text(face = "bold")) +
      ylim(0,100) +
      guides(fill=guide_legend(title="Pitch Type"))
  })
  
  output$fourth_perc = renderPlot({
    n <- fourth_data()$name[1]
    y <- fourth_data()$sim_year[1]
    r <- arrange(filter(rnk, name == n, year == y), pitch_type)
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(r$pitch_type, pot_colors)]
    
    ggplot(data = r, aes(pitch_type, percentile, fill = pitch_type)) +
      geom_col() + 
      scale_fill_manual(values = this_colors) +
      xlab("Pitch Type") +
      ylab("Percentile") +
      theme_classic() +
      labs(title = "Arsenal League Percentiles", subtitle = "(Based on CSW%, Chase%, and RV)\n(>100 Pitches)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black")) +
      theme(axis.title.x = element_text(colour = "gray10")) +
      theme(axis.title.y = element_text(colour = "gray10")) +
      theme(axis.title.x = element_text(face = "bold")) +
      ylim(0,100) +
      guides(fill=guide_legend(title="Pitch Type"))
  })
  
  output$fifth_perc = renderPlot({
    n <- fifth_data()$name[1]
    y <- fifth_data()$sim_year[1]
    r <- arrange(filter(rnk, name == n, year == y), pitch_type)
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(r$pitch_type, pot_colors)]
    
    ggplot(data = r, aes(pitch_type, percentile, fill = pitch_type)) +
      geom_col() + 
      scale_fill_manual(values = this_colors) +
      xlab("Pitch Type") +
      ylab("Percentile") +
      theme_classic() +
      labs(title = "Arsenal League Percentiles", subtitle = "(Based on CSW%, Chase%, and RV)\n(>100 Pitches)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(face="bold")) +
      theme(plot.title = element_text(color="black")) +
      theme(axis.title.x = element_text(colour = "gray10")) +
      theme(axis.title.y = element_text(colour = "gray10")) +
      theme(axis.title.x = element_text(face = "bold")) +
      ylim(0,100) +
      guides(fill=guide_legend(title="Pitch Type"))
  })
  
  
  
  output$og_arsen = renderPlot({
    loc <- filter(location_data, name == input$name,  game_year == 2022) %>%
      filter(release_speed >= 60, (pfx_x < 25 & pfx_x >-25), (pfx_z < 25 & pfx_z >-25))
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(loc$pitch_type, pot_colors)]
    
    {
      plot <- scatterplot3d(loc[,c(8,9,7)], angle = 15, pch = "", box = FALSE, grid = FALSE,
                            main= paste0("Arsenal by Velocity and Movement"),
                            sub = " ",
                            xlab = "H_Break (in)",
                            ylab = "V_Break (in)",
                            zlab = "Velocity",
                            xlim = c(-25,25),
                            ylim = c(-25,25),
                            zlim = c(60,105),
                            col.lab = "black")
      addgrids3d(loc[, c(8,9,7)], grid = c("xy", "xz", "yz"), angle = 15, 
                 xlim = c(-25,25),
                 ylim = c(-25,25),
                 zlim = c(60,105))
      plot$points3d(loc[,c(8,9,7)], pch = 16, col = this_colors, type = "p")
      legend("right", legend = levels(as.factor(loc$pitch_type)),
             col = colors[match(levels(as.factor(loc$pitch_type)), pot_colors)], pch = 16)
      
    }
  })
  
  output$first_arsen = renderPlot({
    loc <- first_location_data() %>%
      filter(release_speed >= 60, (pfx_x < 25 & pfx_x >-25), (pfx_z < 25 & pfx_z >-25))
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(loc$pitch_type, pot_colors)]
    
    {
    plot <- scatterplot3d(loc[,c(8,9,7)], angle = 15, pch = "", box = FALSE, grid = FALSE,
                          main= paste0("Arsenal by Velocity and Movement"),
                          sub = " ",
                          xlab = "H_Break (in)",
                          ylab = "V_Break (in)",
                          zlab = "Velocity",
                          xlim = c(-25,25),
                          ylim = c(-25,25),
                          zlim = c(60,105),
                          col.lab = "black")
    addgrids3d(loc[, c(8,9,7)], grid = c("xy", "xz", "yz"), angle = 15, 
               xlim = c(-25,25),
               ylim = c(-25,25),
               zlim = c(60,105))
    plot$points3d(loc[,c(8,9,7)], pch = 16, col = this_colors, type = "p")
    legend("right", legend = levels(as.factor(loc$pitch_type)),
           col = colors[match(levels(as.factor(loc$pitch_type)), pot_colors)], pch = 16)
    
  }
  })
  
  output$second_arsen = renderPlot({
    loc <- second_location_data() %>%
      filter(release_speed >= 60, (pfx_x < 25 & pfx_x >-25), (pfx_z < 25 & pfx_z >-25))
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(loc$pitch_type, pot_colors)]
    
    {
      plot <- scatterplot3d(loc[,c(8,9,7)], angle = 15, pch = "", box = FALSE, grid = FALSE,
                            main = paste0("Arsenal by Velocity and Movement"),
                            sub = " ",
                            xlab = "H_Break (in)",
                            ylab = "V_Break (in)",
                            zlab = "Velocity",
                            xlim = c(-25,25),
                            ylim = c(-25,25),
                            zlim = c(60,105),
                            col.lab = "black")
      addgrids3d(loc[, c(8,9,7)], grid = c("xy", "xz", "yz"), angle = 15, 
                 xlim = c(-25,25),
                 ylim = c(-25,25),
                 zlim = c(60,105))
      plot$points3d(loc[,c(8,9,7)], pch = 16, col = this_colors, type = "p")
      legend("right", legend = levels(as.factor(loc$pitch_type)),
             col = colors[match(levels(as.factor(loc$pitch_type)), pot_colors)], pch = 16)
      
    }
  })
  
  output$third_arsen = renderPlot({
    loc <- third_location_data() %>%
      filter(release_speed >= 60, (pfx_x < 25 & pfx_x >-25), (pfx_z < 25 & pfx_z >-25))
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(loc$pitch_type, pot_colors)]
    
    {
      plot <- scatterplot3d(loc[,c(8,9,7)], angle = 15, pch = "", box = FALSE, grid = FALSE,
                            main = paste0("Arsenal by Velocity and Movement"),
                            sub = " ",
                            xlab = "H_Break (in)",
                            ylab = "V_Break (in)",
                            zlab = "Velocity",
                            xlim = c(-25,25),
                            ylim = c(-25,25),
                            zlim = c(60,105),
                            col.lab = "black")
      addgrids3d(loc[, c(8,9,7)], grid = c("xy", "xz", "yz"), angle = 15, 
                 xlim = c(-25,25),
                 ylim = c(-25,25),
                 zlim = c(60,105))
      plot$points3d(loc[,c(8,9,7)], pch = 16, col = this_colors, type = "p")
      legend("right", legend = levels(as.factor(loc$pitch_type)),
             col = colors[match(levels(as.factor(loc$pitch_type)), pot_colors)], pch = 16)
      
    }
  })
  
  output$fourth_arsen = renderPlot({
    loc <- fourth_location_data() %>%
      filter(release_speed >= 60, (pfx_x < 25 & pfx_x >-25), (pfx_z < 25 & pfx_z >-25))
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(loc$pitch_type, pot_colors)]
    
    {
      plot <- scatterplot3d(loc[,c(8,9,7)], angle = 15, pch = "", box = FALSE, grid = FALSE,
                            main = paste0("Arsenal by Velocity and Movement"),
                            sub = " ",
                            xlab = "H_Break (in)",
                            ylab = "V_Break (in)",
                            zlab = "Velocity",
                            xlim = c(-25,25),
                            ylim = c(-25,25),
                            zlim = c(60,105),
                            col.lab = "black")
      addgrids3d(loc[, c(8,9,7)], grid = c("xy", "xz", "yz"), angle = 15, 
                 xlim = c(-25,25),
                 ylim = c(-25,25),
                 zlim = c(60,105))
      plot$points3d(loc[,c(8,9,7)], pch = 16, col = this_colors, type = "p")
      legend("right", legend = levels(as.factor(loc$pitch_type)),
             col = colors[match(levels(as.factor(loc$pitch_type)), pot_colors)], pch = 16)
      
    }
  })
  
  output$fifth_arsen = renderPlot({
    loc <- fifth_location_data() %>%
      filter(release_speed >= 60, (pfx_x < 25 & pfx_x >-25), (pfx_z < 25 & pfx_z >-25))
    
    pot_colors <- c("CH", "CS", "CU", "EP", "FA", "FC", "FF", "FO", "FS" ,"IN", "KC", "KN", "PO", "SC", "SI", "SL")
    colors <- c("green", "black", "light blue", "brown", "gray", "darkgoldenrod", "red", "light gray", "turquoise", "maroon", "blue", "purple", "coral", "yellow", "orange", "gold")
    this_colors <- colors[match(loc$pitch_type, pot_colors)]
    
    {
      plot <- scatterplot3d(loc[,c(8,9,7)], angle = 15, pch = "", box = FALSE, grid = FALSE,
                            main = paste0("Arsenal by Velocity and Movement"),
                            sub = " ",
                            xlab = "H_Break (in)",
                            ylab = "V_Break (in)",
                            zlab = "Velocity",
                            xlim = c(-25,25),
                            ylim = c(-25,25),
                            zlim = c(60,105),
                            col.lab = "black")
      addgrids3d(loc[, c(8,9,7)], grid = c("xy", "xz", "yz"), angle = 15, 
                 xlim = c(-25,25),
                 ylim = c(-25,25),
                 zlim = c(60,105))
      plot$points3d(loc[,c(8,9,7)], pch = 16, col = this_colors, type = "p")
      legend("right", legend = levels(as.factor(loc$pitch_type)),
             col = colors[match(levels(as.factor(loc$pitch_type)), pot_colors)], pch = 16)
      
    }
  })
  


  output$og_table = renderDataTable({
    datatable(og_all_data(), options = list(dom = 't', autoWidth = FALSE, order = list(8, 'desc'))) %>%
      formatRound(columns=c('Velocity', 'H Break (in)', 'V Break (in)', 'Run Value'), digits=2) %>%
      formatStyle(
        "pitch",
        target = 'row',
        backgroundColor = styleEqual(input$pitch_type, c('yellow'))
      ) %>%
      formatPercentage(c("Chase%", "CSW%", "% Thrown"), 2)
  })
  
  
  
  
  first_other_data = reactive({
    id = first_data()$sim_player
    sim_pitch = first_data()$sim_pitch_type
    sim_year = first_data()$sim_year
    dat <- first_data() %>%
      mutate(pitch_type = sim_pitch_type) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "Run Value", "% Thrown", "count"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  second_other_data = reactive({
    id = second_data()$sim_player
    sim_pitch = second_data()$sim_pitch_type
    sim_year = second_data()$sim_year
    dat <- second_data() %>%
      mutate(pitch_type = sim_pitch_type) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "Run Value", "% Thrown", "count"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  third_other_data = reactive({
    id = third_data()$sim_player
    sim_pitch = third_data()$sim_pitch_type
    sim_year = third_data()$sim_year
    dat <- third_data() %>%
      mutate(pitch_type = sim_pitch_type) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "Run Value", "% Thrown", "count"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  fourth_other_data = reactive({
    id = fourth_data()$sim_player
    sim_pitch = fourth_data()$sim_pitch_type
    sim_year = fourth_data()$sim_year
    dat <- fourth_data() %>%
      mutate(pitch_type = sim_pitch_type) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "Run Value", "% Thrown", "count"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  fifth_other_data = reactive({
    id = fifth_data()$sim_player
    sim_pitch = fifth_data()$sim_pitch_type
    sim_year = fifth_data()$sim_year
    dat <- fifth_data() %>%
      mutate(pitch_type = sim_pitch_type) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "Run Value", "% Thrown", "count"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  
  output$first_table = renderDataTable({
    datatable(first_other_data(), options = list(dom = 't', autoWidth = FALSE, order = list(8, 'desc'))) %>%
      formatRound(columns=c('Velocity', 'H Break (in)', 'V Break (in)', "Run Value"), digits=2) %>%
      formatStyle(
        "pitch",
        target = 'row',
        backgroundColor = styleEqual(first_data()$sim_pitch_type, c('yellow'))
      ) %>%
      formatPercentage(c("Chase%", "CSW%", "% Thrown"), 2)
  })
  
  output$second_table = renderDataTable({
    datatable(second_other_data(), options = list(dom = 't', autoWidth = FALSE, order = list(8, 'desc'))) %>%
      formatRound(columns=c('Velocity', 'H Break (in)', 'V Break (in)', "Run Value"), digits=2) %>%
      formatStyle(
        "pitch",
        target = 'row',
        backgroundColor = styleEqual(second_data()$sim_pitch_type, c('yellow'))
      ) %>%
      formatPercentage(c("Chase%", "CSW%", "% Thrown"), 2)
  })
  
  output$third_table = renderDataTable({
    datatable(third_other_data(), options = list(dom = 't', autoWidth = FALSE, order = list(8, 'desc'))) %>%
      formatRound(columns=c('Velocity', 'H Break (in)', 'V Break (in)', "Run Value"), digits=2) %>%
      formatStyle(
        "pitch",
        target = 'row',
        backgroundColor = styleEqual(third_data()$sim_pitch_type, c('yellow'))
      ) %>%
      formatPercentage(c("Chase%", "CSW%", "% Thrown"), 2)
  })
  
  output$fourth_table = renderDataTable({
    datatable(fourth_other_data(), options = list(dom = 't', autoWidth = FALSE, order = list(8, 'desc'))) %>%
      formatRound(columns=c('Velocity', 'H Break (in)', 'V Break (in)', "Run Value"), digits=2) %>%
      formatStyle(
        "pitch",
        target = 'row',
        backgroundColor = styleEqual(fourth_data()$sim_pitch_type, c('yellow'))
      ) %>%
      formatPercentage(c("Chase%", "CSW%", "% Thrown"), 2)
  })
  
  output$fifth_table = renderDataTable({
    datatable(fifth_other_data(), options = list(dom = 't', autoWidth = FALSE, order = list(8, 'desc'))) %>%
      formatRound(columns=c('Velocity', 'H Break (in)', 'V Break (in)', "Run Value"), digits=2) %>%
      formatStyle(
        "pitch",
        target = 'row',
        backgroundColor = styleEqual(fifth_data()$sim_pitch_type, c('yellow'))
      ) %>%
      formatPercentage(c("Chase%", "CSW%", "% Thrown"), 2)
  })
  
  
  
}


shinyApp(ui = ui, server = server)


#runApp("Baseball Stuff/Arsenal App")


