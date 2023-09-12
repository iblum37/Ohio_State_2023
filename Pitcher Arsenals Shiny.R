library(shinydashboard)
library(rsconnect)
library(shiny)
library(shinythemes)
library(shinyjs)
library(tidyverse)
library(remotes)
#install_github("BillPetti/baseballr")
#install_github("bayesball/CalledStrike")
#library(CalledStrike)

# Filtering to just 2022 for speed
options <- filter(read_csv("options.csv"), year == '2022')
location_data <- mutate(read_csv("location_data.csv"), pitch_type = ifelse(pitch_type == "KC", "CU", pitch_type)) 
database_to_draw <- mutate(read_csv("database_to_draw.csv"), pitch_type = ifelse(pitch_type == "KC", "CU", pitch_type)) 
colnames(database_to_draw)[10] = "H Break (in)"
colnames(database_to_draw)[11] = "V Break (in)"
colnames(database_to_draw)[16] = "Chase%"
colnames(database_to_draw)[17] = "CSW%"
colnames(database_to_draw)[19] = "% Thrown"
database_to_draw[16] <- round(database_to_draw[16], digits = 2)
database_to_draw[17] <- round(database_to_draw[17], digits = 2)
database_to_draw[19] <- round(database_to_draw[19], digits = 2)
#database_to_draw[16] <- paste0(as.matrix(database_to_draw[16]), '%')
#database_to_draw[17] <- paste0(as.matrix(database_to_draw[17]), '%')
new_diff_all <- read_csv("new_diff_all_edit.csv")
new_diff_2022 <- read_csv("new_diff_2022_edit.csv")

ui <- fluidPage(
  
  
  titlePanel("Pitcher Arsenal Comparison"),
  theme = shinythemes::shinytheme("journal"),
  
  
  
  
  
  
  
  
  sidebarLayout(
    sidebarPanel(width = 3,
      selectInput('name',
                  'Select Pitcher:',
                  choices = c(unique(options$name))),
      selectInput('pitch_type',
                  'Select Pitch Type:',
                  choices = c(unique(options$pitch_type))),
      checkboxInput('check2022', 'Show only 2022 results', FALSE)
    ),
    
    
    
    mainPanel(width = 9,
      fluidRow(
        column(3,
               plotOutput("og_zone", height = 300, width = 250),
        ),
        column(9,
               tableOutput("og_table")
        )
      ),
      tabsetPanel(
        tabPanel("First",
                 fluidRow(
                   column(3,
                          plotOutput("first_zone", height = 300, width = 250)
                   ),
                   column(9,
                          tableOutput("first_table")
                   )
                 )
        ),         
        tabPanel("Second",
                 fluidRow(
                   column(3,
                          plotOutput("second_zone", height = 300, width = 250)
                   ),
                   column(9,
                          tableOutput("second_table")
                   )
                 )
        ),
        tabPanel("Third",
                 fluidRow(
                   column(3,
                          plotOutput("third_zone", height = 300, width = 250)
                   ),
                   column(9,
                          tableOutput("third_table")
                   )
                 )
        ),
        tabPanel("Fourth",
                 fluidRow(
                   column(3,
                          plotOutput("fourth_zone", height = 300, width = 250)
                   ),
                   column(9,
                          tableOutput("fourth_table")
                   )
                 )
        ),
        tabPanel("Fifth",
                 fluidRow(
                   column(3,
                          plotOutput("fifth_zone", height = 300, width = 250)
                   ),
                   column(9,
                          tableOutput("fifth_table")
                   )
                 )
        )
      )
    )
  )
)  
  


