# Stock Price Analysis by Company - Shiny App

Interactive web application developed in R Shiny to visualize and analyze the evolution of stock prices for Chilean companies listed on the stock exchange.

## Description

This application allows you to visualize historical stock price data obtained from elmercurio.com. Users can select a company from a predefined list and explore the evolution of its prices over time, filtering by specific year ranges.

## Features

- **Company selection**: Choose from over 40 Chilean companies listed on the stock exchange
- **Interactive visualization**: Time series line chart showing price evolution
- **Year filtering**: Slider to select specific year ranges
- **Summary table**: Average prices per year in the selected range
- **Visual indicator**: Green color for gains, red for losses in the selected period
- **Dynamic updates**: The slider range adjusts automatically according to available data for each company

## Requirements

### Required R Packages

The application requires the following R packages:

- `shiny` - Framework for interactive web applications
- `tidyverse` - Suite of packages for data manipulation and visualization
- `jsonlite` - For reading JSON data from the API
- `lubridate` - Date manipulation
- `ggplot2` - Data visualization (included in tidyverse)
- `skimr` - Exploratory data analysis
- `shinythemes` - Visual themes for Shiny

**Note**: Packages are automatically installed if not present (for `tidyverse` and `jsonlite`). However, it is recommended to install them manually before running the application.

### Package Installation

```r
install.packages(c("shiny", "tidyverse", "jsonlite", "lubridate", "skimr", "shinythemes"))
```

## How to Run the Application

### Option 1: From RStudio

1. Open the `app.R` file in RStudio
2. Click the "Run App" button located at the top of the editor

### Option 2: From R Console

```r
shiny::runApp("path/to/directory/tallerShinyApp")
```

### Option 3: Run Directly

```r
source("app.R")
```

## Usage

1. **Select company**: Use the dropdown menu in the sidebar panel to choose a company from the list
2. **Adjust year range**: Use the slider to select the time period you want to analyze
3. **Visualize**: The chart updates automatically showing:
   - Price evolution over time
   - Green color if there was a gain or red if there was a loss in the period
4. **Review summary**: The table shows the average prices per year in the selected range

## Available Companies

The application includes over 40 Chilean companies, including:

- NUEVAPOLAR
- SMU
- BESALCO
- COPEC
- FALABELLA
- BSANTANDER
- CMPC
- CHILE
- SQM-B
- ENELAM
- CENCOSUD
- BCI
- And many more...

## Data Source

Data is obtained in real-time from the [elmercurio.com](https://www.elmercurio.com/inversiones/) API, specifically from the JSON endpoint that provides historical financial indicator data.

## Code Structure

- **Function `obtener_indicadores()`**: Retrieves historical price data from the API
- **Function `minmax()`**: Calculates the minimum and maximum years available for a company
- **UI**: User interface with "spacelab" theme
- **Server**: Server logic that processes inputs and generates outputs

## Technical Notes

- Data is obtained in JSON format and processed to create a data frame with columns: `fecha` (date), `precio` (price), and `vol` (volume)
- The slider range is dynamically updated using `observe()` to reflect the years available for each company
- The chart uses `ggplot2` for visualization with date format on the X-axis

## Author

Shiny App Workshop

## License

This project is open source and available for educational and research use.
