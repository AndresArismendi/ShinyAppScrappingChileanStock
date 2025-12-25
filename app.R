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

#Función para obtener indicadores desde elmercudio.com
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

minmax <- function(negocio){
    d <- obtener_indicadores(negocio) 
    salida <- ""
    salida$yearmin <- year(min(d$fecha))
    salida$yearmax <- year(max(d$fecha))
    salida
    
} 


ui <- navbarPage("Análisis de precio por empresa",
                 theme=shinytheme("spacelab"),
                 tabPanel("Inicio",
                          
                          sidebarLayout(
                              sidebarPanel(
                                  selectInput("empresa", "Seleccionar una empresa:", 
                                              choices = lista_empresas, selected = "NUEVAPOLAR"), 
                                  minimo <- textOutput("min"),
                                  sliderInput("year", "Precio por período:", min = 2012, max = 2021, value = c(1,1)),
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
        #Busco los valores de precio iniciales y finales de acuerdo al filtro
        first_val <- d$precio[1]
        last_val <- tail(d$precio, n = 1)
        
        #se define el color rojo cuando hay pérdida y verde cuando hay ganancia
        state_colour <- ifelse(last_val > first_val, "green", "red")
        #Plot de evolución durante rango de tiempo
        ggplot(data = d, aes(x = fecha, y = precio, group = 1)) +
            geom_line(color = state_colour, linetype = "solid", size=1)+ 
            #geom_point()+
            theme(axis.text.x = element_text(angle = 45, vjust = 0.5), 
                  panel.background=element_rect(fill="white"))+
            labs(title = paste0("Evolucion de precio para ",empresa),
                 x = "Fecha",
                 y = "Precio")
        
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
        print(paste0("Tabla valor"))
        print(d)
    })
    
    observe({
        otro <- minmax(input$empresa)
        aux <- otro$yearmin
        auxMax <- otro$yearmax
        
        updateSliderInput(session, 'year',min = as.numeric(aux), 
                          max = as.numeric(auxMax), step = 1, value = c(as.numeric(aux),as.numeric(auxMax)))
        
    })
    # observeEvent(input$Slider,{
    #   updateSelectInput(session,'select',
    #                     choices=unique(df[df==input$Slider]))
    # }) 
}



shinyApp(ui, server)