server <- function(input, output, session) {
  
  observe({
    x <- input$name
    new_options <- filter(options, name == x)
    
    updateSelectInput(session, "pitch_type",
                      choices = new_options$pitch_type
    )
    
  })
  
  
  output$og_name = renderText(input$name)
  
  
  og_all_data = reactive({
    dat <- database_to_draw %>%
      filter(name == input$name, pitch_type == input$pitch_type, year == '2022') %>%
      bind_rows(arrange(filter(database_to_draw, name == input$name, pitch_type != input$pitch_type, year == "2022"), desc(`% Thrown`))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "% Thrown"))
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
      labs(xlab = "", ylab = "", title = paste(input$name, "-", input$pitch_type),
           subtitle = "2022") +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(size=22)) + 
      theme(plot.subtitle = element_text(size=15)) +
      theme(plot.title = element_text(face="bold"))
  })
  
  
  
  first_location_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'first')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'first')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    filter(location_data, pitch_type == sim_pitch & 
             pitcher == id & game_year == sim_year)
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
    filter(location_data, pitch_type == sim_pitch & 
             pitcher == id & game_year == sim_year)
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
    filter(location_data, pitch_type == sim_pitch & 
             pitcher == id & game_year == sim_year)
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
    filter(location_data, pitch_type == sim_pitch & 
             pitcher == id & game_year == sim_year)
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
    filter(location_data, pitch_type == sim_pitch & 
             pitcher == id & game_year == sim_year)
  })
  
  
  output$first_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'first') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'first') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    
    
    ggplot(first_location_data(), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(xlab = "", ylab = "", title = paste0(data$name, " - ", data$sim_pitch_type),
           subtitle = paste0(data$sim_year, "\n(", data$perc, "%)")) +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(size=22)) + 
      theme(plot.subtitle = element_text(size=15)) +
      theme(plot.title = element_text(face="bold"))
  })
  
  output$second_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'second') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'second') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    
    
    ggplot(second_location_data(), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(xlab = "", ylab = "", title = paste0(data$name, " - ", data$sim_pitch_type),
           subtitle = paste0(data$sim_year, "\n(", data$perc, "%)")) +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(size=22)) + 
      theme(plot.subtitle = element_text(size=15)) +
      theme(plot.title = element_text(face="bold"))
  })
  
  output$third_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'third') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'third') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    
    
    ggplot(third_location_data(), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(xlab = "", ylab = "", title = paste0(data$name, " - ", data$sim_pitch_type),
           subtitle = paste0(data$sim_year, "\n(", data$perc, "%)")) +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(size=22)) + 
      theme(plot.subtitle = element_text(size=15)) +
      theme(plot.title = element_text(face="bold"))
  })
  
  output$fourth_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fourth') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fourth') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    
    
    ggplot(fourth_location_data(), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(xlab = "", ylab = "", title = paste0(data$name, " - ", data$sim_pitch_type),
           subtitle = paste0(data$sim_year, "\n(", data$perc, "%)")) +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(size=22)) + 
      theme(plot.subtitle = element_text(size=15)) +
      theme(plot.title = element_text(face="bold"))
  })
  
  output$fifth_zone = renderPlot({
    df <- data.frame(x = c(-0.85, -1, 0, 1, 0.85), y = c(.35, -.15, -.45, -.15, .35))
    
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fifth') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'fifth') %>%
        select(-9) %>%
        left_join(select(database_to_draw, c(5, 20)), by = c("sim_player" = "pitcher")) %>%
        head(1)
    }
    data[5] <- round(data[5], digits = 1)
    
    
    ggplot(fifth_location_data(), aes(plate_x, plate_z)) + 
      stat_density_2d(geom = "polygon", contour = TRUE, aes(fill = after_stat(level)), na.rm = TRUE, show.legend = FALSE) +
      scale_fill_gradientn(colors = c("lightcyan2", "light green", "yellow", "coral")) +
      geom_polygon(df, mapping=aes(x = x, y = y), fill="grey93") +
      geom_segment(aes(x = -0.85, y = 1.6, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = -0.85, y = 1.6, xend = 0.85, yend = 1.6), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = -0.85, yend = 3.5), linewidth = 1) + 
      geom_segment(aes(x = 0.85, y = 3.5, xend = 0.85, yend = 1.6), linewidth = 1) +
      xlim(-3.5, 3.5) +
      ylim(-1,5) +
      labs(xlab = "", ylab = "", title = paste0(data$name, " - ", data$sim_pitch_type),
           subtitle = paste0(data$sim_year, "\n(", data$perc, "%)")) +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5)) +
      theme(plot.subtitle = element_text(hjust = 0.5)) +
      theme(plot.title = element_text(size=22)) + 
      theme(plot.subtitle = element_text(size=15)) +
      theme(plot.title = element_text(face="bold"))
  })
  
  
  
  output$og_table = renderTable({
    expr = og_all_data()
  })
  
  
  
  
  first_other_data = reactive({
    if(input$check2022 == TRUE){
      data <- new_diff_2022 %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'first')
    }
    else {
      data <- new_diff_all %>%
        filter(name == input$name,
               pitch_type == input$pitch_type,
               year == 2022,
               rank == 'first')
    }
    id = data$sim_player
    sim_pitch = data$sim_pitch_type
    sim_year = data$sim_year
    dat <- filter(database_to_draw, pitch_type == sim_pitch & pitcher == id & year == sim_year) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year), desc(`% Thrown`))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "% Thrown"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  second_other_data = reactive({
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
    dat <- filter(database_to_draw, pitch_type == sim_pitch & pitcher == id & year == sim_year) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year), desc(`% Thrown`))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "% Thrown"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  third_other_data = reactive({
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
    dat <- filter(database_to_draw, pitch_type == sim_pitch & pitcher == id & year == sim_year) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year), desc(`% Thrown`))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "% Thrown"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  fourth_other_data = reactive({
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
    dat <- filter(database_to_draw, pitch_type == sim_pitch & pitcher == id & year == sim_year) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year), desc(`% Thrown`))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "% Thrown"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  fifth_other_data = reactive({
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
    dat <- filter(database_to_draw, pitch_type == sim_pitch & pitcher == id & year == sim_year) %>%
      bind_rows(arrange(filter(database_to_draw, pitcher == id & pitch_type != sim_pitch & year == sim_year), desc(`% Thrown`))) %>%
      select(c("pitch_type", "Velocity", "H Break (in)", "V Break (in)", "Chase%", "CSW%", "% Thrown"))
    colnames(dat)[1] = "pitch"
    dat
  })
  
  
  output$first_table = renderTable({
    first_other_data()
  })
  
  output$second_table = renderTable({
    second_other_data()
  })
  
  output$third_table = renderTable({
    third_other_data()
  })
  
  output$fourth_table = renderTable({
    fourth_other_data()
  })
  
  output$fifth_table = renderTable({
    fifth_other_data()
  })
  
  
  
}


shinyApp(ui = ui, server = server)


#runApp("Baseball Stuff/Pitcher Arsenals Shiny.R")


