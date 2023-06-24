# Integrantes del Equipo

- Julian Esteban Garcia Duarte - 2180025
- Jeicob Gilmar Restrepo Gómez - 2183076
- Sebastián David Mendoza Alvarado -2191969

# trapezAreaSimple

## Descripción del Proceso de Ejecución con CUDA para `trapezAreaSimple`

A continuación se describe el proceso paso a paso para ejecutar el código paralelizado con CUDA utilizando el archivo "CUDA_trapezAreaSimple.cu":

1. Cargar el módulo CUDA:
   - El proceso comienza cargando el módulo "devtools/cuda/8.0" para asegurar que las herramientas de desarrollo y la versión adecuada de CUDA estén disponibles en el entorno de ejecución.

2. Solicitar recursos de la GPU:
   - Se utiliza el comando `srun` para solicitar recursos de la GPU y obtener acceso a una máquina que tenga una GPU disponible. La opción `--gres=gpu` se utiliza para especificar que solo se requiere una GPU para la ejecución.
     
3. Iniciar una sesión interactiva:
   - El parámetro `--pty` se utiliza con el comando `srun` para iniciar una sesión interactiva en la máquina asignada. Esto permite ejecutar comandos en un entorno interactivo dentro de la GPU asignada.

4. Compilar el código CUDA:
   - Se utiliza el compilador `nvcc` (NVIDIA CUDA Compiler) para compilar el archivo "CUDA_trapezAreaSimple.cu". El comando de compilación utilizado es `nvcc CUDA_trapezAreaSimple.cu -o CUDA_trapezAreaSimple`, donde se especifica el nombre de salida del ejecutable como "CUDA_trapezAreaSimple".

5. Ejecutar el programa:
   - Finalmente, se ejecuta el programa utilizando el comando `./CUDA_trapezAreaSimple`. Esto inicia la ejecución del código paralelizado con CUDA y muestra los resultados en la salida estándar.

## Ejecución

A continuación se presentan los pantallazos de las ejecuciones de cada una de las implementaciones:

### CUDA

![CUDA](https://github.com/SC3UIS/IntroPP2183076/assets/82180254/e93817cd-7380-432d-8bfd-0c7c4dfe1e4e)

### OpenMP

![OMP](https://github.com/SC3UIS/IntroPP2183076/assets/82180254/fa449955-41aa-4240-862e-a0f617f99820)

### MPI

![MPI](https://github.com/SC3UIS/IntroPP2183076/assets/82180254/8e4f393f-b259-4895-a63e-feeca4639150)


# Análisis y Conclusiones

Los resultados obtenidos de las implementaciones CUDA, OpenMP y MPI del algoritmo de integración numérica son los siguientes:

## CUDA:
- Número de subintervalos: 1000
- Límite inicial: 3
- Límite final: 8
- Valor de la integral: 161.666687
- Tiempo transcurrido: 0.011224 segundos
- Speedup: 14403.62
- Escalabilidad: 14.07
- Rendimiento computacional: 89005.45 FLOPS

## OpenMP:
- Número de subintervalos: 1000
- Límite inicial: 3
- Límite final: 8
- Valor de la integral: 161.666688
- Tiempo transcurrido: 0.000527 segundos
- Speedup: 1.66
- Escalabilidad: 0.10
- Rendimiento computacional: 7590132.83 FLOPS/sec

## MPI:
- Número de subintervalos: 1000
- Límite inicial: 3
- Límite final: 8
- Valor de la integral: 161.666688
- Tiempo transcurrido: 0.000318 segundos
- Speedup: 509068.49
- Escalabilidad: 42422.37
- Rendimiento computacional: 12595507.51 FLOPS/sec

A partir de los resultados, se pueden observar las siguientes conclusiones:

1. Comparación de rendimiento:
   - La implementación CUDA logró el mayor rendimiento computacional con 89005.45 FLOPS.
   - La implementación OpenMP logró un rendimiento computacional de 7590132.83 FLOPS/sec.
   - La implementación MPI logró el mayor rendimiento computacional con 12595507.51 FLOPS/sec.

2. Speedup y escalabilidad:
   - La implementación CUDA logró un speedup significativamente mayor de 14403.62 en comparación con la ejecución secuencial.
   - La implementación OpenMP logró un speedup moderado de 1.66.
   - La implementación MPI logró un speedup excepcionalmente alto de 509068.49.
   - La escalabilidad fue relativamente baja para la implementación OpenMP (0.10) y moderadamente baja para la implementación CUDA (14.07). Sin embargo, la implementación MPI demostró una excelente escalabilidad (42422.37), lo que indica su capacidad para utilizar de manera eficiente un gran número de unidades de procesamiento.

3. Tiempo transcurrido:
   - La implementación CUDA tardó 0.011224 segundos, lo que indica su eficiencia en utilizar la GPU para cálculos paralelos.
   - La implementación OpenMP tardó 0.000527 segundos, demostrando su alta eficiencia en utilizar múltiples hilos para cálculos paralelos.
   - La implementación MPI tardó 0.000318 segundos, mostrando su distribución eficiente de tareas entre varios procesos.

En general, la implementación CUDA superó a las implementaciones OpenMP y MPI en términos de rendimiento computacional y logró un speedup significativo. Sin embargo, la implementación MPI demostró el mayor speedup y escalabilidad, lo que la convierte en una excelente opción para cálculos paralelos a gran escala. La implementación OpenMP mostró un speedup y escalabilidad moderados, lo que indica su eficacia para paralelizar cálculos en un sistema de memoria compartida.
# summaSimple
