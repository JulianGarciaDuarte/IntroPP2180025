# Suma Simple

Para esta parte del taller se vario la cantidad de numeros sobre los cuales calcular la suma desde 1 hasta 1000 incrementando en cada iteracion un orden de magnitud. Todos los experimentos se corrieron en el cluster de Guane.
```
Comparacion para n = 0
Resultado Cuda = 1
Resultado Secu = 1
Tiempo Cuda (milisegundos)       = 0.787648
Tiempo Secuencial (milisegundos) = 0.004768
Speedup: 0.01
Escalabilidad: 0.00
Performance: 0.00 FLOPS


Comparacion para n = 1
Resultado Cuda = 55
Resultado Secu = 55
Tiempo Cuda (milisegundos)       = 0.698688
Tiempo Secuencial (milisegundos) = 0.004768
Speedup: 0.01
Escalabilidad: 0.00
Performance: 0.00 FLOPS


Comparacion para n = 10
Resultado Cuda = 5050
Resultado Secu = 5050
Tiempo Cuda (milisegundos)       = 0.705984
Tiempo Secuencial (milisegundos) = 0.004768
Speedup: 0.01
Escalabilidad: 0.00
Performance: 0.00 FLOPS


Comparacion para n = 100
Resultado Cuda = 500500
Resultado Secu = 500500
Tiempo Cuda (milisegundos)       = 0.753280
Tiempo Secuencial (milisegundos) = 0.004832
Speedup: 0.01
Escalabilidad: 0.00
Performance: 0.00 FLOPS


Comparacion para n = 1000
Resultado Cuda = 50005000
Resultado Secu = 50005000
Tiempo Cuda (milisegundos)       = 0.861888
Tiempo Secuencial (milisegundos) = 0.026816
Speedup: 0.03
Escalabilidad: 0.00
Performance: 0.01 FLOPS

```
Los resultados comparan diferentes ejecuciones para un valor creciente de n utilizando el código proporcionado. Basándonos en la información proporcionada, se pueden obtener las siguientes conclusiones:

En la comparación de resultados, los valores obtenidos de la implementación en CUDA y la implementación secuencial (Resultado Cuda y Resultado Secu, respectivamente) son consistentes y coinciden para cada valor de n probado, lo que indica que ambas implementaciones producen la suma correcta.

En cuanto al tiempo transcurrido, se observa que la implementación en CUDA (Tiempo Cuda) requiere más tiempo de ejecución en comparación con la implementación secuencial (Tiempo Secuencial) para todos los valores de n probados. Probablemente debido a el tiempo que conlleva ubicar los datos en memoria para su ejecucion y recuperacion de resultados.

El speedup, que mide la mejora de rendimiento lograda mediante la implementación en CUDA en comparación con la implementación secuencial, muestra valores consistentemente alrededor de 0.01, lo cual indica que la implementación en CUDA no proporciona una mejora significativa de rendimiento.

La escalabilidad, que mide la capacidad del código para utilizar de manera eficiente recursos adicionales a medida que aumenta el tamaño del problema, muestra valores de 0.00, sugiriendo que el código no exhibe escalabilidad a medida que aumenta el valor de n.

En términos de rendimiento, calculado en FLOPS (operaciones de punto flotante por segundo), los valores son consistentemente alrededor de 0.00 FLOPS, lo que indica una baja eficiencia computacional para ambas implementaciones.

En resumen, los resultados sugieren que la implementación en CUDA no ofrece una mejora significativa de rendimiento en comparación con la implementación secuencial para los valores de n probados. Es posible que los costos asociados con la transferencia de datos y la invocación del kernel en la implementación en CUDA superen los beneficios de la paralelización para tamaños de problemas pequeños. Sin embargo, se requiere un análisis y experimentación adicionales con tamaños de problemas más grandes para obtener conclusiones más definitivas.
