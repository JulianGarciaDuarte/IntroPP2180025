// From https://www.programiz.com/c-programming/c-for-loop 
// Modified by C. Barrios for training purposes 2023
// Simple Program to calculate the sum of first n natural numbers
// Positive integers 1,2,3...n are known as natural numbers

#include <stdio.h>
#include <omp.h>

int run_omp_suma_simple(int num)
{
    int count, sum= 0;
    double exec_time, start_timer, end_timer;

    //Starts running time
    start_timer=omp_get_wtime();

    // Initializes the parallelization
    #pragma omp parallel for reduction(+:sum)

    // Executes the sum
    for (count = 1; count <= num; ++count){
        sum += count;
    }
    
    // Ends time
    end_timer=omp_get_wtime();
    exec_time=(end_timer - start_timer);

    printf("Resultado OMP = %d\n", sum); // Imprimir el resultado de la suma calculada de forma secuencial
    return exec_time;
}


int sec_suma_simple(int num){
    int resultado = 0; // Variable para almacenar la suma

    // Ciclo de suma secuencial
    for (int i = 0; i <= num; i++){
         resultado += i; // Sumar el valor de i al resultado
    }

    return resultado; // Devolver la suma calculada
}

float run_sec_suma_simple(int num){
    double exec_time, start_timer, end_timer;

    //Starts running time
    start_timer=omp_get_wtime();
    int result = sec_suma_simple(num); // Llamar a la función para calcular la suma de forma secuencial
    printf("Resultado Secu = %d\n", result); // Imprimir el resultado de la suma calculada de forma secuencial
    // Ends time
    end_timer=omp_get_wtime();
    exec_time=(end_timer - start_timer);

    return (float) exec_time; // Devolver el tiempo transcurrido
}

int main() {
    float run_time_sec, run_time_cuda;
    int num = 0;

    for (int i = 0; i <= 10; i++) {
        printf("\n\n");
  	    printf("Comparacion para n = %d\n", num);	

        num = pow(10, i);

        // Ejecutar cálculo de la suma utilizando openmp
        run_time_cuda = run_omp_suma_simple(num);

        // Ejecutar cálculo de la suma de forma secuencial
        run_time_sec = run_sec_suma_simple(num);

        printf("Tiempo OMP (milisegundos)       = %f\n", run_time_cuda); 
        printf("Tiempo Secuencial (milisegundos) = %f\n", run_time_sec); 

        int numThreads = omp_get_max_threads();

        // Calcular el speedup y la escalabilidad
        double speedup = run_time_cuda / run_time_sec;
        double scalability = run_time_sec / (run_time_cuda * numThreads);

        printf("Speedup: %.2f\n", speedup);
        printf("Escalabilidad: %.2f\n", scalability);

        int numOperations = num - 1;  // Número de operaciones de punto flotante realizadas
        double performance = numOperations / (run_time_cuda * 1e6);  // Rendimiento computacional en FLOPS

        printf("Performance: %.2f FLOPS\n", performance);
    }
}

