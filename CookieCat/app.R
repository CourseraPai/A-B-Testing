## library() calls go here
library(drake)
library(tidyverse)
library(ggplot2)
library(here)
library(shiny)
library(shinydashboard)
library(rsconnect)
library(dplyr)

source(here("R","get_plot.R"))
source(here("R","get_data.R"))

cookie_data <- readRDS(here("cookie.RDS"))


header <- dashboardHeader(title="Cookie Cat Gate Analysis")
sidebar <- 	dashboardSidebar(sidebarMenu(
	menuItem("Retention Gate Mean", tabName = "Gate-Means", icon = icon("dashboard")),
	menuItem("Confidence in Mean", tabName = "Confidence", icon = icon("dashboard"))
)
)
body <- dashboardBody(
	tabItems(
		tabItem(tabName = "Gate-Means",
						fluidRow(
							fluidRow(
								box("Do you want to check Retention Stats for a Day or 7 Days?",
										selectInput("DayChoice","Select",c("retention_1","retention_7"),selected="retention_1"))),
							box(plotOutput("plot1", height = 600,width=600))
						)
		),
		tabItem(tabName = "Confidence",
						fluidRow(
							box("Do you want to check Retention Stats for a Day or 7 Days?",
									selectInput("DayChoice","Select",c("retention_1","retention_7"),selected="retention_1"))),
						fluidRow(
							box(      "To check our confidence in the Retention Mean, How Many bootstrap samples to be used?",
												sliderInput("slider", "Slider Input:", 0, 10000, 5000)),
							box(plotOutput("plot2", height = 500,width=500))
						)
		)
		
	)
)

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
	output$plot1 <- renderPlot({
		get_plot(cookie_data,"bar",input$slider,input$DayChoice)
	})
	output$plot2 <- renderPlot({
		get_plot(cookie_data,"boot",input$slider,input$DayChoice)
	})
}

shinyApp(ui, server)