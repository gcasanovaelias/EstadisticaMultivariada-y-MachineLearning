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

data("mtcars")

force(mtcars)

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

#* Entrenamos el modelo ajustando un modelo lineal

modelo <- lm(mpg ~ hp + I(hp ^ 2), data = train)

broom::glance(modelo) # glance(): accepts a model object and returns a tibble with model summaries (goodness of fit measures)

broom::tidy(modelo) # tidy(): summarises information about components of a model (similar to summary())

# Un R2 de 0.82 significa que el 82% de la variabilidad es debido al modelo (el 18% restante es del error) por lo que esto correspondería al poder explicativo

train$Pred <- predict(object = modelo, newdata = train) # Creamos una nueva columna con los valores predichos en lla misma base de datos con la que armamos el modelo


# Poder predictivo --------------------------------------------------------

# ¿Cómo es que el modelo se comporta en la predicción de eficiencia en una nueva base de datos?

# Hacemos una predicción del modelo en una nueva base de datos

test$Pred <- predict(object = modelo, newdata = test) # Creamos una nueva columna con los valores predichos

ggplot(data = test, aes(x = hp, y = mpg)) +
  # Los puntos son los valores de mpg observados
  geom_point() +
  # La línea es la predicción de mpg según el modelo
  geom_line(aes(y = Pred)) +
  theme_minimal()

test <- test %>%
  # Creamos una nueva columna con los residuos (diferencia entre obs y predichos)
  mutate(resid = mpg - Pred) %>%
  select(hp, mpg, Pred, resid)


# Poder predictivo vs explicativo -----------------------------------------

# caret: Paquete que permite calcular el R2 y otras medidas con los valores observados y los predichos para...

# ..o el explicativo

caret::postResample(pred = train$Pred, obs = train$mpg)

# ...el poder predictivo

caret::postResample(pred = test$Pred, obs = test$mpg)

# R2: Cuanto % de la variación es explicada por el modelo
# MAE: Cuanto es el error promedio del modelo

# IMPORTANTE: Usualmente el poder predictivo (R2) debiese ser menor que el poder explicativo. Para mejorar la predicción podemos incorporar más variables (y por consiguiente parámetros estimados) pero hay que tener en cuenta no sobreajustar el modelo


# Sobreajuste ------------------------------------------------------------

# Usualmente, al ir construyendo modelos, estamos tentados a ir mejorando indefinidamente el R2, lo cual puede ser bueno para los modelos explicativos pero detrimental para los predictivos. A este fenómeno se le llama complejizar o sobreparametrizar un modelo y comprende la adición de un número creciente de parámetros para cada una de las variables.

# Parámetros se refiere a las estimaciones realizadas por el modelo en cuanto al intercepto al origen (b0), pendiente del factor lineal (b1), pendiente del factor cuadrpatico (b2), etc.

# El ir agregando parámetros siempre va a mejorar el poder explicativo mientras que para el poder predictivo este puede experimentar un leve aumento al principio para luego ir disminuyendo rápidamente tras sobrepasar cierto número de parámetros. De esta manera, el sobreajuste inicia una vez que el poder predictivo empieza a disminuir.

# El sobreajuste implica que los valores obtenidos explican de manera tan fidedigna los datos con los que se construye el modelo que al ser aplicados a otro (poner a prueba su poder predictivo) este presenta errores muy grandes y evidentes.

# Una de las consecuencias de la sobreparametrización es que, a pesar de que el poder explicativo aumenta, el poder explicar el modelo y la importancia de los respectivos parámtros se complejiza afectando negativamente la discusión.

# ¿Cuando maximizar un poder u otro?
# Maximizar el poder predictivo es el objetivo de los estudios que se enfocan en saber la variabilidad de los fenómenos que sucederán en un tiempo determinado. Aquí el interés no es explicar el porqué de dicho comportamiento sino simplemente maximizar la capacidad de predicción de fenómenos.

# Por otro lado, maximizar el poder explicativo va de la mano con poder responder a las preguntas basadas en las relaciones causales de fenómenos. A diferencia de lo que ocurre en el caso anterior, el maximizar el poder explicativo va acompañado de una interpretación sólida de los resultados.














