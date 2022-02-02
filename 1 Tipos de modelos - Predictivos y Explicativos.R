# Packages ----------------------------------------------------------------

library(tidyverse)
library(MuMIn)
library(caret)
library(broom)


# Apuntes modelos ---------------------------------------------------------

# En el curso se hará distinción acerca de los modelos explicativos y predictivos. Mientras que la sección de modelos multivariados son más explicativos mientras que el machine learning se encuentra más dentro de los modelos predictivos

# Modelos estadísticos
#* Modelo no determinista (no espera realizar una predicción exacta) que utiliza una muestra de una población para intentar determinar patrones de esta
#* Simplificación numérica de la realidad con el objetivo de estudiar/descrivir o predecir un fenómeno o suceso
#* "Todos los modelos están equivocados, pero algunos de estos son útiles": Esto hace referencia a que todos los modelos están asociados a un error
#* Algunos ejemplos que vamos a observar en el curso son modelos de ANOVA, regresión lineal y regresiones no lineales

# Poder Explicativo != Poder Predictivo
#* La forma más fácil de entender el poder explicativo es a partir del R2 (% de la variación EXPLICADA por el modelo).
#* Por otro lado, para el poder predictivo tambien se puede emplear el R2 pero aplicado a una nueva base de datos (testeo)

# Ejemplo
# ¿Podemos explicar o predecur la eficiencia de combustible (mpg) a partir de los caballos de fuerza (hp) de un vehículo?

#* Para entender la diferencia entre modelos explicativos y predictivos se divide la base de datos en dos; de entrenamiento (ajustar el modelo y ver el poder explicativo) y de validación ó testeo (determinar si el modelo generado tiene un buen poder predictor)

set.seed(1)

index <- sample(
  # Vector que indica el conjunto de filas de los datos
  x = 1:nrow(mtcars), 
  # Tamaño de las muestras (mitad de los datos)
  size = round(nrow(mtcars) / 2))

# Datos de entrenamiento
train <- mtcars[index, ]

# Datos de validación
test <- mtcars[-index, ]


# Poder explicativo -------------------------------------------------------

data("mtcars")

force(mtcars)







