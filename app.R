if(!require(tidyverse)) install.packages("tidyverse")
if(!require(jsonlite))  install.packages("jsonlite") 

library(tidyverse)
library(jsonlite)

library(shiny)
library(lubridate)
library(ggplot2)
require(skimr)

library(shinythemes)

lista_empresas <- c("NUEVAPOLAR", "SMU", "BESALCO", "COPEC", "FALABELLA", 
                    "BSANTANDER",  "CMPC", "CHILE", "SQM-B", "ENELAM", "CENCOSUD",
                    "BCI", "LTM",  "ENELCHILE", "SM-CHILE B", "CCU", "PARAUCO",
                    "ITAUCORP", "AGUAS-A",  "COLBUN", "ENTEL", "ECL", "CONCHATORO",
                    "RIPLEY", "AESGENER",  "ANDINA-B", "SONDA", "CAP", "ILC", 
                    "SALFACORP", "SECURITY", "VAPORES",  "ENELGXCH", "ANTARCHILE",
                    "BANMEDICA", "EMBONOR-B", "FORUS",  "IAM", "MASISA", "ORO BLANCO", 
                    "SK", "SMSAAM")

#Function to get indicators from elmercurio.com
obtener_indicadores <- function(empresa = "FALABELLA") { 
    
    url <- stringr::str_c("https://www.elmercurio.com/inversiones/json/json.aspx?categoria=", 
                          empresa, "&time=10&indicador=2") 
    
    df <- jsonlite::read_json(url)$Data %>% 
        stringr::str_split(";") %>% 
        dplyr::first() %>%
        I() %>% 
        readr::read_delim(delim = ",", col_names = c("fecha", "precio", "vol")) 
    
    df <- df %>% 
        mutate(
            fecha = lubridate::ymd_hms(fecha),
            anio = lubridate::year(fecha)
        ) 
    df 
} 

minmax <- function(company){
    d <- obtener_indicadores(company) 
    output <- ""
    output$yearmin <- year(min(d$fecha))
    output$yearmax <- year(max(d$fecha))
    output
    
} 


ui <- navbarPage("Stock Price Analysis by Company",
                 theme=shinytheme("spacelab"),
                 tabPanel("Home",
                          
                          sidebarLayout(
                              sidebarPanel(
                                  selectInput("empresa", "Select a company:", 
                                              choices = lista_empresas, selected = "NUEVAPOLAR"), 
                                  minimo <- textOutput("min"),
                                  sliderInput("year", "Price by period:", min = 2012, max = 2021, value = c(1,1)),
                                  mainPanel(tableOutput("tableSummary"))
                                  
                              ),
                              
                              mainPanel(plotOutput("distPlot"))
                          )
                 )
                 
)


server <- function(input, output, session) {
    output$distPlot <- renderPlot({ 
        empresa <- input$empresa
        ##
        #empresa <- "SQM-B"
        print(empresa)
        d <- obtener_indicadores(empresa) 
        inputyear <- input$year
        ##
        #input <- ""
        #input$year <- 2015
        
        
        input$year
        glimpse(d)
        d %>%
            group_by(anio) %>% 
            summarise(mean(precio)) 
        
        if(input$year != ""){
            d <- d %>%
                filter(year(fecha) >= inputyear[1], year(fecha) <= inputyear[2]) 
        }
        #Find initial and final price values according to the filter
        first_val <- d$precio[1]
        last_val <- tail(d$precio, n = 1)
        
        #Red color is defined when there is a loss and green when there is a gain
        state_colour <- ifelse(last_val > first_val, "green", "red")
        #Plot of evolution over time range
        ggplot(data = d, aes(x = fecha, y = precio, group = 1)) +
            geom_line(color = state_colour, linetype = "solid", size=1)+ 
            #geom_point()+
            theme(axis.text.x = element_text(angle = 45, vjust = 0.5), 
                  panel.background=element_rect(fill="white"))+
            labs(title = paste0("Price evolution for ",empresa),
                 x = "Date",
                 y = "Price")
        
    })
    
    output$tableSummary <- renderTable({
        empresa <- input$empresa
        d <- obtener_indicadores(empresa) 
        inputyear <- input$year
        #
        print(inputyear)
        if(input$year != ""){
            d <- d %>%
                filter(year(fecha) >= inputyear[1],year(fecha) <= inputyear[2] ) %>% 
                as.data.frame()
        }
        
        d<-d %>%
            group_by(anio) %>% 
            summarise(mean(precio)) 
        print(paste0("Value table"))
        print(d)
    })
    
    observe({
        result <- minmax(input$empresa)
        aux <- result$yearmin
        auxMax <- result$yearmax
        
        updateSliderInput(session, 'year',min = as.numeric(aux), 
                          max = as.numeric(auxMax), step = 1, value = c(as.numeric(aux),as.numeric(auxMax)))
        
    })
    # observeEvent(input$Slider,{
    #   updateSelectInput(session,'select',
    #                     choices=unique(df[df==input$Slider]))
    # }) 
}



shinyApp(ui, server)

