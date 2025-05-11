# Costos

## Procesamiento de una consulta
1. Parser y Translator
    - Rechazar consulta invalida
2. Optimizador
    - Se convierte la expresion SQL a una de algebra relacional
    - Se busca una expresion equivalente en algebra relacional pero que se ejecute mas rapido
    - Se busca una estrategia para cada operador de A.R.
3. Evaluacion del plan de ejecucion
    - Devolver el resultado en base a los datos

  ## Minimizacion de costos
Se busca que el costo de resolver consultas sea el menor posible. 

Costo de acceso a disco -> bloques leídos o escritos cuestan lo mismo 

## Reglas de equivalencia 
Reglas para convertir una expresion de AR en otra equivalente que tenga la mejor performance. Se usan heuristicas para saber cuando conviene hacer una cosa u otra. 

### Equivalencia en selección y proyección 
Equivalencia en cascada y conmutividad 

- Selección: 
    - Selección con muchas condiciones unidas por AND = hacer una selección de la selección de la selección...
    - Selección con muchas condiciones unidas por OR = selección condicion 1 UNION selección condicion 2 UNION ...
    - Selección c1(selección c2(R)) = Selección c2(selección c1(R))

- Proyección:
    - Varias proyecciones una sobre otra = solo hacer proyección de la de mas afuera
    - Solo si la condicion usa únicamente atributos en X: proyección X(selección condicion(R)) = selección condicion(proyección X(R))
    

### Equivalencia en producto cartesiano, junta y operadores de conjunto 
Conmutividad y asociatividad 

> ver diapositivas página 10

### Equivalencia entre junta y producto cartesiano

> página 11

### Otras equivalencias 

