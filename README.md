# Análisis de Precio por Empresa - Shiny App

Aplicación web interactiva desarrollada en R Shiny para visualizar y analizar la evolución de precios de acciones de empresas chilenas listadas en la bolsa.

## Descripción

Esta aplicación permite visualizar datos históricos de precios de acciones obtenidos desde elmercudio.com. Los usuarios pueden seleccionar una empresa de una lista predefinida y explorar la evolución de sus precios a lo largo del tiempo, filtrando por rangos de años específicos.

## Características

- **Selección de empresa**: Elige entre más de 40 empresas chilenas listadas en la bolsa
- **Visualización interactiva**: Gráfico de línea temporal mostrando la evolución del precio
- **Filtrado por año**: Deslizador para seleccionar rangos de años específicos
- **Tabla resumen**: Promedio de precios por año en el rango seleccionado
- **Indicador visual**: Color verde para ganancias, rojo para pérdidas en el período seleccionado
- **Actualización dinámica**: El rango del deslizador se ajusta automáticamente según los datos disponibles de cada empresa

## Requisitos

### Paquetes de R necesarios

La aplicación requiere los siguientes paquetes de R:

- `shiny` - Framework para aplicaciones web interactivas
- `tidyverse` - Conjunto de paquetes para manipulación y visualización de datos
- `jsonlite` - Para leer datos JSON desde la API
- `lubridate` - Manipulación de fechas
- `ggplot2` - Visualización de datos (incluido en tidyverse)
- `skimr` - Análisis exploratorio de datos
- `shinythemes` - Temas visuales para Shiny

**Nota**: Los paquetes se instalan automáticamente si no están presentes (para `tidyverse` y `jsonlite`). Sin embargo, es recomendable instalarlos manualmente antes de ejecutar la aplicación.

### Instalación de paquetes

```r
install.packages(c("shiny", "tidyverse", "jsonlite", "lubridate", "skimr", "shinythemes"))
```

## Cómo ejecutar la aplicación

### Opción 1: Desde RStudio

1. Abre el archivo `app.R` en RStudio
2. Haz clic en el botón "Run App" ubicado en la parte superior del editor

### Opción 2: Desde la consola de R

```r
shiny::runApp("ruta/al/directorio/tallerShinyApp")
```

### Opción 3: Ejecutar directamente

```r
source("app.R")
```

## Uso

1. **Seleccionar empresa**: Utiliza el menú desplegable en el panel lateral para elegir una empresa de la lista
2. **Ajustar rango de años**: Usa el deslizador para seleccionar el período de tiempo que deseas analizar
3. **Visualizar**: El gráfico se actualiza automáticamente mostrando:
   - La evolución del precio en el tiempo
   - Color verde si hubo ganancia o rojo si hubo pérdida en el período
4. **Revisar resumen**: La tabla muestra el promedio de precios por año en el rango seleccionado

## Empresas disponibles

La aplicación incluye más de 40 empresas chilenas, incluyendo:

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
- Y muchas más...

## Fuente de datos

Los datos se obtienen en tiempo real desde la API de [elmercurio.com](https://www.elmercurio.com/inversiones/), específicamente del endpoint JSON que proporciona datos históricos de indicadores financieros.

## Estructura del código

- **Función `obtener_indicadores()`**: Obtiene datos históricos de precios desde la API
- **Función `minmax()`**: Calcula los años mínimo y máximo disponibles para una empresa
- **UI**: Interfaz de usuario con tema "spacelab"
- **Server**: Lógica del servidor que procesa los inputs y genera outputs

## Notas técnicas

- Los datos se obtienen en formato JSON y se procesan para crear un data frame con columnas: `fecha`, `precio`, y `vol` (volumen)
- El rango del deslizador se actualiza dinámicamente usando `observe()` para reflejar los años disponibles para cada empresa
- El gráfico utiliza `ggplot2` para la visualización con formato de fecha en el eje X

## Autor

Taller de Shiny App

## Licencia

Este proyecto es de código abierto y está disponible para uso educativo y de investigación.

