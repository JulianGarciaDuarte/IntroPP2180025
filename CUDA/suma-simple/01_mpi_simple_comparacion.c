// From https://www.programiz.com/c-programming/c-for-loop 
// Modified by C. Barrios for training purposes 2023
// Simple Program to calculate the sum of first n natural numbers
// Positive integers 1,2,3...n are known as natural numbers
#include <stdio.h>
#include <mpi.h>

int sec_suma_simple(int num){
    int resultado = 0; // Variable para almacenar la suma

    // Ciclo de suma secuencial
    for(int i = 0; i <= num; i++){
         resultado += i; // Sumar el valor de i al resultado
    }

    return resultado; // Devolver la suma calculada
}

float run_sec_suma_simple(int num){
    double exec_time, start_timer, end_timer;

    //We start measuring the time
    start_timer = MPI_Wtime();
    int result = sec_suma_simple(num); // Llamar a la función para calcular la suma de forma secuencial
    printf("Resultado Secu = %d\n", result); // Imprimir el resultado de la suma calculada de forma secuencial
    //We end the measuring of the time
    end_timer = MPI_Wtime();
    exec_time=(end_timer - start_timer);

    return (float) exec_time; // Devolver el tiempo transcurrido
}

int run_mpi_suma_simple(int num, int argc,char* argv[]) {
    int count, sum = 0;
    int rank, size;
    int local_sum = 0;


    //Variables para el tiempo
    double start_time, end_time;

    //Iniciamos MPI
    MPI_Init(&argc,&argv);

    //Get the identifier or rank of actual process
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    //Number of processes
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    //Transfer the value of the variable num to each process
    //the number 1 indicates that we are only transfering one value, the value
    //of the variable num
    MPI_Bcast(&num, 1,MPI_INT,0,MPI_COMM_WORLD);


    //We start measuring the time
    start_time = MPI_Wtime();

    //To calculate the number of iterations for each process we divide
    //num in size

    //then we multiply by the rank and add one to calculate the
    //beginning value for each process
    int start = rank * (num/size) +1;

    //We calculate the end of each process, if the process is the last, it means
    //that is the size - 1 process, we assign value, otherwise we calculate the
    //end of the process by adding rank plus 1 and the multiplying by the number
    //of iterations for each process
    int end = (rank == size - 1) ? num : (rank + 1) * (num/size);


    //All processes make the for loop in their respective range
    for (count = start; count <= end; ++count)
    {
            local_sum += count;
    }


    //We reunited the result of all the processes and storage it in the variable sum
    MPI_Reduce(&local_sum, &sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);


    //We end the measuring of the time
    end_time = MPI_Wtime();

    if (rank == 0) {
        printf("Resultado Secu = %d\n", sum); // Imprimir el resultado de la suma calculada de forma secuencial
    }

    MPI_Finalize();
    return endTime - startTime;
}

int main(int argc,char* argv[]) {
    float run_time_sec, run_time_cuda;
    int num = 0;

    for (int i = 0; i <= 10; i++) {
        printf("\n\n");
  	    printf("Comparacion para n = %d\n", num);	

        num = pow(10, i);

        // Ejecutar cálculo de la suma utilizando mpi
        run_time_cuda = run_mpi_suma_simple(num, argc, argv);

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

